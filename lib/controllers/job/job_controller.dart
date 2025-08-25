import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/event_imports.dart';
import 'package:foap/helper/list_extension.dart';
import 'package:foap/model/data_wrapper.dart';
import 'package:foap/model/job_model.dart';
import '../../api_handler/apis/job_api.dart';
import '../../api_handler/apis/misc_api.dart';
import '../../model/category_model.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class JobController extends GetxController {
  // 🔹 Reactive states
  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  RxList<JobModel> jobs = <JobModel>[].obs;
  RxList<JobModel> appliedJobs = <JobModel>[].obs;

  // 🔹 Search model for filtering
  JobSearchModel searchModel = JobSearchModel();

  // 🔹 Loading states
  RxBool isLoadingCategories = false.obs;
  RxBool isLoadingJobs = false.obs;
  RxBool isLoadingAppliedJobs = false.obs;

  // 🔹 Data wrappers for pagination
  DataWrapper jobsDataWrapper = DataWrapper();
  DataWrapper appliedJobsDataWrapper = DataWrapper();

  // 🔹 Other states
  Rx<JobModel?> currentJob = Rx<JobModel?>(null);
  RxInt currentIndex = 0.obs;
  RxInt experience = 1.obs;

  // 🔹 Resume file handling
  File? selectedResume;
  RxString selectedResumeFileName = ''.obs;

  // --------------------------------------------------------
  // 🔹 State clearing
  clear() {
    categories.clear();
    isLoadingCategories.value = false;
    isLoadingJobs.value = false;
    isLoadingAppliedJobs.value = false;

    appliedJobsDataWrapper = DataWrapper();
    clearJobs();
  }

  clearJobs() {
    jobs.clear();
    jobsDataWrapper = DataWrapper();
  }

  // --------------------------------------------------------
  // 🔹 Filters and selections
  selectExperience(int exp) {
    experience.value = exp;
  }

  setCurrentJob(JobModel job) {
    currentJob.value = job;
  }

  setCategoryId(int? categoryId) {
    clearJobs();
    searchModel.categoryId = categoryId;
    getJobs(() {});
  }

  setTitle(String? title) {
    clearJobs();
    searchModel.title = title;
    getJobs(() {});
  }

  // --------------------------------------------------------
  // 🔹 Categories
  getCategories() {
    isLoadingCategories.value = true;
    JobApi.getCategories(resultCallback: (result) {
      categories.value = result;
      isLoadingCategories.value = false;
      update();
    });
  }

  // --------------------------------------------------------
  // 🔹 Jobs
  refreshJobs(VoidCallback callback) {
    clearJobs();
    getJobs(callback);
  }

  loadMoreJobs(VoidCallback callback) {
    if (jobsDataWrapper.haveMoreData.value) {
      getJobs(callback);
    } else {
      callback();
    }
  }

  getJobs(VoidCallback callback) {
    isLoadingJobs.value = true;

    JobApi.getJobs(
      searchModel: searchModel,
      page: jobsDataWrapper.page,
      resultCallback: (result, metadata) {
        jobs.addAll(result);
        jobs.unique((e) => e.id);
        jobsDataWrapper.processCompletedWithData(metadata);

        isLoadingJobs.value = false;
        update();
        callback();
      },
    );
  }

  // --------------------------------------------------------
  // 🔹 Applied Jobs
  refreshAppliedJobs(VoidCallback callback) {
    appliedJobs.clear();
    appliedJobsDataWrapper = DataWrapper();
    getAppliedJobs(callback);
  }

  loadMoreAppliedJobs(VoidCallback callback) {
    if (appliedJobsDataWrapper.haveMoreData.value) {
      getAppliedJobs(callback);
    } else {
      callback();
    }
  }

  getAppliedJobs(VoidCallback callback) {
    isLoadingAppliedJobs.value = true;

    JobApi.getAppliedJobs(
      page: appliedJobsDataWrapper.page,
      resultCallback: (result, metadata) {
        appliedJobs.addAll(result);
        appliedJobs.unique((e) => e.id);

        appliedJobsDataWrapper.processCompletedWithData(metadata);

        isLoadingAppliedJobs.value = false;
        update();
        callback();
      },
    );
  }

  // --------------------------------------------------------
  // 🔹 Apply for Job
  applyJob({
    required String jobId,
    required String experience,
    required String education,
    required String coverLetter,
  }) async {
    String uploadedResumeFileName = '';

    if (selectedResume != null) {
      await MiscApi.uploadFile(selectedResume!.path,
          mediaType: GalleryMediaType.photo, type: UploadMediaType.uploadResume,
          resultCallback: (fileName, filePath) {
        uploadedResumeFileName = fileName;
      });
    }

    JobApi.applyJob(
        jobId: jobId,
        experience: experience,
        education: education,
        coverLetter: coverLetter,
        resume: uploadedResumeFileName,
        successHandler: () {
          AppUtil.showToast(message: appliedSuccessfully, isSuccess: true);
          Get.close(2);
          refreshJobs(() {});
        });
  }

  // --------------------------------------------------------
  // 🔹 File Picker for Resume
  void openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      selectedResume = file;
      selectedResumeFileName.value = result.files.first.name;
    }
  }
}
