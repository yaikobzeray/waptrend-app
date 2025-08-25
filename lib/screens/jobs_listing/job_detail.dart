import 'package:foap/controllers/job/job_controller.dart';
import 'package:foap/model/job_model.dart';
import '../../helper/imports/common_import.dart';
import 'about_job.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class JobDetail extends StatefulWidget {
  final JobController jobController = Get.find();
  final JobModel job;

  JobDetail({super.key, required this.job});

  @override
  State<JobDetail> createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {
  final List<String> tabs = [
    aboutString.tr,
    commentsString.tr,
    donorsString.tr
  ];

  @override
  Widget build(BuildContext context) {
    return AboutJob(
      job: widget.job,
    );
//     return AppScaffold(
//       backgroundColor: AppColorConstants.backgroundColor,
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           SliverAppBar(
//             pinned: true,
//             floating: true,
//             expandedHeight: 30,
//             backgroundColor: AppColorConstants.backgroundColor,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       AppColorConstants.themeColor.withOpacity(0.1),
//                       Colors.transparent,
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             leading: IconButton(
//               icon: Icon(
//                 Icons.arrow_back_ios,
//                 color: AppColorConstants.mainTextColor,
//               ),
//               onPressed: () => Get.back(),
//             ),
//             // title: Text(
//             //   widget.job.title,
//             //   style: TextStyle(
//             //     fontSize: 20,
//             //     fontWeight: FontWeight.w700,
//             //     color: AppColorConstants.mainTextColor,
//             //   ),
//             //   maxLines: 1,
//             //   overflow: TextOverflow.ellipsis,
//             // ),
//           ),
//           SliverToBoxAdapter(
//             child: AnimationConfiguration.staggeredList(
//               position: 0,
//               duration: const Duration(milliseconds: 375),
//               child: SlideAnimation(
//                 verticalOffset: 50.0,
//                 child: FadeInAnimation(
//                   child: AboutJob(
//                     job: widget.job,
//                   ).hp(DesignConstants.horizontalPadding),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // If you need a shimmer version for loading state, add this:
// class JobDetailShimmer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//       backgroundColor: AppColorConstants.backgroundColor,
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           SliverAppBar(
//             pinned: true,
//             floating: true,
//             expandedHeight: 30,
//             backgroundColor: AppColorConstants.backgroundColor,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       AppColorConstants.themeColor.withOpacity(0.1),
//                       Colors.transparent,
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             leading: IconButton(
//               icon: Icon(
//                 Icons.arrow_back_ios,
//                 color: AppColorConstants.mainTextColor,
//               ),
//               onPressed: () => Get.back(),
//             ),
//             title: Container(
//               width: 150,
//               height: 20,
//               decoration: BoxDecoration(
//                 color: AppColorConstants.subHeadingTextColor.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: _AboutJobShimmer().hp(DesignConstants.horizontalPadding),
//           ),
//         ],
//       ),
//     );
  }
}

class _AboutJobShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company header shimmer
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColorConstants.subHeadingTextColor.withOpacity(0.1),
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
          const SizedBox(height: 20),

          // Job title shimmer
          Container(
            width: 200,
            height: 20,
            decoration: BoxDecoration(
              color: AppColorConstants.subHeadingTextColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 12),

          // Job details row shimmer
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
              const SizedBox(width: 16),
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
          const SizedBox(height: 16),

          // Salary and location shimmer
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
              const SizedBox(width: 16),
              Container(
                width: 100,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColorConstants.subHeadingTextColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Section title shimmer
          Container(
            width: 80,
            height: 16,
            decoration: BoxDecoration(
              color: AppColorConstants.subHeadingTextColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 12),

          // Description shimmer
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColorConstants.subHeadingTextColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColorConstants.subHeadingTextColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 250,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColorConstants.subHeadingTextColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Requirements title shimmer
          Container(
            width: 100,
            height: 16,
            decoration: BoxDecoration(
              color: AppColorConstants.subHeadingTextColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 12),

          // Requirements list shimmer
          Column(
            children: List.generate(
                3,
                (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: AppColorConstants.subHeadingTextColor
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColorConstants.subHeadingTextColor
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
          ),
          const SizedBox(height: 24),

          // Apply button shimmer
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: AppColorConstants.subHeadingTextColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ],
      ),
    );
  }
}
