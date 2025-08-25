import 'package:foap/controllers/job/job_controller.dart';
import 'package:foap/screens/jobs_listing/applied_jobs.dart';
import '../../helper/imports/common_import.dart';
import 'explore_jobs.dart';
import 'job_categories.dart';

class JobsDashboardController extends GetxController {
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

class JobDashboard extends StatelessWidget {
  JobDashboard({super.key});

  final JobsDashboardController _dashboardController =
      JobsDashboardController();
  final JobController jobController = Get.find();

  final List<Widget> items = [
    const ExploreJobs(
      fromCategory: false,
    ),
    JobCategories(),
    const AppliedJobs(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppScaffold(
          backgroundColor: AppColorConstants.backgroundColor,
          body: items[_dashboardController.currentIndex.value],
          bottomNavigationBar: Container(
            height: MediaQuery.of(context).viewPadding.bottom > 0 ? 85 : 75.0,
            decoration: BoxDecoration(
              color: AppColorConstants.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: AppColorConstants.shadowColor.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: BottomNavigationBar(
                backgroundColor: AppColorConstants.cardColor,
                type: BottomNavigationBarType.fixed,
                currentIndex: _dashboardController.currentIndex.value,
                selectedFontSize: 11,
                unselectedFontSize: 11,
                unselectedItemColor: AppColorConstants.subHeadingTextColor,
                selectedItemColor: AppColorConstants.themeColor,
                elevation: 0,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: AppColorConstants.themeColor,
                ),
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                  color: AppColorConstants.subHeadingTextColor,
                ),
                onTap: (index) => {onTabTapped(index)},
                items: [
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _dashboardController.currentIndex.value == 0
                            ? AppColorConstants.themeColor.withOpacity(0.12)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: ThemeIconWidget(
                        ThemeIcon.homeOutlined,
                        size: 20,
                        color: _dashboardController.currentIndex.value == 0
                            ? AppColorConstants.themeColor
                            : AppColorConstants.iconColor,
                      ),
                    ),
                    label: 'Explore',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _dashboardController.currentIndex.value == 1
                            ? AppColorConstants.themeColor.withOpacity(0.12)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: ThemeIconWidget(
                        ThemeIcon.categories,
                        size: 20,
                        color: _dashboardController.currentIndex.value == 1
                            ? AppColorConstants.themeColor
                            : AppColorConstants.iconColor,
                      ),
                    ),
                    label: 'Categories',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _dashboardController.currentIndex.value == 3
                            ? AppColorConstants.themeColor.withOpacity(0.12)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: ThemeIconWidget(
                        ThemeIcon.checkMark,
                        size: 20,
                        color: _dashboardController.currentIndex.value == 3
                            ? AppColorConstants.themeColor
                            : AppColorConstants.iconColor,
                      ),
                    ),
                    label: 'Applied',
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void onTabTapped(int index) async {
    Future.delayed(
        Duration.zero, () => _dashboardController.indexChanged(index));
  }
}
