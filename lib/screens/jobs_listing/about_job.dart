import 'package:foap/components/user_card.dart';
import 'package:foap/controllers/job/job_controller.dart';
import 'package:foap/model/job_model.dart';
import 'package:foap/screens/jobs_listing/apply_job.dart';
import '../../helper/imports/common_import.dart';

class AboutJob extends StatelessWidget {
  final JobModel job;
  final JobController jobController = Get.find();

  AboutJob({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Job Header with gradient
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 50, 24, 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColorConstants.themeColor.withOpacity(0.9).darken(),
                        AppColorConstants.themeColor.withOpacity(0.5).darken(),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColorConstants.themeColor.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Get.height * 0.05),
                      Row(
                        children: [
                          Expanded(
                            child: Heading3Text(
                              job.title,
                              weight: TextWeight.bold,
                              color: Colors.white,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: BodySmallText(
                              job.category!.name,
                              color: Colors.white,
                              weight: TextWeight.medium,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Main content container
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Posted by Section
                      _buildSectionContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BodyMediumText(
                              postedByString.tr,
                              weight: TextWeight.bold,
                              color: AppColorConstants.subHeadingTextColor,
                            ),
                            const SizedBox(height: 16),
                            UserInfo(model: job.postedBy!),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Job Details Card
                      _buildSectionContainer(
                        child: Column(
                          children: [
                            _buildDetailItem(
                              icon: Icons.work_outline_rounded,
                              title: experienceString.tr,
                              value:
                                  '${job.minExperience} - ${job.maxExperience} ${yearString.tr}',
                            ),
                            const Divider(height: 24),
                            _buildDetailItem(
                              icon: Icons.attach_money_rounded,
                              title: salaryString.tr,
                              value: '\$${job.minSalary} - \$${job.maxSalary}',
                            ),
                            const Divider(height: 24),
                            _buildDetailItem(
                              icon: Icons.location_on_rounded,
                              title: locationString.tr,
                              value:
                                  '${job.city}, ${job.state}, ${job.country}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Skills Section
                      _buildSectionContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Heading6Text(
                              skillsString.tr,
                              weight: TextWeight.bold,
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: job.skills
                                  .split(',')
                                  .map(
                                    (skill) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: AppColorConstants.themeColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: AppColorConstants.themeColor
                                              .withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: BodyMediumText(
                                        maxLines: 2,
                                        skill.trim(),
                                        color: AppColorConstants.themeColor,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // About Section
                      _buildSectionContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Heading6Text(
                              aboutString.tr,
                              weight: TextWeight.bold,
                            ),
                            const SizedBox(height: 16),
                            BodyMediumText(
                              maxLines: 100,
                              job.description,
                              color: AppColorConstants.mainTextColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Back Button
          Positioned(
            top: 40,
            left: 16,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded,
                    color: Colors.white, size: 20),
                onPressed: () => Get.back(),
              ),
            ),
          ),

          // Apply Button
          if (!job.isApplied)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColorConstants.themeColor.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: AppThemeButton(
                    text: applyString,
                    onPress: () {
                      Get.to(() => ApplyJob(job));
                    },
                  )
                  // child: FilledButton(
                  //   style: FilledButton.styleFrom(
                  //     backgroundColor: AppColorConstants.themeColor,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(16),
                  //     ),
                  //     padding: const EdgeInsets.symmetric(vertical: 16),
                  //   ),
                  //   onPressed: () {
                  //     Get.to(() => ApplyJob(job));
                  //   },
                  //   child: BodyLargeText(
                  //     applyString.tr,
                  //     color: Colors.white,
                  //     weight: TextWeight.bold,
                  //   ),
                  // ),
                  ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColorConstants.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColorConstants.themeColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 24,
            color: AppColorConstants.themeColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BodySmallText(
                title,
                color: AppColorConstants.subHeadingTextColor,
              ),
              const SizedBox(height: 4),
              BodyMediumText(
                value,
                weight: TextWeight.semiBold,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
