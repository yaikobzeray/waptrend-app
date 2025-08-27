import 'package:camera/camera.dart';
import 'package:foap/screens/add_on/controller/reel/create_reel_controller.dart';
import 'package:foap/screens/add_on/ui/reel/select_music.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart'; // Add this import
import '../../../content_creator_view.dart';

class CreateReelScreen extends StatefulWidget {
  const CreateReelScreen({super.key});

  @override
  State<CreateReelScreen> createState() => _CreateReelScreenState();
}

class _CreateReelScreenState extends State<CreateReelScreen>
    with TickerProviderStateMixin {
  final CreateReelController _createReelController = Get.find();
  final ImagePicker _imagePicker = ImagePicker(); // Add image picker instance
  AnimationController? animationController;

  @override
  void initState() {
    _initAnimation();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CreateReelScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initAnimation();
  }

  @override
  void dispose() {
    _createReelController.clear();
    super.dispose();
  }

  _initAnimation() {
    animationController = AnimationController(
        vsync: this,
        duration:
            Duration(seconds: _createReelController.recordingLength.value));
    animationController!.addListener(() {
      setState(() {});
    });
    animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        stopRecording();
      }
    });
  }

  // Add this method to pick video from gallery
  _pickVideoFromGallery() async {
    try {
      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
        maxDuration:
            Duration(seconds: _createReelController.recordingLength.value),
      );

      if (video != null) {
        // Handle the selected video
        _createReelController.handleGalleryVideo(video);

        // Navigate to next screen or process the video
        // For example:
        // Get.to(() => VideoPreviewScreen(videoFile: File(video.path)));
      }
    } catch (e) {
      debugPrint('Error picking video: $e');
      // Show error message to user
      Get.snackbar(
        errorString.tr,
        "failedToPickVideoString"
            .tr, // Make sure to add these strings to your localization
        backgroundColor: AppColorConstants.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: Column(
        children: [
          Stack(
            children: [
              // Camera Preview
              const CameraView(),

              // Top Controls
              Positioned(
                top: 50,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Close Button
                    _buildControlButton(
                      icon: const Icon(AntDesign.close_outline, size: 20),
                      onTap: () => Get.back(),
                    ),

                    // Music Selection
                    Obx(() => _buildMusicSelector()),
                  ],
                ),
              ),

              // Right Side Controls
              Positioned(
                right: 16,
                top: 120,
                child: _buildSideControls(),
              ),

              // Gallery Import Button - ADDED THIS
              // Positioned(
              //   left: 16,
              //   top: 120,
              //   child: _buildGalleryButton(),
              // ),

              // Bottom Record Button
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: _buildRecordButton(),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Row(
              children: [
                // Close Button
                _buildControlButton(
                  icon: Icon(
                    Icons.image,
                    size: 20,
                    color: AppColorConstants.backgroundColor,
                  ),
                  onTap: () => _pickVideoFromGallery(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Add this method to build the gallery button
  // Widget _buildGalleryButton() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
  //     decoration: BoxDecoration(
  //       color: AppColorConstants.cardColor.withOpacity(0.7),
  //       borderRadius: BorderRadius.circular(24),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.2),
  //           blurRadius: 12,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: _buildSideControlButton(
  //       icon: const Icon(Icons.photo_library, size: 24),
  //       onTap: _pickVideoFromGallery,
  //     ),
  //   );
  // }

  Widget _buildControlButton(
      {required Widget icon, required VoidCallback onTap}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColorConstants.themeColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(child: icon),
    ).ripple(onTap);
  }

  Widget _buildMusicSelector() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColorConstants.themeColor,
            AppColorConstants.themeColor.darken(),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_createReelController.selectedAudio.value != null)
            ThemeIconWidget(
              ThemeIcon.music,
              color: AppColorConstants.mainTextColor,
            ).p8,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: BodyMediumText(
              _createReelController.selectedAudio.value != null
                  ? _createReelController.selectedAudio.value!.name
                  : selectMusicString.tr,
              color: AppColorConstants.backgroundColor,
              weight: TextWeight.medium,
            ),
          ),
        ],
      ),
    ).ripple(() {
      final cameraService = Get.find<CameraControllerService>();
      Get.bottomSheet(
        SelectMusic(
          selectedAudioCallback: (croppedAudio, music) {
            _createReelController.setCroppedAudio(croppedAudio);
            cameraService.initializeCamera(CameraLensDirection.front);
          },
        ),
        isScrollControlled: true,
        ignoreSafeArea: true,
      );
    });
  }

  Widget _buildSideControls() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColorConstants.cardColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Camera Flip
          _buildSideControlButton(
            icon: const Icon(ZondIcons.camera, size: 24),
            onTap: () {
              final cameraService = Get.find<CameraControllerService>();
              if (cameraService.controller.description.lensDirection ==
                  CameraLensDirection.back) {
                cameraService.initializeCamera(CameraLensDirection.front);
              } else {
                cameraService.initializeCamera(CameraLensDirection.back);
              }
            },
          ),

          const SizedBox(height: 16),

          // Flash Toggle
          Obx(() => _buildSideControlButton(
                icon: Icon(
                  _createReelController.flashSetting.value
                      ? IonIcons.flash_off
                      : IonIcons.flash,
                  size: 24,
                ),
                onTap: () {
                  final cameraService = Get.find<CameraControllerService>();
                  if (_createReelController.flashSetting.value) {
                    cameraService.controller.setFlashMode(FlashMode.off);
                    _createReelController.turnOffFlash();
                  } else {
                    cameraService.controller.setFlashMode(FlashMode.torch);
                    _createReelController.turnOnFlash();
                  }
                },
              )),

          const SizedBox(height: 16),

          // Duration Selector - 15s
          Obx(() => _buildDurationButton(
                duration: 15,
                isActive: _createReelController.recordingLength.value == 15,
              )),

          const SizedBox(height: 16),

          // Duration Selector - 30s
          Obx(() => _buildDurationButton(
                duration: 30,
                isActive: _createReelController.recordingLength.value == 30,
              )),
        ],
      ),
    );
  }

  Widget _buildSideControlButton({
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColorConstants.backgroundColor.withOpacity(0.7),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: icon,
      ),
    ).ripple(onTap);
  }

  Widget _buildDurationButton({required int duration, required bool isActive}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isActive
            ? AppColorConstants.themeColor.darken()
            : AppColorConstants.backgroundColor.withOpacity(0.7),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: BodySmallText(
          '${duration}s',
          color: isActive
              ? AppColorConstants.backgroundColor
              : AppColorConstants.themeColor.darken(),
        ),
      ),
    ).ripple(() {
      _createReelController.updateRecordingLength(duration);
      _initAnimation();
    });
  }

  Widget _buildRecordButton() {
    return GestureDetector(
      onTap: () {
        animationController!.forward();
        _recordVideo();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Progress Circle
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              value: animationController!.value,
              strokeWidth: 3,
              backgroundColor: AppColorConstants.themeColor.withOpacity(0.2),
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColorConstants.themeColor),
            ),
          ),

          // Record Button
          Obx(() => Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _createReelController.isRecording.value
                      ? Colors.red
                      : AppColorConstants.themeColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    _createReelController.isRecording.value
                        ? Icons.pause
                        : Icons.fiber_manual_record,
                    size: 30,
                    color: AppColorConstants.backgroundColor,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  // Existing methods remain unchanged below this point
  _recordVideo() async {
    if (_createReelController.isRecording.value) {
      stopRecording();
    } else {
      startRecording();
    }
  }

  void stopRecording() async {
    animationController?.reset();
    final cameraService = Get.find<CameraControllerService>();
    final file = await cameraService.controller.stopVideoRecording();
    debugPrint('RecordedFile:: ${file.path}');
    _createReelController.stopRecording();
    if (_createReelController.croppedAudioFile != null) {
      _createReelController.stopPlayingAudio();
    }
    _createReelController.isRecording.value = false;
    _createReelController.createReel(
        _createReelController.croppedAudioFile, file);
  }

  void startRecording() async {
    final cameraService = Get.find<CameraControllerService>();

    await cameraService.controller.prepareForVideoRecording();
    await cameraService.controller.startVideoRecording();
    _createReelController.startRecording();
    if (_createReelController.croppedAudioFile != null) {
      _createReelController
          .playAudioFile(_createReelController.croppedAudioFile!);
    }
  }
}
