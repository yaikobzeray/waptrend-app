import 'package:foap/helper/imports/common_import.dart';
import '../../components/otp_fields/otp_field1.dart';
import '../../controllers/auth/login_controller.dart';

class VerifyOTPForSignup extends StatefulWidget {
  final String token;

  const VerifyOTPForSignup({
    super.key,
    required this.token,
  });

  @override
  VerifyOTPForSignupState createState() => VerifyOTPForSignupState();
}

class VerifyOTPForSignupState extends State<VerifyOTPForSignup> {
  final LoginController loginController = Get.find();
  String filledOTP = '';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            children: [
              // backNavigationBar(title: otpVerificationString.tr),
              SizedBox(
                height: Get.height * 0.05,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: AppThemeBackButton(),
              ).hp(20),
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                SizedBox(
                  height: Get.height * 0.03,
                ),
                Heading4Text(
                  otpVerificationString.tr,
                  weight: TextWeight.bold,
                  color: AppColorConstants.mainTextColor,
                  textAlign: TextAlign.start,
                ),
                BodyMediumText(
                  pleaseEnterOneTimePasswordPhoneNumberChangeString.tr,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 100,
                  child: OTPFieldView(
                    length: loginController.pinLength,
                    defaultPinTheme: PinTheme(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColorConstants.themeColor,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 50,
                        width: 45,
                        textStyle: TextStyle(
                            fontSize: FontSizes.h4,
                            fontWeight: TextWeight.medium)),
                    onSubmitted: (String pin) {
                      filledOTP = pin;
                      loginController.otpCompleted();
                    },
                    onChanged: (String pin) {
                      loginController.otpTextFilled(pin);
                    },
                  ),
                ),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BodySmallText(
                          didntReceivedCodeString.tr,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        BodySmallText(
                          resendOTPString.tr,
                          weight: TextWeight.bold,
                          color: loginController.canResendOTP.value == false
                              ? AppColorConstants.disabledColor
                              : AppColorConstants.themeColor,
                        ).ripple(() {
                          if (loginController.canResendOTP.value == true) {
                            loginController.resendOTP(token: widget.token);
                          }
                        }),
                        loginController.canResendOTP.value == false
                            ? TweenAnimationBuilder<Duration>(
                                duration: const Duration(minutes: 2),
                                tween: Tween(
                                    begin: const Duration(minutes: 2),
                                    end: Duration.zero),
                                onEnd: () {
                                  loginController.canResendOTP.value = true;
                                  setState(() {});
                                },
                                builder: (BuildContext context, Duration value,
                                    Widget? child) {
                                  final minutes = value.inMinutes;
                                  final seconds = value.inSeconds % 60;
                                  return BodyLargeText(' ($minutes:$seconds)',
                                      textAlign: TextAlign.center,
                                      color: AppColorConstants.themeColor);
                                })
                            : Container()
                      ],
                    )),
                SizedBox(
                  height: Get.height * 0.15,
                ),
                Obx(() => loginController.otpFilled.value == true
                    ? addSubmitBtn()
                    : Container()),
                const SizedBox(
                  height: 55,
                )
              ]).setPadding(left: 25, right: 25),
            ],
          ),
        ),
      ),
    );
  }

  addSubmitBtn() {
    return AppThemeButton(
      onPress: () {
        if (loginController.otpFilled.value == true) {
          loginController.callVerifyOTPForRegistration(
            otp: filledOTP,
            token: widget.token,
          );
        }
      },
      text: verifyString.tr,
    );
  }
}
