import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/login_signup_imports.dart';
import '../../universal_components/rounded_input_field.dart';
import '../profile/password_changed_popup.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String token;

  const ResetPasswordScreen({super.key, required this.token});

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final UserProfileManager _userProfileManager = Get.find();

  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  late String token;

  final LoginController controller = Get.find();

  @override
  void initState() {
    super.initState();
    token = widget.token;
  }

  @override
  void dispose() {
    controller.passwordReset = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SizedBox(
                height: Get.height * 0.1,
              ),
              // Center(
              //     child: Image.asset(
              //   'assets/logo.png',
              //   width: 80,
              //   height: 25,
              // )),

              Heading3Text(
                resetPwdString.tr,
                weight: TextWeight.bold,
                color: AppColorConstants.mainTextColor,
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 20,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                BodyMediumText(
                  newPasswordString.tr,
                  weight: TextWeight.semiBold,
                ),
                addTextField(newPassword, newPasswordString.tr),
              ]),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                BodyMediumText(
                  confirmPasswordString.tr,
                  weight: TextWeight.semiBold,
                ),
                addTextField(confirmPassword, confirmPasswordString.tr)
              ]),
              // const Spacer(),
              SizedBox(
                height: Get.height * 0.1,
              ),
              addSubmitBtn(),
            ]).setPadding(left: 25, right: 25),
            GetBuilder<LoginController>(
                init: controller,
                builder: (ctx) {
                  return controller.passwordReset == true
                      ? Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: PasswordChangedPopup(dismissHandler: () {
                            controller.passwordReset = false;
                            _userProfileManager.logout();
                          }))
                      : Container();
                })
          ],
        ),
      ),
    );
  }

  Widget addTextField(TextEditingController controller, String hint) {
    return SizedBox(
      height: 48,
      child: PasswordField(
        onChanged: (value) {},
        controller: controller,
        // showRevealPasswordIcon: true,
        hintText: hint,
      ),
    );
  }

  addSubmitBtn() {
    return AppThemeButton(
      onPress: () {
        controller.resetPassword(
          newPassword: newPassword.text.trim(),
          confirmPassword: confirmPassword.text.trim(),
          token: token,
        );
      },
      text: changePwdString.tr,
    );
  }
}
