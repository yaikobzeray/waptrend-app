import 'package:foap/helper/imports/event_imports.dart';
import '../../components/event/events_list.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchEventListing extends StatefulWidget {
  const SearchEventListing({super.key});

  @override
  SearchEventListingState createState() => SearchEventListingState();
}

class SearchEventListingState extends State<SearchEventListing> {
  final EventsController _eventsController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _eventsController.clear();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            expandedHeight: 120,
            backgroundColor: AppColorConstants.backgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColorConstants.themeColor.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColorConstants.mainTextColor,
              ),
              onPressed: () => Get.back(),
            ),
            title: Text(
              searchString.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColorConstants.mainTextColor,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                color: AppColorConstants.backgroundColor,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: SFSearchBar(
                  hintText: searchString.tr,
                  showSearchIcon: true,
                  iconColor: AppColorConstants.themeColor,
                  onSearchChanged: (value) {
                    _eventsController.searchEvents(value);
                  },
                  onSearchStarted: () {},
                  onSearchCompleted: (searchTerm) {},
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 16),
            sliver: Obx(() {
              final events = _eventsController.events;
              return events.isEmpty
                  ? SliverFillRemaining(
                      child: emptyData(
                        title: noEventFoundString.tr,
                        subTitle: '',
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final event = events[index];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: _buildEventCard(context, event),
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: events.length,
                      ),
                    );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, EventModel event) {
    return Card(
      elevation: 2,
      color: AppColorConstants.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColorConstants.borderColor,
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Get.to(() => EventDetail(
                event: event,
                needRefreshCallback: () {},
              ));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Stack(
                children: [
                  // Event image
                  event.image.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: event.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          placeholder: (context, url) => Container(
                            color: AppColorConstants.cardColor,
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColorConstants.cardColor,
                            child: Center(
                              child: Icon(
                                Icons.error_outline,
                                color: AppColorConstants.themeColor,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          color: AppColorConstants.cardColor,
                          child: Center(
                            child: Icon(
                              Icons.event_rounded,
                              size: 48,
                              color: AppColorConstants.themeColor,
                            ),
                          ),
                        ),

                  // Gradient overlay
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.4),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Free badge
                  if (event.isFree)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColorConstants.themeColor.darken(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          freeString.tr.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                  // Event title on image
                  Positioned(
                    left: 12,
                    bottom: 12,
                    right: 12,
                    child: Text(
                      event.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Content section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event date
                  Text(
                    event.startAtDateTime,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColorConstants.mainTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Event title
                  Text(
                    event.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColorConstants.themeColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Location row
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: AppColorConstants.subHeadingTextColor,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.placeName,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColorConstants.subHeadingTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
