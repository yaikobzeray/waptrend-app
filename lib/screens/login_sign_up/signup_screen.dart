import 'package:flutter/gestures.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/login_signup_imports.dart';
import '../../controllers/profile/profile_controller.dart';
import '../settings_menu/settings_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  SettingsController settingsController = Get.find();
  final ProfileController profileController = Get.find();

  String countryCode = '+1';
  final LoginController loginController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(
              height: Get.height * 0.1,
            ),
            // const Align(
            //   alignment: Alignment.centerLeft,
            //   child: AppThemeBackButton(),
            // ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                "assets/waptrend-logo.jpg",
                height: Get.height * 0.1,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Heading3Text(createAnAccountString.tr,
                        textAlign: TextAlign.center, weight: TextWeight.bold),
                  ],
                )),
            SizedBox(
                child: BodyMediumText(
              createAnAccountString2,
              weight: TextWeight.regular,
            )),
            SizedBox(
              height: Get.height * 0.04,
            ),
            Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodyMediumText(
                      userNameString.tr,
                      weight: TextWeight.semiBold,
                    ),
                    AppTextField(
                      // icon: ThemeIcon.account,
                      hintText: userNameString.tr,
                      controller: userName,
                      onChanged: (value) {
                        if (value.length > 3) {
                          profileController.verifyUsername(userName: value);
                        }
                      },
                    ),
                  ],
                ),
                Positioned(
                  right: DesignConstants.horizontalPadding,
                  bottom: 0,
                  top: 0,
                  child: Center(
                    child: Obx(
                        () => profileController.userNameCheckStatus.value == 1
                            ? ThemeIconWidget(
                                ThemeIcon.checkMark,
                                color: AppColorConstants.themeColor,
                              )
                            : profileController.userNameCheckStatus.value == 0
                                ? ThemeIconWidget(
                                    ThemeIcon.close,
                                    color: AppColorConstants.red,
                                  )
                                : Container()),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.015,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodyMediumText(
                  emailString.tr,
                  weight: TextWeight.semiBold,
                ),
                AppTextField(
                  // icon: ThemeIcon.email,
                  controller: email,
                  hintText: emailString,
                ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.015,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodyMediumText(
                  passwordString.tr,
                  weight: TextWeight.semiBold,
                ),
                AppPasswordTextField(
                  controller: password,
                  hintText: passwordString.tr,
                  // icon: ThemeIcon.lock,
                  onChanged: (value) {
                    loginController.checkPassword(value);
                  },
                ),
              ],
            ),
            Obx(() {
              return loginController.passwordStrength.value < 0.8 &&
                      password.text.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        LinearProgressIndicator(
                          value: loginController.passwordStrength.value,
                          backgroundColor: Colors.grey[300],
                          color: loginController.passwordStrength.value <= 1 / 4
                              ? Colors.red
                              : loginController.passwordStrength.value == 2 / 4
                                  ? Colors.yellow
                                  : loginController.passwordStrength.value ==
                                          3 / 4
                                      ? Colors.blue
                                      : Colors.green,
                          minHeight: 5,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        BodySmallText(
                          loginController.passwordStrengthText.value,
                        ),
                      ],
                    )
                  : Container();
            }),
            SizedBox(
              height: Get.height * 0.015,
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: signingInTermsString.tr,
                      style: TextStyle(
                          fontSize: FontSizes.b3,
                          color: AppColorConstants.mainTextColor)),
                  TextSpan(
                      text: ' ${termsOfServiceString.tr}',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          loginController.launchUrlInBrowser(settingsController
                              .setting.value!.termsOfServiceUrl!);
                        },
                      style: TextStyle(
                          fontSize: FontSizes.b3,
                          color: AppColorConstants.themeColor)),
                  TextSpan(
                      text: ' ${andString.tr}',
                      style: TextStyle(
                          fontSize: FontSizes.b3,
                          color: AppColorConstants.mainTextColor)),
                  TextSpan(
                      text: ' ${privacyPolicyString.tr}',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          loginController.launchUrlInBrowser(settingsController
                              .setting.value!.privacyPolicyUrl!);
                        },
                      style: TextStyle(
                          fontSize: FontSizes.b3,
                          color: AppColorConstants.themeColor)),
                ],
              ),
            ),
            SizedBox(
              height: Get.height * 0.015,
            ),
            addSignUpBtn(),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: Get.width * 0.25, child: divider(height: 1).vp(20)),
                BodyMediumText(continueWithAccountsString),
                SizedBox(
                    width: Get.width * 0.25, child: divider(height: 1).vp(20)),
              ],
            ),
            const SocialLogin(
              hidePhoneLogin: false,
            ).setPadding(left: 45, right: 45),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Wrap(
              spacing: 2,
              children: [
                BodySmallText(alreadyHaveAccString),
                BodySmallText(
                  signInString,
                  weight: TextWeight.bold,
                  color: AppColorConstants.themeColor,
                ),
              ],
            ).ripple(() {
              Get.to(() => const LoginScreen());
            }),
          ]),
        ).setPadding(left: 25, right: 25),
      ),
    );
  }

  addSignUpBtn() {
    return AppThemeButton(
      onPress: () {
        FocusScope.of(context).requestFocus(FocusNode());
        loginController.register(
          userName: userName.text,
          email: email.text,
          password: password.text,
        );
      },
      text: signUpString.tr,
    );
  }
}
