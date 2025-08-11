import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/login_signup_imports.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  PhoneLoginScreenState createState() => PhoneLoginScreenState();
}

class PhoneLoginScreenState extends State<PhoneLoginScreen> {
  TextEditingController phone = TextEditingController();

  final LoginController controller = Get.find();

  bool showPassword = false;

  @override
  void initState() {
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
              child: SizedBox(
                height: Get.height,
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
                            phoneNumberString.tr,
                            weight: TextWeight.semiBold,
                          ),
                          Obx(() => AppMobileTextField(
                                controller: phone,
                                // showDivider: true,

                                hintText: phoneNumberString.tr,
                                // cornerRadius: 5,

                                countryCodeText:
                                    controller.phoneCountryCode.value,
                                onChanged: (String value) {},
                                countryCodeValueChanged: (String value) {
                                  controller.phoneCodeSelected(value);
                                },
                              )),
                        ],
                      ),

                      SizedBox(
                        height: Get.height * 0.04,
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
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      const SocialLogin(
                        hidePhoneLogin: true,
                      ).setPadding(left: 20, right: 20),

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
            )).setPadding(left: 25, right: 25),
      ),
    );
  }

  Widget addLoginBtn() {
    return AppThemeButton(
      onPress: () {
        controller.phoneLogin(
            countryCode: controller.phoneCountryCode.value,
            phone: phone.text.trim());
      },
      text: signInString.tr,
    );
  }
}
