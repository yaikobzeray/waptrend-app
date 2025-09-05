import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/screens/add_on/ui/dating/dating_card.dart';

class HomeScreenShimmer extends StatelessWidget {
  const HomeScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 20),
      itemCount: 20,
      itemBuilder: (ctx, index) {
        return const PostCardShimmer().hp(DesignConstants.horizontalPadding);
      },
      separatorBuilder: (ctx, index) {
        return const SizedBox(height: 20);
      },
    );
  }
}

class ClubsCategoriesScreenShimmer extends StatelessWidget {
  const ClubsCategoriesScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: EdgeInsets.only(left: DesignConstants.horizontalPadding),
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (BuildContext ctx, int index) {
          return SizedBox(
            width: 100,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColorConstants.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColorConstants.themeColor.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(238, 238, 238, 1.0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                )
              ],
            ),
          ).addShimmer();
        },
        separatorBuilder: (BuildContext ctx, int index) {
          return const SizedBox(width: 10);
        },
      ),
    );
  }
}

class ClubsScreenShimmer extends StatelessWidget {
  const ClubsScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(
        left: DesignConstants.horizontalPadding,
        right: DesignConstants.horizontalPadding,
      ),
      itemCount: 5,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext ctx, int index) {
        return Container(
          height: 320,
          decoration: BoxDecoration(
            color: AppColorConstants.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColorConstants.themeColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(238, 238, 238, 1.0),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 20,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(238, 238, 238, 1.0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 16,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(238, 238, 238, 1.0),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          height: 40,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(238, 238, 238, 1.0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).addShimmer();
      },
      separatorBuilder: (BuildContext ctx, int index) {
        return const SizedBox(height: 25);
      },
    );
  }
}

class EventCategoriesScreenShimmer extends StatelessWidget {
  const EventCategoriesScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(left: DesignConstants.horizontalPadding),
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (BuildContext ctx, int index) {
        return Row(
          children: [
            Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: AppColorConstants.cardColor,
                  shape: BoxShape.circle,
                )),
            const SizedBox(width: 10),
            Container(
              height: 16,
              width: 60,
              decoration: BoxDecoration(
                color: Color.fromRGBO(238, 238, 238, 1.0),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        )
            .setPadding(left: 12, right: 12, top: 8, bottom: 8)
            .borderWithRadius(value: 1, radius: 20)
            .addShimmer();
      },
      separatorBuilder: (BuildContext ctx, int index) {
        return const SizedBox(width: 10);
      },
    );
  }
}

class EventsScreenShimmer extends StatelessWidget {
  const EventsScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        // App Bar Placeholder
        SliverAppBar(
          pinned: true,
          floating: true,
          expandedHeight: 30,
          backgroundColor: AppColorConstants.backgroundColor,
          flexibleSpace: Container(
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
          leading: Container(
            width: 24,
            height: 24,
            color: Color.fromRGBO(238, 238, 238, 1.0),
          ).addShimmer().p8,
          title: Container(
            width: 100,
            height: 20,
            color: Color.fromRGBO(238, 238, 238, 1.0),
          ).addShimmer(),
        ),

        // Posting View Placeholder
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColorConstants.cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColorConstants.shadowColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(238, 238, 238, 1.0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ).addShimmer(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        color: Color.fromRGBO(238, 238, 238, 1.0),
                      ).addShimmer(),
                      const SizedBox(height: 8),
                      Container(
                        width: 150,
                        height: 12,
                        color: Color.fromRGBO(238, 238, 238, 1.0),
                      ).addShimmer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Posts List Placeholder
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColorConstants.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColorConstants.shadowColor.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Info
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromRGBO(238, 238, 238, 1.0),
                              ),
                            ).addShimmer(),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 120,
                                  height: 16,
                                  color: Color.fromRGBO(238, 238, 238, 1.0),
                                ).addShimmer(),
                                const SizedBox(height: 4),
                                Container(
                                  width: 80,
                                  height: 12,
                                  color: Color.fromRGBO(238, 238, 238, 1.0),
                                ).addShimmer(),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              width: 24,
                              height: 24,
                              color: Color.fromRGBO(238, 238, 238, 1.0),
                            ).addShimmer(),
                          ],
                        ),
                      ),

                      // Post Image
                      Container(
                        height: 300,
                        color: Color.fromRGBO(238, 238, 238, 1.0),
                      ).addShimmer(),

                      // Post Actions
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: List.generate(
                                3,
                                (i) => Container(
                                  width: 24,
                                  height: 24,
                                  margin: const EdgeInsets.only(right: 16),
                                  color: Color.fromRGBO(238, 238, 238, 1.0),
                                ).addShimmer(),
                              ),
                            ),
                            Container(
                              width: 24,
                              height: 24,
                              color: Color.fromRGBO(238, 238, 238, 1.0),
                            ).addShimmer(),
                          ],
                        ),
                      ),

                      // Post Caption
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 14,
                              color: Color.fromRGBO(238, 238, 238, 1.0),
                            ).addShimmer(),
                            const SizedBox(height: 4),
                            Container(
                              width: 200,
                              height: 14,
                              color: Color.fromRGBO(238, 238, 238, 1.0),
                            ).addShimmer(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              );
            },
            childCount: 5,
          ),
        ),
      ],
    );
  }
}

class PostCardShimmer extends StatelessWidget {
  const PostCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorConstants.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColorConstants.themeColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(238, 238, 238, 1.0),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 16,
                width: 100,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(238, 238, 238, 1.0),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 280,
            decoration: BoxDecoration(
              color: Color.fromRGBO(238, 238, 238, 1.0),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(238, 238, 238, 1.0),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 16,
                width: 40,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(238, 238, 238, 1.0),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(238, 238, 238, 1.0),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 16,
                width: 40,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(238, 238, 238, 1.0),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 16,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(238, 238, 238, 1.0),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 16,
                width: 200,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(238, 238, 238, 1.0),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 16,
                width: 150,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(238, 238, 238, 1.0),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 14,
                width: 80,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(238, 238, 238, 1.0),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    ).addShimmer();
  }
}

class StoryAndHighlightsShimmer extends StatelessWidget {
  const StoryAndHighlightsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: EdgeInsets.only(left: DesignConstants.horizontalPadding),
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (BuildContext ctx, int index) {
          return Column(
            children: [
              Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(238, 238, 238, 1.0),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColorConstants.themeColor.withOpacity(0.2),
                    width: 2,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 12,
                width: 40,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(238, 238, 238, 1.0),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ).addShimmer();
        },
        separatorBuilder: (BuildContext ctx, int index) {
          return const SizedBox(width: 16);
        },
      ),
    );
  }
}

class ShimmerUsers extends StatelessWidget {
  const ShimmerUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 20, bottom: 100),
      itemCount: 20,
      itemBuilder: (ctx, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColorConstants.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColorConstants.themeColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(238, 238, 238, 1.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(238, 238, 238, 1.0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 14,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(238, 238, 238, 1.0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                height: 35,
                width: 110,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(238, 238, 238, 1.0),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        ).addShimmer();
      },
      separatorBuilder: (ctx, index) {
        return const SizedBox(height: 16);
      },
    );
  }
}

class ShimmerHashtag extends StatelessWidget {
  const ShimmerHashtag({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (ctx, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColorConstants.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColorConstants.themeColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(238, 238, 238, 1.0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(238, 238, 238, 1.0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(238, 238, 238, 1.0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 14,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(238, 238, 238, 1.0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).addShimmer();
      },
    );
  }
}

class PostBoxShimmer extends StatelessWidget {
  const PostBoxShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 50, // Keeping the same item count
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          // height: 500, // Set a fixed height for list items
          margin: const EdgeInsets.only(
              bottom: 8), // Vertical spacing between items
          decoration: BoxDecoration(
            color: AppColorConstants.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),

          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor : AppColorConstants.cardColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: 120,
                            height: 14,
                            decoration: BoxDecoration(
                              color: AppColorConstants.cardColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 80,
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppColorConstants.cardColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColorConstants.cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    )
                  ],
                ),
              ).addShimmer(),
              const SizedBox(height: 16),
              Container(
                  width: double.infinity,
                  height: Get.width * 1,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(238, 238, 238, 1.0),
                    borderRadius: BorderRadius.circular(5),
                  )).addShimmer(),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    4,
                    (index) => Container(
                      width: 30,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(238, 238, 238, 1.0),
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                ),
              ).addShimmer()
            ],
          ),
        );
      },
    );
  }
}

class StoriesShimmerWidget extends StatelessWidget {
  const StoriesShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.6,
      ),
      itemCount: 20,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(238, 238, 238, 1.0),
            borderRadius: BorderRadius.circular(12),
          ),
        ).addShimmer();
      },
    );
  }
}

class EventBookingShimmerWidget extends StatelessWidget {
  const EventBookingShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 20,
      itemBuilder: (BuildContext ctx, int index) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColorConstants.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColorConstants.themeColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(238, 238, 238, 1.0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(238, 238, 238, 1.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(238, 238, 238, 1.0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 2,
                        width: 30,
                        color: AppColorConstants.themeColor,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 16,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(238, 238, 238, 1.0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(238, 238, 238, 1.0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 2,
                        width: 30,
                        color: AppColorConstants.themeColor,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 16,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(238, 238, 238, 1.0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 32,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(238, 238, 238, 1.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).addShimmer();
      },
      separatorBuilder: (BuildContext ctx, int index) {
        return const SizedBox(height: 16);
      },
    );
  }
}

class CardsStackShimmerWidget extends StatelessWidget {
  const CardsStackShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height - 670,
      width: Get.width - 40,
      decoration: BoxDecoration(
        // color: AppColorConstants.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          // BoxShadow(
          //   // color: AppColorConstants.mainTextColor.withOpacity(0.2),
          //   blurRadius: 16,
          //   offset: const Offset(0, 8),
          // ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(238, 238, 238, 1.0),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: AppColorConstants.cardColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(238, 238, 238, 1.0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 16,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(238, 238, 238, 1.0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(238, 238, 238, 1.0),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 24),
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(238, 238, 238, 1.0),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).addShimmer();
  }
}

class ShimmerMatchedList extends StatelessWidget {
  const ShimmerMatchedList({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 210,
      ),
      itemCount: 10,
      itemBuilder: (ctx, index) {
        return Container(
          decoration: BoxDecoration(
            color: AppColorConstants.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColorConstants.themeColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(238, 238, 238, 1.0),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(238, 238, 238, 1.0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 14,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(238, 238, 238, 1.0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).addShimmer();
      },
    );
  }
}

class ShimmerLikeList extends StatelessWidget {
  const ShimmerLikeList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 80,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColorConstants.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColorConstants.themeColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 60,
                width: 60,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(238, 238, 238, 1.0),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Expanded(
                child: Container(
                  height: 16,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(238, 238, 238, 1.0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ).addShimmer();
      },
    );
  }
}

final _shimmerGradient = LinearGradient(
  colors: [
    Color.fromRGBO(238, 238, 238, 1.0),
    Color.fromRGBO(238, 238, 238, 1.0),
    Color.fromRGBO(238, 238, 238, 1.0),
  ],
  stops: const [
    0.1,
    0.3,
    0.4,
  ],
  begin: const Alignment(-1.0, -0.3),
  end: const Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);

class ReelsShimmer extends StatelessWidget {
  const ReelsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: Stack(
        children: [
          PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 3, // Show 3 placeholder reels
            itemBuilder: (context, index) {
              return Container(
                height: Get.height,
                width: Get.width,
                color: Color.fromRGBO(238, 238, 238, 1.0),
                child: Column(
                  children: [
                    // Video placeholder
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 50),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(238, 238, 238, 1.0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ).addShimmer(),
                    ),

                    // Bottom controls placeholder
                    Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // User info placeholder
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(238, 238, 238, 1.0),
                            ),
                          ).addShimmer(),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 120,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(238, 238, 238, 1.0),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ).addShimmer(),
                              const SizedBox(height: 6),
                              Container(
                                width: 80,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(238, 238, 238, 1.0),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ).addShimmer(),
                            ],
                          ),
                          const Spacer(),
                          // Action buttons placeholder
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: List.generate(
                              4,
                              (i) => Container(
                                width: 30,
                                height: 30,
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(238, 238, 238, 1.0),
                                  shape: BoxShape.circle,
                                ),
                              ).addShimmer(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Top navigation bar (same as original)
          Positioned(
            right: DesignConstants.horizontalPadding,
            left: DesignConstants.horizontalPadding,
            top: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  color: AppColorConstants.themeColor.withOpacity(0.5),
                  child: ThemeIconWidget(
                    ThemeIcon.backArrow,
                    color: Color.fromRGBO(238, 238, 238, 1.0),
                  ).lP8,
                ).circular,
                Container(
                  height: 40,
                  width: 40,
                  color: AppColorConstants.themeColor.withOpacity(0.5),
                  child: ThemeIconWidget(
                    ThemeIcon.camera,
                    color: Color.fromRGBO(238, 238, 238, 1.0),
                  ),
                ).circular,
              ],
            ),
          ).addShimmer()
        ],
      ),
    );
  }
}

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: DefaultTabController(
        length: 3,
        child: CustomScrollView(
          slivers: [
            // App Bar Section
            SliverAppBar(
              backgroundColor: AppColorConstants.backgroundColor,
              expandedHeight: 380,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  children: [
                    // Top App Bar
                    Container(
                      height: 100,
                      padding: EdgeInsets.only(
                        left: DesignConstants.horizontalPadding,
                        right: DesignConstants.horizontalPadding,
                        top: 50,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 120,
                            height: 20,
                            color: Color.fromRGBO(238, 238, 238, 1.0),
                          ).addShimmer(),
                          Row(
                            children: [
                              Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(238, 238, 238, 1.0),
                                  shape: BoxShape.circle,
                                ),
                              ).addShimmer(),
                              const SizedBox(width: 20),
                              Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(238, 238, 238, 1.0),
                                  shape: BoxShape.circle,
                                ),
                              ).addShimmer(),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Profile Info
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              // Avatar
                              Container(
                                width: 90,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(238, 238, 238, 1.0),
                                  shape: BoxShape.circle,
                                ),
                              ).addShimmer(),
                              const SizedBox(width: 30),
                              // Stats
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: List.generate(
                                      3, (index) => _buildStatShimmer()),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Bio
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 150,
                                height: 20,
                                color: Color.fromRGBO(238, 238, 238, 1.0),
                              ).addShimmer(),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                height: 16,
                                color: Color.fromRGBO(238, 238, 238, 1.0),
                              ).addShimmer(),
                              const SizedBox(height: 4),
                              Container(
                                width: 200,
                                height: 16,
                                color: Color.fromRGBO(238, 238, 238, 1.0),
                              ).addShimmer(),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Edit Profile Button
                          Container(
                            width: double.infinity,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(238, 238, 238, 1.0),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ).addShimmer(),
                        ],
                      ),
                    ),

                    // Highlights
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(238, 238, 238, 1.0),
                                    shape: BoxShape.circle,
                                  ),
                                ).addShimmer(),
                                const SizedBox(height: 4),
                                Container(
                                  width: 40,
                                  height: 12,
                                  color: Color.fromRGBO(238, 238, 238, 1.0),
                                ).addShimmer(),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tab Bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  tabs: ['Posts', 'Reels', 'Tagged']
                      .map((name) => Tab(text: name))
                      .toList(),
                  indicatorColor: AppColorConstants.themeColor,
                  labelColor: AppColorConstants.themeColor,
                  unselectedLabelColor:
                      AppColorConstants.themeColor.withOpacity(0.5),
                ),
              ),
            ),

            // Content Grid
            SliverPadding(
              padding: EdgeInsets.zero,
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Container(
                    color: Color.fromRGBO(238, 238, 238, 1.0),
                  ).addShimmer(),
                  childCount: 9,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatShimmer() {
    return Column(
      children: [
        Container(
          width: 40,
          height: 20,
          color: Color.fromRGBO(238, 238, 238, 1.0),
        ).addShimmer(),
        const SizedBox(height: 4),
        Container(
          width: 60,
          height: 12,
          color: Color.fromRGBO(238, 238, 238, 1.0),
        ).addShimmer(),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColorConstants.backgroundColor,
      child: _tabBar,
    );
  }

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class MarketplaceShimmer extends StatelessWidget {
  const MarketplaceShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: Column(
        children: [
          backNavigationBar(title: shopString.tr),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Search bar placeholder
                  ShimmerComponent(
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.all(DesignConstants.horizontalPadding),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(238, 238, 238, 1.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  // Category view shimmer
                  const CategoryShimmer(),
                  // Ads grid shimmer
                  const ProductShimmer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(DesignConstants.horizontalPadding),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Number of items per row
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        childAspectRatio: 0.8, // Adjust this to control item height
      ),
      itemCount: 8, // Total number of shimmer items
      itemBuilder: (context, index) {
        return ShimmerComponent(
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(238, 238, 238, 1.0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(238, 238, 238, 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        );
      },
    ).hp(DesignConstants.horizontalPadding);
  }
}

class ProductShimmer extends StatelessWidget {
  const ProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      padding: EdgeInsets.all(DesignConstants.horizontalPadding),
      itemCount: 6,
      itemBuilder: (context, index) {
        return ShimmerComponent(
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(238, 238, 238, 1.0),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 14,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 100,
                        height: 16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 120,
                        height: 12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ShimmerComponent extends StatelessWidget {
  final Widget child;

  const ShimmerComponent({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child.addShimmer();
  }
}
