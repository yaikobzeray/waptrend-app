import 'package:chewie/chewie.dart';
import 'package:foap/components/post_card/share_post.dart';
import 'package:foap/components/user_card.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/reel_imports.dart';
import 'package:foap/helper/number_extension.dart';
import 'package:foap/screens/home_feed/comments_screen.dart';
import 'package:foap/screens/live/gifts_list.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../profile/other_user_profile.dart';

class ReelVideoPlayer extends StatefulWidget {
  final PostModel reel;

  const ReelVideoPlayer({
    super.key,
    required this.reel,
  });

  @override
  State<ReelVideoPlayer> createState() => _ReelVideoPlayerState();
}

class _ReelVideoPlayerState extends State<ReelVideoPlayer> {
  late Future<void> initializeVideoPlayerFuture;
  VideoPlayerController? videoPlayerController;
  late bool playVideo;
  final ReelsController _reelsController = Get.find();
  final UserFollowUnfollowBtnController _userFollowUnfollowBtnController =
      UserFollowUnfollowBtnController();

  @override
  void initState() {
    super.initState();
    _userFollowUnfollowBtnController.setUser(widget.reel.user);
    prepareVideo(url: widget.reel.gallery.first.filePath);
  }

  @override
  void didUpdateWidget(covariant ReelVideoPlayer oldWidget) {
    playVideo = _reelsController.currentViewingReel.value!.id == widget.reel.id;

    if (playVideo == true) {
      play();
    } else {
      pause();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder(
          future: initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            final size = MediaQuery.of(context).size;

            // calculate scale for aspect ratio widget
            var scale =
                videoPlayerController!.value.aspectRatio / size.aspectRatio;

            // check if adjustments are needed...
            if (videoPlayerController!.value.aspectRatio < size.aspectRatio) {
              scale = 1 / scale;
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return GestureDetector(
                onLongPress: () => pause(),
                onLongPressUp: () => play(),
                child: VisibilityDetector(
                  key: Key(widget.reel.gallery.first.filePath),
                  onVisibilityChanged: (VisibilityInfo info) {
                    if (info.visibleFraction == 1.0) {
                      play();
                    } else if (info.visibleFraction < 0.4) {
                      pause();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Transform.scale(
                      scale: scale,
                      child: SizedBox(
                        key: PageStorageKey(widget.reel.gallery.first.filePath),
                        child: Chewie(
                          key: PageStorageKey(
                              widget.reel.gallery.first.filePath),
                          controller: ChewieController(
                            allowFullScreen: false,
                            videoPlayerController: videoPlayerController!,
                            aspectRatio:
                                videoPlayerController!.value.aspectRatio,
                            showOptions: false,
                            showControls: false,
                            autoInitialize: true,
                            looping: true,
                            autoPlay: false,
                            errorBuilder: (context, errorMessage) {
                              return Center(
                                child: Text(
                                  errorMessage,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              );
            }
          },
        ),
        // Gradient Overlay
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.5),
                ],
                stops: const [0.0, 0.5, 0.8, 1.0],
              ),
            ),
          ),
        ),
        // Content Overlay
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                // User Info Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Left Content (User Info + Caption)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!widget.reel.isMyPost &&
                              widget.reel.user.role != UserRole.admin)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildGiftButton(),
                            ),
                          _buildUserInfoRow(),
                          const SizedBox(height: 12),
                          if (widget.reel.postTitle.isNotEmpty)
                            _buildPostTitle(),
                          const SizedBox(height: 12),
                          _buildAudioInfo(),
                        ],
                      ),
                    ),
                    // Right Action Buttons
                    _buildActionButtons(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGiftButton() {
    return InkWell(
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return FractionallySizedBox(
              heightFactor: 0.8,
              child: GiftsPageView(
                giftSelectedCompletion: (gift) {
                  Get.back();
                  _reelsController.sendPostGift(
                      gift, widget.reel.user.id, widget.reel.id);
                },
              ),
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColorConstants.themeColor.withOpacity(0.8),
              AppColorConstants.themeColor.darken(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Iconsax.gift_outline,
              size: 16,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            BodyMediumText(
              sendGiftString.tr,
              color: Colors.white,
              weight: TextWeight.medium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoRow() {
    return InkWell(
      onTap: () {
        Get.to(() => OtherUserProfile(userId: widget.reel.user.id));
      },
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 1.5,
              ),
            ),
            child: UserAvatarView(
              size: 40,
              user: widget.reel.user,
              hideOnlineIndicator: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodyLargeText(
                  widget.reel.user.userName,
                  weight: TextWeight.medium,
                  color: Colors.white,
                ),
                if (widget.reel.user.followingStatus ==
                    FollowingStatus.notFollowing)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: UserFollowUnfollowButton(
                      isSmallSized: true,
                      controller: _userFollowUnfollowBtnController,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostTitle() {
    return BodyLargeText(
      widget.reel.postTitle,
      weight: TextWeight.semiBold,
      color: Colors.white,
    );
  }

  Widget _buildAudioInfo() {
    return InkWell(
      onTap: () {
        if (widget.reel.audio != null) {
          Get.to(() => ReelAudioDetail(audio: widget.reel.audio!));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Iconsax.music_bold,
              size: 16,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: BodySmallText(
                widget.reel.audio == null
                    ? originalAudioString.tr
                    : widget.reel.audio!.name,
                color: Colors.white,
                maxLines: 1,
                // overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Obx(
          () => _buildActionButton(
            icon: _reelsController.likedReels.contains(widget.reel) ||
                    widget.reel.isLike
                ? Iconsax.heart_bold
                : Iconsax.heart_outline,
            count: widget.reel.totalLike,
            isActive: _reelsController.likedReels.contains(widget.reel) ||
                widget.reel.isLike,
            onTap: () => _reelsController.likeUnlikeReel(post: widget.reel),
          ),
        ),
        const SizedBox(height: 20),
        if (widget.reel.commentsEnabled)
          _buildActionButton(
            icon: Iconsax.message_outline,
            count: widget.reel.totalComment,
            onTap: openComments,
          ),
        const SizedBox(height: 20),
        if (widget.reel.sharedPost == null)
          _buildActionButton(
            icon: Iconsax.send_2_outline,
            count: widget.reel.totalShare,
            onTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                isScrollControlled: true,
                builder: (context) => FractionallySizedBox(
                  heightFactor: 0.95,
                  child: SharePost(post: widget.reel),
                ),
              );
            },
          ),
        const SizedBox(height: 20),
        if (widget.reel.audio != null) _buildAudioThumbnail(),
        const SizedBox(height: 20),
        _buildActionButton(
          icon: Iconsax.more_outline,
          onTap: openActionPopup,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    int? count,
    VoidCallback? onTap,
    bool isActive = false,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 24,
              color: isActive ? AppColorConstants.red : Colors.white,
            ),
          ),
        ),
        if (count != null) ...[
          const SizedBox(height: 4),
          BodyMediumText(
            count.formatNumber,
            color: Colors.white,
          ),
        ],
      ],
    );
  }

  Widget _buildAudioThumbnail() {
    return InkWell(
      onTap: () {
        if (widget.reel.audio != null) {
          Get.to(() => ReelAudioDetail(audio: widget.reel.audio!));
        }
      },
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: widget.reel.audio!.thumbnail,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  prepareVideo({required String url}) {
    if (videoPlayerController != null) {
      videoPlayerController!.pause();
    }

    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));

    initializeVideoPlayerFuture = videoPlayerController!.initialize().then((_) {
      setState(() {});

      if (playVideo == true) {
        play();
      } else {
        pause();
      }
    });
  }

  play() {
    videoPlayerController!.play();
  }

  openComments() {
    Get.bottomSheet(
      CommentsScreen(
        isPopup: true,
        model: widget.reel,
        commentPostedCallback: () {
          setState(() {
            widget.reel.totalComment += 1;
          });
        },
      ),
      isScrollControlled: true,
      enterBottomSheetDuration: const Duration(milliseconds: 250),
      exitBottomSheetDuration: const Duration(milliseconds: 200),
    );
  }

  pause() {
    videoPlayerController!.pause();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  clear() {
    videoPlayerController!.pause();
    videoPlayerController!.dispose();
  }

  void openActionPopup() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: AppColorConstants.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.only(top: 20),
        child: widget.reel.user.isMe
            ? _buildOwnerActionMenu()
            : _buildVisitorActionMenu(),
      ),
      enterBottomSheetDuration: const Duration(milliseconds: 250),
      exitBottomSheetDuration: const Duration(milliseconds: 200),
    );
  }

  Widget _buildOwnerActionMenu() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(Iconsax.trash_outline,
              color: AppColorConstants.mainTextColor),
          title: BodyLargeText(
            deleteString.tr,
            color: AppColorConstants.mainTextColor,
          ),
          onTap: () async {
            Get.back();
            _reelsController.deletePost(post: widget.reel);
          },
        ),
        Divider(
            height: 1, color: AppColorConstants.borderColor.withOpacity(0.5)),
        ListTile(
          leading:
              Icon(Iconsax.close_circle_outline, color: AppColorConstants.red),
          title: BodyLargeText(
            cancelString.tr,
            color: AppColorConstants.red,
          ),
          onTap: () => Get.back(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildVisitorActionMenu() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(Iconsax.flag_2_outline,
              color: AppColorConstants.mainTextColor),
          title: BodyLargeText(
            reportString.tr,
            color: AppColorConstants.mainTextColor,
          ),
          onTap: () {
            Get.back();
            _showReportConfirmation();
          },
        ),
        ListTile(
          leading: Icon(Icons.block, color: AppColorConstants.mainTextColor),
          title: BodyLargeText(
            blockUserString.tr,
            color: AppColorConstants.mainTextColor,
          ),
          onTap: () {
            Get.back();
            _showBlockConfirmation();
          },
        ),
        Divider(
            height: 1, color: AppColorConstants.dividerColor.withOpacity(0.5)),
        ListTile(
          leading:
              Icon(Iconsax.close_circle_outline, color: AppColorConstants.red),
          title: BodyLargeText(
            cancelString.tr,
            color: AppColorConstants.red,
          ),
          onTap: () => Get.back(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _showReportConfirmation() {
    AppUtil.showNewConfirmationAlert(
      title: reportString.tr,
      subTitle: areYouSureToReportPostString.tr,
      okHandler: () {
        _reelsController.reportPost(
          post: widget.reel,
          callback: () {
            AppUtil.showToast(
              message: reelReportedSuccessfullyString.tr,
              isSuccess: true,
            );
          },
        );
      },
      cancelHandler: () => Get.back(),
    );
  }

  void _showBlockConfirmation() {
    AppUtil.showNewConfirmationAlert(
      title: blockString.tr,
      subTitle: areYouSureToBlockUserString.tr,
      okHandler: () {
        _reelsController.blockUser(
          userId: widget.reel.user.id,
          callback: () {
            AppUtil.showToast(
              message: userBlockedSuccessfullyString.tr,
              isSuccess: true,
            );
          },
        );
      },
      cancelHandler: () => Get.back(),
    );
  }
}
