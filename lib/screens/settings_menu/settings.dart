import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/setting_imports.dart';
import 'package:foap/screens/post/saved_posts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../../controllers/misc/gift_controller.dart';
import 'received_gifts.dart';
import 'creator_tools/creator_tools.dart';
import 'help_screen.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final SettingsController _settingsController = Get.find();
  final UserProfileManager _userProfileManager = Get.find();

  @override
  void initState() {
    super.initState();
    _settingsController.loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppScaffold(
          backgroundColor: AppColorConstants.backgroundColor,
          body: Column(
            children: [
              if (_settingsController.appearanceChanged!.value) Container(),
              backNavigationBar(title: settingsString.tr),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColorConstants.themeColor.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: EdgeInsets.symmetric(
                      horizontal: DesignConstants.horizontalPadding),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildListDelegate([
                            _buildSettingsSection([
                              _buildSettingTile(
                                icon: Icons.notifications,
                                title: notificationsString.tr,
                                onTap: () =>
                                    Get.to(() => const NotificationsScreen()),
                              ),
                              _buildSettingTile(
                                icon: Icons.language,
                                title: changeLanguageString.tr,
                                onTap: () =>
                                    Get.to(() => const ChangeLanguage()),
                              ),
                              _buildSettingTile(
                                icon: Icons.payment,
                                title: paymentAndCoinsString.tr,
                                onTap: () =>
                                    Get.to(() => const PaymentAndCoins()),
                              ),
                              _buildSettingTile(
                                icon: Icons.wallet_giftcard,
                                title: giftsReceivedString.tr,
                                onTap: () {
                                  final GiftController giftController =
                                      Get.find();
                                  giftController.fetchReceivedGifts();
                                  Get.to(() => ReceivedGiftsList());
                                },
                              ),
                            ]),
                            _buildSettingsSection([
                              _buildSettingTile(
                                icon: Icons.settings,
                                title: creatorToolsString.tr,
                                onTap: () => Get.to(() => const CreatorTools()),
                              ),
                              _buildSettingTile(
                                icon: Icons.person,
                                title: accountString.tr,
                                onTap: () => Get.to(() => const AppAccount()),
                              ),
                              _buildSettingTile(
                                icon: Icons.bookmark,
                                title: savedPostsString.tr,
                                onTap: () => Get.to(() => const SavedPosts()),
                              ),
                            ]),
                            _buildSettingsSection([
                              _buildSettingTile(
                                icon: Icons.lock,
                                title: privacyString.tr,
                                onTap: () =>
                                    Get.to(() => const PrivacyOptions()),
                              ),
                              _buildSettingTile(
                                icon: Icons.mail,
                                title: notificationSettingsString.tr,
                                onTap: () => Get.to(
                                    () => const AppNotificationSettings()),
                              ),
                            ]),
                            _buildSettingsSection([
                              _buildSettingTile(
                                icon: Icons.help,
                                title: faqString.tr,
                                onTap: () => Get.to(() => const FaqList()),
                              ),
                              _buildSettingTile(
                                icon: Icons.help_center_outlined,
                                title: helpString.tr,
                                onTap: () => Get.to(() => const HelpScreen()),
                              ),
                            ]),
                            if (_settingsController
                                .setting.value!.enableDarkLightModeSwitch)
                              _buildSettingsSection([
                                _buildDarkModeTile(),
                              ]),
                            if (_settingsController.setting.value!.iosAppLink !=
                                    null ||
                                _settingsController
                                        .setting.value!.androidAppLink !=
                                    null)
                              _buildSettingsSection([
                                _buildSettingTile(
                                  icon: Icons.share,
                                  title: shareString.tr,
                                  onTap: () {
                                    try {
                                      Share.share(
                                          '${installThisCoolAppString.tr}\n${_settingsController.setting.value!.iosAppLink ?? ''}\n${_settingsController.setting.value!.androidAppLink ?? ''}');
                                    } catch (e) {
                                      AppUtil.showToast(
                                        message: "Failed to share app".tr,
                                        isSuccess: false,
                                      );
                                    }
                                  },
                                  showTrailing: false,
                                ),
                              ]),
                            _buildSettingsSection([
                              _buildSettingTile(
                                icon: Icons.exit_to_app,
                                title: logoutString.tr,
                                isDestructive: true,
                                onTap: () {
                                  _showLogoutConfirmation();
                                },
                                showTrailing: false,
                              ),
                              _buildSettingTile(
                                icon: Icons.delete,
                                title: deleteAccountString.tr,
                                isDestructive: true,
                                onTap: () {
                                  _showDeleteAccountConfirmation();
                                },
                                showTrailing: false,
                              ),
                            ]),
                            // _buildSettingsSection([
                            //   _buildSettingTile(
                            //     icon: FeatherIcons.heart,
                            //     title: createdByString.tr,
                            //     onTap: () async {
                            //       const url =
                            //           'https://instagram.com/singhcoders/';
                            //       if (await canLaunchUrl(Uri.parse(url))) {
                            //         await launchUrl(Uri.parse(url));
                            //       } else {
                            //         AppUtil.showToast(
                            //           message: "Could not launch the url".tr,
                            //           isSuccess: false,
                            //         );
                            //       }
                            //     },
                            //   ),
                            // ]),
                            const SizedBox(height: 30),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildSettingsSection(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: AppColorConstants.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showTrailing = true,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDestructive
                    ? AppColorConstants.red.withOpacity(0.2)
                    : AppColorConstants.themeColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                icon,
                size: 18,
                color: isDestructive
                    ? AppColorConstants.red
                    : AppColorConstants.themeColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDestructive
                      ? AppColorConstants.red
                      : AppColorConstants.mainTextColor,
                ),
              ),
            ),
            if (showTrailing)
              Icon(
                Icons.arrow_circle_right_outlined,
                size: 20,
                color: AppColorConstants.iconColor.withOpacity(0.6),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkModeTile() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColorConstants.themeColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              _settingsController.darkMode.value
                  ? Icons.dark_mode
                  : Icons.light_mode,
              size: 18,
              color: AppColorConstants.themeColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              darkModeString.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColorConstants.mainTextColor,
              ),
            ),
          ),
          Obx(() => Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: _settingsController.darkMode.value,
                  activeColor: AppColorConstants.themeColor,
                  inactiveTrackColor: AppColorConstants.disabledColor,
                  onChanged: (val) {
                    _settingsController.appearanceModeChanged(val);
                    setState(() {});
                    Get.forceAppUpdate();
                  },
                ),
              )),
        ],
      ),
    );
  }

  void _showLogoutConfirmation() {
    AppUtil.showNewConfirmationAlert(
      title: logoutString.tr,
      subTitle: logoutConfirmationString.tr,
      cancelHandler: () {
        Get.back();
      },
      okHandler: () {
        _userProfileManager.logout();
      },
    );
  }

  void _showDeleteAccountConfirmation() {
    AppUtil.showNewConfirmationAlert(
      title: deleteAccountString.tr,
      subTitle: areYouSureToDeleteAccountString.tr,
      cancelHandler: () {
        Get.back();
      },
      okHandler: () {
        _settingsController.deleteAccount();
      },
    );
  }
}
