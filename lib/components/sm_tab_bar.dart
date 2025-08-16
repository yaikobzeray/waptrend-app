import 'package:foap/helper/imports/common_import.dart';

class SMTabBar extends StatelessWidget {
  final TabController? controller;
  final List<String> tabs;
  final bool canScroll;
  final bool hideDivider;
  final Color? lableColor;
  final Color? unselectedLabelColor;

  const SMTabBar({
    super.key,
    required this.tabs,
    required this.canScroll,
    this.controller,
    this.hideDivider = true,
    this.lableColor,
    this.unselectedLabelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        getTextTabBar(
            lableColor: lableColor,
            unselectedLabelColor: unselectedLabelColor,
            tabs: tabs,
            controller: controller,
            canScroll: canScroll,
            hideDivider: !hideDivider)
      ],
    );
  }
}

class SMIconTabBar extends StatelessWidget {
  final List<ThemeIcon> tabs;
  final TabController? controller;
  final int selectedTab;

  const SMIconTabBar(
      {super.key,
      required this.tabs,
      this.controller,
      required this.selectedTab});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
          left: DesignConstants.horizontalPadding,
          right: DesignConstants.horizontalPadding,
          bottom: 0,
          child: Container(
            height: 2,
            color: AppColorConstants.dividerColor,
          ).round(5)),
    ]);
  }
}

class SMIconAndTextTabBar extends StatelessWidget {
  final List<ThemeIcon> icons;
  final List<String> texts;

  final TabController? controller;
  final int selectedTab;

  const SMIconAndTextTabBar(
      {super.key,
      required this.icons,
      required this.texts,
      this.controller,
      required this.selectedTab});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
          left: DesignConstants.horizontalPadding,
          right: DesignConstants.horizontalPadding,
          bottom: 0,
          child: Container(
            height: 2,
            color: AppColorConstants.dividerColor,
          ).round(5)),
      getIconAndTexTabBar(icons: icons, texts: texts, selectedTab: selectedTab)
    ]);
  }
}

TabBar getTextTabBar(
    {TabController? controller,
    required List<String> tabs,
    bool hideDivider = false,
    Color? lableColor,
    Color? unselectedLabelColor,
    required bool canScroll}) {
  return TabBar(
    padding: EdgeInsets.zero,
    controller: controller,
    isScrollable: canScroll,
    tabAlignment: canScroll == true ? TabAlignment.start : null,
    dividerHeight: hideDivider ? 0 : 1,
    indicator: UnderlineTabIndicator(
      borderSide:
          BorderSide(width: 3.0, color: AppColorConstants.backgroundColor),
      insets: const EdgeInsets.symmetric(horizontal: 16.0),
    ),
    onTap: (status) {
      FocusScope.of(Get.context!).requestFocus(FocusNode());
    },
    labelStyle: TextStyle(
        fontSize: FontSizes.b2,
        color: AppColorConstants.backgroundColor,
        fontWeight: TextWeight.medium),
    labelColor: lableColor ?? AppColorConstants.themeColor,
    unselectedLabelColor:
        unselectedLabelColor ?? AppColorConstants.mainTextColor,
    tabs: List.generate(tabs.length, (int index) {
      return Tab(
        text: tabs[index],
      );
    }),
  );
}

TabBar getIconTabBar(
    {TabController? controller,
    required List<ThemeIcon> icons,
    required int selectedTab}) {
  return TabBar(
    controller: controller,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(width: 3.0, color: AppColorConstants.themeColor),
      insets: const EdgeInsets.symmetric(horizontal: 16.0),
    ),
    labelColor: AppColorConstants.themeColor,
    unselectedLabelColor: AppColorConstants.subHeadingTextColor,
    tabs: List.generate(icons.length, (int index) {
      return Tab(
        icon: ThemeIconWidget(
          icons[index],
          color: index == selectedTab
              ? AppColorConstants.themeColor
              : AppColorConstants.mainTextColor,
        ),
        // text: tabs[index],
      );
    }),
  );
}

TabBar getIconAndTexTabBar(
    {TabController? controller,
    required List<ThemeIcon> icons,
    required List<String> texts,
    required int selectedTab}) {
  return TabBar(
    controller: controller,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(width: 3.0, color: AppColorConstants.themeColor),
      insets: const EdgeInsets.symmetric(horizontal: 16.0),
    ),
    labelColor: AppColorConstants.themeColor,
    unselectedLabelColor: AppColorConstants.subHeadingTextColor,
    tabs: List.generate(icons.length, (int index) {
      return Tab(
        icon: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ThemeIconWidget(
              icons[index],
              color: index == selectedTab
                  ? AppColorConstants.themeColor
                  : AppColorConstants.mainTextColor,
            ),
            const SizedBox(
              width: 5,
            ),
            BodyLargeText(
              texts[index],
              color: index == selectedTab
                  ? AppColorConstants.themeColor
                  : AppColorConstants.mainTextColor,
              weight: TextWeight.semiBold,
            )
          ],
        ),
        // text: tabs[index],
      );
    }),
  );
}
