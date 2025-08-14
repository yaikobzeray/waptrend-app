import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/controllers/shop/shop_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../model/shop_model/ad_model.dart';
import '../../../segmentAndMenu/horizontal_menu.dart';
import '../components/ad_card.dart';
import '../home/ad_detail_screen.dart';
import '../post_ad/choose_category.dart';
import '../post_ad/enter_ad_detail.dart';

class MyAds extends StatefulWidget {
  const MyAds({Key? key}) : super(key: key);

  @override
  State<MyAds> createState() => _MyAdsState();
}

class _MyAdsState extends State<MyAds> {
  final ShopController shopController = Get.find();
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  final double _itemSpacing = 16.0;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    shopController.refreshMyAds(() {
      refreshController.refreshCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColorConstants.themeColor,
        elevation: 4,
        child: const Icon(Icons.add, size: 28, color: Colors.white),
        onPressed: _navigateToCreateAd,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: AppColorConstants.backgroundColor,
              pinned: true,
              elevation: 0,
              leading: IconButton(
                icon:
                    Icon(Icons.arrow_back, color: AppColorConstants.themeColor),
                onPressed: () => Get.back(),
              ),
              centerTitle: true,
              title: Text(
                myProductString.tr,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColorConstants.mainTextColor,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(70),
                child: Column(
                  children: [
                    _buildSegmentedControl(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ];
        },
        body: _buildAdsList(),
      ),
    );
  }

  void _navigateToCreateAd() {
    Get.to(() => ChooseListingCategory(ad: AdModel(images: [])))?.then((_) {
      refreshController.requestRefresh();
    });
  }

  Widget _buildSegmentedControl() {
    return Obx(() => Container(
          decoration: BoxDecoration(
            color: AppColorConstants.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(4),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: HorizontalMenuBar(
            menus: [
              activeString.tr,
              pendingString.tr,
              rejectedString.tr,
              expiredString.tr,
              soldString.tr,
              deletedString.tr
            ],
            selectedIndex: shopController.selectSegment.value,
            onSegmentChange: (selectedMenu) {
              shopController.handleSegmentChange(selectedMenu);
              refreshController.requestRefresh();
            },
          ),
        ));
  }

  Widget _buildAdsList() {
    return Obx(() {
      if (shopController.myAds.isEmpty) {
        return _buildEmptyState();
      }
      return SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown: true,
        onRefresh: _loadInitialData,
        onLoading: () => shopController.loadMoreMyAds(() {
          refreshController.loadComplete();
        }),
        physics: const BouncingScrollPhysics(),
        child: AnimationLimiter(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: DesignConstants.horizontalPadding,
              vertical: _itemSpacing,
            ),
            itemCount: shopController.myAds.length,
            itemBuilder: (context, index) =>
                AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: _buildAdCard(index),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAdCard(int index) {
    final ad = shopController.myAds[index];
    final statusInfo = _getStatusInfo(ad.statusText ?? "");

    return Padding(
      padding: EdgeInsets.only(bottom: _itemSpacing),
      child: GestureDetector(
        onTap: () => Get.to(() => AdDetailScreen(adModel: ad)),
        child: Container(
          decoration: BoxDecoration(
            color: AppColorConstants.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: MyAdCard(
                  ad: ad,
                  actionHandler: () => _showAdActionSheet(ad),
                ),
              ),
              _buildStatusIndicator(statusInfo.color, statusInfo.text),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(Color color, String text) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.chevron_right,
            color: color.withOpacity(0.7),
            size: 20,
          ),
        ],
      ),
    );
  }

  _StatusInfo _getStatusInfo(String status) {
    switch (status) {
      case "Deleted":
        return _StatusInfo(
            const Color.fromARGB(255, 64, 62, 62), deletedString.tr);
      case "Pending":
        return _StatusInfo(Colors.orange, pendingString.tr);
      case "Rejected":
        return _StatusInfo(Colors.red, rejectedString.tr);
      case "Expired":
        return _StatusInfo(Colors.amber, expiredString.tr);
      case "Sold":
        return _StatusInfo(Colors.orange, soldString.tr);
      case "Active":
        return _StatusInfo(Colors.green, activeString.tr);
      default:
        return _StatusInfo(AppColorConstants.themeColor, activeString.tr);
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 60,
            color: AppColorConstants.subHeadingTextColor,
          ),
          const SizedBox(height: 20),
          Text(
            noProductFoundString.tr,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColorConstants.mainTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              tapToEditString.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColorConstants.subHeadingTextColor,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: AppColorConstants.themeColor,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          //   ),
          //   onPressed: _navigateToCreateAd,
          //   child: Text(
          //     addedNewProductString.tr,
          //     style: GoogleFonts.poppins(
          //       fontSize: 16,
          //       fontWeight: FontWeight.w500,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  void _showAdActionSheet(AdModel ad) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColorConstants.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              ad.title ?? '',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              selectAdTypeString.tr,
              style: TextStyle(
                color: AppColorConstants.subHeadingTextColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            if (ad.status == 10) // Active
              _buildActionButton(
                icon: Icons.check_circle_outline,
                label: markAsSoldString.tr,
                color: Colors.green,
                onTap: () {
                  _updateAdStatus(4, ad);
                  Get.back();
                },
              ),
            _buildActionButton(
              icon: Icons.edit,
              label: editString.tr,
              color: AppColorConstants.themeColor,
              onTap: () {
                Get.back();
                Get.to(() => EnterAdDetail(ad));
              },
            ),
            _buildActionButton(
              icon: Icons.delete_outline,
              label: deleteString.tr,
              color: Colors.red,
              onTap: () {
                _updateAdStatus(0, ad);
                Get.back();
              },
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                cancelString.tr,
                style: TextStyle(
                  color: AppColorConstants.subHeadingTextColor,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: TextStyle(color: color),
      ),
      onTap: onTap,
    );
  }

  void _updateAdStatus(int status, AdModel ad) {
    shopController.updateStatus(ad: ad, status: status);
  }
}

class _StatusInfo {
  final Color color;
  final String text;

  _StatusInfo(this.color, this.text);
}
