import 'package:icons_plus/icons_plus.dart';
import '../../helper/imports/common_import.dart';
import '../settings_menu/settings_controller.dart';

class PostOptionsPopup extends StatelessWidget {
  final SettingsController _settingsController = Get.find();
  final Function(PostOptionType) callbackHandler;

  PostOptionsPopup({super.key, required this.callbackHandler});

  @override
  Widget build(BuildContext context) {
    List<ModalComponents> options = [];

    options.add(cameraButton());

    if (_settingsController.setting.value!.enableImagePost) {
      options.add(galleryButton());
    }
    if (_settingsController.setting.value!.enableVideoPost) {
      options.add(videoButton());
    }
    options.add(drawButton());
    options.add(audioButton());
    options.add(gifButton());
    options.add(pollButton());

    return SizedBox(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: DesignConstants.horizontalPadding,
          vertical: 8,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // 4 items per row
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.3, // Adjust for button proportions
        ),
        itemCount: options.length,
        itemBuilder: (ctx, index) {
          return options[index];
        },
      ),
    );
  }

  ModalComponents cameraButton() {
    return ModalComponents(
      icon: Iconsax.camera_outline,
      name: cameraString.tr,
      onPress: () async {
        callbackHandler(PostOptionType.camera);
      },
    );
  }

  ModalComponents galleryButton() {
    return ModalComponents(
      icon: Iconsax.gallery_outline,
      name: galleryString.tr,
      onPress: () async {
        callbackHandler(PostOptionType.gallery);
      },
    );
  }

  ModalComponents videoButton() {
    return ModalComponents(
      icon: Iconsax.video_outline,
      name: videoString.tr,
      onPress: () async {
        callbackHandler(PostOptionType.video);
      },
    );
  }

  ModalComponents drawButton() {
    return ModalComponents(
      icon: Iconsax.pen_tool_outline,
      name: drawingString.tr,
      onPress: () {
        callbackHandler(PostOptionType.drawing);
      },
    );
  }

  ModalComponents audioButton() {
    return ModalComponents(
      icon: Iconsax.microphone_2_outline,
      name: audioString.tr,
      onPress: () {
        callbackHandler(PostOptionType.audio);
      },
    );
  }

  ModalComponents gifButton() {
    return ModalComponents(
      icon: Iconsax.gallery_import_outline,
      name: gifString.tr,
      onPress: () {
        callbackHandler(PostOptionType.gif);
      },
    );
  }

  ModalComponents pollButton() {
    return ModalComponents(
      icon: Iconsax.chart_outline,
      name: pollString.tr,
      onPress: () {
        callbackHandler(PostOptionType.poll);
      },
    );
  }
}

class ModalComponents extends StatelessWidget {
  final String? imageUrl;
  final IconData icon;
  final String name;
  final VoidCallback? onPress;

  const ModalComponents({
    super.key,
    this.imageUrl,
    required this.icon,
    required this.name,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 80, // Minimum height to prevent overflow
        maxHeight: 100, // Maximum height constraint
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 4, vertical: 8), // Reduced padding
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColorConstants.themeColor.darken(),
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize:
              MainAxisSize.min, // Important: prevents column from expanding
          children: [
            Icon(
              icon,
              size: 18, // Slightly smaller icon
              color: AppColorConstants.iconColor,
            ),
            const SizedBox(height: 4), // Reduced spacing
            Expanded(
              // Use Expanded to contain text
              child: BodySmallText(
                name,
                color: AppColorConstants.mainTextColor,
                textAlign: TextAlign.center,
                maxLines: 2, // Allow 2 lines for longer text
              ),
            ),
          ],
        ),
      ).ripple(() {
        onPress?.call();
      }),
    );
  }
}
