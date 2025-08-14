import 'package:foap/helper/imports/common_import.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../model/shop_model/ad_model.dart';

class AdCard extends StatefulWidget {
  final AdModel ad;
  final VoidCallback pressed;
  final VoidCallback favPressed;

  const AdCard(
      {super.key,
      required this.ad,
      required this.pressed,
      required this.favPressed});

  @override
  State<AdCard> createState() => _AdCardState();
}

class _AdCardState extends State<AdCard> {
  bool _isFavoriteHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.pressed(),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: AppColorConstants.cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Stack(
                children: [
                  SizedBox(
                    height: 160,
                    width: double.infinity,
                    child: widget.ad.images.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: widget.ad.images.first,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: AppUtil.addProgressIndicator(size: 30),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.broken_image, size: 40),
                            ),
                          )
                        : Container(
                            color: Colors.grey[200],
                            child:
                                const Icon(Icons.image_not_supported, size: 40),
                          ),
                  ),

                  // Deal & Featured Badges
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.ad.isDeal == 1)
                          Container(
                            decoration: BoxDecoration(
                              color: AppColorConstants.red.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.local_offer,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                BodySmallText(
                                  widget.ad.actualPriceString,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                BodyMediumText(
                                  widget.ad.dealPriceString,
                                  color: Colors.white,
                                  weight: TextWeight.bold,
                                ),
                              ],
                            ),
                          ).bP8,
                        if (widget.ad.featured == 1)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.yellow[700],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            child: BodySmallText(
                              'FEATURED',
                              color: Colors.black,
                              weight: TextWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              // Content Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BodyLargeText(
                                widget.ad.finalPriceString,
                                weight: TextWeight.bold,
                                color: AppColorConstants.themeColor,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                              MouseRegion(
                                onEnter: (_) =>
                                    setState(() => _isFavoriteHovered = true),
                                onExit: (_) =>
                                    setState(() => _isFavoriteHovered = false),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: (widget.ad.isFavorite == 1
                                        ? Colors.red[100]
                                        : Colors.green[200]),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    widget.ad.isFavorite == 1
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: widget.ad.isFavorite == 1
                                        ? AppColorConstants.red
                                        : AppColorConstants.mainTextColor,
                                    size: 20,
                                  ),
                                ).ripple(() {
                                  setState(() {
                                    widget.ad.isFavorite =
                                        widget.ad.isFavorite == 1 ? 0 : 1;
                                  });
                                  widget.favPressed();
                                }),
                              ),
                            ],
                          ),
                          BodyMediumText(
                            widget.ad.title ?? 'No Title',
                            maxLines: 1,
                            weight: TextWeight.bold,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ).bP4,
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  size: 14,
                                  color: AppColorConstants.subHeadingTextColor),
                              const SizedBox(width: 4),
                              Expanded(
                                child: BodySmallText(
                                  widget.ad.locations?.customLocation == ''
                                      ? 'Location not specified'
                                      : widget.ad.locations?.customLocation,
                                  color: AppColorConstants.subHeadingTextColor,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HorizontalAdCard extends StatefulWidget {
  final AdModel ad;
  final VoidCallback pressed;
  final VoidCallback favPressed;

  const HorizontalAdCard(
      {super.key,
      required this.ad,
      required this.pressed,
      required this.favPressed});

  @override
  State<HorizontalAdCard> createState() => _HorizontalAdCardState();
}

class _HorizontalAdCardState extends State<HorizontalAdCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.pressed(),
      child: SizedBox(
        width: Get.width * 0.8,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
              width: 100,
              child: (widget.ad.images).isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: widget.ad.images.first,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          AppUtil.addProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ).round(10)
                  : const Icon(Icons.error)),
          Flexible(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BodyExtraSmallText(
                'Resort',
                maxLines: 2,
                weight: TextWeight.bold,
                color: AppColorConstants.red,
              ).bP4,
              BodySmallText(
                widget.ad.title!,
                maxLines: 2,
                weight: TextWeight.semiBold,
              ).bP4,
              BodyExtraSmallText(
                widget.ad.locations!.customLocation!,
                weight: TextWeight.semiBold,
                color: AppColorConstants.subHeadingTextColor,
              ).bP4,
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BodyExtraSmallText(
                    '${widget.ad.currency ?? '\$'} ${widget.ad.price}',
                    weight: TextWeight.bold,
                    color: AppColorConstants.red,
                  ),
                  Icon(Icons.favorite,
                          color: widget.ad.isFavorite == 1
                              ? AppColorConstants.red
                              : AppColorConstants.subHeadingTextColor)
                      .ripple(() {
                    if (widget.ad.isFavorite == 0) {
                      widget.ad.isFavorite = 1;
                    } else {
                      widget.ad.isFavorite = 0;
                    }
                    widget.favPressed();
                    setState(() {});
                  })
                ],
              ).bP4
            ],
          ).hP8.tP8),
        ]),
      ),
    );
  }
}

class MyAdCard extends StatefulWidget {
  final AdModel ad;
  final Function actionHandler;

  const MyAdCard({super.key, required this.ad, required this.actionHandler});

  @override
  State<MyAdCard> createState() => _MyAdCardState();
}

class _MyAdCardState extends State<MyAdCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.8,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
            height: 100,
            width: 200,
            child: (widget.ad.images).isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: widget.ad.images.first,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        AppUtil.addProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ).rightRounded(10)
                : const Icon(Icons.error)),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BodySmallText(
                widget.ad.categoryName!,
                maxLines: 2,
                weight: TextWeight.bold,
                color: AppColorConstants.themeColor,
              ).bP8,
              BodyLargeText(
                widget.ad.title!,
                maxLines: 2,
                weight: TextWeight.semiBold,
              ).bP4,
              // BodyExtraSmallText(
              //   widget.ad.locations!.customLocation!,
              //   weight: TextWeight.semiBold,
              //   color: AppColorConstants.subHeadingTextColor,
              // ).bP4,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BodySmallText(
                    '${widget.ad.currency ?? '\$'} ${widget.ad.price}',
                    weight: TextWeight.bold,
                    color: AppColorConstants.themeColor,
                  ),
                  widget.ad.canEdit() == true
                      ? ThemeIconWidget(ThemeIcon.moreVertical)
                          .ripple(widget.actionHandler)
                      : Container()
                ],
              )
            ],
          ).lP8.tP8,
        ),
      ]),
    );
  }
}
