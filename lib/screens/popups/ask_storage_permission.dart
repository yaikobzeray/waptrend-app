import 'package:flutter/material.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/util/shared_prefs.dart';
import 'package:permission_handler/permission_handler.dart';
import '../dashboard/loading.dart';

class AskStoragePermission extends StatelessWidget {
  const AskStoragePermission({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: DesignConstants.horizontalPadding,
            vertical: 20,
          ),
          child: Column(
            children: [
              // Progress indicator (optional visual enhancement)
              LinearProgressIndicator(
                value: 1.0,
                backgroundColor: AppColorConstants.themeColor.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColorConstants.themeColor,
                ),
                minHeight: 4,
              ),
              const SizedBox(height: 20),

              // Skip button for better UX
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    SharedPrefs().setTutorialSeen();
                    Get.offAll(() => LoadingScreen());
                  },
                  child: Text(
                    skipString.tr,
                    style: TextStyle(
                      color: AppColorConstants.themeColor.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Modern file icon with visual enhancement
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColorConstants.themeColor.withOpacity(0.15),
                            AppColorConstants.themeColor.withOpacity(0.05),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColorConstants.themeColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Main icon
                            ThemeIconWidget(
                              ThemeIcon.files,
                              size: 100,
                              color: AppColorConstants.themeColor,
                            ),

                            // Decorative elements
                            Positioned(
                              right: 25,
                              top: 25,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: AppColorConstants.themeColor
                                      .withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.insert_drive_file_rounded,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            Positioned(
                              left: 30,
                              bottom: 30,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: AppColorConstants.themeColor
                                      .withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.folder_rounded,
                                  size: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).circular,

                    const SizedBox(height: 40),

                    // Title text
                    BodyLargeText(
                      'We will access your files for sharing with friends in chat',
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      weight: TextWeight.semiBold,
                    ),

                    const SizedBox(height: 50),

                    // Permission button
                    AppThemeButton(
                      text: nextString.tr,
                      onPress: () async {
                        await Permission.storage.request();
                        SharedPrefs().setTutorialSeen();
                        Get.offAll(() => LoadingScreen());
                      },
                    ),

                    const SizedBox(height: 20),

                    // Additional info text
                    BodyMediumText(
                      'Your files are only accessed when you choose to share them',
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      weight: TextWeight.medium,
                      color: AppColorConstants.themeColor.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
