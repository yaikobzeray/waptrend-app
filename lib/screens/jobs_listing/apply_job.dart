import 'package:foap/controllers/job/job_controller.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/model/job_model.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:icons_plus/icons_plus.dart';

class ApplyJob extends StatefulWidget {
  final JobModel job;

  const ApplyJob(this.job, {super.key});

  @override
  State<ApplyJob> createState() => ApplyJobState();
}

class ApplyJobState extends State<ApplyJob> {
  final JobController jobController = Get.find();
  TextEditingController experience = TextEditingController();
  TextEditingController education = TextEditingController();
  TextEditingController coverLetter = TextEditingController();

  List<int> experienceList = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25
  ];

  @override
  void initState() {
    super.initState();
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
              applyString.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColorConstants.mainTextColor,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: AnimationConfiguration.staggeredList(
              position: 0,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: DesignConstants.horizontalPadding,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildApplicationForm(),
                        SizedBox(height: Get.height * 0.1),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: DesignConstants.horizontalPadding,
                vertical: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildApplyButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Experience Dropdown
        _buildExperienceDropdown(),
        const SizedBox(height: 20),

        // Education Field
        _buildEducationField(),
        const SizedBox(height: 20),

        // Cover Letter Field
        _buildCoverLetterField(),
        const SizedBox(height: 20),

        // Resume Upload
        _buildResumeUpload(),
      ],
    );
  }

  Widget _buildExperienceDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          experienceInYearsString.tr,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColorConstants.mainTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Container(
              decoration: BoxDecoration(
                // color: AppColorConstants.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColorConstants.themeColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: jobController.experience.value.toString(),
                  isExpanded: true,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: AppColorConstants.themeColor,
                  ),
                  items: experienceList.map((e) {
                    return DropdownMenuItem<String>(
                      value: e.toString(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '$e ${"years".tr}',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColorConstants.mainTextColor,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      jobController.selectExperience(int.parse(value));
                    }
                  },
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildEducationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          educationString.tr,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColorConstants.mainTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            // color: AppColorConstants.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColorConstants.themeColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: TextField(
            controller: education,
            decoration: InputDecoration(
              hintText: 'MCA, B.Tech, etc.',
              hintStyle: TextStyle(
                color: AppColorConstants.subHeadingTextColor,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            style: TextStyle(
              fontSize: 16,
              color: AppColorConstants.mainTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCoverLetterField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          coverLetterString.tr,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColorConstants.mainTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            // color: AppColorConstants.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColorConstants.themeColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: TextField(
            controller: coverLetter,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: enterHereString.tr,
              hintStyle: TextStyle(
                color: AppColorConstants.subHeadingTextColor,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            style: TextStyle(
              fontSize: 16,
              color: AppColorConstants.mainTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResumeUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          uploadResumeString.tr,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColorConstants.mainTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColorConstants.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColorConstants.dividerColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: InkWell(
                onTap: () {
                  jobController.openFilePicker();
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.drive_folder_upload_outlined,
                        size: 32,
                        color: AppColorConstants.themeColor,
                      ),
                      const SizedBox(height: 8),
                      jobController.selectedResumeFileName.isEmpty
                          ? Text(
                              "Click To Upload Resume".tr,
                              style: TextStyle(
                                color: AppColorConstants.subHeadingTextColor,
                              ),
                            )
                          : Text(
                              jobController.selectedResumeFileName.value,
                              style: TextStyle(
                                color: AppColorConstants.themeColor,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildApplyButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColorConstants.cardColor,
        boxShadow: [
          BoxShadow(
            color: AppColorConstants.shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: AppThemeButton(
        text: applyString.tr,
        onPress: submitBtnClicked,
      ),
    );
  }

  void submitBtnClicked() {
    if (education.text.isEmpty) {
      AppUtil.showToast(message: pleaseEnterEducationString, isSuccess: false);
    } else if (coverLetter.text.isEmpty) {
      AppUtil.showToast(
          message: pleaseEnterCoverLetterString, isSuccess: false);
    } else if (jobController.selectedResume == null) {
      AppUtil.showToast(message: pleaseSelectResumeString, isSuccess: false);
    } else {
      jobController.applyJob(
          jobId: widget.job.id.toString(),
          experience: jobController.experience.value.toString(),
          education: education.text,
          coverLetter: coverLetter.text);
    }
  }
}

class _JobHeaderCard extends StatelessWidget {
  final JobModel job;

  const _JobHeaderCard({required this.job});

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
          Text(
            job.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColorConstants.mainTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

// Add these string constants if they don't exist
