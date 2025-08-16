import 'package:foap/components/segmented_control.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/screens/add_on/controller/dating/dating_controller.dart';
import 'package:foap/screens/add_on/model/preference_model.dart';
import 'package:foap/universal_components/rounded_input_field.dart';
import 'add_profesional_details.dart';

class AddInterests extends StatefulWidget {
  final bool isSettingProfile;

  const AddInterests({super.key, required this.isSettingProfile});

  @override
  State<AddInterests> createState() => AddInterestsState();
}

class AddInterestsState extends State<AddInterests> {
  final UserProfileManager _userProfileManager = Get.find();

  int? smoke;

  TextEditingController drinkHabitController = TextEditingController();
  List<String> drinkHabitList = DatingProfileConstants.drinkHabits;

  final DatingController datingController = DatingController();
  TextEditingController interestsController = TextEditingController();
  List<InterestModel> selectedInterests = [];

  TextEditingController languageController = TextEditingController();
  List<LanguageModel> selectedLanguages = [];

  @override
  void initState() {
    super.initState();
    datingController.getInterests();
    datingController.getLanguages();

    if (_userProfileManager.user.value!.smoke != null) {
      smoke = (_userProfileManager.user.value!.smoke!);
    }
    if (_userProfileManager.user.value!.drink != null) {
      int drink = int.parse(_userProfileManager.user.value!.drink!) - 1;
      drinkHabitController.text = drinkHabitList[drink];
    }

    if (_userProfileManager.user.value!.interests != null) {
      selectedInterests = _userProfileManager.user.value!.interests!;
      String result = selectedInterests.map((val) => val.name).join(', ');
      interestsController.text = result;
    }
    if (_userProfileManager.user.value!.languages != null) {
      selectedLanguages = _userProfileManager.user.value!.languages!;
      String result = selectedLanguages.map((val) => val.name).join(', ');
      languageController.text = result;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        backgroundColor: AppColorConstants.backgroundColor,
        body: Column(children: [
          backNavigationBar(
            title: addInterestsString.tr,
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Heading3Text(
                  addInterestsString.tr,
                ).setPadding(top: 20),
                Heading6Text(
                  addYourInterstsAndHabitsString.tr,
                ).setPadding(top: 20),
                addHeader(doYouSmokeString.tr).setPadding(top: 30, bottom: 8),
                SegmentedControl(
                    segments: [yesString.tr, noString.tr],
                    value: smoke == null ? null : smoke! - 1,
                    onValueChanged: (value) {
                      setState(() => smoke = value + 1);
                    }),
                addHeader(drinkingHabitString.tr)
                    .setPadding(top: 30, bottom: 8),
                DropdownBorderedField(
                  hintText: selectString.tr,
                  controller: drinkHabitController,
                  showBorder: true,
                  borderColor: AppColorConstants.borderColor,
                  cornerRadius: 10,
                  iconOnRightSide: true,
                  icon: ThemeIcon.downArrow,
                  iconColor: AppColorConstants.iconColor,
                  onTap: () {
                    openDrinkHabitListPopup();
                  },
                ),
                addHeader(interestsString.tr).setPadding(top: 30, bottom: 8),
                DropdownBorderedField(
                  hintText: selectString.tr,
                  controller: interestsController,
                  showBorder: true,
                  borderColor: AppColorConstants.borderColor,
                  cornerRadius: 10,
                  iconOnRightSide: true,
                  icon: ThemeIcon.downArrow,
                  iconColor: AppColorConstants.iconColor,
                  onTap: () {
                    openInterestsPopup();
                  },
                ),
                addHeader(languageString.tr).setPadding(top: 30, bottom: 8),
                DropdownBorderedField(
                  hintText: selectString.tr,
                  controller: languageController,
                  showBorder: true,
                  borderColor: AppColorConstants.borderColor,
                  cornerRadius: 10,
                  iconOnRightSide: true,
                  icon: ThemeIcon.downArrow,
                  iconColor: AppColorConstants.iconColor,
                  onTap: () {
                    openLanguagePopup();
                  },
                ),
                Center(
                  child: SizedBox(
                      height: 50,
                      width: Get.width - 50,
                      child: AppThemeButton(
                          cornerRadius: 25,
                          text: submitString.tr,
                          onPress: () {
                            submitDetail();
                          })),
                ).setPadding(top: 50, bottom: 100),
              ],
            ).paddingAll(25),
          )),
        ]));
  }

  BodySmallText addHeader(String header) {
    return BodySmallText(
      header,
      // weight: TextWeight.medium,
    );
  }

  void openDrinkHabitListPopup() {
    showModalBottomSheet(
      backgroundColor: AppColorConstants.backgroundColor,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return FractionallySizedBox(
              heightFactor: 0.7,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColorConstants.cardColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Select Drinking Habit',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: AppColorConstants.mainTextColor,
                        ),
                      ),
                    ),
                    const Divider(height: 1, thickness: 0.5),
                    // List
                    Expanded(
                      child: ListView.separated(
                        itemCount: drinkHabitList.length,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, thickness: 0.5),
                        itemBuilder: (_, int index) {
                          final isSelected = drinkHabitList[index] ==
                              drinkHabitController.text;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                drinkHabitController.text =
                                    drinkHabitList[index];
                              });
                              Navigator.pop(context);
                            },
                            splashColor:
                                AppColorConstants.themeColor.withOpacity(0.1),
                            highlightColor:
                                AppColorConstants.themeColor.withOpacity(0.05),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      drinkHabitList[index],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        color: AppColorConstants.mainTextColor,
                                      ),
                                    ),
                                  ),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: Icon(
                                      isSelected
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_unchecked,
                                      color: isSelected
                                          ? AppColorConstants.themeColor
                                          : AppColorConstants.iconColor
                                              .withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void openInterestsPopup() {
    showModalBottomSheet(
      backgroundColor: AppColorConstants.backgroundColor,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return FractionallySizedBox(
              heightFactor: 0.7,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColorConstants.cardColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Select Interests',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: AppColorConstants.mainTextColor,
                        ),
                      ),
                    ),
                    const Divider(height: 1, thickness: 0.5),
                    // Selected chips
                    if (selectedInterests.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        height: 60,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedInterests.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (_, index) {
                            return Chip(
                              label: Text(selectedInterests[index].name),
                              backgroundColor:
                                  AppColorConstants.themeColor.withOpacity(0.2),
                              deleteIcon: Icon(Icons.close, size: 16),
                              onDeleted: () {
                                setState(() {
                                  selectedInterests.removeAt(index);
                                  interestsController.text = selectedInterests
                                      .map((val) => val.name)
                                      .join(', ');
                                });
                              },
                            );
                          },
                        ),
                      ),
                      const Divider(height: 1, thickness: 0.5),
                    ],
                    // List
                    Expanded(
                      child: ListView.separated(
                        itemCount: datingController.interests.length,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, thickness: 0.5),
                        itemBuilder: (_, int index) {
                          InterestModel model =
                              datingController.interests[index];
                          bool isAdded = selectedInterests
                              .any((element) => element.id == model.id);

                          return InkWell(
                            onTap: () {
                              setState(() {
                                isAdded
                                    ? selectedInterests.remove(model)
                                    : selectedInterests.add(model);

                                interestsController.text = selectedInterests
                                    .map((val) => val.name)
                                    .join(', ');
                              });
                            },
                            splashColor:
                                AppColorConstants.themeColor.withOpacity(0.1),
                            highlightColor:
                                AppColorConstants.themeColor.withOpacity(0.05),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      model.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        color: AppColorConstants.mainTextColor,
                                      ),
                                    ),
                                  ),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: isAdded
                                          ? AppColorConstants.themeColor
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: isAdded
                                            ? AppColorConstants.themeColor
                                            : AppColorConstants.iconColor
                                                .withOpacity(0.5),
                                        width: 2,
                                      ),
                                    ),
                                    child: isAdded
                                        ? Icon(Icons.check,
                                            size: 16, color: Colors.white)
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void openLanguagePopup() {
    showModalBottomSheet(
      backgroundColor: AppColorConstants.backgroundColor,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return FractionallySizedBox(
              heightFactor: 0.7,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColorConstants.cardColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Select Languages',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: AppColorConstants.mainTextColor,
                        ),
                      ),
                    ),
                    const Divider(height: 1, thickness: 0.5),
                    // Selected chips
                    if (selectedLanguages.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        height: 60,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedLanguages.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (_, index) {
                            return Chip(
                              label: Text(selectedLanguages[index].name ?? ''),
                              backgroundColor:
                                  AppColorConstants.themeColor.withOpacity(0.2),
                              deleteIcon: Icon(Icons.close, size: 16),
                              onDeleted: () {
                                setState(() {
                                  selectedLanguages.removeAt(index);
                                  languageController.text = selectedLanguages
                                      .map((val) => val.name)
                                      .join(', ');
                                });
                              },
                            );
                          },
                        ),
                      ),
                      const Divider(height: 1, thickness: 0.5),
                    ],
                    // List
                    Expanded(
                      child: ListView.separated(
                        itemCount: datingController.languages.length,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, thickness: 0.5),
                        itemBuilder: (_, int index) {
                          LanguageModel model =
                              datingController.languages[index];
                          bool isAdded = selectedLanguages
                              .any((element) => element.id == model.id);

                          return InkWell(
                            onTap: () {
                              setState(() {
                                isAdded
                                    ? selectedLanguages.remove(model)
                                    : selectedLanguages.add(model);

                                languageController.text = selectedLanguages
                                    .map((val) => val.name)
                                    .join(', ');
                              });
                            },
                            splashColor:
                                AppColorConstants.themeColor.withOpacity(0.1),
                            highlightColor:
                                AppColorConstants.themeColor.withOpacity(0.05),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      model.name ?? '',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        color: AppColorConstants.mainTextColor,
                                      ),
                                    ),
                                  ),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: isAdded
                                          ? AppColorConstants.themeColor
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: isAdded
                                            ? AppColorConstants.themeColor
                                            : AppColorConstants.iconColor
                                                .withOpacity(0.5),
                                        width: 2,
                                      ),
                                    ),
                                    child: isAdded
                                        ? Icon(Icons.check,
                                            size: 16, color: Colors.white)
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  submitDetail() {
    AddDatingDataModel dataModel = AddDatingDataModel();
    dataModel.smoke = smoke;
    _userProfileManager.user.value!.smoke = dataModel.smoke;

    if (drinkHabitController.text.isNotEmpty) {
      int drink = drinkHabitList.indexOf(drinkHabitController.text);
      dataModel.drink = drink + 1;
      _userProfileManager.user.value!.drink = dataModel.drink.toString();
    }
    if (selectedInterests.isNotEmpty) {
      dataModel.interests = selectedInterests;
      _userProfileManager.user.value!.interests = selectedInterests;
    }
    if (selectedLanguages.isNotEmpty) {
      dataModel.languages = selectedLanguages;
      _userProfileManager.user.value!.languages = selectedLanguages;
    }
    datingController.updateDatingProfile(dataModel, () {
      if (widget.isSettingProfile) {
        Get.to(() =>
            AddProfessionalDetails(isSettingProfile: widget.isSettingProfile));
      } else {
        Get.back();
      }
    });
  }
}
