import 'package:flutter/material.dart';
import 'package:foap/components/app_scaffold.dart';
import 'package:foap/components/custom_texts.dart';
import 'package:foap/components/empty_states.dart';
import 'package:foap/helper/extension.dart';
import 'package:foap/helper/localization_strings.dart';
import 'package:foap/screens/add_on/controller/event/event_controller.dart';
import 'package:foap/screens/add_on/ui/event/event_detail.dart';
import 'package:foap/util/app_config_constants.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' show RefreshController;

import '../../../../components/shimmer_widgets.dart' show EventsScreenShimmer;
import '../../../../helper/imports/event_imports.dart';
import '../../model/event_category_model.dart';
import 'create_event/choose_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' show RefreshController;
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../helper/imports/event_imports.dart';
import '../../model/event_category_model.dart';
import 'create_event/choose_category.dart';
import 'package:foap/components/app_scaffold.dart';
import 'package:foap/components/empty_states.dart';
import 'package:foap/helper/localization_strings.dart';
import 'package:foap/screens/add_on/controller/event/event_controller.dart';
import 'package:foap/screens/add_on/ui/event/event_detail.dart';

class ExploreEvents extends StatefulWidget {
  const ExploreEvents({super.key});

  @override
  ExploreEventsState createState() => ExploreEventsState();
}

class ExploreEventsState extends State<ExploreEvents> {
  final EventsController _eventsController = Get.find();
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _eventsController.getCategories();
    });
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await _eventsController.getCategories();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const ChooseEventCategory()),
        backgroundColor: AppColorConstants.themeColor,
        elevation: 4,
        shape: const CircleBorder(),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColorConstants.themeColor,
            boxShadow: [
              BoxShadow(
                color: AppColorConstants.themeColor.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.add,
            color: AppColorConstants.iconColor,
            size: 28,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColorConstants.themeColor,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: true,
              expandedHeight: 30,
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
                eventsString.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColorConstants.mainTextColor,
                ),
              ),
            ),
            Obx(() {
              final categories = _eventsController.categories;
              return _eventsController.isLoadingCategories.value
                  ? SliverFillRemaining(child: EventsScreenShimmer())
                  : categories.isEmpty
                      ? SliverFillRemaining(
                          child: emptyData(
                            title: noEventFoundString.tr,
                            subTitle: '',
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, categoryGroupIndex) {
                              final category = categories[categoryGroupIndex];
                              return AnimationConfiguration.staggeredList(
                                position: categoryGroupIndex,
                                duration: const Duration(milliseconds: 375),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: _buildCategorySection(
                                        context, category, categoryGroupIndex),
                                  ),
                                ),
                              );
                            },
                            childCount: categories.length,
                          ),
                        );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(
      BuildContext context, EventCategoryModel category, int index) {
    final events = category.events;
    final cardWidth = MediaQuery.of(context).size.width * 0.45;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColorConstants.themeColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.category_rounded,
                  color: AppColorConstants.themeColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColorConstants.mainTextColor,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  _eventsController.setCategoryId(category.id);
                  _eventsController.getEvents();
                  Get.to(() => CategoryEventsListing(category: category));
                },
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColorConstants.themeColor.withOpacity(0.1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        seeAllString.tr,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColorConstants.themeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: AppColorConstants.themeColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: cardWidth * 0.8 + 120, // Adjusted for card content height
          child: events.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      noEventFoundString.tr,
                      style: TextStyle(
                        color: AppColorConstants.subHeadingTextColor,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: events.length,
                  itemBuilder: (ctx, index) {
                    final event = events[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: _buildEventCard(context, event),
                            // child: EventCard(
                            //   event: event,
                            //   joinBtnClicked: () {},
                            //   leaveBtnClicked: () {},
                            //   previewBtnClicked: () {
                            //     Get.to(() => EventDetail(
                            //           event: event,
                            //           needRefreshCallback: () {},
                            //         ));
                            //   },
                            // ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Divider(
            height: 1,
            thickness: 1,
            color: AppColorConstants.dividerColor,
          ),
        ),
      ],
    );
  }
}

// class EEventCard extends StatelessWidget {
//   final EventModel event;
//   final VoidCallback joinBtnClicked;
//   final VoidCallback previewBtnClicked;
//   final VoidCallback leaveBtnClicked;

//   const EEventCard({
//     super.key,
//     required this.event,
//     required this.joinBtnClicked,
//     required this.leaveBtnClicked,
//     required this.previewBtnClicked,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final cardWidth = MediaQuery.of(context).size.width * 0.45;

//     return SizedBox(
//       width: cardWidth,
//       child: Card(
//         elevation: 2,
//         color: AppColorConstants.cardColor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//           side: BorderSide(
//             color: AppColorConstants.borderColor,
//             width: 1,
//           ),
//         ),
//         clipBehavior: Clip.antiAlias,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(16),
//           onTap: previewBtnClicked,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Image with overlay and text
//               _buildImageSection(context, cardWidth),

//               // Content section
//               Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Event date
//                     Text(
//                       event.startAtDateTime,
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: AppColorConstants.mainTextColor,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 4),

//                     // Event title
//                     Text(
//                       event.name,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: AppColorConstants.themeColor,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 8),

//                     // Location row
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.location_on_outlined,
//                           size: 16,
//                           color: AppColorConstants.subHeadingTextColor,
//                         ),
//                         const SizedBox(width: 4),
//                         Expanded(
//                           child: Text(
//                             event.placeName,
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: AppColorConstants.subHeadingTextColor,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildImageSection(BuildContext context, double width) {
//     return SizedBox(
//       height: width * 0.8,
//       width: double.infinity,
//       child: Stack(
//         children: [
//           // Event image
//           event.image.isNotEmpty
//               ? CachedNetworkImage(
//                   imageUrl: event.image,
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                   height: double.infinity,
//                   placeholder: (context, url) => Container(
//                     color: AppColorConstants.cardColor,
//                   ),
//                   errorWidget: (context, url, error) => Container(
//                     color: AppColorConstants.cardColor,
//                     child: Center(
//                       child: Icon(
//                         Icons.error_outline,
//                         color: AppColorConstants.themeColor,
//                       ),
//                     ),
//                   ),
//                 )
//               : Container(
//                   color: AppColorConstants.cardColor,
//                   child: Center(
//                     child: Icon(
//                       Icons.event_rounded,
//                       size: 48,
//                       color: AppColorConstants.themeColor,
//                     ),
//                   ),
//                 ),

//           // Gradient overlay
//           Positioned.fill(
//             child: DecoratedBox(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.bottomCenter,
//                   end: Alignment.topCenter,
//                   colors: [
//                     Colors.black.withOpacity(0.4),
//                     Colors.transparent,
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // Free badge
//           if (event.isFree)
//             Positioned(
//               top: 12,
//               right: 12,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: AppColorConstants.themeColor.darken(),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   freeString.tr.toUpperCase(),
//                   style: const TextStyle(
//                     fontSize: 10,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),

//           // Event title on image
//           Positioned(
//             left: 12,
//             bottom: 12,
//             right: 12,
//             child: Text(
//               event.name,
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//               ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

Widget _buildEventCard(BuildContext context, EventModel event) {
  final cardWidth = MediaQuery.of(context).size.width * 0.45;

  return SizedBox(
    width: cardWidth,
    child: Card(
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
              height: cardWidth * 0.8,
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
    ),
  );
}
