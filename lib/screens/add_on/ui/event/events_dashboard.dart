import 'package:foap/screens/add_on/ui/event/event_feed.dart';
import 'package:foap/screens/add_on/ui/event/search_events.dart';
import 'create_event/my_events.dart';
import 'event_bookings.dart';
import 'explore_events.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:flutter/animation.dart';

class EventsDashboardController extends GetxController {
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

class EventsDashboardScreen extends StatefulWidget {
  const EventsDashboardScreen({super.key});

  @override
  EventsDashboardScreenState createState() => EventsDashboardScreenState();
}

class EventsDashboardScreenState extends State<EventsDashboardScreen>
    with SingleTickerProviderStateMixin {
  final EventsDashboardController _dashboardController =
      EventsDashboardController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<Widget> items = [];
  bool hasPermission = false;

  @override
  void initState() {
    super.initState();

    items = [
      const ExploreEvents(),
      const EventFeedScreen(),
      const SearchEventListing(),
      const EventBookingScreen(),
      const MyEventListing()
    ];

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Trigger animation when tab changes
      if (_animationController.status != AnimationStatus.forward) {
        _animationController.reset();
        _animationController.forward();
      }

      return AppScaffold(
        backgroundColor: AppColorConstants.backgroundColor,
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: items[_dashboardController.currentIndex.value],
        ),
        bottomNavigationBar: _buildModernNavBar(),
      );
    });
  }

  Widget _buildModernNavBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: AppColorConstants.shadowColor.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          backgroundColor: AppColorConstants.cardColor,
          type: BottomNavigationBarType.fixed,
          currentIndex: _dashboardController.currentIndex.value,
          selectedFontSize: 0, // Hide labels
          unselectedFontSize: 0, // Hide labels
          elevation: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: onTabTapped,
          items: [
            _buildNavItem(ThemeIcon.event, 0),
            _buildNavItem(ThemeIcon.home, 1),
            _buildNavItem(ThemeIcon.search, 2),
            _buildNavItem(ThemeIcon.bookings, 3),
            _buildNavItem(ThemeIcon.account, 4),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(ThemeIcon icon, int index) {
    final isSelected = _dashboardController.currentIndex.value == index;
    final iconColor = isSelected
        ? AppColorConstants.themeColor
        : AppColorConstants.iconColor.withOpacity(0.7);

    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: isSelected
            ? BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColorConstants.themeColor.withOpacity(0.2),
                    AppColorConstants.themeColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ThemeIconWidget(
              icon,
              color: iconColor,
              size: 22,
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 3,
                width: 20,
                decoration: BoxDecoration(
                  color: AppColorConstants.themeColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
      label: '',
    );
  }

  void onTabTapped(int index) async {
    _dashboardController.indexChanged(index);
  }
}
