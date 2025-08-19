import 'package:foap/controllers/shop/shop_controller.dart';
import 'package:foap/helper/imports/chat_imports.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/profile_imports.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../model/shop_model/ad_model.dart';
import 'enlarge_imageview.dart';

class AdDetailScreen extends StatefulWidget {
  final AdModel adModel;

  const AdDetailScreen({Key? key, required this.adModel}) : super(key: key);

  @override
  AdDetailState createState() => AdDetailState();
}

class AdDetailState extends State<AdDetailScreen> {
  final ShopController shopController = Get.find();
  final ChatDetailController _chatDetailController = Get.find();
  int _currentImageIndex = 0;
  final double _sectionSpacing = 24;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageCarousel(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAdHeader(),
                        SizedBox(height: _sectionSpacing),
                        _buildAboutSection(),
                        SizedBox(height: _sectionSpacing),
                        _buildAddressSection(),
                        SizedBox(height: _sectionSpacing),
                        _buildPriceSection(),
                        SizedBox(height: _sectionSpacing * 1.5),
                        _buildSellerSection(),
                        SizedBox(height: _sectionSpacing),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: AppColorConstants.backgroundColor,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios,
                  color: AppColorConstants.themeColor),
              onPressed: () => Get.back(),
            ),
          ),
          CircleAvatar(
            backgroundColor: AppColorConstants.cardColor,
            child: IconButton(
              icon: Icon(
                widget.adModel.isFavorite == 1
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: widget.adModel.isFavorite == 1
                    ? AppColorConstants.red
                    : AppColorConstants.subHeadingTextColor,
              ),
              onPressed: _toggleFavorite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: AppColorConstants.cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: widget.adModel.images.isNotEmpty
              ? WKCarouselSlider(
                  items: widget.adModel.images
                      .map((item) => GestureDetector(
                            onTap: () =>
                                Get.to(() => EnlargeImageViewScreen(item)),
                            child: Hero(
                              tag: item,
                              child: CachedNetworkImage(
                                imageUrl: item,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(
                                    color: AppColorConstants.themeColor,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ))
                      .toList(),
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  viewportFraction: 1,
                  height: 300,
                  onPageChanged: (index) =>
                      setState(() => _currentImageIndex = index),
                )
              : Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 60,
                    color: AppColorConstants.subHeadingTextColor,
                  ),
                ),
        ),
        if (widget.adModel.images.length > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.adModel.images.asMap().entries.map((entry) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _currentImageIndex == entry.key ? 20 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _currentImageIndex == entry.key
                        ? AppColorConstants.themeColor
                        : Colors.white.withOpacity(0.5),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildAdHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (widget.adModel.featured == 1)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'FEATURED',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.amber[800],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          widget.adModel.title ?? '',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColorConstants.mainTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.location_on_outlined,
                size: 18, color: AppColorConstants.subHeadingTextColor),
            const SizedBox(width: 4),
            Text(
              widget.adModel.locations?.customLocation ?? '',
              style: TextStyle(
                fontSize: 14,
                color: AppColorConstants.subHeadingTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About this item',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColorConstants.mainTextColor,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.adModel.description ?? '',
          style: TextStyle(
            fontSize: 15,
            height: 1.5,
            color: AppColorConstants.subHeadingTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColorConstants.mainTextColor,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.pin_drop_outlined, color: AppColorConstants.themeColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.adModel.locations?.customLocation ?? '',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColorConstants.subHeadingTextColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return widget.adModel.isDeal == 1
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Deal Price',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColorConstants.subHeadingTextColor,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    widget.adModel.actualPriceString,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColorConstants.subHeadingTextColor,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColorConstants.themeColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.adModel.dealPriceString,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColorConstants.themeColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColorConstants.subHeadingTextColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.adModel.currency} ${widget.adModel.price}',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColorConstants.themeColor,
                ),
              ),
            ],
          );
  }

  Widget _buildSellerSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorConstants.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColorConstants.backgroundColor,
                backgroundImage: widget.adModel.user?.picture != null
                    ? CachedNetworkImageProvider(widget.adModel.user!.picture!)
                    : null,
                child: widget.adModel.user?.picture == null
                    ? Icon(Icons.person, color: AppColorConstants.themeColor)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seller',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColorConstants.subHeadingTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.adModel.user?.name ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _buildChatButton(),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => Get.to(() => OtherUserProfile(
                  user: widget.adModel.user!,
                  userId: widget.adModel.user!.id,
                )),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColorConstants.themeColor,
              side: BorderSide(color: AppColorConstants.themeColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('View Profile'),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppColorConstants.themeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(Icons.chat, color: Colors.white),
        onPressed: _startChatWithSeller,
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      widget.adModel.isFavorite = widget.adModel.isFavorite == 1 ? 0 : 1;
    });
    shopController.favUnfavAd(widget.adModel);
  }

  void _startChatWithSeller() {
    _chatDetailController.getChatRoomWithUser(
      userId: widget.adModel.user!.id,
      callback: (room) => Get.to(() => ChatDetail(chatRoom: room)),
    );
  }
}
