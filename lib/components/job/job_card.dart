import 'package:foap/model/job_model.dart';
import 'package:foap/screens/jobs_listing/job_detail.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import '../../helper/imports/common_import.dart';

class JobCard extends StatelessWidget {
  final JobModel job;

  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => JobDetail(job: job)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColorConstants.backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColorConstants.shadowColor.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: AppColorConstants.themeColor.withOpacity(0.1),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: job.postedBy!.picture!,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        color: AppColorConstants.themeColor.withOpacity(0.1),
                        child: Icon(
                          Icons.work_outline,
                          color: AppColorConstants.themeColor,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),

                // Content area
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Company Name and Location
                      Row(
                        children: [
                          Expanded(
                            child: BodyLargeText(
                              job.postedBy!.name!,
                              weight: TextWeight.semiBold,
                              maxLines: 1,
                              // overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: Get.width * 0.35,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  IonIcons.location,
                                  size: 16,
                                  color: AppColorConstants.mainTextColor
                                      .withOpacity(0.6),
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: BodySmallText(
                                    job.city.isNotEmpty ? job.city : 'Remote',
                                    maxLines: 1,
                                    // overflow: TextOverflow.ellipsis,
                                    color: AppColorConstants.mainTextColor
                                        .withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(height: 8),

                      // Job Title
                      BodyLargeText(
                        job.title,
                        weight: TextWeight.semiBold,
                        maxLines: 1,
                      ),

                      if (job.category != null) ...[
                        BodySmallText(
                          job.category!.name,
                          color: AppColorConstants.themeColor,
                          weight: TextWeight.medium,
                        ),
                        const SizedBox(height: 8),
                      ],

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (job.minExperience > 0 || job.maxExperience > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColorConstants.themeColor
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.work_history,
                                    size: 14,
                                    color: AppColorConstants.themeColor,
                                  ),
                                  const SizedBox(width: 4),
                                  BodySmallText(
                                    job.minExperience == job.maxExperience
                                        ? '${job.minExperience}+ yrs'
                                        : '${job.minExperience}-${job.maxExperience} yrs',
                                    color: AppColorConstants.themeColor,
                                  ),
                                ],
                              ),
                            ),

                          // Education
                          if (job.education.isNotEmpty)
                            Container(
                              // padding: const EdgeInsets.symmetric(
                              //     horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                // color:
                                //     AppColorConstants.themeColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Icon(
                                  //   Iconsax.text_block_bold,
                                  //   size: 14,
                                  //   color: AppColorConstants.themeColor,
                                  // ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: Get.width * 0.78,
                                    child: Text(
                                      job.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: AppColorConstants.mainTextColor
                                            .withOpacity(0.5),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Salary Range with modern design
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColorConstants.themeColor
                                  .withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: BodyMediumText(
                            '\$${NumberFormat.compact().format(job.minSalary)}-\$${NumberFormat.compact().format(job.maxSalary)}',
                            weight: TextWeight.semiBold,
                            color: AppColorConstants.mainTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Applied Badge - positioned at top right
            if (job.isApplied)
              Positioned(
                right: 16,
                top: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColorConstants.themeColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColorConstants.themeColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: BodySmallText(
                    appliedString.tr,
                    color: Colors.white,
                    weight: TextWeight.medium,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
