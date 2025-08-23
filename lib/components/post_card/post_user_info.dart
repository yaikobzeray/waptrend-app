import 'package:foap/components/user_card.dart';
import 'package:foap/controllers/clubs/clubs_controller.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/models.dart';
import 'package:foap/model/collaboration_model.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../controllers/misc/misc_controller.dart';
import '../../controllers/post/add_post_controller.dart';
import '../../controllers/profile/profile_controller.dart';
import '../../screens/club/club_detail.dart';
import '../../screens/post/edit_post.dart';
import '../../screens/profile/my_profile.dart';
import '../../screens/profile/other_user_profile.dart';
import '../post_card_controller.dart';

class PostUserInfo extends StatefulWidget {
  final PostModel post;
  final bool isSponsored;
  final VoidCallback removePostHandler;
  final VoidCallback blockUserHandler;
  final bool isResharedPost;

  const PostUserInfo({
    super.key,
    required this.post,
    required this.isSponsored,
    required this.removePostHandler,
    required this.blockUserHandler,
    required this.isResharedPost,
  });

  @override
  State<PostUserInfo> createState() => _PostUserInfoState();
}

class _PostUserInfoState extends State<PostUserInfo> {
  final ProfileController _profileController = Get.find();
  final PostCardController postCardController = Get.find();
  final UserFollowUnfollowBtnController _userFollowUnfollowBtnController =
      UserFollowUnfollowBtnController();

  @override
  void initState() {
    _userFollowUnfollowBtnController.setUser(widget.post.user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // User Avatar
          _buildUserAvatar(),
          const SizedBox(width: 12),

          // User Info Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Name and Metadata
                _buildUserInfoRow(),
                const SizedBox(height: 4),

                // Post Time/Sponsored Tag
                _buildPostMetadata(),
              ],
            ),
          ),

          // Follow Button and Action Icons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildUserAvatar() {
    return SizedBox(
      height: 50,
      width: 50,
      child: UserAvatarView(
        size: 50,
        user: widget.post.user,
        onTapHandler: () => openProfile(widget.post.user),
      ),
    );
  }

  Widget _buildUserInfoRow() {
    return Row(
      children: [
        // User Name with Verification Badge
        _buildUserNameWithVerification(),

        // Collaborations Info
        if (widget.post.collaborations.isNotEmpty)
          widget.post.isMyPost
              ? _buildCollaborationsViewForPostOwner()
              : _buildCollaborationsView(),

        // Club Info if posted in club
        if (widget.post.postedInClub != null) _buildClubInfo(),

        // Reshared indicator
        if (widget.post.sharedPost != null) _buildResharedIndicator(),
      ],
    );
  }

  Widget _buildUserNameWithVerification() {
    return Row(
      children: [
        BodyMediumText(
          widget.post.user.userName,
          weight: TextWeight.semiBold,
        ).ripple(() {
          if (widget.post.user.role != UserRole.admin) {
            openProfile(widget.post.user);
          }
        }),
        if (widget.post.user.isVerified) verifiedUserTag().rP8,
      ],
    );
  }

  Widget _buildCollaborationsViewForPostOwner() {
    if (widget.post.collaborations.length == 1 &&
        widget.post.activeCollaborations.length == 1) {
      return Row(
        children: [
          BodyMediumText(andString.tr, weight: TextWeight.medium),
          _buildUserNameWithVerificationForCollaborator(
              widget.post.activeCollaborations.first.user!),
        ],
      );
    } else {
      return Row(
        children: [
          BodyMediumText(andString.tr, weight: TextWeight.medium),
          BodyMediumText(
            '${widget.post.collaborations.length} ${otherString.tr}',
            weight: TextWeight.medium,
            color: AppColorConstants.themeColor,
          ).ripple(() => _showCollaboratorsModal(widget.post.collaborations)),
        ],
      );
    }
  }

  Widget _buildCollaborationsView() {
    if (widget.post.activeCollaborations.isEmpty) return Container();
    if (widget.post.activeCollaborations.length == 1) {
      return Row(
        children: [
          BodyMediumText(andString.tr, weight: TextWeight.medium),
          _buildUserNameWithVerificationForCollaborator(
              widget.post.activeCollaborations.first.user!),
        ],
      );
    } else {
      return Row(
        children: [
          BodyMediumText(andString.tr, weight: TextWeight.medium),
          BodyMediumText(
            '${widget.post.activeCollaborations.length} ${otherString.tr}',
            weight: TextWeight.medium,
            color: AppColorConstants.themeColor,
          ).ripple(() => _showCollaboratorsModal(widget.post.collaborations
              .where((e) => e.status == CollaborationStatusType.accepted)
              .toList())),
        ],
      );
    }
  }

  Widget _buildUserNameWithVerificationForCollaborator(UserModel user) {
    return Row(
      children: [
        BodyMediumText(user.userName, weight: TextWeight.medium),
        if (user.isVerified) verifiedUserTag().rP8,
      ],
    );
  }

  Widget _buildClubInfo() {
    return Expanded(
      child: BodyMediumText(
        ' ${sharedInString.tr} (${widget.post.postedInClub!.name})',
        weight: TextWeight.semiBold,
        color: AppColorConstants.themeColor,
        maxLines: 1,
      ).ripple(openClubDetail),
    );
  }

  Widget _buildResharedIndicator() {
    return BodySmallText(
      ' ($reSharedString) ',
      weight: TextWeight.semiBold,
      maxLines: 1,
    );
  }

  Widget _buildPostMetadata() {
    return widget.isSponsored
        ? BodyExtraSmallText(sponsoredString.tr)
        : Row(
            children: [
              // ThemeIconWidget(ThemeIcon.clock, size: 12),
              // const SizedBox(width: 5),
              BodyExtraSmallText(widget.post.postTime.tr),
            ],
          );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // // Follow Button for non-following users
        // if (widget.post.user.followingStatus == FollowingStatus.notFollowing)
        //   Padding(
        //     padding: const EdgeInsets.only(right: 8),
        //     child: UserFollowUnfollowButton(
        //       isSmallSized: true,
        //       controller: _userFollowUnfollowBtnController,
        //     ),
        //   ),

        // Post Actions (only for non-reshared posts)
        if (!widget.isResharedPost) _buildPostActionIcons(),
      ],
    );
  }

  Widget _buildPostActionIcons() {
    return Row(
      children: [
        // Pin Icon
        if (widget.post.isPinned) _buildPinIcon(),

        // Bookmark Icon
        // _buildBookmarkIcon(),

        // More Options
        _buildMoreOptionsIcon(),
      ],
    );
  }

  Widget _buildPinIcon() {
    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: ThemeIconWidget(
            ThemeIcon.pin,
            color: AppColorConstants.themeColor,
            size: 20,
          ),
        ).ripple(() {
          setState(() {
            widget.post.isPinned = false;
            Get.find<MiscController>()
                .removeFromPin(PinContentType.post, widget.post.id);
          });
        }),
        const SizedBox(width: 16),
      ],
    );
  }

  // Widget _buildBookmarkIcon() {
  //   return Obx(() => SizedBox(
  //         height: 24,
  //         width: 24,
  //         child: Icon(
  //           postCardController.savedPosts.contains(widget.post) ||
  //                   widget.post.isSaved
  //               ? Iconsax.bookmark_bold
  //               : Iconsax.bookmark_outline,
  //           color: widget.post.isSaved ||
  //                   postCardController.savedPosts.contains(widget.post)
  //               ? AppColorConstants.themeColor
  //               : AppColorConstants.iconColor,
  //           size: 20,
  //         ),
  //       )).ripple(() => postCardController.saveUnSavePost(post: widget.post));
  // }

  Widget _buildMoreOptionsIcon() {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: SizedBox(
        height: 24,
        width: 24,
        child: ThemeIconWidget(
          ThemeIcon.more,
          color: AppColorConstants.iconColor,
          size: 20,
        ),
      ).ripple(openActionPopup),
    );
  }

  void _showCollaboratorsModal(List<CollaborationModel> collaborators) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CollaboratorsListModal(
        collaborators: collaborators,
        isMyPost: widget.post.isMyPost,
        removeCollaboratorCallback: (collaborator) {
          Get.find<AddPostController>().updateCollaborationStatus(
              id: collaborator.id, status: CollaborationStatusType.cancelled);
          setState(() => widget.post.removeCollaboration(collaborator));
        },
      ),
    );
  }

  void openProfile(UserModel user) async {
    if (user.isMe) {
      Get.to(() => const MyProfile(showBack: true));
    } else {
      _profileController.otherUserProfileView(
          refId: user.id, viewSource: UserViewSourceType.post);
      Get.to(() => OtherUserProfile(userId: user.id, user: user));
    }
  }

  void openClubDetail() async {
    Get.find<ClubsController>().getClubDetail(
      widget.post.postedInClub!.id!,
      (club) => Get.to(() => ClubDetail(
            club: club,
            needRefreshCallback: () {},
            deleteCallback: (club) {},
          )),
    );
  }

  void openActionPopup() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: AppColorConstants.cardColor.darken(0.05),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.only(top: 12, bottom: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle indicator
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColorConstants.iconColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            widget.post.user.isMe
                ? _buildOwnerActions()
                : _buildNonOwnerActions(),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      enterBottomSheetDuration: const Duration(milliseconds: 250),
      exitBottomSheetDuration: const Duration(milliseconds: 200),
    );
  }

  Widget _buildOwnerActions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionTile(
          icon: Icons.edit_outlined,
          title: editPostString.tr,
          onTap: () => _handleEditPost(),
        ),
        _buildActionTile(
          icon: widget.post.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
          title: widget.post.isPinned ? unPinString.tr : pinString.tr,
          onTap: _handlePinAction,
        ),
        _buildActionTile(
          icon: Icons.delete_outline,
          title: deletePostString.tr,
          textColor: AppColorConstants.red,
          onTap: () => _handleDeletePost(),
        ),
        const SizedBox(height: 8),
        _buildCancelButton(),
      ],
    );
  }

  Widget _buildNonOwnerActions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionTile(
          icon: Icons.flag_outlined,
          title: reportString.tr,
          onTap: () => _handleReport(),
        ),
        _buildActionTile(
          icon: Icons.block,
          title: blockUserString.tr,
          onTap: () => _handleBlockUser(),
        ),
        _buildActionTile(
          icon: Iconsax.bookmark_outline,
          title: widget.post.isSaved ||
                  postCardController.savedPosts.contains(widget.post)
              ? "Remove post".tr
              : "Save post".tr,
          onTap: () => postCardController.saveUnSavePost(post: widget.post),
        ),

        // if (widget.post.user.followingStatus == FollowingStatus.notFollowing)
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: UserFollowUnfollowButton(
            isSmallSized: true,
            controller: _userFollowUnfollowBtnController,
          ),
        ),
        if (widget.post.amICollaborator) ...[
          _buildActionTile(
            icon: Icons.exit_to_app,
            title: withdrawCollaborationString.tr,
            textColor: AppColorConstants.red,
            onTap: () => _handleWithdrawCollaboration(),
          ),
        ],
        const SizedBox(height: 8),
        _buildCancelButton(),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Color? textColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.back();
          onTap?.call();
        },
        splashColor: AppColorConstants.themeColor.withOpacity(0.1),
        highlightColor: AppColorConstants.themeColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: Row(
            children: [
              Icon(icon,
                  size: 24, color: textColor ?? AppColorConstants.iconColor),
              const SizedBox(width: 20),
              Expanded(
                child: BodyLargeText(
                  title,
                  weight: TextWeight.medium,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return Material(
      color: AppColorConstants.disabledColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: Get.back,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: BodyLargeText(
              cancelString.tr,
              weight: TextWeight.semiBold,
              color: AppColorConstants.iconColor,
            ),
          ),
        ),
      ),
    );
  }

// Action handlers
  void _handleEditPost() {
    Get.to(() => EditPostScreen(post: widget.post));
  }

  void _handlePinAction() {
    final miscController = Get.find<MiscController>();
    setState(() {
      if (widget.post.isPinned) {
        miscController.removeFromPin(PinContentType.post, widget.post.pinId!);
        widget.post.isPinned = false;
      } else {
        miscController.addToPin(PinContentType.post, widget.post.id, (id) {
          widget.post.pinId = id;
        });
        widget.post.isPinned = true;
      }
    });
  }

  void _handleDeletePost() {
    postCardController.deletePost(
      post: widget.post,
      callback: widget.removePostHandler,
    );
  }

  void _handleReport() {
    _showReportConfirmation();
  }

  void _handleBlockUser() {
    _showBlockUserConfirmation();
  }

  void _handleWithdrawCollaboration() {
    setState(() => widget.post.removeMyCollaboration());
    Get.find<AddPostController>().updateCollaborationStatus(
      id: widget.post.myCollaboration.id,
      status: CollaborationStatusType.cancelled,
    );
  }

  void _showReportConfirmation() {
    AppUtil.showNewConfirmationAlert(
      title: reportString.tr,
      subTitle: areYouSureToReportPostString.tr,
      okHandler: () {
        postCardController.reportPost(
          post: widget.post,
          callback: widget.removePostHandler,
        );
      },
      cancelHandler: Get.back,
    );
  }

  void _showBlockUserConfirmation() {
    AppUtil.showNewConfirmationAlert(
      title: blockString.tr,
      subTitle: areYouSureToBlockUserString.tr,
      okHandler: () {
        postCardController.blockUser(
          userId: widget.post.user.id,
          callback: widget.blockUserHandler,
        );
      },
      cancelHandler: Get.back,
    );
  }
}

class CollaboratorsListModal extends StatefulWidget {
  final List<CollaborationModel> collaborators;
  final bool isMyPost;
  final Function(CollaborationModel) removeCollaboratorCallback;

  const CollaboratorsListModal({
    super.key,
    required this.collaborators,
    required this.isMyPost,
    required this.removeCollaboratorCallback,
  });

  @override
  State<CollaboratorsListModal> createState() => _CollaboratorsListModalState();
}

class _CollaboratorsListModalState extends State<CollaboratorsListModal> {
  @override
  Widget build(BuildContext context) {
    if (widget.collaborators.isEmpty) {
      Navigator.pop(context);
      return Container();
    }

    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      decoration: BoxDecoration(
        color: AppColorConstants.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Heading5Text(
            collaboratorsString.tr,
            weight: TextWeight.bold,
          ),
          divider(height: 0.5).vP16,
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: widget.collaborators.length,
              separatorBuilder: (context, index) => divider(height: 0.5).vP8,
              itemBuilder: (context, index) {
                final collaborator = widget.collaborators[index];
                return widget.isMyPost
                    ? CollaboratorTile(
                        collaborator: collaborator,
                        removeCallback: () {
                          setState(() {
                            collaborator.status =
                                CollaborationStatusType.cancelled;
                          });
                          widget.removeCollaboratorCallback(collaborator);
                        },
                      ).vP8
                    : UserTile(
                        profile: collaborator.user!,
                        viewCallback: () {
                          Get.back();
                          Get.to(() =>
                              OtherUserProfile(userId: collaborator.user!.id));
                        },
                      ).vP8;
              },
            ),
          ).hp(DesignConstants.horizontalPadding),
        ],
      ),
    );
  }
}
