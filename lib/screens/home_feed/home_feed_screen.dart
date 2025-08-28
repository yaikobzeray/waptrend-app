import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foap/helper/imports/chat_imports.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/story_imports.dart';
import 'package:foap/model/live_model.dart';
import 'package:foap/screens/home_feed/story_uploader.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../components/post_card/post_card.dart';
import '../../controllers/post/add_post_controller.dart';
import '../../controllers/live/agora_live_controller.dart';
import '../../controllers/home/home_controller.dart';
import '../../helper/imports/setting_imports.dart';
import '../../model/post_model.dart';
import '../content_creator_view.dart';
import '../dashboard/dashboard_screen.dart';
import '../dashboard/map_screen.dart';
import '../settings_menu/settings_controller.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  HomeFeedState createState() => HomeFeedState();
}

class HomeFeedState extends State<HomeFeedScreen> {
  final HomeController _homeController = Get.find();
  final AddPostController _addPostController = Get.find();
  final AgoraLiveController _agoraLiveController = Get.find();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final SettingsController _settingsController = Get.find();
  final DashboardController _dashboardController = Get.find();
  final _controller = ScrollController();

  String? selectedValue;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
      _homeController.loadQuickLinksAccordingToSettings();
    });
  }

  loadMore() {
    loadPosts();
  }

  refreshData() {
    _homeController.clearPosts();
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _homeController.clear();
    _homeController.closeQuickLinks();
  }

  loadPosts() {
    _homeController.getPosts(callback: () {
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
    });

    _homeController.getPromotionalPosts();
  }

  void loadData() {
    loadPosts();
    if (_settingsController.setting.value!.enableStories) {
      _homeController.getStories();
    }
  }

  @override
  void didUpdateWidget(covariant HomeFeedScreen oldWidget) {
    loadData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AppScaffold(
          backgroundColor: AppColorConstants.backgroundColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 35,
              ),
              Container(
                decoration: BoxDecoration(
                    border: BorderDirectional(
                        bottom: BorderSide(
                            color: AppColorConstants.borderColor
                                .withOpacity(0.2)))),
                child: Row(
                  children: [
                    // App Logo/Name
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "assets/waptrend-logo.jpg",
                        height: Get.height * 0.04,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      AppConfigConstants.appName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: TextWeight.semiBold,
                        color: AppColorConstants.mainTextColor,
                      ),
                    ),

                    const Spacer(),

                    // Segmented Control
                    // Container(
                    //   padding: const EdgeInsets.all(4),
                    //   decoration: BoxDecoration(
                    //     color: AppColorConstants.cardColor,
                    //     borderRadius: BorderRadius.circular(12),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.black.withOpacity(0.05),
                    //         blurRadius: 6,
                    //         offset: const Offset(0, 2),
                    //       ),
                    //     ],
                    //   ),
                    //   child: Obx(() => CupertinoSegmentedControl<int>(
                    //         groupValue: _homeController.selectedSegment.value,
                    //         padding: const EdgeInsets.all(4),
                    //         children: {
                    //           0: Container(
                    //             padding: const EdgeInsets.symmetric(
                    //                 horizontal: 16, vertical: 8),
                    //             child: BodyMediumText(
                    //               allString.tr,
                    //               weight: _homeController.selectedSegment.value == 0
                    //                   ? TextWeight.semiBold
                    //                   : TextWeight.regular,
                    //             ),
                    //           ),
                    //           1: Container(
                    //             padding: const EdgeInsets.symmetric(
                    //                 horizontal: 16, vertical: 8),
                    //             child: BodyMediumText(
                    //               followingString.tr,
                    //               weight: _homeController.selectedSegment.value == 1
                    //                   ? TextWeight.semiBold
                    //                   : TextWeight.regular,
                    //             ),
                    //           ),
                    //         },
                    //         unselectedColor: Colors.transparent,
                    //         selectedColor: AppColorConstants.themeColor,
                    //         borderColor: Colors.transparent,
                    //         pressedColor:
                    //             AppColorConstants.themeColor.withOpacity(0.2),
                    //         onValueChanged: (value) {
                    //           _homeController.selectSegment(value);
                    //         },
                    //       )),
                    // ),

                    // const Spacer(),

                    // Action Icons
                    Row(
                      children: [
                        // Chat Button with Badge

                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color:
                                AppColorConstants.themeColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Iconsax.notification_outline,
                            size: 20,
                            color: AppColorConstants.mainTextColor
                                .withOpacity(0.7),
                          ),
                        ).ripple(() {
                          Future.delayed(Duration.zero,
                              () => Get.to(() => NotificationsScreen()));
                        }),
                        const SizedBox(width: 12),

                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color:
                                AppColorConstants.themeColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                height: 25,
                                "assets/Chat.svg",
                                color: AppColorConstants.iconColor,
                              ),
                              Obx(() =>
                                  _dashboardController.unreadMsgCount.value == 0
                                      ? Container()
                                      : Positioned(
                                          top: 6,
                                          right: 6,
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: AppColorConstants.red,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: AppColorConstants
                                                    .backgroundColor,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        )),
                            ],
                          ),
                        ).ripple(() {
                          Get.to(() => const ChatHistory());
                        }),
                      ],
                    ),
                  ],
                ).hp(16).vP8,
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: postsView(),
              ),
            ],
          ));
    });
  }

  Widget postingView() {
    return Obx(() => _addPostController.isPosting.value
        ? Container(
            height: 55,
            color: AppColorConstants.cardColor,
            child: Row(
              children: [
                _addPostController.postingMedia.isNotEmpty &&
                        _addPostController.postingMedia.first.mediaType !=
                            GalleryMediaType.gif
                    ? _addPostController.postingMedia.first.thumbnail != null
                        ? Image.memory(
                            _addPostController.postingMedia.first.thumbnail!,
                            fit: BoxFit.cover,
                            width: 40,
                            height: 40,
                          ).round(5)
                        : _addPostController.postingMedia.first.mediaType ==
                                GalleryMediaType.photo
                            ? Image.file(
                                _addPostController.postingMedia.first.file!,
                                fit: BoxFit.cover,
                                width: 40,
                                height: 40,
                              ).round(5)
                            // : BodyLargeText(_addPostController.postingTitle)
                            : Container()
                    // : BodyLargeText(_addPostController.postingTitle),
                    : Container(),
                const SizedBox(
                  width: 10,
                ),
                Heading5Text(
                  _addPostController.isErrorInPosting.value
                      ? postFailedString.tr
                      : postingString.tr,
                ),
                const Spacer(),
                _addPostController.isErrorInPosting.value
                    ? Row(
                        children: [
                          Heading5Text(
                            discardString.tr,
                            weight: TextWeight.medium,
                          ).ripple(() {
                            _addPostController.discardFailedPost();
                          }),
                          const SizedBox(
                            width: 20,
                          ),
                          Heading5Text(
                            retryString.tr,
                            weight: TextWeight.medium,
                          ).ripple(() {
                            _addPostController.retryPublish();
                          }),
                        ],
                      )
                    : Container()
              ],
            ).hP8,
          ).backgroundCard(radius: 10).bp(20)
        : Container());
  }

  Widget storiesView() {
    return SizedBox(
      height: storyCircleSize + (storyCircleSize / 1.2),
      child: GetBuilder<HomeController>(
          init: _homeController,
          builder: (ctx) {
            return StoryUpdatesBar(
              stories: _homeController.stories,
              // liveUsers: _homeController.liveUsers,
              addStoryCallback: () {
                openStoryUploader();
              },
              viewStoryCallback: (story) {
                if (story.isLive) {
                  LiveModel live = LiveModel();
                  live.channelName = story.user!.liveCallDetail!.channelName;
                  live.mainHostUserDetail = story.user;
                  live.token = story.user!.liveCallDetail!.token;
                  live.id = story.user!.liveCallDetail!.id;
                  _agoraLiveController.joinAsAudience(
                    live: live,
                  );
                } else {
                  Get.to(
                      () => StoryViewer(
                            story: story,
                            storyDeleted: () {
                              _homeController.getStories();
                            },
                          ),
                      fullscreenDialog: true);
                }
              },
              // joinLiveUserCallback: (user) {
              //
              // },
            ).hp(DesignConstants.horizontalPadding / 2);
          }),
    );
  }

  postsView() {
    int offset = _settingsController.setting.value!.enableStories ? 2 : 1;
    return Obx(() {
      return ListView.separated(
              controller: _controller,
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: _homeController.posts.length + offset,
              itemBuilder: (context, index) {
                if (index == 0 &&
                    _settingsController.setting.value!.enableStories) {
                  return Obx(() =>
                      _homeController.isRefreshingStories.value == true
                          ? const StoryAndHighlightsShimmer()
                          : storiesView());
                } else if (index == offset - 1) {
                  return Obx(() =>
                      _homeController.isRefreshingPosts.value == true
                          ? PostBoxShimmer()
                          : postingView().hP16);
                } else {
                  PostModel model = _homeController.posts[index - offset];
                  return Obx(
                      () => _homeController.isRefreshingPosts.value == true
                          ? PostBoxShimmer()
                          : PostCard(
                              model: model,
                              removePostHandler: () {
                                _homeController.removePostFromList(model);
                              },
                              blockUserHandler: () {
                                _homeController
                                    .removeUsersAllPostFromList(model);
                              },
                            ));
                }
              },
              separatorBuilder: (context, index) {
                if (index > 0 &&
                    index % 5 == 0 &&
                    _homeController.sponsoredPosts.length >= index / 5) {
                  PostModel post =
                      _homeController.sponsoredPosts[(index ~/ 5) - 1];
                  return Obx(
                      () => _homeController.isRefreshingPosts.value == true
                          ? PostBoxShimmer()
                          : Column(
                              children: [
                                PostCard(
                                  model: post,
                                  removePostHandler: () {
                                    _homeController.removePostFromList(post);
                                  },
                                  blockUserHandler: () {
                                    _homeController
                                        .removeUsersAllPostFromList(post);
                                  },
                                ),
                                divider(
                                  height: index > (offset - 1) ? 10 : 0,
                                ).tP16
                              ],
                            ).vp(index > (offset - 1) ? 16 : 8));
                } else {
                  return divider(
                    height: index > 1 ? 10 : 0,
                  ).vp(index > 1 ? 16 : 8);
                }
              })
          .addPullToRefresh(
              refreshController: _refreshController,
              enablePullUp: true,
              onRefresh: refreshData,
              onLoading: loadMore,
              enablePullDown: true);
    });
  }
}
