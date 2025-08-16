import '../../components/notification_tile.dart';
import '../../controllers/notification/notifications_controller.dart';
import '../../controllers/profile/profile_controller.dart';
import '../../helper/imports/common_import.dart';
import '../../model/notification_modal.dart';
import '../competitions/competition_detail_screen.dart';
import '../post/single_post_detail.dart';
import '../profile/follow_requests.dart';
import '../profile/other_user_profile.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationController _notificationController = Get.find();
  final ProfileController _profileController = Get.find();

  @override
  void initState() {
    _notificationController.getNotifications();
    _notificationController.getFollowRequests(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: Column(
        children: [
          // Header with back button and filter
          backNavigationBarWithTrailingWidget(
            title: notificationsString,
            widget: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColorConstants.themeColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.filter_alt,
                size: 18,
                color: AppColorConstants.themeColor,
              ),
            ).ripple(() {
              filterNotifications();
            }),
          ),

          // Follow requests banner
          Obx(() => _notificationController.followRequests.isEmpty
              ? Container()
              : _buildFollowRequestsBanner()),

          // Main content
          Expanded(
            child: GetBuilder<NotificationController>(
              init: _notificationController,
              builder: (ctx) {
                return _notificationController
                        .groupedNotifications.keys.isNotEmpty
                    ? _buildNotificationsList()
                    : _buildEmptyState();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowRequestsBanner() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: DesignConstants.horizontalPadding,
        vertical: 10,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColorConstants.themeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColorConstants.themeColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColorConstants.themeColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: ThemeIconWidget(
              ThemeIcon.request,
              size: 20,
              color: AppColorConstants.themeColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodyMediumText(
                  followRequestsString.tr,
                  weight: TextWeight.semiBold,
                ),
                BodySmallText(
                  acceptFollowRequestsString.tr,
                  color: AppColorConstants.disabledColor,
                ),
              ],
            ),
          ),
          ThemeIconWidget(
            ThemeIcon.nextArrow,
            color: AppColorConstants.themeColor,
          ),
        ],
      ).ripple(() {
        Get.to(() => const FollowRequestList());
      }),
    );
  }

  Widget _buildNotificationsList() {
    return RefreshIndicator(
      onRefresh: () async {
        await _notificationController.getNotifications();
      },
      color: AppColorConstants.themeColor,
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        itemCount: _notificationController.groupedNotifications.keys.length,
        itemBuilder: (BuildContext context, int index) {
          String key =
              _notificationController.groupedNotifications.keys.toList()[index];
          List<NotificationModel> notifications =
              _notificationController.groupedNotifications[key] ?? [];

          return Container(
            margin: EdgeInsets.symmetric(
              horizontal: DesignConstants.horizontalPadding,
              vertical: 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 8),
                  child: Heading6Text(
                    key,
                    weight: TextWeight.medium,
                    color: AppColorConstants.disabledColor,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColorConstants.cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: notifications
                        .map((notification) => Column(
                              children: [
                                NotificationTile(
                                  notification: notification,
                                  followBackUserHandler: () {
                                    _profileController
                                        .followUser(notification.actionBy!);
                                    _notificationController.getNotifications();
                                  },
                                ).ripple(() {
                                  handleNotificationTap(notification);
                                }),
                                if (notification != notifications.last)
                                  Divider(
                                    height: 1,
                                    color: AppColorConstants.dividerColor
                                        .withOpacity(0.2),
                                    indent: 60,
                                  ),
                              ],
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 15);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            color: AppColorConstants.themeColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: ThemeIconWidget(
              ThemeIcon.notification,
              size: 40,
              color: AppColorConstants.themeColor,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Heading5Text(
          noNotificationFoundString.tr,
          weight: TextWeight.medium,
        ),
        const SizedBox(height: 10),
        BodyMediumText(
          "whenYouGetNotificationsTheyWillAppearHere".tr,
          color: AppColorConstants.disabledColor,
          textAlign: TextAlign.center,
        ).hP16,
      ],
    );
  }

  void filterNotifications() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: AppColorConstants.backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4,
              width: 40,
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              decoration: BoxDecoration(
                color: AppColorConstants.disabledColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Heading5Text(
              filterString.tr,
              weight: TextWeight.bold,
            ).bP16,
            Divider(
              height: 1,
              color: AppColorConstants.dividerColor.withOpacity(0.2),
            ),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                children: [
                  _buildFilterOption(
                    SMNotificationType.comment,
                    commentsString.tr,
                    Icons.comment,
                  ),
                  _buildFilterOption(
                    SMNotificationType.like,
                    likesString.tr,
                    Icons.favorite,
                  ),
                  _buildFilterOption(
                    SMNotificationType.follow,
                    followsString.tr,
                    Icons.person,
                  ),
                  _buildFilterOption(
                    SMNotificationType.gift,
                    giftsString.tr,
                    Icons.card_giftcard,
                  ),
                  _buildFilterOption(
                    SMNotificationType.clubInvitation,
                    clubsString.tr,
                    Icons.class_,
                  ),
                  _buildFilterOption(
                    SMNotificationType.competitionAdded,
                    competitionString.tr,
                    Icons.wb_incandescent_sharp,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColorConstants.backgroundColor,
                border: Border(
                  top: BorderSide(
                    color: AppColorConstants.dividerColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppThemeButton(
                      text: "resetString".tr,
                      // textStyle: TextStyle(
                      //   color: AppColorConstants.themeColor,
                      // ),
                      backgroundColor:
                          AppColorConstants.themeColor.withOpacity(0.1),
                      onPress: () {
                        // _notificationController.resetNotificationFilters();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppThemeButton(
                      text: doneString.tr,
                      onPress: () {
                        _notificationController.filterNotifications();
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildFilterOption(
      SMNotificationType type, String title, IconData icon) {
    return Obx(() => Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: _notificationController.selectedNotificationsTypes
                    .contains(type)
                ? AppColorConstants.themeColor.withOpacity(0.1)
                : AppColorConstants.cardColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: Icon(
              icon,
              size: 20,
              color: _notificationController.selectedNotificationsTypes
                      .contains(type)
                  ? AppColorConstants.themeColor
                  : AppColorConstants.disabledColor,
            ),
            title: BodyLargeText(
              title,
              weight: TextWeight.medium,
            ),
            trailing: _notificationController.selectedNotificationsTypes
                    .contains(type)
                ? ThemeIconWidget(
                    ThemeIcon.checkMarkWithCircle,
                    color: AppColorConstants.themeColor,
                  )
                : ThemeIconWidget(
                    ThemeIcon.circleOutline,
                    color: AppColorConstants.disabledColor,
                  ),
            onTap: () {
              _notificationController.selectNotificationType(type);
            },
          ),
        ));
  }

  void handleNotificationTap(NotificationModel notification) {
    _notificationController.markNotificationAsRead(notification.id);

    if (notification.type == SMNotificationType.follow) {
      int userId = notification.actionBy!.id;
      Get.to(() => OtherUserProfile(userId: userId));
    } else if (notification.type == SMNotificationType.comment) {
      int postId = notification.post!.id;
      Get.to(() => SinglePostDetail(postId: postId));
    } else if (notification.type == SMNotificationType.like) {
      Get.to(() => SinglePostDetail(postId: notification.post!.id));
    } else if (notification.type == SMNotificationType.collaborate) {
      Get.to(() => SinglePostDetail(postId: notification.collaboration!.refId));
    } else if (notification.type == SMNotificationType.competitionAdded) {
      int competitionId = notification.competition!.id;
      Get.to(() => CompetitionDetailScreen(
            competitionId: competitionId,
            refreshPreviousScreen: () {},
          ));
    }
  }
}
