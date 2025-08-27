import 'package:foap/api_handler/apis/misc_api.dart';
import 'package:foap/api_handler/apis/story_api.dart';
import 'package:foap/controllers/chat_and_call/chat_detail_controller.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:async';
import 'package:foap/model/story_model.dart';
import 'package:foap/screens/chat/media.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';
// import 'package:flutter_video_info/flutter_video_info.dart';
import '../../manager/db_manager_realm.dart';
import '../../model/data_wrapper.dart';
import '../home/home_controller.dart';
import 'package:foap/helper/file_extension.dart';

class AppStoryController extends GetxController {
  final ChatDetailController _chatDetailController = Get.find();
  RxList<Media> mediaList = <Media>[].obs;
  RxList<StoryViewerModel> storyViewers = <StoryViewerModel>[].obs;
  DataWrapper storyViewerDataWrapper = DataWrapper();

  RxBool allowMultipleSelection = false.obs;
  RxInt numberOfItems = 0.obs;

  Rx<StoryMediaModel?> currentStoryMediaModel = Rx<StoryMediaModel?>(null);

  RxBool showEmoticons = false.obs;
  RxString replyText = ''.obs;

  clearStoryViewers() {
    storyViewers.clear();
    storyViewerDataWrapper = DataWrapper();
  }

  showHideEmoticons(bool show) {
    showEmoticons.value = show;
  }

  replyTextChanged(String text) {
    replyText.value = text;
  }

  mediaSelected(List<Media> media) {
    mediaList.value = media;
  }

  toggleMultiSelectionMode() {
    allowMultipleSelection.value = !allowMultipleSelection.value;
    update();
  }

  deleteStory(VoidCallback callback) {
    StoryApi.deleteStory(
        id: currentStoryMediaModel.value!.id, callback: callback);
  }

  setCurrentStoryMedia(StoryMediaModel storyMedia) {
    UserProfileManager userProfileManager = Get.find();
    clearStoryViewers();
    currentStoryMediaModel.value = storyMedia;
    getIt<RealmDBManager>().storyViewed(storyMedia);

    if (storyMedia.userId == userProfileManager.user.value!.id) {
      loadStoryViewer();
    } else {
      StoryApi.viewStory(storyId: storyMedia.id);
    }
    update();
  }

  loadStoryViewer() {
    if (storyViewerDataWrapper.haveMoreData.value) {
      storyViewerDataWrapper.isLoading.value = true;
      StoryApi.getStoryViewers(
          storyId: currentStoryMediaModel.value!.id,
          page: storyViewerDataWrapper.page,
          resultCallback: (result, metadata) {
            storyViewers.addAll(result);

            storyViewerDataWrapper.processCompletedWithData(metadata);
          });
    }
  }

  void uploadAllMedia({required List<Media> items}) async {
    var responses =
        await Future.wait([for (Media media in items) uploadMedia(media)])
            .whenComplete(() {});

    publishAction(galleryItems: responses);
  }

  Future<Map<String, String>> uploadMedia(Media media) async {
    try {
      final tempDir = await getTemporaryDirectory();
      File mainFile;
      String? videoThumbnailPath;
      int videoDuration = 0;

      if (media.mediaType == GalleryMediaType.photo) {
        // Image handling
        Uint8List mainFileData = await media.file!.compress();
        mainFile = File(
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await mainFile.writeAsBytes(mainFileData);
      } else {
        // Video handling
        MediaInfo? mediaInfo = await VideoCompress.compressVideo(
          media.file!.path,
          quality: VideoQuality.DefaultQuality,
          deleteOrigin: false,
        );

        if (mediaInfo == null || mediaInfo.file == null) {
          throw Exception("Video compression failed");
        }

        mainFile = mediaInfo.file!;

        var info = await VideoCompress.getMediaInfo(media.file!.path);
        videoDuration = info.duration?.toInt() ?? 0;

        // Create thumbnail file
        File videoThumbnail = File(
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_thumbnail.jpg');
        await videoThumbnail.writeAsBytes(media.thumbnail!);

        // Upload thumbnail
        videoThumbnailPath =
            await _uploadFile(videoThumbnail, GalleryMediaType.photo);
        await videoThumbnail.delete();
      }

      // Upload main file
      String mainFileUploadedPath =
          await _uploadFile(mainFile, media.mediaType!);
      await mainFile.delete();

      return {
        'image': media.mediaType == GalleryMediaType.photo
            ? mainFileUploadedPath
            : videoThumbnailPath ?? '',
        'video': media.mediaType == GalleryMediaType.photo
            ? ''
            : mainFileUploadedPath,
        'video_time': videoDuration.toString(),
        'type': media.mediaType == GalleryMediaType.photo ? '2' : '3',
        'description': '',
        'background_color': '',
      };
    } catch (e) {
      print("Upload media error: $e");
      rethrow;
    }
  }

  Future<String> _uploadFile(File file, GalleryMediaType mediaType) async {
    final completer = Completer<String>();

    // Start upload
    MiscApi.uploadFile(
      file.path,
      mediaType: mediaType,
      type: UploadMediaType.storyOrHighlights,
      resultCallback: (fileName, filePath) {
        print("Upload success: $fileName");
        if (!completer.isCompleted) {
          completer.complete(fileName);
        }
      },
    );

    // Wait for completion with timeout
    return completer.future.timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        print("Upload timeout for file: ${file.path}");
        throw Exception("Upload timeout");
      },
    );
  }

  void publishAction({
    required List<Map<String, String>> galleryItems,
  }) {
    HomeController homeController = Get.find();
    StoryApi.postStory(
        gallery: galleryItems,
        successHandler: () {
          homeController.getStories();

          AppUtil.showToast(
              message: storyPostedSuccessfullyString, isSuccess: true);
        });
    // DashboardController dashboardController = Get.find();
    // dashboardController.indexChanged(0);
    // Get.offAll(() => const DashboardScreen());
  }

  sendTextMessage(String message, StoryModel story) {
    _chatDetailController.getChatRoomWithUser(
        userId: currentStoryMediaModel.value!.userId,
        callback: (room) {
          FocusScope.of(Get.context!).requestFocus(FocusNode());
          showHideEmoticons(false);
          StoryModel storyToSend = StoryModel(
              id: story.id,
              name: story.name,
              userName: story.userName,
              userImage: story.userImage,
              media: [currentStoryMediaModel.value!]);

          _chatDetailController.sendStoryTextReplyMessage(
              messageText: message, story: storyToSend, room: room);
        });
  }

  sendReactionMessage(String emoji, StoryModel story) {
    _chatDetailController.getChatRoomWithUser(
        userId: currentStoryMediaModel.value!.userId,
        callback: (room) {
          FocusScope.of(Get.context!).requestFocus(FocusNode());
          showHideEmoticons(false);

          StoryModel storyToSend = StoryModel(
              id: story.id,
              name: story.name,
              userName: story.userName,
              userImage: story.userImage,
              media: [currentStoryMediaModel.value!]);

          _chatDetailController.sendStoryReactionReplyMessage(
              emoji: emoji, story: storyToSend, room: room);
        });
  }

  sendStoryAsMessage(int userId, StoryModel story) {
    _chatDetailController.getChatRoomWithUser(
        userId: userId,
        callback: (room) {
          FocusScope.of(Get.context!).requestFocus(FocusNode());
          showHideEmoticons(false);
          StoryModel storyToSend = StoryModel(
              id: story.id,
              name: story.name,
              userName: story.userName,
              userImage: story.userImage,
              media: [currentStoryMediaModel.value!]);
          _chatDetailController.sendStoryMessage(
              story: storyToSend, room: room);
        });
  }
}
