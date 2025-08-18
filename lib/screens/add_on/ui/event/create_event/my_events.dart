import 'package:flutter/material.dart';
import 'package:foap/components/app_scaffold.dart';
import 'package:foap/components/empty_states.dart';
import 'package:foap/components/shimmer_widgets.dart';
import 'package:foap/helper/imports/event_imports.dart';
import 'package:foap/helper/localization_strings.dart';
import 'package:foap/screens/add_on/controller/event/create_event/add_event_controller.dart';
import 'package:foap/screens/add_on/controller/event/create_event/my_events_controller.dart';
import 'package:foap/screens/add_on/model/create_event_model.dart';
import 'package:foap/screens/add_on/ui/event/create_event/choose_category.dart';
import 'package:foap/screens/add_on/ui/event/create_event/create_event.dart';
import 'package:foap/util/app_config_constants.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'event_detail.dart';

class MyEventListing extends StatefulWidget {
  const MyEventListing({super.key});

  @override
  MyEventListingState createState() => MyEventListingState();
}

class MyEventListingState extends State<MyEventListing> {
  final MyEventsController _eventsController = Get.find();
  final RefreshController _refreshController = RefreshController();
  final AddEventController _addEventController = Get.find();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    _eventsController.refreshEvents(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _eventsController.clear();
      _eventsController.clearSegment();
    });
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await _eventsController.refreshEvents(() {});
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoadMore() async {
    await _eventsController.loadMoreEvents(() {});
    _refreshController.loadComplete();
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
      body: CustomScrollView(
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
              "My Events",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColorConstants.mainTextColor,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildSegmentView(),
          ),
          Obx(() {
            final events = _eventsController.events;
            return _eventsController.isLoading.isTrue
                ? SliverFillRemaining(child: EventBookingShimmerWidget())
                : _eventsController.events.isEmpty
                    ? SliverFillRemaining(
                        child: emptyData(
                          title: noEventFoundString.tr,
                          subTitle: '',
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16),
                                      child: _buildEventCard(events[index]),
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: events.length,
                          ),
                        ),
                      );
          }),
        ],
      ),
    );
  }

  Widget _buildSegmentView() {
    return Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _buildSegmentButton(
                text: activeString.tr,
                isSelected: _eventsController.selectSegment.value == 0,
                onTap: () => _eventsController.handleSegmentChange(0),
              ),
              const SizedBox(width: 8),
              _buildSegmentButton(
                text: upcomingString.tr,
                isSelected: _eventsController.selectSegment.value == 1,
                onTap: () => _eventsController.handleSegmentChange(1),
              ),
              const SizedBox(width: 8),
              _buildSegmentButton(
                text: completedString.tr,
                isSelected: _eventsController.selectSegment.value == 2,
                onTap: () => _eventsController.handleSegmentChange(2),
              ),
            ],
          ),
        ));
  }

  Widget _buildSegmentButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColorConstants.themeColor
                : AppColorConstants.cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppColorConstants.themeColor
                  : AppColorConstants.borderColor,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color:
                    isSelected ? Colors.white : AppColorConstants.mainTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(CreateEventModel event) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          SizedBox(
            height: 180,
            width: double.infinity,
            child: Stack(
              children: [
                // Event image
                event.image != ""
                    ? CachedNetworkImage(
                        imageUrl: event.image!,
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

                // Status badge
                // Positioned(
                //   top: 12,
                //   right: 12,
                //   child: Container(
                //     padding:
                //         const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                //     decoration: BoxDecoration(
                //       color: _getStatusColor(event.status!),
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //     child: Text(
                //       _getStatusText(event.status!),
                //       style: const TextStyle(
                //         fontSize: 10,
                //         color: Colors.white,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),

          // Content section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event title
                Text(
                  event.name!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColorConstants.mainTextColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Date and location row
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppColorConstants.subHeadingTextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      event.startAtDateTimeString!,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColorConstants.subHeadingTextColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: AppColorConstants.subHeadingTextColor,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.placeName!,
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
                const SizedBox(height: 16),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.edit,
                        text: editString.tr,
                        onPressed: () {
                          _addEventController.setEditableEvent(event);
                          Get.to(() => EnterEventDetail());
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.visibility,
                        text: previewString.tr,
                        onPressed: () {
                          Get.to(() => ProviderEventDetail(
                                event: event,
                                needRefreshCallback: () {
                                  _eventsController.refreshEvents(() {});
                                },
                              ));
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(
          color: AppColorConstants.themeColor,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColorConstants.themeColor,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: AppColorConstants.themeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 1: // Active
        return Colors.green;
      case 2: // Upcoming
        return Colors.orange;
      case 3: // Completed
        return Colors.grey;
      default:
        return AppColorConstants.themeColor;
    }
  }

  String _getStatusText(int status) {
    switch (status) {
      case 1:
        return activeString.tr.toUpperCase();
      case 9:
        return upcomingString.tr.toUpperCase();
      case 3:
        return completedString.tr.toUpperCase();
      default:
        return '';
    }
  }
}
