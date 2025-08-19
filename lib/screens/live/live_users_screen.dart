import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/number_extension.dart';
import 'package:foap/model/live_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import '../../controllers/live/agora_live_controller.dart';
import '../../controllers/live/live_users_controller.dart';
import 'live_end_screen.dart';

class LiveUserScreen extends StatefulWidget {
  const LiveUserScreen({super.key});

  @override
  State<LiveUserScreen> createState() => _LiveUserScreenState();
}

class _LiveUserScreenState extends State<LiveUserScreen> {
  final AgoraLiveController _agoraLiveController = Get.find();
  final LiveUserController _liveUserController = Get.find();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _liveUserController.getLiveUsers(() {});
    });
    super.initState();
  }

  loadMore() {
    _liveUserController.loadMore(() {});
  }

  @override
  void dispose() {
    _liveUserController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColorConstants.backgroundColor,
      body: KeyboardDismissOnTap(
        child: Column(
          children: [
            backNavigationBar(title: liveUsersString.tr),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                // Show shimmer loading while initially loading
                if (_liveUserController.isLoading.value &&
                    _liveUserController.liveStreamUser.isEmpty) {
                  return _buildShimmerLoading();
                }

                // Show empty state only after loading complete
                if (_liveUserController.liveStreamUser.isEmpty) {
                  return _buildEmptyState();
                }

                return SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: false,
                  enablePullUp: true,
                  onLoading: () => loadMore(),
                  footer: CustomFooter(
                    builder: (context, mode) {
                      return Container(
                        height: 55,
                        child: Center(
                          child: mode == LoadStatus.loading
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColorConstants.themeColor,
                                  ),
                                )
                              : const SizedBox(),
                        ),
                      );
                    },
                  ),
                  child: ListView.builder(
                    itemCount: _liveUserController.liveStreamUser.length,
                    padding: EdgeInsets.symmetric(
                      horizontal: DesignConstants.horizontalPadding,
                      vertical: 8,
                    ),
                    itemBuilder: (context, index) {
                      final liveStreaming =
                          _liveUserController.liveStreamUser[index];

                      return _buildLiveCard(liveStreaming, index);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 3,
      padding: EdgeInsets.symmetric(
        horizontal: DesignConstants.horizontalPadding,
        vertical: 8,
      ),
      itemBuilder: (context, index) {
        return Container(
          height: 280,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColorConstants.cardColor,
          ),
          child: Shimmer.fromColors(
            baseColor: AppColorConstants.cardColor,
            highlightColor: AppColorConstants.cardColor.lighten(0.1),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.live_tv_rounded,
            size: 64,
            color: AppColorConstants.themeColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Heading5Text(
            noLiveUserString,
            color: AppColorConstants.mainTextColor.withOpacity(0.7),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          BodyMediumText(
            'Be the first to go live!',
            color: AppColorConstants.subHeadingTextColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLiveCard(UserLiveCallDetail liveStreaming, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      height: 280,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColorConstants.shadowColor.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 6),
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: UserPlaneImageView(
                size: Get.width,
                user: liveStreaming.host![0],
              ),
            ),

            // Gradient overlay for better text readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                    stops: const [0.0, 0.4, 0.6, 1.0],
                  ),
                ),
              ),
            ),

            // Live badge with viewer count (top-right)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Live indicator
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    BodySmallText(
                      'LIVE',
                      color: Colors.white,
                      weight: TextWeight.bold,
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.group,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    BodySmallText(
                      liveStreaming.totalUsers!.formatNumber,
                      color: Colors.white,
                      weight: TextWeight.medium,
                    ),
                  ],
                ),
              ),
            ),

            // Host info (bottom-left)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  // Host avatar with gradient border
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColorConstants.themeColor,
                          AppColorConstants.themeColor.withOpacity(0.8),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColorConstants.shadowColor,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(2),
                    child: ClipOval(
                      child: UserAvatarView(
                        user: liveStreaming.host![0],
                        size: 46,
                        hideBorder: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Host username and subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Heading6Text(
                          liveStreaming.host![0].userName,
                          color: Colors.white,
                          maxLines: 1,
                          // overflow: TextOverflow.ellipsis,
                          weight: TextWeight.bold,
                        ),
                        const SizedBox(height: 4),
                        BodySmallText(
                          'Tap to join • Live now',
                          color: Colors.white.withOpacity(0.8),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).ripple(() {
      _liveUserController.getLiveDetail(
        channelName: liveStreaming.channelName,
        resultCallback: (result) {
          LiveModel live = LiveModel();
          live.channelName = liveStreaming.channelName;
          live.mainHostUserDetail = liveStreaming.host!.first;
          live.token = liveStreaming.token;
          live.id = liveStreaming.id;
          if (result.isOngoing) {
            _agoraLiveController.joinAsAudience(
              live: live,
            );
          } else {
            Get.to(() => LiveEndScreen(
                  live: live,
                ));
          }
        },
      );
    });
  }
}
