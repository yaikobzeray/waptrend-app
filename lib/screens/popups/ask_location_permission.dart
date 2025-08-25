import 'package:flutter/material.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/screens/popups/ask_contact_permission.dart';
import 'package:permission_handler/permission_handler.dart';

class AskLocationPermission extends StatelessWidget {
  const AskLocationPermission({super.key});

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
                  onPressed: () => Get.to(() => const AskContactPermission()),
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
                    // Modern location icon with map visualization
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
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background circle
                          Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              color:
                                  AppColorConstants.themeColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                          ),

                          // Map visualization with location pin
                          CustomPaint(
                            size: Size(120, 120),
                            painter: _MapBackgroundPainter(),
                          ),

                          // Location pin icon
                          Positioned(
                            top: 50,
                            child: Icon(
                              Icons.location_pin,
                              size: 40,
                              color: AppColorConstants.themeColor,
                            ),
                          ),

                          // Pulse animation effect (conceptual)
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColorConstants.themeColor
                                    .withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Title
                    Heading5Text(
                      "Enable Location String",
                      textAlign: TextAlign.center,
                      weight: TextWeight.bold,
                    ),

                    const SizedBox(height: 16),

                    // Description
                    BodyMediumText(
                      'Share your location with friends in chat to meet up or share your whereabouts',
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      weight: TextWeight.medium,
                      color: AppColorConstants.themeColor.withOpacity(0.7),
                    ),

                    const SizedBox(height: 50),

                    // Permission button
                    AppThemeButton(
                      text: "Allow Access",
                      onPress: () async {
                        await Permission.location.request();
                        Get.to(() => const AskContactPermission());
                      },
                    ),

                    const SizedBox(height: 16),

                    // Privacy reassurance
                    BodySmallText(
                      'Your location is only shared when you choose to send it',
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

// Custom painter for map background visualization
class _MapBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColorConstants.themeColor.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw simple map grid lines
    final verticalSpacing = size.height / 4;
    final horizontalSpacing = size.width / 4;

    for (var i = 1; i < 4; i++) {
      // Vertical lines
      canvas.drawLine(
        Offset(horizontalSpacing * i, 0),
        Offset(horizontalSpacing * i, size.height),
        paint,
      );

      // Horizontal lines
      canvas.drawLine(
        Offset(0, verticalSpacing * i),
        Offset(size.width, verticalSpacing * i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
