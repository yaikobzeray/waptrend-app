import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/segmentAndMenu/horizontal_menu.dart';
import 'package:foap/helper/imports/event_imports.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class EventBookingScreen extends StatefulWidget {
  const EventBookingScreen({super.key});

  @override
  State<EventBookingScreen> createState() => _EventBookingScreenState();
}

class _EventBookingScreenState extends State<EventBookingScreen> {
  final EventBookingsController _eventBookingsController =
      EventBookingsController();

  @override
  void initState() {
    _eventBookingsController.changeSegment(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: Column(
        children: [
          // Updated App Bar Section
          Container(
            decoration: BoxDecoration(
              color: AppColorConstants.backgroundColor,
              border: Border(
                bottom: BorderSide(
                  color: AppColorConstants.dividerColor.withOpacity(0.5),
                  width: 1,
                ),
              ),
            ),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              bottom: 15,
              left: DesignConstants.horizontalPadding,
              right: DesignConstants.horizontalPadding,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        // color: AppColorConstants.themeColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 18,
                        // color: AppColorConstants.themeColor,
                      ).p8.ripple(() {
                        Get.back();
                      }),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        bookingsString.tr,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColorConstants.mainTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                HorizontalSegmentBar(
                  width: Get.width,
                  hideHighlightIndicator: false,
                  onSegmentChange: (segment) {
                    _eventBookingsController.changeSegment(segment);
                  },
                  segments: [
                    upcomingString.tr,
                    completedString.tr,
                    cancelledString.tr,
                  ],
                ),
              ],
            ),
          ),

          // Bookings list (rest of the code remains exactly the same)
          Expanded(
            child: GetBuilder<EventBookingsController>(
              init: _eventBookingsController,
              builder: (ctx) {
                List<EventBookingModel> bookings = [];

                switch (_eventBookingsController.selectedSegment.value) {
                  case 0:
                    bookings = _eventBookingsController.upcomingBookings;
                    break;
                  case 1:
                    bookings = _eventBookingsController.completedBookings;
                    break;
                  case 2:
                    bookings = _eventBookingsController.cancelledBookings;
                    break;
                }

                return _eventBookingsController.isLoading.value
                    ? const EventBookingShimmerWidget()
                    : bookings.isEmpty
                        ? emptyData(
                            title: noBookingFoundString.tr,
                            subTitle: goToEventAndBookString.tr,
                          )
                        : AnimationLimiter(
                            child: ListView.separated(
                              padding: EdgeInsets.only(
                                top: 8,
                                left: DesignConstants.horizontalPadding,
                                right: DesignConstants.horizontalPadding,
                                bottom: 20,
                              ),
                              itemCount: bookings.length,
                              itemBuilder: (BuildContext ctx, int index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: EventBookingCard(
                                              bookingModel: bookings[index])
                                          .ripple(
                                        () {
                                          Get.to(() => EventBookingDetail(
                                                  booking: bookings[index]))!
                                              .then((value) {
                                            _eventBookingsController.reload();
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext ctx, int index) {
                                return const SizedBox(height: 12);
                              },
                            ),
                          );
              },
            ),
          ),
        ],
      ),
    );
  }
}
