import 'package:foap/controllers/coupons/near_by_offers.dart';
import 'package:foap/controllers/fund_raising/fund_raising_controller.dart';
import 'package:foap/controllers/shop/shop_controller.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/event_imports.dart';
import 'package:foap/screens/add_on/ui/dating/dating_dashboard.dart';
import 'package:foap/screens/add_on/ui/dating/profile/upload_profile_picture.dart';
import 'package:foap/screens/chatgpt/chat_gpt.dart';
import 'package:foap/screens/fund_raising/fund_raising_dashboard.dart';
import 'package:foap/screens/home_feed/story_uploader.dart';
import 'package:foap/screens/jobs_listing/job_listing_dashboard.dart';
import 'package:foap/screens/live/live_users_screen.dart';
import 'package:foap/screens/near_by_offers/offers_dashboard.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../controllers/home/home_controller.dart';
import '../../controllers/job/job_controller.dart';
import '../../helper/permission_utils.dart';
import '../add_on/ui/podcast/podcast_dashboard.dart';
import '../add_on/ui/reel/create_reel_video.dart';
import '../chat/random_chat/choose_profile_category.dart';
import '../club/explore_clubs.dart';
import '../competitions/competitions_screen.dart';
import '../content_creator_view.dart';
import '../highlights/choose_stories.dart';
import '../post/watch_videos.dart';
import '../shop_feature/home/shop_dashboard.dart';
import '../tvs/tv_dashboard.dart';

enum QuickLinkType {
  live,
  randomChat,
  randomCall,
  competition,
  clubs,
  pages,
  tv,
  event,
  podcast,
  story,
  highlights,
  goLive,
  liveUsers,
  reel,
  dating,
  chatGPT,
  fundRaising,
  offers,
  shop,
  job
}

class QuickLink {
  String icon;
  String heading;
  String subHeading;
  QuickLinkType linkType;

  QuickLink({
    required this.icon,
    required this.heading,
    required this.subHeading,
    required this.linkType,
  });
}

class QuickLinkWidget extends StatefulWidget {
  final VoidCallback callback;

  const QuickLinkWidget({super.key, required this.callback});

  @override
  State<QuickLinkWidget> createState() => _QuickLinkWidgetState();
}

class _QuickLinkWidgetState extends State<QuickLinkWidget> {
  final HomeController _homeController = Get.find();
  final UserProfileManager _userProfileManager = Get.find();
  final FundRaisingController _fundRaisingController = Get.find();
  final NearByOffersController _nearByOffersController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => GridView(
          padding: EdgeInsets.only(
            left: DesignConstants.horizontalPadding,
            right: DesignConstants.horizontalPadding,
            top: 20,
            bottom: 100,
          ),
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.2,
          ),
          children: [
            for (QuickLink link in _homeController.quickLinks)
              _QuickLinkCard(
                link: link,
                onTap: () {
                  widget.callback();
                  _handleQuickLinkTap(link);
                },
              ),
          ],
        ));
  }

  void _handleQuickLinkTap(QuickLink link) {
    if (link.linkType == QuickLinkType.competition) {
      Get.to(() => const CompetitionsScreen());
    } else if (link.linkType == QuickLinkType.randomChat) {
      if (AppConfigConstants.isDemoApp) {
        AppUtil.showDemoAppConfirmationAlert(
          title: 'Demo app',
          subTitle: 'This is demo app so might not find online user to test it',
          okHandler: () {
            Get.to(() => const ChooseProfileCategory(
                  isCalling: false,
                ));
          },
        );
        return;
      } else {
        Get.to(() => const ChooseProfileCategory(
              isCalling: false,
            ));
      }
    } else if (link.linkType == QuickLinkType.randomCall) {
      Get.to(() => const ChooseProfileCategory(
            isCalling: true,
          ));
    } else if (link.linkType == QuickLinkType.clubs) {
      Get.to(() => const ExploreClubs());
    } else if (link.linkType == QuickLinkType.pages) {
      // Handle pages
    } else if (link.linkType == QuickLinkType.goLive) {
      Future.delayed(
        Duration.zero,
        () => showGeneralDialog(
          context: Get.context!,
          pageBuilder: (context, animation, secondaryAnimation) =>
              const ContentCreatorView(animateToIndex: 2),
        ),
      );
    } else if (link.linkType == QuickLinkType.story) {
      openStoryUploader();
    } else if (link.linkType == QuickLinkType.highlights) {
      Get.to(() => const ChooseStoryForHighlights());
    } else if (link.linkType == QuickLinkType.tv) {
      Get.to(() => const TvDashboardScreen());
    } else if (link.linkType == QuickLinkType.liveUsers) {
      Get.to(() => const LiveUserScreen());
    } else if (link.linkType == QuickLinkType.event) {
      Get.to(() => const EventsDashboardScreen());
    } else if (link.linkType == QuickLinkType.podcast) {
      Get.to(() => PodcastDashboard());
    } else if (link.linkType == QuickLinkType.reel) {
      Get.to(() => const WatchVideos());
    } else if (link.linkType == QuickLinkType.dating) {
      if (_userProfileManager.user.value!.canUseDating) {
        Get.to(() => const DatingDashboard());
      } else {
        AppUtil.showNewConfirmationAlert(
          title: enableDatingString,
          subTitle: enableDatingProfileToUseString,
          okHandler: () {
            Get.to(() => const UploadProfilePicture(isSettingProfile: true));
          },
          cancelHandler: () {},
        );
      }
    } else if (link.linkType == QuickLinkType.chatGPT) {
      Get.to(() => const ChatGPT());
    } else if (link.linkType == QuickLinkType.fundRaising) {
      _fundRaisingController.initiate();
      Get.to(() => FundRaisingDashboard())!.then((value) {
        _fundRaisingController.clear();
      });
    } else if (link.linkType == QuickLinkType.offers) {
      _nearByOffersController.initiate();
      Get.to(() => OffersDashboard())!.then((value) {
        _nearByOffersController.clear();
      });
    } else if (link.linkType == QuickLinkType.shop) {
      final ShopController shopController = Get.find();
      Get.to(() => ShopDashboard())!.then((value) {
        shopController.clear();
      });
    } else if (link.linkType == QuickLinkType.job) {
      final JobController jobController = Get.find();
      Get.to(() => JobDashboard())!.then((value) {
        jobController.clear();
      });
    }
  }
}

class _QuickLinkCard extends StatelessWidget {
  final QuickLink link;
  final VoidCallback onTap;

  const _QuickLinkCard({
    required this.link,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColorConstants.themeColor.withOpacity(0.1),
                AppColorConstants.themeColor.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColorConstants.themeColor.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background icon (subtle)
              Positioned(
                right: 10,
                bottom: 10,
                child: Opacity(
                  opacity: 0.1,
                  child: Image.asset(
                    link.icon,
                    height: 60,
                    width: 60,
                    color: AppColorConstants.themeColor,
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon with background
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColorConstants.themeColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        fit: BoxFit.cover,
                        link.icon,
                        height: 24,
                        width: 24,
                        // color: AppColorConstants.themeColor.withOpacity(0.5),
                      ),
                    ),
                    // Text content
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Heading6Text(
                          link.heading.tr,
                          weight: TextWeight.bold,
                          maxLines: 1,
                          color: AppColorConstants.themeColor,
                        ),
                        // const SizedBox(height: 2),
                        Text(
                          link.subHeading.tr,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              letterSpacing: -0.17,
                              fontSize: 12,
                              color: AppColorConstants.mainTextColor
                                  .withOpacity(0.3)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
