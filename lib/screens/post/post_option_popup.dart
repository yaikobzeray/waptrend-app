import 'package:icons_plus/icons_plus.dart';
import '../../helper/imports/common_import.dart';
import '../settings_menu/settings_controller.dart';

class PostOptionsPopup extends StatelessWidget {
  final SettingsController _settingsController = Get.find();
  final Function(PostOptionType) callbackHandler;

  PostOptionsPopup({super.key, required this.callbackHandler});

  @override
  Widget build(BuildContext context) {
    List<Widget> options = [];

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
      height: 30,
      child: ListView.separated(
        padding: EdgeInsets.only(
            left: DesignConstants.horizontalPadding,
            right: DesignConstants.horizontalPadding),
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        itemBuilder: (ctx, index) {
          return options[index];
        },
        separatorBuilder: (ctx, index) {
          return const SizedBox(
            width: 8,
          );
        },
      ),
    );
  }

  Widget cameraButton() {
    return ModalComponents(
      icon: Iconsax.camera_outline,
      name: cameraString.tr,
      onPress: () async {
        callbackHandler(PostOptionType.camera);
      },
    );
  }

  Widget galleryButton() {
    return ModalComponents(
      icon: Iconsax.gallery_outline,
      name: galleryString.tr,
      onPress: () async {
        callbackHandler(PostOptionType.gallery);
      },
    );
  }

  Widget videoButton() {
    return ModalComponents(
      icon: Iconsax.video_outline,
      name: videoString.tr,
      onPress: () async {
        callbackHandler(PostOptionType.video);
      },
    );
  }

  Widget drawButton() {
    return ModalComponents(
      icon: Iconsax.pen_tool_outline,
      name: drawingString.tr,
      onPress: () {
        callbackHandler(PostOptionType.drawing);
      },
    );
  }

  Widget audioButton() {
    return ModalComponents(
      icon: Iconsax.microphone_2_outline,
      name: audioString.tr,
      onPress: () {
        callbackHandler(PostOptionType.audio);
      },
    );
  }

  Widget gifButton() {
    return ModalComponents(
      icon: Iconsax.gallery_import_outline,
      name: gifString.tr,
      onPress: () {
        callbackHandler(PostOptionType.gif);
      },
    );
  }

  Widget pollButton() {
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColorConstants.themeColor.darken(),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColorConstants.iconColor,
          ),
          const SizedBox(width: 8),
          BodySmallText(
            name,
            color: AppColorConstants.mainTextColor,
          ),
        ],
      ),
    ).ripple(() {
      onPress?.call();
    });
  }
}
