import 'package:flutter/material.dart';
import 'package:foap/screens/content_creator_view.dart';
import 'package:get/get.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../../components/force_update_view.dart';
import '../../main.dart';
import '../../manager/location_manager.dart';
import '../add_on/ui/reel/reels.dart';
import '../home_feed/home_feed_screen.dart';
import '../profile/my_profile.dart';
import '../settings_menu/settings_controller.dart';
import 'explore.dart';

class DashboardController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxInt unreadMsgCount = 0.obs;
  RxBool isLoading = false.obs;

  indexChanged(int index) {
    currentIndex.value = index;
  }

  updateUnreadMessageCount(int count) {
    unreadMsgCount.value = count;
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  final DashboardController _dashboardController = Get.find();
  final SettingsController _settingsController = Get.find();
  final LocationManager _locationManager = Get.find();

  late PersistentTabController _navController;

  @override
  void initState() {
    super.initState();
    isAnyPageInStack = true;
    _locationManager.postLocation();

    _navController = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      const HomeFeedScreen(),
      const Explore(),
      Container(),
      const Reels(needBackBtn: false),
      const MyProfile(showBack: false),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(AntDesign.home_fill),
        activeColorPrimary: AppColorConstants.themeColor.darken(),
        inactiveColorPrimary: AppColorConstants.themeColor.darken(),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Bootstrap.at),
        activeColorPrimary: AppColorConstants.themeColor.darken(),
        inactiveColorPrimary: AppColorConstants.themeColor.darken(),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.add_circle, size: 35),
        activeColorPrimary: AppColorConstants.themeColor.darken(),
        inactiveColorPrimary: AppColorConstants.themeColor.darken(),
        onPressed: (context) {
          Get.to(() => ContentCreatorView());
        },
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Bootstrap.camera_video_fill),
        activeColorPrimary: AppColorConstants.themeColor.darken(),
        inactiveColorPrimary: AppColorConstants.themeColor.darken(),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Bootstrap.person_circle),
        activeColorPrimary: AppColorConstants.themeColor.darken(),
        inactiveColorPrimary: AppColorConstants.themeColor.darken(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_dashboardController.isLoading.value) {
        return _buildLoadingScreen();
      }

      if (_settingsController.forceUpdate.value) {
        return ForceUpdateView();
      }
      if (_settingsController.appearanceChanged?.value == null) {
        return Container();
      }
      return PersistentTabView(
        context,
        controller: _navController,
        screens: _buildScreens(),
        items: _navBarItems(),
        backgroundColor: AppColorConstants.themeColor.withOpacity(0.1),
        animationSettings: NavBarAnimationSettings(),
        hideNavigationBarWhenKeyboardAppears: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(0),
          colorBehindNavBar: AppColorConstants.backgroundColor,
        ),
        navBarStyle: NavBarStyle.style6,
      );
    });
  }

  Widget _buildLoadingScreen() {
    return Container(
      color: AppColorConstants.backgroundColor,
      child: Center(
        child: SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator.adaptive(
            backgroundColor: AppColorConstants.themeColor.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColorConstants.themeColor,
            ),
            strokeWidth: 3,
          ),
        ),
      ),
    );
  }
}
