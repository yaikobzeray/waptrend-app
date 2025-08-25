import 'package:foap/components/job/job_card.dart';
import 'package:foap/controllers/job/job_controller.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/event_imports.dart';
import 'package:foap/screens/jobs_listing/jobs_list.dart';
import '../../components/paging_scrollview.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class JobsByCategory extends StatefulWidget {
  final CategoryModel category;

  const JobsByCategory({super.key, required this.category});

  @override
  State<JobsByCategory> createState() => _JobsByCategoryState();
}

class _JobsByCategoryState extends State<JobsByCategory> {
  final JobController _jobController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _jobController.refreshJobs(() {});
    });
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
              widget.category.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColorConstants.mainTextColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
                    vertical: 16,
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
                          ],
                        ),
                      );
                    }

                    final totalRecords =
                        _jobController.jobsDataWrapper.totalRecords.value;
                    return totalRecords > 0
                        ? Container(
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
                                        AppColorConstants.themeColor
                                            .darken(0.3),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Results Text
                                Expanded(
                                  child: BodyMediumText(
                                    '${found.tr} $totalRecords ${jobsString.tr.toLowerCase()}',
                                    color: AppColorConstants.mainTextColor,
                                    weight: TextWeight.medium,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink();
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
                              subTitle: 'in ${widget.category.name}',
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
