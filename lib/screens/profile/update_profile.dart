import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/profile_imports.dart';
import 'package:foap/screens/add_on/ui/dating/profile/add_interests.dart';
import 'package:foap/screens/login_sign_up/set_profile_category_type.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  UpdateProfileState createState() => UpdateProfileState();
}

class UpdateProfileState extends State<UpdateProfile> {
  bool isLoading = true;
  final picker = ImagePicker();
  final ProfileController profileController = Get.find();
  final UserProfileManager _userProfileManager = Get.find();

  @override
  void initState() {
    super.initState();
    reloadData();
  }

  reloadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.setUser(_userProfileManager.user.value!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: Column(
        children: [
          backNavigationBar(title: updateString.tr),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 24),
                  _buildProfileSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return GetBuilder<ProfileController>(
      init: profileController,
      builder: (ctx) {
        return Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              // color: AppColorConstants.themeColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColorConstants.themeColor,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: UserAvatarView(
                        user: profileController.user.value!,
                        size: 100,
                        onTapHandler: () {},
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColorConstants.themeColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColorConstants.backgroundColor,
                          width: 2,
                        ),
                      ),
                      child: ThemeIconWidget(
                        ThemeIcon.edit,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ).ripple(() {
                  openImagePickingPopup();
                }),
                const SizedBox(height: 16),
                if (profileController.user.value != null)
                  Column(
                    children: [
                      Heading5Text(
                        profileController.user.value!.userName,
                        weight: TextWeight.bold,
                      ),
                      if (profileController.user.value?.email != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: BodyMediumText(
                            profileController.user.value!.email!,
                            color: AppColorConstants.mainTextColor
                                .withOpacity(0.8),
                          ),
                        ),
                      if (profileController.user.value?.country != null ||
                          profileController.user.value?.city != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ThemeIconWidget(
                                ThemeIcon.location,
                                size: 14,
                                color: AppColorConstants.iconColor,
                              ),
                              const SizedBox(width: 4),
                              BodyMediumText(
                                '${profileController.user.value?.country ?? ''}${profileController.user.value?.city != null ? ', ${profileController.user.value?.city}' : ''}',
                                color: AppColorConstants.mainTextColor
                                    .withOpacity(0.8),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildProfileCard(
            title: accountString.tr,
            items: [
              _buildEditableItem(
                title: userNameString.tr,
                value: profileController.user.value?.userName ?? '',
                onTap: () {
                  Get.to(() => const ChangeUserName())!.then((value) {
                    reloadData();
                  });
                },
              ),
              _buildEditableItem(
                title: categoryString.tr,
                value:
                    profileController.user.value?.profileCategoryTypeName ?? '',
                onTap: () {
                  Get.to(() => const SetProfileCategoryType(
                            isFromSignup: false,
                          ))!
                      .then((value) {
                    reloadData();
                  });
                },
              ),
              if (profileController.user.value!.accountCreatedWith == 1)
                _buildEditableItem(
                  title: passwordString.tr,
                  value: '********',
                  onTap: () {
                    Get.to(() => const ChangePassword());
                  },
                ),
              _buildEditableItem(
                title: phoneNumberString.tr,
                value: profileController.user.value?.phone ?? '',
                onTap: () {
                  Get.to(() => const ChangePhoneNumber())!.then((value) {
                    reloadData();
                  });
                },
              ),
              _buildEditableItem(
                title: paymentDetailString.tr,
                value: profileController.user.value?.paypalId ?? '',
                onTap: () {
                  Get.to(() => const ChangePaypalId())!.then((value) {
                    reloadData();
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildProfileCard(
            title: personalDetailsString.tr,
            items: [
              _buildEditableItem(
                title: nameString.tr,
                value: profileController.user.value?.name ?? '',
                onTap: () {
                  Get.to(() => const AddName(isSettingProfile: false))!
                      .then((value) {
                    reloadData();
                  });
                },
              ),
              _buildEditableItem(
                title: dateOfBirthString.tr,
                value: profileController.user.value?.dob ?? '',
                onTap: () {
                  Get.to(() => const SetDateOfBirth(isSettingProfile: false))!
                      .then((value) {
                    reloadData();
                  });
                },
              ),
              _buildEditableItem(
                title: genderString.tr,
                value:
                    profileController.user.value?.genderType == GenderType.male
                        ? maleString.tr
                        : profileController.user.value?.genderType ==
                                GenderType.female
                            ? femaleString.tr
                            : otherString.tr,
                onTap: () {
                  Get.to(() => const SetYourGender(isSettingProfile: false))!
                      .then((value) {
                    reloadData();
                  });
                },
              ),
              _buildEditableItem(
                title: locationString.tr,
                value:
                    '${profileController.user.value?.country ?? ''} ${profileController.user.value?.city ?? ''}',
                onTap: () {
                  Get.to(() => const ChangeLocation())!.then((value) {
                    reloadData();
                  });
                },
              ),
              // _buildEditableItem(
              //   title: personalDetailsString.tr,
              //   value: '',
              //   showEditIcon: true,
              //   onTap: () {
              //     Get.to(() => const AddPersonalInfo(isSettingProfile: false))!
              //         .then((value) {
              //       reloadData();
              //     });
              //   },
              // ),
            ],
          ),
          const SizedBox(height: 16),
          _buildProfileCard(
            title: preferencesString.tr,
            items: [
              _buildEditableItem(
                title: interestsString.tr,
                value: '',
                showEditIcon: true,
                onTap: () {
                  Get.to(() => const AddInterests(
                            isSettingProfile: false,
                          ))!
                      .then((value) {
                    reloadData();
                  });
                },
              ),
              _buildEditableItem(
                title: professionalDetailString.tr,
                value: '',
                showEditIcon: true,
                onTap: () {
                  Get.to(() => const AddProfessionalDetails(
                          isSettingProfile: false))!
                      .then((value) {
                    reloadData();
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProfileCard({
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColorConstants.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Heading6Text(
              title,
              weight: TextWeight.semiBold,
              color: AppColorConstants.themeColor,
            ),
          ),
          Column(
            children: items.map((item) {
              return Column(
                children: [
                  item,
                  if (item != items.last)
                    Divider(
                      height: 1,
                      color: AppColorConstants.dividerColor.withOpacity(0.2),
                      indent: 16,
                      endIndent: 16,
                    ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableItem({
    required String title,
    required String value,
    required VoidCallback onTap,
    bool showEditIcon = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodyMediumText(
                      title,
                      color: AppColorConstants.mainTextColor.withOpacity(0.6),
                    ),
                    if (value.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: BodyLargeText(
                          value,
                          maxLines: 2,
                          // overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              if (showEditIcon || value.isNotEmpty)
                ThemeIconWidget(
                  ThemeIcon.nextArrow,
                  color: AppColorConstants.iconColor,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void openImagePickingPopup() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.35,
        child: Container(
          decoration: BoxDecoration(
            color: AppColorConstants.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColorConstants.dividerColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Heading5Text(
                  addPhotoString.tr,
                  weight: TextWeight.bold,
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildPopupOption(
                      icon: ThemeIconWidget(
                        ThemeIcon.camera,
                        color: AppColorConstants.themeColor,
                        size: 24,
                      ),
                      title: takePhotoString.tr,
                      onTap: () {
                        Get.back();
                        picker
                            .pickImage(source: ImageSource.camera)
                            .then((pickedFile) {
                          if (pickedFile != null) {
                            profileController
                                .editProfileImageAction(pickedFile);
                          }
                        });
                      },
                    ),
                    _buildPopupOption(
                      icon: ThemeIconWidget(
                        ThemeIcon.gallery,
                        color: AppColorConstants.themeColor,
                        size: 24,
                      ),
                      title: chooseFromGalleryString.tr,
                      onTap: () {
                        Get.back();
                        picker
                            .pickImage(source: ImageSource.gallery)
                            .then((pickedFile) {
                          if (pickedFile != null) {
                            profileController
                                .editProfileImageAction(pickedFile);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: AppColorConstants.dividerColor.withOpacity(0.2),
              ),
              _buildPopupOption(
                icon: ThemeIconWidget(
                  ThemeIcon.close,
                  color: AppColorConstants.red,
                  size: 24,
                ),
                title: cancelString.tr,
                textColor: AppColorConstants.red,
                onTap: () => Get.back(),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopupOption({
    required Widget icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              icon,
              const SizedBox(width: 16),
              BodyLargeText(
                title,
                color: textColor ?? AppColorConstants.mainTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
