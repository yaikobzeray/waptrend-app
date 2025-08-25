import 'package:flutter/material.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/screens/popups/ask_mic_permission.dart';
import 'package:permission_handler/permission_handler.dart';

class AskGalleryPermission extends StatelessWidget {
  const AskGalleryPermission({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => Get.to(() => const AskMicPermission()),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Modern gallery icon with visual hierarchy
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColorConstants.themeColor.withOpacity(0.2),
                            AppColorConstants.themeColor.withOpacity(0.05),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background circle
                          Container(
                            width: 170,
                            height: 170,
                            decoration: BoxDecoration(
                              color:
                                  AppColorConstants.themeColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                          ),

                          // Gallery icon with image preview effect
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 70,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.photo_rounded,
                                  size: 30,
                                  color: AppColorConstants.themeColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 60,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColorConstants.themeColor
                                      .withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.collections_rounded,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Title
                    Heading5Text(
                      "Enable Gallery Access",
                      textAlign: TextAlign.center,
                      weight: TextWeight.bold,
                    ),

                    const SizedBox(height: 16),

                    // Description
                    BodyMediumText(
                      'Access your photos and videos to share media with friends in chat and create posts',
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      weight: TextWeight.medium,
                      color: AppColorConstants.themeColor.withOpacity(0.7),
                    ),

                    const SizedBox(height: 50),

                    // Permission button
                    AppThemeButton(
                      text: "Allow Access",
                      onPress: () async {
                        await Permission.photos.request();
                        Get.to(() => const AskMicPermission());
                      },
                    ),

                    const SizedBox(height: 16),

                    // Privacy reassurance
                    BodySmallText(
                      'Your media is only accessed when you choose to share it',
                      textAlign: TextAlign.center,
                      maxLines: 3,
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
