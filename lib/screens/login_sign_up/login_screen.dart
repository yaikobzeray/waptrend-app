import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/login_signup_imports.dart';
import '../../main.dart';

class LoginScreen extends StatefulWidget {
  final bool? showCloseBtn;

  const LoginScreen({super.key, this.showCloseBtn = false});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final LoginController controller = Get.find();

  bool showPassword = false;

  @override
  void initState() {
    isAnyPageInStack = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: Get.height * 0.1,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "assets/waptrend-logo.jpg",
                        height: Get.height * 0.1,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (widget.showCloseBtn == true)
                      const Align(
                        alignment: Alignment.centerRight,
                        child: AppThemeCloseButton(),
                      ),
                    SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Heading3Text(signInMessageString.tr,
                                textAlign: TextAlign.center,
                                weight: TextWeight.bold),
                          ],
                        )),
                    SizedBox(
                        child: BodyMediumText(
                      signInMessageString2,
                      weight: TextWeight.regular,
                    )),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BodyMediumText(
                          emailOrUsernameString.tr,
                          weight: TextWeight.semiBold,
                        ),
                        AppTextField(
                          controller: email,
                          filled: false,
                          hintText: emailOrUsernameString.tr,
                          // icon: ThemeIcon.email,
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
                          icon: ThemeIcon.lock,
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => const ForgotPasswordScreen());
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: BodySmallText(
                          forgotPwdString.tr,
                          weight: TextWeight.semiBold,
                          color: AppColorConstants.themeColor.darken(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.015,
                    ),
                    addLoginBtn(),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),

                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                            width: Get.width * 0.25,
                            child: divider(height: 1).vp(20)),
                        BodyMediumText(continueWithAccountsString),
                        SizedBox(
                            width: Get.width * 0.25,
                            child: divider(height: 1).vp(20)),
                      ],
                    ),

                    const SocialLogin(hidePhoneLogin: false)
                        .setPadding(left: 20, right: 20),

                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    Wrap(
                      spacing: 2,
                      children: [
                        BodySmallText(dontHaveAccountString),
                        BodySmallText(
                          createAnAccountString,
                          weight: TextWeight.bold,
                          color: AppColorConstants.themeColor,
                        ),
                      ],
                    ).ripple(() {
                      Get.to(() => const SignUpScreen());
                    }),
                    // bioMetricView(),
                    // const Spacer(),
                  ]),
            ),
          ),
        ).setPadding(right: 0),
      ),
    );
  }

  Widget addLoginBtn() {
    return AppThemeButton(
      onPress: () {
        controller.login(email.text.trim(), password.text.trim());
      },
      text: signInString.tr,
    );
  }
}
