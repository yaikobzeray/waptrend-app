import 'dart:io';

import 'package:foap/helper/file_extension.dart';
import 'package:image_picker/image_picker.dart';
import '../../components/vs_story_designer/vs_story_designer.dart';
import '../../controllers/story/story_controller.dart';
import '../../helper/imports/common_import.dart';
import '../chat/media.dart';
import 'package:icons_plus/icons_plus.dart';

final ImagePicker _picker = ImagePicker();

void openStoryUploader() {
  showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) => Container(
            decoration: BoxDecoration(
              color: AppColorConstants.backgroundColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(25)),
            ),
            padding: const EdgeInsets.only(top: 20, bottom: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Draggable handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColorConstants.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ).bp(20),

                // Title
                // Heading5Text(
                //   shareStoryString.tr,
                //   weight: TextWeight.semiBold,
                // ).bottom(25),

                // Options row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildModernOption(
                      icon: FontAwesome.camera_solid,
                      label: cameraString.tr,
                      onTap: () {
                        Get.back();
                        selectPhoto(source: ImageSource.camera);
                      },
                    ),
                    _buildModernOption(
                      icon: FontAwesome.image_solid,
                      label: photoString.tr,
                      onTap: () {
                        Get.back();
                        Get.to(() => VSStoryDesigner(
                              giphyKey:
                                  settingsController.setting.value!.giphyApiKey,
                              onDone: (String uri) async {
                                print("uri=$uri");

                                File file = File(uri); // <-- use dart:io File
                                if (!await file.exists()) {
                                  print("File not found!");
                                  return;
                                }

                                // If your toMedia requires XFile, convert from File.bytes
                                XFile image = XFile(file.path);

                                Media media =
                                    await image.toMedia(GalleryMediaType.photo);
                                postStoryMedia([media]);

                                Get.back();
                              },
                              onDoneButtonStyle: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColorConstants.themeColor,
                                      AppColorConstants.themeColor.darken(),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                height: 50,
                                width: 50,
                                child: Center(
                                  child: BodyLargeText(
                                    postString.tr,
                                    color: Colors.white,
                                  ),
                                ),
                              ).round(10),
                              centerText: '',
                              middleBottomWidget: Container(),
                            ));
                      },
                    ),
                    _buildModernOption(
                      icon: FontAwesome.video_solid,
                      label: videoString.tr,
                      onTap: () {
                        Get.back();
                        selectVideo(source: ImageSource.gallery);
                      },
                    ),
                  ],
                ).hp(20),

                // Close button
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: Get.width * 0.9,
                    margin: const EdgeInsets.only(top: 25),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    decoration: BoxDecoration(
                      color: AppColorConstants.dividerColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: BodyMediumText(
                      textAlign: TextAlign.center,
                      cancelString.tr,
                      color: AppColorConstants.red,
                    ),
                  ),
                ),
              ],
            ),
          ));
}

Widget _buildModernOption({
  required dynamic icon,
  required String label,
  required Function onTap,
}) {
  return Column(
    children: [
      Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppColorConstants.themeColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 24,
          color: AppColorConstants.themeColor,
        ),
      ).bp(8),
      BodySmallText(
        label,
        color: AppColorConstants.mainTextColor,
      ),
    ],
  ).ripple(() {
    onTap();
  });
}

// Keep all other methods (selectPhoto, selectVideo, postStoryMedia) exactly the same

Widget _buildOption(
    {required dynamic icon, required String label, required Function onTap}) {
  return Column(
    children: [
      Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppColorConstants.themeColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          icon,
          size: 25,
          color: AppColorConstants.themeColor,
        ),
      ),
      BodyMediumText(
        label,
        color: AppColorConstants.themeColor,
      )
    ],
  ).ripple(() {
    onTap();
  });
}

selectPhoto({
  required ImageSource source,
}) async {
  if (source == ImageSource.camera) {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);
    print("Media=$image");

    if (image != null) {
      Media media = await image.toMedia(GalleryMediaType.photo);
      print("Media=$media");

      postStoryMedia([media]);
    }
  } else {
    List<Media> mediaList = [];
    List<XFile> images = await _picker.pickMultiImage();

    for (XFile file in images) {
      Media media = await file.toMedia(GalleryMediaType.photo);
      print("Media=$media");

      mediaList.add(media);
    }
    postStoryMedia(mediaList);
  }
}

selectVideo({
  required ImageSource source,
}) async {
  XFile? file = await _picker.pickVideo(source: source);

  if (file != null) {
    Media media = await file.toMedia(GalleryMediaType.video);
    print("Media=$media");

    postStoryMedia([media]);
  }
}

postStoryMedia(List<Media> medias) {
  final AppStoryController storyController = Get.find();

  storyController.uploadAllMedia(items: medias);
}
