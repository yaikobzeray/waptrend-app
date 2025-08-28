import 'package:flutter/material.dart';
import 'package:foap/components/sm_tab_bar.dart';
import 'package:foap/controllers/notification/notifications_controller.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/login_signup_imports.dart';
import 'package:foap/helper/imports/reel_imports.dart';
import 'package:foap/model/account.dart';
import 'package:foap/model/highlights.dart';
import 'package:foap/screens/profile/update_profile.dart';
import 'package:foap/screens/settings_menu/notifications.dart';
import 'package:foap/screens/settings_menu/settings.dart';
import 'package:foap/util/shared_prefs.dart';
import '../../components/highlights_bar.dart';
import '../../controllers/story/highlights_controller.dart';
import '../../controllers/profile/profile_controller.dart';
import '../highlights/choose_stories.dart';
import '../highlights/hightlights_viewer.dart';
import '../settings_menu/settings_controller.dart';

class MyProfile extends StatefulWidget {
  final bool showBack;

  const MyProfile({super.key, required this.showBack});

  @override
  MyProfileState createState() => MyProfileState();
}

class MyProfileState extends State<MyProfile> {
  final ProfileController _profileController = Get.find();
  final HighlightsController _highlightsController = Get.find();
  final SettingsController _settingsController = Get.find();
  final UserProfileManager _userProfileManager = Get.find();
  final NotificationController _notificationController = Get.find();

  List<String> tabs = ['Posts', 'Trends', 'Tagged'];

  @override
  void initState() {
    super.initState();
    _notificationController.getNotificationInfo();
    initialLoad();
  }

  initialLoad() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _profileController.clear();
      loadData();
    });
  }

  @override
  void didUpdateWidget(covariant MyProfile oldWidget) {
    super.didUpdateWidget(oldWidget);
    loadData();
  }

  @override
  void dispose() {
    _profileController.clear();
    super.dispose();
  }

  loadData() {
    _profileController.getMyProfile();
    _profileController.getPosts(
        userId: _userProfileManager.user.value!.id, callback: () {});
    _profileController.getReels(_userProfileManager.user.value!.id);
    _highlightsController.getHighlights(
        userId: _userProfileManager.user.value!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppScaffold(
          backgroundColor: AppColorConstants.backgroundColor,
          body: _profileController.user.value == null
              ? ProfileShimmer()
              : DefaultTabController(
                  length: tabs.length,
                  child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          backgroundColor: AppColorConstants.backgroundColor,
                          expandedHeight: 380,
                          floating: false,
                          pinned: true,
                          automaticallyImplyLeading: false,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Column(
                              children: [
                                // Top app bar
                                _buildInstagramAppBar(),
                                // Profile header
                                _buildProfileHeader(),
                                // Highlights
                                _buildHighlights(),
                              ],
                            ),
                          ),
                        ),
                        SliverPersistentHeader(
                          delegate: _SliverAppBarDelegate(
                            TabBar(
                              tabs: tabs
                                  .map((String name) => Tab(text: name))
                                  .toList(),
                              indicatorColor: AppColorConstants.themeColor,
                              labelColor: AppColorConstants.themeColor,
                              unselectedLabelColor:
                                  AppColorConstants.themeColor.withOpacity(0.5),
                            ),
                          ),
                          pinned: true,
                        ),
                      ];
                    },
                    body: TabBarView(
                      children: [
                        _buildPostsView(),
                        _buildReelsView(),
                        _buildTaggedView(),
                      ],
                    ),
                  ),
                ),
        ));
  }

  Widget _buildInstagramAppBar() {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Stack(
        children: [
          if (widget.showBack == false)
            Row(
              children: [
                Heading6Text(
                  _profileController.user.value!.userName,
                  weight: TextWeight.bold,
                ),
                const SizedBox(
                  width: 5,
                ),
                ThemeIconWidget(ThemeIcon.downArrow),
              ],
            ).ripple(() async {
              List<SayHiAppAccount> accounts =
                  await SharedPrefs().getAccounts();
              accounts = accounts
                  .where((e) =>
                      e.userId != _userProfileManager.user.value!.id.toString())
                  .toList();
              Get.bottomSheet(LinkedAccountsList(
                accounts: accounts,
              ));
            }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.showBack == true
                  ? SizedBox(
                      width: 50,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ThemeIconWidget(
                          ThemeIcon.backArrow,
                          size: 18,
                          color: AppColorConstants.iconColor,
                        ),
                      )).ripple(() {
                      Get.back();
                    })
                  : const SizedBox(width: 50),
              Row(
                children: [
                  // Obx(() => Stack(
                  //       children: [
                  //         ThemeIconWidget(
                  //           ThemeIcon.notification,
                  //           size: 25,
                  //           color: AppColorConstants.themeColor,
                  //         )
                  //             .rp(_notificationController
                  //                         .unreadNotificationCount.value >
                  //                     0
                  //                 ? 15
                  //                 : 0)
                  //             .ripple(() {
                  //           Get.to(() => const NotificationsScreen());
                  //         }),
                  //         if (_notificationController
                  //                 .unreadNotificationCount.value >
                  //             0)
                  //           Positioned(
                  //               right: 0,
                  //               top: 0,
                  //               child: Container(
                  //                 color: AppColorConstants.themeColor,
                  //                 child: Center(
                  //                   child: Text(
                  //                     _notificationController
                  //                         .unreadNotificationCount.value
                  //                         .toString(),
                  //                     style: const TextStyle(
                  //                         fontSize: 8, color: Colors.white),
                  //                     textAlign: TextAlign.center,
                  //                   ).setPadding(
                  //                       top: 2, bottom: 2, left: 4, right: 4),
                  //                 ),
                  //               ).circular)
                  //       ],
                  //     )),
                  const SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.menu,
                    size: 25,
                    color: AppColorConstants.themeColor,
                  ).ripple(() {
                    Get.to(() => const Settings());
                  })
                ],
              ),
            ],
          ),
        ],
      ).setPadding(
          left: DesignConstants.horizontalPadding,
          right: DesignConstants.horizontalPadding,
          top: 50),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              // Profile picture
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: UserAvatarView(
                    user: _profileController.user.value!,
                    size: 80,
                  ),
                ),
              ),
              const SizedBox(width: 30),
              // Stats
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn(
                        'Posts', _profileController.user.value!.totalPost),
                    _buildStatColumn('Followers',
                        _profileController.user.value!.totalFollower),
                    _buildStatColumn('Following',
                        _profileController.user.value!.totalFollowing),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Bio
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodyLargeText(
                  _profileController.user.value!.userName,
                  weight: TextWeight.bold,
                ),
                if (_profileController.user.value!.bio != null)
                  BodyMediumText(_profileController.user.value!.bio!),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Edit profile button
          SizedBox(
            width: double.infinity,
            child: AppThemeButton(
              height: 35,
              text: editProfileString.tr,
              onPress: () {
                Get.to(() => const UpdateProfile())!.then((value) {
                  loadData();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, int value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BodyLargeText(
          value.toString(),
          weight: TextWeight.bold,
        ),
        BodySmallText(label),
      ],
    );
  }

  Widget _buildHighlights() {
    return SizedBox(
      height: 100,
      child: GetBuilder<HighlightsController>(
        builder: (ctx) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _highlightsController.highlights.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildAddHighlight();
              }
              final highlight = _highlightsController.highlights[index - 1];
              return _buildHighlightItem(highlight);
            },
          );
        },
      ),
    );
  }

  Widget _buildAddHighlight() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Get.to(() => const ChooseStoryForHighlights());
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Icon(Icons.add),
            ),
          ),
          const SizedBox(height: 4),
          const BodySmallText('New'),
        ],
      ),
    );
  }

  Widget addHighlightsView() {
    return GetBuilder<HighlightsController>(
      init: _highlightsController,
      builder: (ctx) {
        return _highlightsController.isLoading.value == true
            ? const StoryAndHighlightsShimmer()
            : HighlightsBar(
                highlights: _highlightsController.highlights,
                addHighlightCallback: () {
                  Get.to(() => const ChooseStoryForHighlights());
                },
                viewHighlightCallback: (highlight) {
                  print("Tapped highlight: ${highlight.id}");
                  Get.to(() => HighlightViewer(highlight: highlight))
                      ?.then((_) => loadData());
                },
              );
      },
    );
  }

  Widget _buildHighlightItem(HighlightsModel highlight) {
    return GestureDetector(
      onTap: () {
        // Call the same callback that opens HighlightViewer
        Get.to(() => HighlightViewer(highlight: highlight))
            ?.then((_) => loadData());
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.yellow.shade600,
                    Colors.orange,
                    Colors.red,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(2),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: highlight.coverImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            BodySmallText(
              highlight.name,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsView() {
    return GetBuilder<ProfileController>(
      builder: (ctx) {
        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
          ),
          itemCount: _profileController.posts.length,
          itemBuilder: (context, index) {
            return CachedNetworkImage(
              imageUrl: _profileController.posts[index].gallery.first.thumbnail,
              fit: BoxFit.cover,
            );
          },
        );
      },
    );
  }

  Widget _buildReelsView() {
    return GetBuilder<ProfileController>(
      builder: (ctx) {
        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
          ),
          itemCount: _profileController.reels.length,
          itemBuilder: (context, index) {
            return Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl:
                      _profileController.reels[index].gallery.first.thumbnail,
                  fit: BoxFit.cover,
                ),
                const Center(
                  child: Icon(Icons.play_arrow, color: Colors.white),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTaggedView() {
    return GetBuilder<ProfileController>(
      builder: (ctx) {
        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
          ),
          itemCount: _profileController.mentions.length,
          itemBuilder: (context, index) {
            return CachedNetworkImage(
              imageUrl:
                  _profileController.mentions[index].gallery.first.thumbnail,
              fit: BoxFit.cover,
            );
          },
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColorConstants.backgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class LinkedAccountsList extends StatelessWidget {
  final UserProfileManager _userProfileManager = Get.find();

  List<SayHiAppAccount> accounts;

  LinkedAccountsList({super.key, required this.accounts});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        color: AppColorConstants.backgroundColor,
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            BodyLargeText(switchAccountString.tr),
            divider(height: 0.5).tP16,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (SayHiAppAccount account in accounts)
                      Column(
                        children: [
                          SizedBox(
                            height: 55,
                            child: Row(
                              children: [
                                AvatarView(
                                  url: account.picture,
                                  name: account.username,
                                  size: 28,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                BodyLargeText(account.username),
                              ],
                            ),
                          ).ripple(() {
                            Get.back();
                            _userProfileManager.switchToAccount(account);
                          }),
                          divider(height: 0.5).vP8,
                        ],
                      ),
                  ],
                ).p(DesignConstants.horizontalPadding),
              ),
            ),
            AppThemeButton(
                text: addAccountString.tr,
                onPress: () {
                  Get.back();
                  Get.to(const LoginScreen(
                    showCloseBtn: true,
                  ));
                }).p(DesignConstants.horizontalPadding)
          ],
        ),
      ).topRounded(25),
    );
  }
}
