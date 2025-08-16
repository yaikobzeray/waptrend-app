import 'package:foap/helper/imports/common_import.dart';
import 'package:google_fonts/google_fonts.dart';

Widget backNavigationBar({required String title}) {
  return Container(
    height: 100,
    decoration: BoxDecoration(
      color: Colors.transparent,
      border: Border(
        bottom: BorderSide(
          color: AppColorConstants.dividerColor.withOpacity(0.2),
          width: 0.5,
        ),
      ),
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // color: AppColorConstants.themeColor.withOpacity(0.1),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: AppColorConstants.iconColor,
                ),
              ),
            ).ripple(() {
              Get.back();
            }),
            const SizedBox(width: 40),
          ],
        ),
        BodyLargeText(
          title.tr,
          maxLines: 1,
          weight: TextWeight.bold,
          color: AppColorConstants.themeColor,
        )
      ],
    ).setPadding(
      left: DesignConstants.horizontalPadding,
      right: DesignConstants.horizontalPadding,
      top: 40,
    ),
  );
}

Widget backNavigationBarWithTrailingWidget(
    {required String title, required Widget widget}) {
  return Container(
    height: 70,
    decoration: BoxDecoration(
      color: AppColorConstants.cardColor,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    width: double.infinity,
    child: Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // color: AppColorConstants.themeColor.withOpacity(0.1),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_back,
                  size: 18,
                  color: AppColorConstants.themeColor,
                ),
              ),
            ).ripple(() {
              Get.back();
            }),
            widget,
          ],
        ),
        Positioned.fill(
          child: Center(
            child: BodyLargeText(
              title,
              weight: TextWeight.bold,
              color: AppColorConstants.themeColor,
            ),
          ),
        )
      ],
    ).setPadding(
      left: DesignConstants.horizontalPadding,
      right: DesignConstants.horizontalPadding,
      top: 40,
    ),
  );
}

Widget profileScreensNavigationBar(
    {required String title,
    String? rightBtnTitle,
    required VoidCallback completion}) {
  return Container(
    decoration: BoxDecoration(
      // color: AppColorConstants.cardColor,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    ),
    child: Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // color: AppColorConstants.themeColor.withOpacity(0.1),
              ),
              child: ThemeIconWidget(
                ThemeIcon.backArrow,
                size: 18,
                color: AppColorConstants.iconColor,
              ),
            ).ripple(() {
              Get.back();
            }),
            if (rightBtnTitle != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    AppColorConstants.themeColor.darken(),
                    AppColorConstants.themeColor
                  ]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: BodyMediumText(
                  rightBtnTitle.tr,
                  weight: TextWeight.medium,
                  color: Colors.white,
                ),
              ).ripple(() {
                completion();
              }),
          ],
        ).setPadding(
          left: DesignConstants.horizontalPadding,
          right: DesignConstants.horizontalPadding,
        ),
        Positioned(
          left: 0,
          right: 0,
          child: Center(
            child: BodyLargeText(
              title.tr,
              weight: TextWeight.bold,
              color: AppColorConstants.themeColor,
            ),
          ),
        )
      ],
    ).bP16,
  );
}

Widget titleNavigationBarWithIcon(
    {required String title,
    required ThemeIcon icon,
    Color? iconColor,
    required VoidCallback completion}) {
  return Container(
    decoration: BoxDecoration(
      color: AppColorConstants.cardColor,
      border: Border(
        bottom: BorderSide(
          color: AppColorConstants.dividerColor.withOpacity(0.2),
          width: 0.5,
        ),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 25),
        BodyLargeText(
          title.tr,
          weight: TextWeight.bold,
          color: AppColorConstants.themeColor,
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColorConstants.themeColor.withOpacity(0.1),
          ),
          child: ThemeIconWidget(
            icon,
            color: iconColor ?? AppColorConstants.themeColor,
            size: 25,
          ),
        ).ripple(() {
          completion();
        }),
      ],
    ).setPadding(
      left: DesignConstants.horizontalPadding,
      right: DesignConstants.horizontalPadding,
      top: 8,
      bottom: 16,
    ),
  );
}

Widget titleNavigationBarWithWidget(
    {required String title,
    required Widget widget,
    required VoidCallback completion}) {
  return Container(
    decoration: BoxDecoration(
      color: AppColorConstants.cardColor,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 25),
        BodyLargeText(
          title.tr,
          weight: TextWeight.bold,
          color: AppColorConstants.themeColor,
        ),
        widget,
      ],
    ).setPadding(
      left: DesignConstants.horizontalPadding,
      right: DesignConstants.horizontalPadding,
      top: 8,
      bottom: 16,
    ),
  );
}

Widget titleNavigationBar({required String title}) {
  return Container(
    height: 100,
    width: Get.width,
    decoration: BoxDecoration(
      color: AppColorConstants.cardColor,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Center(
      child: BodyLargeText(
        title.tr,
        weight: TextWeight.bold,
        color: AppColorConstants.themeColor,
      ).setPadding(top: 40),
    ),
  );
}

Widget customNavigationBar(
    {required String title, VoidCallback? action, Widget? trailing}) {
  return Container(
    height: 100,
    decoration: BoxDecoration(
      color: AppColorConstants.cardColor,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColorConstants.themeColor.withOpacity(0.1),
          ),
          child: ThemeIconWidget(
            ThemeIcon.backArrow,
            size: 18,
            color: AppColorConstants.iconColor,
          ),
        ).ripple(() {
          if (action != null) {
            action();
          } else {
            Get.back();
          }
        }),
        Heading4Text(
          title,
          weight: TextWeight.bold,
          color: AppColorConstants.themeColor,
        ),
        trailing ?? const SizedBox(width: 20),
      ],
    ).setPadding(
      left: DesignConstants.horizontalPadding,
      right: DesignConstants.horizontalPadding,
      top: 8,
      bottom: 16,
    ),
  );
}
