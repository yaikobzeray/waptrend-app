import 'package:flutter/material.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/screens/popups/ask_storage_permission.dart';
import 'package:permission_handler/permission_handler.dart';

class AskMicPermission extends StatelessWidget {
  const AskMicPermission({super.key});

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
                  onPressed: () => Get.to(() => const AskStoragePermission()),
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
                    // Modern microphone visualization with sound waves
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

                          // Sound wave visualization
                          CustomPaint(
                            size: Size(140, 140),
                            painter: _SoundWavePainter(),
                          ),

                          // Microphone icon
                          Icon(
                            Icons.mic_rounded,
                            size: 50,
                            color: AppColorConstants.themeColor,
                          ),

                          // Decorative elements
                          Positioned(
                            right: 30,
                            top: 40,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColorConstants.themeColor
                                    .withOpacity(0.4),
                              ),
                            ),
                          ),

                          Positioned(
                            left: 30,
                            bottom: 40,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColorConstants.themeColor
                                    .withOpacity(0.3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Title
                    Heading5Text(
                      "Enable Microphone ",
                      textAlign: TextAlign.center,
                      weight: TextWeight.bold,
                    ),

                    const SizedBox(height: 16),

                    // Description
                    BodyMediumText(
                      'Access your microphone to record audio messages for chats and create audio posts',
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
                        await Permission.microphone.request();
                        Get.to(() => const AskStoragePermission());
                      },
                    ),

                    const SizedBox(height: 16),

                    // Privacy reassurance
                    BodySmallText(
                      'Microphone access is only used when you actively record audio',
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

// Custom painter for sound wave visualization
class _SoundWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;
    final paint = Paint()
      ..color = AppColorConstants.themeColor.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw concentric circles for sound wave effect
    for (var i = 1; i <= 3; i++) {
      final radius = maxRadius * (i / 3);
      canvas.drawCircle(center, radius, paint);
    }

    // Draw sound wave lines
    final wavePaint = Paint()
      ..color = AppColorConstants.themeColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final waveCount = 4;
    final waveSpacing = 8.0;

    for (var i = 0; i < waveCount; i++) {
      final y = center.dy - (waveCount ~/ 2) * waveSpacing + i * waveSpacing;
      final path = Path()
        ..moveTo(center.dx - 20, y)
        ..quadraticBezierTo(center.dx, y - 4, center.dx + 20, y);
      canvas.drawPath(path, wavePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
