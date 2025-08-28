import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foap/components/post_card/poll_post_tile.dart';
import 'package:foap/components/post_card/post_user_info.dart';
import 'package:foap/components/post_card/reshared_post_card.dart';
import 'package:foap/components/post_card/post_text_widget.dart';
import 'package:foap/components/post_card/share_post.dart';
import 'package:foap/controllers/clubs/clubs_controller.dart';
import 'package:foap/helper/imports/competition_imports.dart';
import 'package:foap/helper/imports/event_imports.dart';
import 'package:foap/screens/fund_raising/fund_raising_campaign_detail.dart';
import 'package:foap/screens/jobs_listing/job_detail.dart';
import 'package:foap/screens/near_by_offers/offer_detail.dart';
import 'package:foap/components/post_card/video_widget.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/post_imports.dart';
import 'package:foap/screens/shop_feature/home/ad_detail_screen.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../controllers/chat_and_call/chat_detail_controller.dart';
import '../../controllers/coupons/near_by_offers.dart';
import '../../controllers/fund_raising/fund_raising_controller.dart';
import '../../controllers/home/home_controller.dart';
import '../../controllers/post/comments_controller.dart';
import '../../screens/post/liked_by_users.dart';
import '../../controllers/post/promotion_controller.dart';
import '../../screens/chat/chat_detail.dart';
import '../../screens/club/club_detail.dart';
import '../../screens/home_feed/comments_screen.dart';
import '../../screens/live/gifts_list.dart';
import '../../screens/post/post_promotion/post_promotion.dart';
import '../../screens/post/view_post_insight.dart';
import '../../screens/profile/other_user_profile.dart';
import 'audio_tile.dart';
import 'classified_product_post_tile.dart';
import 'club_post_tile.dart';
import 'competition_post_tile.dart';
import 'event_post_tile.dart';
import 'fund_raising_campaign_tile.dart';
import 'job_post_tile.dart';
import 'offer_post_tile.dart';

class PostMediaTile extends StatelessWidget {
  final PostCardController postCardController = Get.find();
  final HomeController homeController = Get.find();

  final PostModel model;
  final bool isResharedPost;

  PostMediaTile({
    super.key,
    required this.model,
    required this.isResharedPost,
  });

  @override
  Widget build(BuildContext context) {
    return _buildMediaTile();
  }

  Widget _buildMediaTile() {
    if (model.gallery.length > 1) {
      return _buildCarouselSlider();
    } else {
      return _buildSingleMedia();
    }
  }

  Widget _buildCarouselSlider() {
    return SizedBox(
      height: 350,
      child: Stack(
        children: [
          WKCarouselSlider(
            items: _buildMediaList(isResharedPost),
            enlargeCenterPage: false,
            enableInfiniteScroll: false,
            height: double.infinity,
            viewportFraction: 1,
            onPageChanged: (index) {
              postCardController.updateGallerySlider(index, model.id);
            },
          ),
          _buildCarouselIndicator(),
        ],
      ),
    );
  }

  Widget _buildCarouselIndicator() {
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.center,
        child: Obx(() {
          return WKIndicator1(
            dotsCount: model.gallery.length,
            position: postCardController.postScrollIndexMapping[model.id] ?? 0,
            activeDotColor: AppColorConstants.themeColor,
            dotColor: AppColorConstants.disabledColor,
          );
        }),
      ),
    );
  }

  Widget _buildSingleMedia() {
    switch (model.contentType) {
      case PostContentType.media:
        return _buildMediaContent();
      case PostContentType.event:
        return EventPostTile(post: model, isResharedPost: isResharedPost);
      case PostContentType.competitionAdded:
      case PostContentType.competitionResultDeclared:
        return CompetitionPostTile(post: model, isResharedPost: isResharedPost);
      case PostContentType.fundRaising:
        return FundRaisingCampaignPostTile(
            post: model, isResharedPost: isResharedPost);
      case PostContentType.job:
        return JobPostTile(post: model, isResharedPost: isResharedPost);
      case PostContentType.offer:
        return OfferPostTile(post: model, isResharedPost: isResharedPost);
      case PostContentType.classified:
        return ClassifiedProductPostTile(
            post: model, isResharedPost: isResharedPost);
      case PostContentType.donation:
        return FundRaisingCampaignPostTile(
            post: model, isResharedPost: isResharedPost);
      case PostContentType.club:
        return ClubPostTile(post: model, isResharedPost: isResharedPost);
      case PostContentType.poll:
        return PollPostTile(post: model, isResharedPost: isResharedPost);
      default:
        return Container();
    }
  }

  Widget _buildMediaContent() {
    final media = model.gallery.first;
    if (media.isVideoPost) {
      return _buildVideoPostTile(media: media, isReshared: isResharedPost);
    } else if (media.isAudioPost) {
      return AudioPostTile(post: model, isResharedPost: isResharedPost);
    } else {
      return _buildPhotoPostTile(media);
    }
  }

  List<Widget> _buildMediaList(bool isReshared) {
    return model.gallery.map((item) {
      return item.isVideoPost
          ? _buildVideoPostTile(media: item, isReshared: isReshared)
          : _buildPhotoPostTile(item);
    }).toList();
  }

  Widget _buildVideoPostTile(
      {required PostGallery media, required bool isReshared}) {
    return VisibilityDetector(
      key: Key(media.id.toString()),
      onVisibilityChanged: (visibilityInfo) {
        final visiblePercentage = visibilityInfo.visibleFraction * 100;
        homeController.setCurrentVisibleVideo(
          media: media,
          visibility: visiblePercentage,
        );
      },
      child: Obx(() => VideoPostTile(
            media: media,
            width: isReshared
                ? Get.width - ((DesignConstants.horizontalPadding * 3) + 10)
                : Get.width,
            url: media.filePath,
            isLocalFile: false,
            play: homeController.currentVisibleVideoId.value == media.id,
            onTapActionHandler: () {},
          )),
    );
  }

  Widget _buildPhotoPostTile(PostGallery media) {
    return CachedNetworkImage(
      imageUrl: media.filePath,
      fit: BoxFit.cover,
      width: Get.width,
      placeholder: (context, url) => AppUtil.addProgressIndicator(size: 100),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}

class PostContent extends StatelessWidget {
  final PostModel model;
  final PostCardController postCardController = Get.find();
  final FlareControls flareControls = FlareControls();
  final bool isSponsored;

  PostContent({
    super.key,
    required this.model,
    required this.isSponsored,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onDoubleTap: _handleDoubleTap,
          child: Stack(
            children: [
              if (!model.isLocked) _buildPostContent(),
              if (!model.isLocked) _buildLikeAnimation(),
              if (model.isLocked) _buildLockedContent(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPostContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (model.postTitle.isNotEmpty)
          RichTextPostTitle(model: model).setPadding(
            left: DesignConstants.horizontalPadding / 2,
            right: DesignConstants.horizontalPadding / 2,
            bottom: 25,
          ),
        PostMediaTile(
          model: model,
          isResharedPost: model.sharedPost != null,
        ),
        if (model.sharedPost != null)
          ResharedPostCard(model: model.sharedPost!).setPadding(
            left: DesignConstants.horizontalPadding,
            right: 10,
            top: 5,
            bottom: 15,
          ),
      ],
    );
  }

  Widget _buildLikeAnimation() {
    return Obx(() => Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: SizedBox(
                width: 80,
                height: 80,
                child: FlareActor(
                  'assets/like.flr',
                  controller: flareControls,
                  animation: 'idle',
                  color: postCardController.likedPosts.contains(model) ||
                          model.isLike
                      ? Colors.red
                      : Colors.white,
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildLockedContent() {
    return Container(
      height: 350,
      width: double.infinity,
      color: AppColorConstants.themeColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ThemeIconWidget(
            ThemeIcon.lock,
            color: Colors.white,
            size: 150,
          ),
          const SizedBox(height: 20),
          Heading5Text(
            subscribeToViewThisContentString.tr
                .replaceAll('{{userName}}', model.user.userName),
            color: Colors.white,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
        ],
      ),
    ).ripple(() {
      Get.to(OtherUserProfile(userId: model.user.id, user: model.user));
    });
  }

  void _handleDoubleTap() {
    if (!model.isLocked) {
      postCardController.likeUnlikePost(post: model);
      flareControls.play("like");
    }
  }

  void _openClubDetail() {
    Get.to(() => ClubDetail(
          club: model.postedInClub!,
          needRefreshCallback: () {},
          deleteCallback: (club) {},
        ));
  }
}

class PostCard extends StatefulWidget {
  final PostModel model;
  final VoidCallback removePostHandler;
  final VoidCallback blockUserHandler;

  const PostCard({
    super.key,
    required this.model,
    required this.removePostHandler,
    required this.blockUserHandler,
  });

  @override
  PostCardState createState() => PostCardState();
}

class PostCardState extends State<PostCard> {
  final HomeController homeController = Get.find();
  final PostCardController postCardController = Get.find();
  final PromotionController _promotionController = Get.find();
  final ChatDetailController _chatDetailController = Get.find();
  final CommentsController _commentsController = CommentsController();

  TextEditingController commentInputField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.model.id.toString()),
      onVisibilityChanged: _handleVisibilityChanged,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfo(),
          PostContent(
            model: widget.model,
            isSponsored: widget.model.postPromotionData != null,
          ),
          // if (widget.model.isMyPost) _buildPostManagementOptions(),
          if (!widget.model.isMyPost &&
              widget.model.isPendingCollaborationRequest)
            _buildCollaborationRequest(),
          const SizedBox(height: 20),
          if (widget.model.postPromotionData != null) _buildSponsoredPostView(),
          _buildCommentAndLikeWidget()
              .hp(DesignConstants.horizontalPadding / 2),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: PostUserInfo(
            post: widget.model,
            isSponsored: widget.model.postPromotionData != null,
            removePostHandler: widget.removePostHandler,
            blockUserHandler: widget.blockUserHandler,
            isResharedPost: false,
          ),
        ),
      ],
    ).setPadding(
      left: DesignConstants.horizontalPadding / 2,
      right: DesignConstants.horizontalPadding / 2,
      bottom: 16,
    );
  }

  // Widget _buildPostManagementOptions() {
  //   return Container(
  //     color: AppColorConstants.cardColor.darken(),
  //     height: 50,
  //     width: double.infinity,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         BodyLargeText(
  //           viewInsightsString.tr,
  //           weight: TextWeight.semiBold,
  //         ).ripple(() {
  //           Get.to(() => ViewPostInsights(post: widget.model));
  //         }),
  //         AppThemeButton(
  //           text: boostPost.tr,
  //           cornerRadius: 5,
  //           height: 36,
  //           onPress: () {
  //             _promotionController.setPromotingPost(widget.model);
  //             Get.to(() => PostPromotionScreen());
  //           },
  //         ),
  //       ],
  //     ).hp(DesignConstants.horizontalPadding),
  //   );
  // }

  Widget _buildCollaborationRequest() {
    return Container(
      color: AppColorConstants.cardColor.darken(),
      height: 50,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BodyLargeText(
            collaborationRequestString.tr,
            weight: TextWeight.semiBold,
          ),
          Row(
            children: [
              AppThemeButton(
                text: acceptString.tr,
                cornerRadius: 5,
                height: 36,
                onPress: _acceptCollaboration,
              ),
              const SizedBox(width: 5),
              AppThemeButton(
                backgroundColor: AppColorConstants.red,
                text: rejectString.tr,
                cornerRadius: 5,
                height: 36,
                onPress: _rejectCollaboration,
              ),
            ],
          ),
        ],
      ).hp(DesignConstants.horizontalPadding),
    );
  }

  Widget _buildSponsoredPostView() {
    return Container(
      color: AppColorConstants.themeColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BodyLargeText(
            _getSponsoredActionText(),
            color: Colors.white,
            weight: TextWeight.semiBold,
          ),
          ThemeIconWidget(
            ThemeIcon.nextArrow,
            size: 25,
            color: Colors.white,
          ),
        ],
      ).p8.ripple(_handleSponsoredAction),
    ).bP16;
  }

  Widget _buildCommentAndLikeWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        spacing: 18,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildLikeButton(),
          if (widget.model.commentsEnabled) _buildCommentButton(),
          _buildViewCount(),
          if (widget.model.sharedPost == null) _buildShareButton(),
          // if (!widget.model.isMyPost &&
          //     widget.model.user.role != UserRole.admin)
          //   _buildGiftButton(),
          if (widget.model.contentType == PostContentType.event)
            _buildEventActionButton(),
          if (widget.model.contentType == PostContentType.competitionAdded ||
              widget.model.contentType ==
                  PostContentType.competitionResultDeclared)
            _buildCompetitionActionButton(),
          if (widget.model.contentType == PostContentType.fundRaising)
            _buildFundRaisingButton(),
          if (widget.model.contentType == PostContentType.job)
            _buildJobActionButton(),
          if (widget.model.contentType == PostContentType.offer)
            _buildOfferActionButton(),
          if (widget.model.contentType == PostContentType.classified)
            _buildClassifiedActionButton(),
          if (widget.model.contentType == PostContentType.donation)
            _buildDonationButton(),
          if (widget.model.contentType == PostContentType.club)
            _buildClubActionButton(),
        ],
      ),
    );
  }

  Widget _buildLikeButton() {
    return Row(
      children: [
        Obx(() => SvgPicture.asset(
              height: postCardController.likedPosts.contains(widget.model) ||
                      widget.model.isLike
                  ? 22 // red filled heart
                  : 22,
              postCardController.likedPosts.contains(widget.model) ||
                      widget.model.isLike
                  ? "assets/Like_filled.svg" // red filled heart
                  : "assets/Like.svg",
              color: postCardController.likedPosts.contains(widget.model) ||
                      widget.model.isLike
                  ? AppColorConstants.red
                  : AppColorConstants.iconColor,
            )

                // Icon(
                // (postCardController.likedPosts.contains(widget.model) ||
                //         widget.model.isLike
                //           ? Iconsax.heart_
                //           : Iconsax.heart_outline) as IconData?,
                //       color: postCardController.likedPosts.contains(widget.model) ||
                //               widget.model.isLike
                //           ? AppColorConstants.red
                //           : AppColorConstants.iconColor,
                //       size: 22,
                //     )
                //       ThemeIconWidget(
                //   postCardController.likedPosts.contains(widget.model) ||
                //           widget.model.isLike
                //       ? Iconsax.like
                //       : ThemeIcon.fav,
                //   color: postCardController.likedPosts.contains(widget.model) ||
                //           widget.model.isLike
                //       ? AppColorConstants.red
                //       : AppColorConstants.iconColor,
                //   size: 20,
                // )

                .ripple(() {
              postCardController.likeUnlikePost(post: widget.model);
            })),
        const SizedBox(width: 5),
        Obx(() {
          final totalLikes =
              postCardController.likedPosts.contains(widget.model)
                  ? postCardController.likedPosts
                      .where((e) => e.id == widget.model.id)
                      .first
                      .totalLike
                  : widget.model.totalLike;
          return BodyMediumText(
            '$totalLikes',
            color: AppColorConstants.mainTextColor,
          ).ripple(() {
            Get.to(() => LikedByUsers(postId: widget.model.id));
          });
        }),
      ],
    );
  }

  Widget _buildCommentButton() {
    return Row(
      children: [
        SvgPicture.asset(
          height: 29,
          "assets/Chat.svg",
          color: AppColorConstants.iconColor,
        ),
        const SizedBox(width: 5),
        BodyMediumText(
          '${widget.model.totalComment}',
          color: AppColorConstants.mainTextColor,
        ).ripple(openComments),
      ],
    ).ripple(openComments);
  }

  Widget _buildViewCount() {
    return Row(
      children: [
        Icon(
          Iconsax.eye_outline,
          size: 24,
          color: AppColorConstants.iconColor,
        ),
        const SizedBox(width: 5),
        BodyMediumText(
          '${widget.model.totalView}',
          color: AppColorConstants.mainTextColor,
        ),
      ],
    );
  }

  Widget _buildShareButton() {
    return Row(
      children: [
        SvgPicture.asset(
          height: 20,
          "assets/Messanger.svg",
          color: AppColorConstants.iconColor,
        ),
        const SizedBox(width: 5),
        BodyMediumText(
          '${widget.model.totalShare}',
          color: AppColorConstants.mainTextColor,
        ),
      ],
    ).ripple(_showShareBottomSheet);
  }

  Widget _buildGiftButton() {
    return Row(
      children: [
        Icon(Iconsax.gift_outline, size: 22),
      ],
    ).ripple(_showGiftBottomSheet);
  }

  Widget _buildEventActionButton() {
    return Column(
      children: [
        ThemeIconWidget(ThemeIcon.event, size: 15),
        const SizedBox(width: 5),
        BodyMediumText(
          !widget.model.event!.isCompleted &&
                  !widget.model.event!.isTicketBooked
              ? bookNow.tr
              : viewString.tr,
        ),
      ],
    ).ripple(() {
      Get.to(() => EventDetail(
            event: widget.model.event!,
            needRefreshCallback: () {},
          ));
    });
  }

  Widget _buildCompetitionActionButton() {
    return Row(
      children: [
        ThemeIconWidget(ThemeIcon.event, size: 15),
        const SizedBox(width: 5),
        BodyMediumText(
          widget.model.contentType == PostContentType.competitionResultDeclared
              ? viewResultString.tr
              : (widget.model.competition!.isPast ||
                      widget.model.competition!.isJoined
                  ? viewString.tr
                  : joinString.tr),
        ),
      ],
    ).ripple(() {
      Get.to(() => CompetitionDetailScreen(
            competitionId: widget.model.competition!.id,
            refreshPreviousScreen: () {},
          ));
    });
  }

  Widget _buildFundRaisingButton() {
    return Row(
      children: [
        ThemeIconWidget(ThemeIcon.event, size: 20),
        const SizedBox(width: 5),
        BodyMediumText(donateNowString.tr),
      ],
    ).ripple(() {
      final FundRaisingController fundRaisingController = Get.find();
      fundRaisingController
          .setCurrentCampaign(widget.model.fundRaisingCampaign!);
      Get.to(() => FundRaisingCampaignDetail(
            campaign: widget.model.fundRaisingCampaign!,
          ));
    });
  }

  Widget _buildJobActionButton() {
    return Row(
      children: [
        ThemeIconWidget(ThemeIcon.event, size: 15),
        const SizedBox(width: 5),
        BodyMediumText(applyString.tr),
      ],
    ).ripple(() {
      Get.to(() => JobDetail(job: widget.model.job!));
    });
  }

  Widget _buildOfferActionButton() {
    return Row(
      children: [
        ThemeIconWidget(ThemeIcon.event, size: 15),
        const SizedBox(width: 5),
        BodyMediumText(viewString.tr),
      ],
    ).ripple(() {
      final NearByOffersController nearByOffersController = Get.find();
      nearByOffersController.setCurrentOffer(widget.model.offer!);
      Get.to(() => OfferDetail(offer: widget.model.offer!));
    });
  }

  Widget _buildClassifiedActionButton() {
    if (widget.model.product?.isSold != true &&
        widget.model.product?.isDeleted != true) {
      return Row(
        children: [
          ThemeIconWidget(ThemeIcon.cart, size: 15),
          const SizedBox(width: 5),
          BodyMediumText(buyString.tr),
        ],
      ).ripple(() {
        Get.to(() => AdDetailScreen(adModel: widget.model.product!));
      });
    }
    return Container();
  }

  Widget _buildDonationButton() {
    return Row(
      children: [
        ThemeIconWidget(ThemeIcon.event, size: 15),
        const SizedBox(width: 5),
        BodyMediumText(donateNowString.tr),
      ],
    ).ripple(() {
      final FundRaisingController fundRaisingController = Get.find();
      fundRaisingController
          .setCurrentCampaign(widget.model.fundRaisingCampaign!);
      Get.to(() => FundRaisingCampaignDetail(
            campaign: widget.model.fundRaisingCampaign!,
          ));
    });
  }

  Widget _buildClubActionButton() {
    return Row(
      children: [
        ThemeIconWidget(ThemeIcon.event, size: 15),
        const SizedBox(width: 5),
        BodyMediumText(
          widget.model.createdClub!.isJoined == true
              ? viewString.tr
              : joinString.tr,
        ),
      ],
    ).ripple(() {
      ClubsController clubController = Get.find();
      clubController.getClubDetail(widget.model.createdClub!.id!, (club) {
        Get.to(() => ClubDetail(
              club: club,
              needRefreshCallback: () {},
              deleteCallback: (club) {},
            ));
      });
    });
  }

  String _getSponsoredActionText() {
    if (widget.model.postPromotionData?.type == GoalType.website) {
      return widget.model.postPromotionData!.urlText!;
    } else if (widget.model.postPromotionData?.type == GoalType.message) {
      return sendMessagesString.tr;
    } else {
      return viewProfileString.tr;
    }
  }

  void _handleSponsoredAction() {
    if (widget.model.postPromotionData?.type == GoalType.website) {
      launchUrl(Uri.parse(widget.model.postPromotionData?.url ?? ''));
    } else if (widget.model.postPromotionData?.type == GoalType.message) {
      _openChatRoom();
    } else {
      Get.to(() => OtherUserProfile(
            userId: widget.model.user.id,
            user: widget.model.user,
          ));
    }
  }

  void _acceptCollaboration() {
    AddPostController controller = Get.find();
    controller.updateCollaborationStatus(
      id: widget.model.myCollaboration.id,
      status: CollaborationStatusType.accepted,
    );
    setState(() {
      widget.model.acceptMyCollaboration();
    });
  }

  void _rejectCollaboration() {
    setState(() {
      widget.model.removeMyCollaboration();
    });
    AddPostController controller = Get.find();
    controller.updateCollaborationStatus(
      id: widget.model.myCollaboration.id,
      status: CollaborationStatusType.rejected,
    );
  }

  void _showShareBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.95,
        child: SharePost(post: widget.model),
      ),
    );
  }

  void _showGiftBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: GiftsPageView(
            giftSelectedCompletion: (gift) {
              Get.back();
              homeController.sendPostGift(
                  gift, widget.model.user.id, widget.model.id);
            },
          ),
        );
      },
    );
  }

  void _handleVisibilityChanged(VisibilityInfo visibilityInfo) {
    final visiblePercentage = visibilityInfo.visibleFraction * 100;
    if (visiblePercentage >= 80) {
      postCardController.postView(
        postId: widget.model.id,
        source: widget.model.postPromotionData != null
            ? ItemViewSource.promotion
            : ItemViewSource.normal,
        postPromotionId: widget.model.postPromotionData?.id,
      );
    }
  }

  void _openChatRoom() {
    Loader.show(status: loadingString.tr);
    _chatDetailController.getChatRoomWithUser(
      userId: widget.model.user.id,
      callback: (room) {
        Loader.dismiss();
        Get.to(() => ChatDetail(chatRoom: room));
      },
    );
  }

  void openComments() {
    Get.to(() => CommentsScreen(
          isPopup: true,
          model: widget.model,
          commentPostedCallback: () {
            setState(() {
              widget.model.totalComment += 1;
            });
          },
        ));
  }
}
