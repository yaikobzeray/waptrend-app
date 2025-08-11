import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/login_signup_imports.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPasswordScreen> {
  TextEditingController email = TextEditingController();
  final LoginController loginController = Get.find();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        backgroundColor: AppColorConstants.backgroundColor,
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: Get.height * 0.1,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: AppThemeBackButton(),
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Heading3Text(forgotPwdString.tr, weight: TextWeight.bold),
                BodyMediumText(
                  helpToGetAccountString.tr,
                  color: AppColorConstants.subHeadingTextColor,
                ).setPadding(top: 10, bottom: 20),
                AppTextField(
                  controller: email,
                  hintText: enterEmailString.tr,
                  // icon: ThemeIcon.email,
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: BodySmallText(
                    loginAnotherAccountString.tr,
                    weight: TextWeight.bold,
                    textAlign: TextAlign.start,
                    color: AppColorConstants.themeColor,
                  ).ripple(() {
                    Get.back();
                  }),
                ),
                // const Spacer(),
                addSubmitBtn(),
                const SizedBox(
                  height: 55,
                )
              ],
            ).hp(20)));
  }

  addSubmitBtn() {
    return AppThemeButton(
      onPress: () {
        loginController.forgotPassword(email: email.text);
      },
      text: sendOTPString.tr,
    ).setPadding(top: 25);
  }
}
