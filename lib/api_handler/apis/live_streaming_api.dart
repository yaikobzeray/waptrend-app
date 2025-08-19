import '../../helper/imports/common_import.dart';
import '../../model/api_meta_data.dart';
import '../../model/live_model.dart';
import '../api_wrapper.dart';

class LiveStreamingApi {
  static getAllLiveUsers({
    required int page,
    String? name,
    String? profileCategoryType,
    bool? isFollowing,
    required Function(List<UserLiveCallDetail>, APIMetaData) resultCallback,
    required Null Function() errorCallback,
  }) async {
    // Build query params dynamically
    final queryParams = {
      "expand": "userdetails",
      if (name != null && name.isNotEmpty) "name": name,
      if (profileCategoryType != null && profileCategoryType.isNotEmpty)
        "profile_category_type": profileCategoryType,
      if (isFollowing != null) "is_following": isFollowing ? "1" : "0",
      "page": page.toString(),
    };

    final queryString =
        queryParams.entries.map((e) => "${e.key}=${e.value}").join("&");

    final url = "${NetworkConstantsUtil.liveUsers}?$queryString";

    // Loader.show(status: loadingString.tr);

    try {
      final result = await ApiWrapper().getApi(url: url);
      // Loader.dismiss();

      if (result?.success == true) {
        final liveStreamUser = result!.data['liveStreamUser']?['items'] ?? [];

        final users = List<UserLiveCallDetail>.from(
          liveStreamUser.map((user) => UserLiveCallDetail.fromJson(user)),
        );

        final meta =
            APIMetaData.fromJson(result.data['liveStreamUser']?['_meta'] ?? {});

        resultCallback(users, meta);
      } else {
        // print("API failed: ${result?.message}");
      }
    } catch (e) {
      Loader.dismiss();
      // print("Error fetching live users: $e");
    }
  }

  static getLiveDetail(
      {required String channelName,
      required Function(LiveModel) resultCallback}) async {
    var url = '${NetworkConstantsUtil.liveDetailByChannel}$channelName';

    await ApiWrapper().getApi(url: url).then((result) {
      if (result?.success == true) {
        var live = result!.data['live_history'];
        resultCallback(LiveModel.fromJson(live));
      }
    });
  }

  static getCurrentLiveUsers(
      {required Function(List<UserModel>) resultCallback}) async {
    UserProfileManager userProfileManager = Get.find();
    var url =
        '${NetworkConstantsUtil.currentLiveUsers}${userProfileManager.user.value!.id}';

    await ApiWrapper().getApi(url: url).then((result) {
      if (result?.success == true) {
        var items = (result!.data['following'] as List<dynamic>)
            .map((e) => e['followingUserDetail'])
            .toList();
        if (items.isNotEmpty) {
          resultCallback(
              List<UserModel>.from(items.map((x) => UserModel.fromJson(x))));
        }
      }
    });
  }

  static getLiveHistory(
      {required int page,
      required Function(List<LiveModel>, APIMetaData) resultCallback}) async {
    var url = '${NetworkConstantsUtil.liveHistory}&page=$page';

    await ApiWrapper().getApi(url: url).then((result) {
      if (result?.success == true) {
        var items = result!.data['live_history']['items'];
        resultCallback(
            List<LiveModel>.from(items.map((x) => LiveModel.fromJson(x))),
            APIMetaData.fromJson(result.data['live_history']['_meta']));
      }
    });
  }

  static getLiveViewers(
      {required int liveId,
      int? role,
      bool? isBanned,
      required Function(List<LiveViewer>, APIMetaData) resultCallback}) async {
    var url = '${NetworkConstantsUtil.liveCallViewers}$liveId';

    if (role != null) {
      url = '$url&role=$role';
    }
    if (isBanned != null) {
      url = '$url&is_ban=1';
    }
    await ApiWrapper().getApi(url: url).then((result) {
      if (result?.success == true) {
        var items = result!.data['live_user_view']['items'];
        if (items.isNotEmpty) {
          resultCallback(
              List<LiveViewer>.from(items.map((x) => LiveViewer.fromJson(x))),
              APIMetaData.fromJson(result.data['live_user_view']['_meta']));
        }
      }
    });
  }
}
