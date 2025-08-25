import 'package:foap/components/job/job_card.dart';
import 'package:foap/controllers/job/job_controller.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/model/category_model.dart';
import 'package:foap/screens/jobs_listing/jobs_list.dart';
import '../../components/category_slider.dart';
import '../../components/paging_scrollview.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ExploreJobs extends StatefulWidget {
  final bool fromCategory;

  const ExploreJobs({super.key, required this.fromCategory});

  @override
  State<ExploreJobs> createState() => _ExploreJobsState();
}

class _ExploreJobsState extends State<ExploreJobs> {
  final JobController _jobController = Get.find();

  @override
  void initState() {
    _jobController.getCategories();
    _jobController.refreshJobs(() {});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showCategoryFilterPopup() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColorConstants.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColorConstants.subHeadingTextColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Header with clean typography
            Row(
              children: [
                Heading5Text(
                  "Filter by Category".tr,
                  color: AppColorConstants.mainTextColor,
                  weight: TextWeight.bold,
                ),
                const Spacer(),
                // Clear all button
                GestureDetector(
                  onTap: () {
                    _jobController.setCategoryId(null);
                    Get.back();
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColorConstants.themeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: BodySmallText(
                      "Clear all".tr,
                      color: AppColorConstants.themeColor,
                      weight: TextWeight.medium,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Modern category grid
            GetBuilder<JobController>(
              init: _jobController,
              builder: (ctx) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: _jobController.categories.length,
                  itemBuilder: (context, index) {
                    final category = _jobController.categories[index];
                    final isSelected =
                        _jobController.searchModel.categoryId == category.id;

                    return GestureDetector(
                      onTap: () {
                        _jobController.setCategoryId(category.id);
                        Get.back();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColorConstants.themeColor
                              : AppColorConstants.backgroundColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppColorConstants.themeColor
                                : AppColorConstants.dividerColor
                                    .withOpacity(0.5),
                            width: isSelected ? 0 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColorConstants.themeColor
                                        .withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color: AppColorConstants.shadowColor
                                        .withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                        ),
                        child: Center(
                          child: BodyMediumText(
                            category.name,
                            color: isSelected
                                ? AppColorConstants.backgroundColor
                                : AppColorConstants.mainTextColor,
                            weight: isSelected
                                ? TextWeight.semiBold
                                : TextWeight.regular,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            expandedHeight: 30,
            backgroundColor: AppColorConstants.backgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColorConstants.themeColor.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColorConstants.mainTextColor,
              ),
              onPressed: () => Get.back(),
            ),
            title: Text(
              jobsString.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColorConstants.mainTextColor,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Modern Search Bar
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: DesignConstants.horizontalPadding,
                    vertical: 8,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColorConstants.backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color:
                              AppColorConstants.shadowColor.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SFSearchBar(
                      shadowOpacity: 0,
                      showSearchIcon: true,
                      iconColor: AppColorConstants.themeColor,
                      backgroundColor: AppColorConstants.cardColor,
                      onSearchChanged: (text) {
                        _jobController.setTitle(text);
                      },
                      onSearchCompleted: (text) {},
                    ),
                  ),
                ),

                // Selected Category Indicator (if any) - Shimmer when loading
                GetBuilder<JobController>(
                  init: _jobController,
                  builder: (ctx) {
                    if (_jobController.isLoadingJobs.value) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColorConstants.cardColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 60,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: AppColorConstants.subHeadingTextColor
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: AppColorConstants.subHeadingTextColor
                                      .withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (_jobController.searchModel.categoryId != null) {
                      final selectedCategory =
                          _jobController.categories.firstWhere(
                        (cat) =>
                            cat.id == _jobController.searchModel.categoryId,
                        orElse: () =>
                            CategoryModel(id: 0, name: '', coverImage: ""),
                      );

                      if (selectedCategory.id != 0) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColorConstants.themeColor
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColorConstants.themeColor
                                        .withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    BodySmallText(
                                      selectedCategory.name,
                                      color: AppColorConstants.themeColor,
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () =>
                                          _jobController.setCategoryId(null),
                                      child: Icon(
                                        Icons.close,
                                        size: 16,
                                        color: AppColorConstants.themeColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                    return const SizedBox.shrink();
                  },
                ),

                // Results Header with Gradient Accent - Shimmer when loading
                GetBuilder<JobController>(
                  init: _jobController,
                  builder: (ctx) {
                    if (_jobController.isLoadingJobs.value) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            // Gradient Accent Bar Shimmer
                            Container(
                              height: 24,
                              width: 4,
                              decoration: BoxDecoration(
                                color: AppColorConstants.subHeadingTextColor
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Results Text Shimmer
                            Expanded(
                              child: Container(
                                width: 120,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: AppColorConstants.subHeadingTextColor
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            // Filter Button Shimmer
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: AppColorConstants.subHeadingTextColor
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          // Gradient Accent Bar
                          Container(
                            height: 24,
                            width: 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColorConstants.themeColor,
                                  AppColorConstants.themeColor.darken(0.3),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Results Text
                          Expanded(
                            child: BodyMediumText(
                              '${found.tr} ${_jobController.jobs.length} ${jobsString.tr.toLowerCase()}',
                              color: AppColorConstants.mainTextColor,
                              weight: TextWeight.medium,
                            ),
                          ),
                          // Filter Button to open bottom sheet
                          GestureDetector(
                            onTap: _showCategoryFilterPopup,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColorConstants.themeColor
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.filter_list_rounded,
                                color: AppColorConstants.themeColor,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Jobs List with animations and shimmer
          GetBuilder<JobController>(
            init: _jobController,
            builder: (ctx) {
              return _jobController.isLoadingJobs.value
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: _JobCardShimmer(),
                          );
                        },
                        childCount: 5, // Show 5 shimmer cards
                      ),
                    )
                  : _jobController.jobs.isEmpty
                      ? SliverFillRemaining(
                          child: Center(
                            child: emptyData(
                              title: "No Jobs Found".tr,
                              subTitle: '',
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      child: JobCard(
                                        job: _jobController.jobs[index],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: _jobController.jobs.length,
                          ),
                        );
            },
          ),
        ],
      ),
    );
  }
}

// Job Card Shimmer Widget
class _JobCardShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColorConstants.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColorConstants.shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company logo and title row
          Row(
            children: [
              // Company logo shimmer
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColorConstants.subHeadingTextColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 12),
              // Title and company shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColorConstants.subHeadingTextColor
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 80,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColorConstants.subHeadingTextColor
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Location and type row
          Row(
            children: [
              Container(
                width: 100,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColorConstants.subHeadingTextColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 80,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColorConstants.subHeadingTextColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Salary and posted date
          Row(
            children: [
              Container(
                width: 90,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColorConstants.subHeadingTextColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const Spacer(),
              Container(
                width: 70,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColorConstants.subHeadingTextColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Apply button shimmer
          Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: AppColorConstants.subHeadingTextColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }
}
