import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'ask_image_permission.dart';

class AskContactPermission extends StatelessWidget {
  const AskContactPermission({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Skip button for better UX
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => Get.to(() => const AskGalleryPermission()),
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
                    // Animated icon container
                    Container(
                      height: 180,
                      width: 180,
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
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              color:
                                  AppColorConstants.themeColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Icon(
                            Icons.contacts_rounded,
                            size: 70,
                            color: AppColorConstants.themeColor,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Title
                    Heading5Text(
                      "Enable Contacts",
                      textAlign: TextAlign.center,
                      weight: TextWeight.bold,
                    ),

                    const SizedBox(height: 16),

                    // Description
                    BodyMediumText(
                      'We will access your contact list for sharing contacts with friends in chat',
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      weight: TextWeight.medium,
                      color: AppColorConstants.themeColor.withOpacity(0.7),
                    ),

                    const SizedBox(height: 50),

                    // Permission button
                    AppThemeButton(
                      text: "Allow",
                      onPress: () async {
                        await FlutterContacts.requestPermission();
                        Get.to(() => const AskGalleryPermission());
                      },
                    ),

                    const SizedBox(height: 16),

                    // Additional info
                    BodySmallText(
                      'Your contacts are only used to connect you with friends',
                      maxLines: 3,
                      textAlign: TextAlign.center,
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
