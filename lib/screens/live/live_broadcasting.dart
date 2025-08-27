import 'dart:ui';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:animate_do/animate_do.dart';
import 'package:foap/helper/number_extension.dart';
import 'package:foap/screens/live/banned_users.dart';
import 'package:foap/screens/live/moderator_users.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../components/timer_view.dart';
import '../../controllers/live/agora_live_controller.dart';
import '../../controllers/misc/gift_controller.dart';
import '../../controllers/misc/subscription_packages_controller.dart';
import '../../controllers/profile/profile_controller.dart';
import '../../model/gift_model.dart';
import 'components.dart';
import 'gift_sender_list.dart';
import 'gifts_list.dart';
import 'invite_users.dart';
import 'live_joined_users.dart';
import 'messages_in_live.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'moderator_detail_popup.dart';

class LiveBroadcastScreen extends StatefulWidget {
  const LiveBroadcastScreen({Key? key}) : super(key: key);

  @override
  State<LiveBroadcastScreen> createState() => _LiveBroadcastScreenState();
}

class _LiveBroadcastScreenState extends State<LiveBroadcastScreen>
    with SingleTickerProviderStateMixin {
  final AgoraLiveController _agoraLiveController = Get.find();
  final GiftController _giftController = Get.find();
  final SubscriptionPackageController packageController = Get.find();
  final ProfileController _profileController = Get.find();

  late AnimationController _controller;
  late Animation<double> _leftContainerAnimation;
  late Animation<double> _rightContainerAnimation;

  @override
  void initState() {
    super.initState();
    prepareAnimationController();
    packageController.initiate();

    _agoraLiveController.getLiveViewers(() {});
    _agoraLiveController.getModerator(() {});
    _agoraLiveController.getBannedUser(() {});

    WakelockPlus.enable();
  }

  @override
  void dispose() {
    _controller.dispose();
    _agoraLiveController.clear();
    super.dispose();
  }

  void prepareAnimationController() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _leftContainerAnimation =
        Tween<double>(begin: -Get.width / 2, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5),
      ),
    );

    _rightContainerAnimation = Tween<double>(begin: Get.width, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5),
      ),
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Background with blur effect
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: AppColorConstants.backgroundColor.withOpacity(0.85),
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Obx(
                    () => _agoraLiveController.liveEnd.value
                        ? liveEndWidget()
                        : onLiveWidget(),
                  ),
                ),
              ),
            ),

            // Gift animation overlay
            Obx(() => _agoraLiveController.populateGift.value == null
                ? Container()
                : Positioned.fill(
                    child: Pulse(
                      duration: const Duration(milliseconds: 500),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColorConstants.themeColor
                                    .withOpacity(0.3),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: CachedNetworkImage(
                            imageUrl: _agoraLiveController
                                .populateGift.value!.giftDetail.logo,
                            height: 150,
                            width: 150,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  )),

            // Battle result bottom sheet
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Obx(
                () => _agoraLiveController
                                .live.value?.battleDetail?.battleStatus ==
                            BattleStatus.completed &&
                        !_agoraLiveController.liveEnd.value
                    ? SlideInUp(
                        child: battleResultView(),
                      )
                    : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget askLiveEndConfirmation() {
    return Container(
      width: Get.width,
      height: Get.height,
      color: AppColorConstants.backgroundColor.withOpacity(0.4),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Center(
          child: Container(
            width: Get.width * 0.85,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColorConstants.cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Heading4Text(
                  maxLines: 3,
                  _agoraLiveController.live.value!.battleStatus ==
                          BattleStatus.started
                      ? endLiveBattleConfirmationString.tr
                      : endLiveCallConfirmationString.tr,
                  textAlign: TextAlign.center,
                  weight: TextWeight.semiBold,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: AppThemeButton(
                        text: noString.tr,
                        onPress: () {
                          if (_agoraLiveController.live.value!.battleStatus ==
                              BattleStatus.started) {
                            _agoraLiveController.dontEndLiveBattle();
                          } else {
                            _agoraLiveController.dontEndLiveCall();
                          }
                        },
                        cornerRadius: 15,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: AppThemeButton(
                        text: yesString.tr,
                        onPress: () {
                          if (_agoraLiveController.live.value!.battleStatus ==
                              BattleStatus.started) {
                            _agoraLiveController.liveBattleCompleted();
                          } else {
                            _agoraLiveController.onCallEnd(isHost: true);
                          }
                        },
                        cornerRadius: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget onLiveWidget() {
    return Stack(
      children: [
        Obx(
          () => (_agoraLiveController.live.value?.battleDetail?.battleStatus ==
                      BattleStatus.started ||
                  _agoraLiveController.live.value?.battleDetail?.battleStatus ==
                      BattleStatus.accepted ||
                  (_agoraLiveController.live.value?.battleDetail?.battleUsers ??
                              [])
                          .isNotEmpty &&
                      _agoraLiveController
                              .live.value?.battleDetail?.battleStatus !=
                          BattleStatus.completed)
              ? Column(
                  children: [
                    battleView(),
                    bottomSectionView(),
                  ],
                )
              : Stack(
                  children: [
                    singleUserLiveView(),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: bottomSectionView(),
                    ),
                  ],
                ),
        ),
        Obx(() => _agoraLiveController.liveEnd.value ? Container() : topBar()),
        if (_agoraLiveController.askLiveEndConformation.value == true ||
            _agoraLiveController.askBattleEndConformation.value == true)
          Positioned.fill(child: askLiveEndConfirmation()),
      ],
    );
  }

  Widget singleUserLiveView() {
    return Obx(() {
      if (_agoraLiveController.live.value == null) return Container();

      return _agoraLiveController.live.value!.amIMainHostInLive
          ? SizedBox(height: Get.height, child: _renderLocalPreview())
          : _renderRemoteVideo(LiveCallHostUser(
              userDetail: _agoraLiveController.live.value!.mainHostUserDetail!,
              isMainHost: true,
              totalCoins: 0,
              totalGifts: 0,
            ));
    });
  }

  Widget battleView() {
    return SizedBox(
      height: Get.height * 0.6,
      child: Column(
        children: [
          const SizedBox(height: 50),
          // Battle progress bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColorConstants.cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                UserAvatarView(
                  size: 30,
                  hideLiveIndicator: true,
                  hideOnlineIndicator: true,
                  user: _agoraLiveController
                      .live.value!.battleDetail!.mainHost.userDetail,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColorConstants.backgroundColor,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: _agoraLiveController.live.value!.battleDetail!
                                .percentageOfCoinsFor(_agoraLiveController
                                    .live.value!.battleDetail!.mainHost)
                                .round(),
                            child: Container(
                              height: 25,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColorConstants.themeColor,
                                    AppColorConstants.themeColor
                                        .withOpacity(0.7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ThemeIconWidget(
                                      ThemeIcon.diamond,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                    Obx(() => BodySmallText(
                                          _agoraLiveController.live.value!
                                              .battleDetail!.mainHost.totalCoins
                                              .toString(),
                                          color: Colors.white,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: _agoraLiveController.live.value!.battleDetail!
                                .percentageOfCoinsFor(_agoraLiveController
                                    .live.value!.battleDetail!.opponentHost)
                                .round(),
                            child: Container(
                              height: 25,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColorConstants.red,
                                    AppColorConstants.red.withOpacity(0.7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Obx(() => BodySmallText(
                                          _agoraLiveController
                                              .live
                                              .value!
                                              .battleDetail!
                                              .opponentHost
                                              .totalCoins
                                              .toString(),
                                          color: Colors.white,
                                        )),
                                    ThemeIconWidget(
                                      ThemeIcon.diamond,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                UserAvatarView(
                  size: 30,
                  hideLiveIndicator: true,
                  hideOnlineIndicator: true,
                  user: _agoraLiveController
                      .live.value!.battleDetail!.opponentHost.userDetail,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Stack(
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Row(
                      children: [
                        SizedBox(
                          width: Get.width / 2,
                          height: double.infinity,
                          child: Transform.translate(
                            offset: Offset(_leftContainerAnimation.value, 0),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20),
                              ),
                              child: mainHostView(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Get.width / 2,
                          height: double.infinity,
                          child: Transform.translate(
                            offset: Offset(_rightContainerAnimation.value, 0),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                              ),
                              child: battleOpponentView(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColorConstants.red,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ThemeIconWidget(
                            ThemeIcon.clock,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          UnlockTimerView(
                            unlockTime: _agoraLiveController.live.value!
                                .battleDetail!.timeRemainingInBattle,
                            completionHandler: () {
                              _agoraLiveController.liveBattleCompleted();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_agoraLiveController
                        .live.value?.battleDetail?.battleStatus ==
                    BattleStatus.accepted)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _userBattleCard(
                                _agoraLiveController
                                    .live.value!.mainHostUserDetail!,
                                _agoraLiveController
                                    .live.value!.mainHostUserDetail!.userName,
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColorConstants.backgroundColor,
                                  border: Border.all(
                                    color: AppColorConstants.red,
                                    width: 3,
                                  ),
                                ),
                                child: Heading4Text(
                                  'VS',
                                  weight: TextWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              _userBattleCard(
                                _agoraLiveController.live.value!.battleDetail!
                                    .opponentHost.userDetail,
                                _agoraLiveController.live.value!.battleDetail!
                                    .opponentHost.userDetail.userName,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Lottie.asset(
                            'assets/lottie/live_battle.json',
                            height: 150,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _userBattleCard(UserModel user, String userName) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColorConstants.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          UserAvatarView(
            user: user,
            size: 40,
            hideOnlineIndicator: true,
            hideLiveIndicator: true,
          ),
          const SizedBox(height: 5),
          BodySmallText(
            userName,
            maxLines: 1,
            weight: TextWeight.medium,
          ),
        ],
      ),
    );
  }

  Widget mainHostView() {
    if (_agoraLiveController.live.value!.amIMainHostInLive) {
      return _renderLocalPreview();
    } else {
      return _renderRemoteVideo(
          _agoraLiveController.live.value!.battleDetail!.mainHost);
    }
  }

  Widget battleOpponentView() {
    if (_agoraLiveController.live.value!.amIMainHostInLive) {
      return _renderRemoteVideo(
          _agoraLiveController.live.value!.battleDetail!.opponentHost);
    } else {
      if (_agoraLiveController.live.value!.amIHostInLive) {
        return _renderLocalPreview();
      }
      return _renderRemoteVideo(
          _agoraLiveController.live.value!.battleDetail!.opponentHost);
    }
  }

  Widget battleResultView() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColorConstants.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child:
                    _agoraLiveController.live.value!.battleDetail!.resultType ==
                            LiveBattleResultType.winner
                        ? winnerDetail()
                        : drawViewDetail(),
              ),
              if (_agoraLiveController.live.value!.amIHostInLive)
                Expanded(
                  child: GiftSenders(
                    liveId: _agoraLiveController.live.value!.id,
                    battleId: _agoraLiveController.live.value!.battleDetail?.id,
                  ),
                ),
            ],
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColorConstants.themeColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: ThemeIconWidget(
                  ThemeIcon.close,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ).ripple(() {
              _agoraLiveController.closeWinnerInfo();
            }),
          ),
        ],
      ),
    );
  }

  Widget winnerDetail() {
    return Column(
      children: [
        Text(
          winnerString,
          style: TextStyle(
            fontSize: FontSizes.h3,
            fontWeight: TextWeight.bold,
            color: AppColorConstants.themeColor,
          ),
        ),
        const SizedBox(height: 15),
        Image.asset(
          'assets/crown.png',
          width: 60,
        ),
        const SizedBox(height: 15),
        UserAvatarView(
          user: _agoraLiveController
              .live.value!.battleDetail!.winnerHost.userDetail,
          size: 80,
          hideOnlineIndicator: true,
          hideLiveIndicator: true,
        ),
        const SizedBox(height: 10),
        Heading5Text(
          _agoraLiveController
              .live.value!.battleDetail!.winnerHost.userDetail.userName,
          weight: TextWeight.semiBold,
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColorConstants.themeColor,
                AppColorConstants.themeColor.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ThemeIconWidget(
                ThemeIcon.diamond,
                size: 18,
                color: Colors.white,
              ),
              const SizedBox(width: 5),
              BodyLargeText(
                _agoraLiveController
                    .live.value!.battleDetail!.winnerHost.totalCoins
                    .toString(),
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget drawViewDetail() {
    return Column(
      children: [
        Heading4Text(
          battleDrawString,
          weight: TextWeight.bold,
          color: AppColorConstants.themeColor,
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _hostDetailCard(
                _agoraLiveController.live.value!.battleDetail!.mainHost),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColorConstants.backgroundColor,
                border: Border.all(
                  color: AppColorConstants.red,
                  width: 2,
                ),
              ),
              child: Heading5Text(
                'VS',
                weight: TextWeight.bold,
              ),
            ),
            _hostDetailCard(
                _agoraLiveController.live.value!.battleDetail!.opponentHost),
          ],
        ),
      ],
    );
  }

  Widget _hostDetailCard(LiveCallHostUser host) {
    return Column(
      children: [
        UserAvatarView(
          user: host.userDetail,
          size: 60,
          hideOnlineIndicator: true,
          hideLiveIndicator: true,
        ),
        const SizedBox(height: 10),
        BodyLargeText(
          host.userDetail.userName,
          weight: TextWeight.semiBold,
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColorConstants.themeColor,
                AppColorConstants.themeColor.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ThemeIconWidget(
                ThemeIcon.diamond,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 5),
              BodySmallText(
                host.totalCoins.toString(),
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget liveEndWidget() {
    return _agoraLiveController.live.value != null
        ? _agoraLiveController.live.value!.amIHostInLive
            ? liveEndWidgetForHosts()
            : liveEndWidgetForViewers()
        : Container();
  }

  Widget liveEndWidgetForViewers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 50),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColorConstants.cardColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: ThemeIconWidget(
                ThemeIcon.close,
                size: 20,
              ),
            ).ripple(() {
              Get.back();
              _agoraLiveController.clear();
            }),
            const Spacer(),
          ],
        ).hP25,
        hostUserInfo(),
      ],
    );
  }

  Widget liveEndWidgetForHosts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 50),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColorConstants.cardColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ThemeIconWidget(
                ThemeIcon.close,
                size: 20,
              ),
            ).ripple(() {
              _agoraLiveController.closeLive();
            }),
            const Spacer(),
          ],
        ).hP25,
        const SizedBox(height: 20),
        Heading4Text(
          liveEndString.tr,
          weight: TextWeight.medium,
        ),
        Container(
          height: 4,
          width: 100,
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColorConstants.themeColor,
                AppColorConstants.themeColor.withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 40),
        liveStatisticsInfo().hp(DesignConstants.horizontalPadding),
        const SizedBox(height: 30),
        Expanded(
          child: GiftSenders(
            liveId: _agoraLiveController.live.value!.id,
          ),
        ),
      ],
    );
  }

  Widget liveStatisticsInfo() {
    return Container(
      width: Get.width / 1.4,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColorConstants.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statItem(
                '${_agoraLiveController.totalViewers}',
                usersString.tr,
              ),
              _statItem(
                _agoraLiveController.liveDurationLength,
                durationString.tr,
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statItem(
                '${_agoraLiveController.giftsReceived.length}',
                giftsString.tr,
              ),
              _statItem(
                _agoraLiveController.totalCoinsEarned.toString(),
                coinsEarnedString.tr,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Heading4Text(
          value,
          weight: TextWeight.medium,
        ),
        const SizedBox(height: 5),
        BodySmallText(
          label,
          weight: TextWeight.bold,
          color: AppColorConstants.themeColor,
        ),
      ],
    );
  }

  Widget hostUserInfo() {
    UserModel mainHostDetail =
        _agoraLiveController.live.value!.mainHostUserDetail!;
    return Column(
      children: [
        const SizedBox(height: 100),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppColorConstants.themeColor,
                AppColorConstants.themeColor.withOpacity(0.5),
              ],
            ),
          ),
          child: UserAvatarView(
            user: mainHostDetail,
            hideLiveIndicator: true,
            hideOnlineIndicator: true,
            size: 100,
          ),
        ),
        const SizedBox(height: 15),
        Heading4Text(
          mainHostDetail.userName,
          weight: TextWeight.bold,
          color: AppColorConstants.mainTextColor,
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: AppColorConstants.cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Heading6Text(
            liveEndString.tr,
            weight: TextWeight.medium,
          ),
        ),
      ],
    );
  }

  Widget bottomSectionView() {
    return Container(
      height: Get.height * 0.4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.5),
          ],
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: !(_agoraLiveController.live.value?.amIHostInLive == true)
                ? Column(
                    children: [
                      Expanded(child: MessagesInLive()),
                    ],
                  )
                : MessagesInLive(),
          ),
          messageComposerView(),
        ],
      ),
    );
  }

  Widget messageComposerView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: AppColorConstants.cardColor.withOpacity(0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Textfield row
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: AppColorConstants.themeColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Obx(() => TextField(
                        controller: _agoraLiveController.messageTf.value,
                        style: TextStyle(
                          fontSize: FontSizes.b2,
                          color: AppColorConstants.mainTextColor,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          border: InputBorder.none,
                          hintText: messageString.tr,
                          hintStyle: TextStyle(
                            fontSize: FontSizes.b2,
                            color: AppColorConstants.subHeadingTextColor,
                          ),
                        ),
                      )),
                ),
              ),
              const SizedBox(width: 10),
              Obx(() {
                if (_agoraLiveController.messageTextFocus.value) {
                  return _sendButton();
                }
                return _sendButton();
              }),
            ],
          ),

          const SizedBox(height: 10),

          // Host controls appear only below textfield if host
          Obx(() {
            if (_agoraLiveController.live.value?.amIHostInLive == true &&
                !_agoraLiveController.messageTextFocus.value) {
              return _hostControls();
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _sendButton() {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColorConstants.themeColor,
            AppColorConstants.themeColor.withOpacity(0.8),
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: ThemeIconWidget(
          ThemeIcon.send,
          size: 20,
          color: Colors.white,
        ),
      ),
    ).ripple(() {
      sendMessage();
    });
  }

  Widget _hostControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _sendButton(),
        const SizedBox(width: 8),
        _controlButton(
          icon: ThemeIcon.cameraSwitch,
          onTap: () => _agoraLiveController.onToggleCamera(),
        ),
        const SizedBox(width: 8),
        _controlButton(
          icon: _agoraLiveController.mutedVideo.value
              ? ThemeIcon.videoCameraOff
              : ThemeIcon.videoCamera,
          onTap: () => _agoraLiveController.onToggleMuteVideo(),
        ),
        const SizedBox(width: 8),
        _controlButton(
          icon: _agoraLiveController.mutedAudio.value
              ? ThemeIcon.micOff
              : ThemeIcon.mic,
          onTap: () => _agoraLiveController.onToggleMuteAudio(),
        ),
        if (_agoraLiveController.live.value?.canInvite == true) ...[
          const SizedBox(width: 8),
          _controlButton(
            icon: ThemeIcon.invite,
            onTap: () => createBattle(),
          ),
        ],
      ],
    );
  }

  Widget _viewerControls() {
    return _controlButton(
      icon: ThemeIcon.diamond,
      color: Colors.yellow,
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => FractionallySizedBox(
            heightFactor: 0.8,
            child: GiftsPageView(
              giftSelectedCompletion: (gift) {
                Get.back();
                sendGift(gift);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _controlButton({
    required ThemeIcon icon,
    Color? color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: AppColorConstants.themeColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: ThemeIconWidget(
          icon,
          size: 20,
          color: color ?? Colors.white,
        ),
      ),
    ).ripple(onTap);
  }

  Widget topBar() {
    return _agoraLiveController.live.value != null
        ? Column(
            children: [
              Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    // Host info
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColorConstants.themeColor,
                                AppColorConstants.themeColor.withOpacity(0.7),
                              ],
                            ),
                          ),
                          child: UserAvatarView(
                            user: _agoraLiveController
                                .live.value!.mainHostUserDetail!,
                            size: 30,
                            hideLiveIndicator: true,
                            hideOnlineIndicator: true,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: Get.width * 0.2,
                          child: BodyMediumText(
                            _agoraLiveController
                                .live.value!.mainHostUserDetail!.userName,
                            maxLines: 1,
                            weight: TextWeight.medium,
                          ),
                        ),
                      ],
                    ).ripple(() {
                      _profileController.getOtherUserDetail(
                        userId: _agoraLiveController
                            .live.value!.mainHostUserDetail!.id,
                        completionBlock: (user) {},
                      );
                      showModalBottomSheet<void>(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => FractionallySizedBox(
                          heightFactor: 1,
                          child: ModeratorDetail(),
                        ),
                      ).then((value) {
                        _profileController.clear();
                      });
                    }),
                    const Spacer(),
                    // Moderators button
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: const ModeratorUsers(),
                    ),
                    const SizedBox(width: 10),
                    // Share button
                    _topBarButton(
                      icon: ThemeIcon.share,
                      onTap: () => Share.share(
                          _agoraLiveController.live.value!.shareLink),
                    ),
                    const SizedBox(width: 10),
                    // Banned users (for moderators/hosts)
                    if (_agoraLiveController.amIModeratorInLive ||
                        _agoraLiveController.live.value!.amIHostInLive)
                      _topBarButton(
                        icon: ThemeIcon.bannedAccount,
                        onTap: () {
                          _agoraLiveController.refreshBannedViewers();
                          showModalBottomSheet<void>(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const BannedUsers(),
                          );
                        },
                      ),
                    const SizedBox(width: 10),
                    // Viewer count
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColorConstants.themeColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          ThemeIconWidget(
                            ThemeIcon.eye,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          Obx(() => BodySmallText(
                                _agoraLiveController
                                    .totalViewers.value.formatNumber,
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ).ripple(() {
                      _agoraLiveController.getLiveViewers(() {});
                      showModalBottomSheet<void>(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const LiveJoinedUsers(),
                      );
                    }),
                    const SizedBox(width: 10),
                    // Close button
                    _topBarButton(
                      icon: ThemeIcon.close,
                      onTap: () {
                        if (_agoraLiveController.live.value!.battleStatus ==
                            BattleStatus.started) {
                          _agoraLiveController.askConfirmationForEndBattle();
                        } else if (_agoraLiveController
                            .live.value!.amIHostInLive) {
                          _agoraLiveController.askConfirmationForEndCall();
                        } else {
                          _agoraLiveController.onCallEnd(isHost: false);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          )
        : Container();
  }

  Widget _topBarButton({
    required ThemeIcon icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: AppColorConstants.cardColor.withOpacity(0.7),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: ThemeIconWidget(
          icon,
          size: 18,
        ),
      ),
    ).ripple(onTap);
  }

  Widget _renderLocalPreview() {
    return Obx(() => _agoraLiveController.mutedVideo.value
        ? Container(
            color: AppColorConstants.red,
            child: Center(
                child: Heading6Text(
              videoPausedString.tr,
              color: AppColorConstants.subHeadingTextColor,
            )))
        : _agoraLiveController.engine != null
            ? AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: _agoraLiveController.engine!,
                  canvas: VideoCanvas(
                      uid: 0,
                      sourceType: _agoraLiveController.localVideoSource),
                ),
              )
            : Container(
                color: Colors.yellow,
              ));
  }

  Widget _renderRemoteVideo(LiveCallHostUser host) {
    return GetBuilder<AgoraLiveController>(
        init: _agoraLiveController,
        builder: (ctx) {
          return _agoraLiveController.remoteJoinedUsers
                      .contains(host.userDetail.id) ==
                  false
              ? Container(
                  color: AppColorConstants.backgroundColor,
                )
              : _agoraLiveController.videoPausedUsers
                          .contains(host.userDetail.id) ==
                      true
                  ? Container(
                      color: AppColorConstants.themeColor,
                      child: Center(
                          child: Heading6Text(
                        videoPausedString.tr,
                        color: AppColorConstants.subHeadingTextColor,
                      )))
                  : _agoraLiveController.engine != null
                      ? AgoraVideoView(
                          controller: VideoViewController.remote(
                            rtcEngine: _agoraLiveController.engine!,
                            canvas: VideoCanvas(uid: host.userDetail.id),
                            connection: RtcConnection(
                                channelId: _agoraLiveController
                                    .live.value!.channelName),
                          ),
                        )
                      : Container(
                          color: Colors.brown,
                        );
        });
  }

  Widget topGiftsView() {
    return SizedBox(
      height: 80,
      child: Obx(() => ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: DesignConstants.horizontalPadding,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: _giftController.topGifts.length,
            itemBuilder: (ctx, index) {
              return _giftItem(_giftController.topGifts[index]);
            },
            separatorBuilder: (ctx, index) => const SizedBox(width: 10),
          )),
    );
  }

  Widget _giftItem(GiftModel gift) {
    return Container(
      width: 70,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColorConstants.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CachedNetworkImage(
            imageUrl: gift.logo,
            height: 30,
            width: 30,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ThemeIconWidget(
                ThemeIcon.diamond,
                size: 14,
                color: AppColorConstants.themeColor,
              ),
              const SizedBox(width: 2),
              BodySmallText(
                gift.coins.toString(),
                weight: TextWeight.medium,
              ),
            ],
          ),
        ],
      ),
    ).ripple(() => sendGift(gift));
  }

  Widget selectHostForGift(Function(LiveCallHostUser) userSelectedCallback) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColorConstants.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Heading4Text(
            sendGiftToString,
            weight: TextWeight.bold,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _giftRecipientCard(
                  _agoraLiveController
                      .live.value!.battleDetail!.battleUsers.first,
                  () => userSelectedCallback(
                    _agoraLiveController
                        .live.value!.battleDetail!.battleUsers.first,
                  ),
                ),
                Container(
                  width: 1,
                  height: 120,
                  color: AppColorConstants.dividerColor,
                ),
                _giftRecipientCard(
                  _agoraLiveController
                      .live.value!.battleDetail!.battleUsers.last,
                  () => userSelectedCallback(
                    _agoraLiveController
                        .live.value!.battleDetail!.battleUsers.last,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _giftRecipientCard(LiveCallHostUser host, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Get.width * 0.35,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColorConstants.backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UserAvatarView(
              user: host.userDetail,
              size: 60,
              hideOnlineIndicator: true,
              hideLiveIndicator: true,
            ),
            const SizedBox(height: 10),
            BodyLargeText(
              host.userDetail.userName,
              weight: TextWeight.semiBold,
              maxLines: 1,
            ),
            const SizedBox(height: 15),
            AppThemeButton(
              height: 35,
              width: 80,
              text: sendString,
              onPress: onTap,
            ),
          ],
        ),
      ),
    );
  }

  void createBattle() {
    if (!_agoraLiveController.live.value!.canInvite) {
      alreadyInvitedWidget();
      return;
    }
    showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.6,
            child: Container(
              color: AppColorConstants.cardColor,
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  Heading4Text(
                    chooseBattleTimeString,
                    weight: TextWeight.bold,
                  ),
                  const SizedBox(height: 25),
                  Expanded(
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 8,
                                childAspectRatio: 3,
                                crossAxisSpacing: 8),
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 50),
                        itemBuilder: (ctx, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColorConstants.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Heading4Text(
                                _agoraLiveController.battleTimeArray[index]
                                    .convertSecondsToTimeString,
                                color: Colors.white,
                              ),
                            ),
                          ).ripple(() {
                            Navigator.of(context).pop();
                            Future.delayed(const Duration(milliseconds: 200),
                                () {
                              inviteOpponent(
                                  _agoraLiveController.battleTimeArray[index]);
                            });
                          });
                        },
                        itemCount: _agoraLiveController.battleTimeArray.length),
                  ),
                ],
              ),
            ).topRounded(40),
          );
        });
  }

  void inviteOpponent(int battleTime) {
    showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return InviteUsers(
            userSelectedHandler: (user) {
              _agoraLiveController.inviteUserToLive(
                  user: user,
                  battleTime: battleTime,
                  alreadyInvitedHandler: () {
                    alreadyInvitedWidget();
                  });
            },
          );
        });
  }

  void alreadyInvitedWidget() {
    showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.55,
            child: AlreadyInvitedTimerView(
              user: _agoraLiveController.live.value!.invitedUserDetail!,
              time: 30,
            ),
          );
        });
  }

  void sendGift(GiftModel gift) {
    if ((_agoraLiveController.live.value!.battleDetail?.battleUsers ?? [])
        .isEmpty) {
      _agoraLiveController.sendGift(gift: gift);
    } else {
      showModalBottomSheet<void>(
          backgroundColor: Colors.transparent,
          context: context,
          enableDrag: true,
          isDismissible: true,
          builder: (BuildContext context) {
            return FractionallySizedBox(
                heightFactor: 0.65,
                child: selectHostForGift((user) {
                  Navigator.of(context).pop();
                  _agoraLiveController.sendGift(gift: gift, host: user);
                }));
          });
    }
  }

  void sendMessage() {
    if (_agoraLiveController.messageTf.value.text.removeAllWhitespace
        .trim()
        .isNotEmpty) {
      _agoraLiveController
          .sendTextMessage(_agoraLiveController.messageTf.value.text);
    }
  }
}
