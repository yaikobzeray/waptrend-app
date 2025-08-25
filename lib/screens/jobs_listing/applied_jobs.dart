import 'package:foap/controllers/job/job_controller.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/model/job_model.dart';
import 'package:foap/screens/jobs_listing/job_detail.dart';
import 'package:foap/screens/jobs_listing/jobs_list.dart';
import 'package:intl/intl.dart';
import '../../components/paging_scrollview.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AppliedJobs extends StatefulWidget {
  const AppliedJobs({super.key});

  @override
  State<AppliedJobs> createState() => _AppliedJobsState();
}

class _AppliedJobsState extends State<AppliedJobs> {
  final JobController _jobController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _jobController.refreshAppliedJobs(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
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
              appliedJobsString.tr,
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
                // const SizedBox(height: 20),
                // Results Count with Gradient Accent
                Obx(() {
                  final totalRecords =
                      _jobController.appliedJobsDataWrapper.totalRecords.value;
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
                                      AppColorConstants.themeColor.darken(0.3),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Results Text
                              Expanded(
                                child: BodyMediumText(
                                  '${found.tr} $totalRecords ${appliedJobsString.tr.toLowerCase()}',
                                  color: AppColorConstants.mainTextColor,
                                  weight: TextWeight.medium,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink();
                }),
              ],
            ),
          ),
          // Applied Jobs List
          Obx(() {
            final isLoading = _jobController.isLoadingAppliedJobs.value;
            final appliedJobs = _jobController.appliedJobs;

            return isLoading
                ? SliverFillRemaining(child: AppliedJobShimmerList())
                : appliedJobs.isEmpty
                    ? SliverFillRemaining(
                        child: Center(
                          child: emptyData(
                            title: "No Applied Jobs".tr,
                            subTitle: '',
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final job = appliedJobs[index];
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 0),
                                    child: AppliedJobCard(
                                      job: job,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: appliedJobs.length,
                        ),
                      );
          }),
        ],
      ),
    );
  }
}

class AppliedJobCard extends StatelessWidget {
  final JobModel job;

  const AppliedJobCard({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => JobDetail(job: job)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColorConstants.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company logo/icon
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColorConstants.themeColor.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.business_rounded,
                      color: AppColorConstants.themeColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Job title and company
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColorConstants.mainTextColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          job.postedBy?.name ?? 'Company Name',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColorConstants.subHeadingTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Applied status badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColorConstants.themeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Applied',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColorConstants.themeColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Job details row
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  // Location
                  if (job.city.isNotEmpty)
                    _buildDetailChip(
                      icon: Icons.location_on_outlined,
                      text: '${job.city}, ${job.state}',
                    ),

                  // Experience
                  _buildDetailChip(
                    icon: Icons.work_outline_rounded,
                    text: '${job.minExperience}-${job.maxExperience} yrs',
                  ),

                  // Salary
                  _buildDetailChip(
                    icon: Icons.attach_money_rounded,
                    text:
                        '\$${NumberFormat.compact().format(job.minSalary)}-\$${NumberFormat.compact().format(job.maxSalary)}',
                  ),

                  // Education
                  // if (job.education.isNotEmpty)
                  //   _buildDetailChip(
                  //     icon: Icons.school_outlined,
                  //     text: job.education,
                  //   ),
                ],
              ),

              const SizedBox(height: 12),

              // Skills preview
              if (job.skills.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Skills:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColorConstants.subHeadingTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 28,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: job.skills.split(',').length > 3
                            ? 3
                            : job.skills.split(',').length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 6),
                        itemBuilder: (context, index) {
                          final skill = job.skills.split(',')[index].trim();
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                                  AppColorConstants.themeColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              skill,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColorConstants.themeColor,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailChip({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColorConstants.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColorConstants.subHeadingTextColor,
          ),
          const SizedBox(width: 4),
          Text(
            maxLines: 1,
            text,
            style: TextStyle(
              fontSize: 12,
              color: AppColorConstants.subHeadingTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

class AppliedJobShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              color: AppColorConstants.cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColorConstants.subHeadingTextColor
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(width: 12),
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
                Container(
                  width: 80,
                  height: 24,
                  decoration: BoxDecoration(
                    color:
                        AppColorConstants.subHeadingTextColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 120,
                  height: 14,
                  decoration: BoxDecoration(
                    color:
                        AppColorConstants.subHeadingTextColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Add this string constant if it doesn't exist
extension AppliedJobsStrings on String {
  String get noAppliedJobsString => 'No applied jobs found';
}
