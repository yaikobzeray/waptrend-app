import 'package:foap/components/thumbnail_view.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/story_imports.dart';
import 'package:foap/helper/string_extension.dart';

double storyCircleSize = 50;

class StoryUpdatesBar extends StatelessWidget {
  final List<StoryModel> stories;

  final VoidCallback addStoryCallback;
  final Function(StoryModel) viewStoryCallback;

  const StoryUpdatesBar({
    super.key,
    required this.stories,
    required this.addStoryCallback,
    required this.viewStoryCallback,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(right: DesignConstants.horizontalPadding),
      scrollDirection: Axis.horizontal,
      itemCount: stories.length + 1,
      itemBuilder: (BuildContext ctx, int index) {
        if (index == 0) {
          return SizedBox(
            width: storyCircleSize + 24,
            child: Column(
              children: [
                SizedBox(
                  height: storyCircleSize + 10,
                  width: storyCircleSize + 10,
                  child: ThemeIconWidget(
                    ThemeIcon.plusSymbol,
                    size: 28,
                    color: AppColorConstants.disabledColor.darken(),
                  ),
                )
                    .borderWithRadius(value: 2, color: Colors.green, radius: 50)
                    .ripple(() {
                  addStoryCallback();
                }),
                const SizedBox(
                  height: 4,
                ),
                BodySmallText(yourStoryString.tr, weight: TextWeight.medium)
              ],
            ),
          );
        } else {
          return Stack(
            children: [
              SizedBox(
                  width: storyCircleSize + 20,
                  child: Column(
                    children: [
                      Container(
                        child: stories[index - 1].userImage != null
                            ? CachedNetworkImage(
                                imageUrl: stories[index - 1].userImage!,
                                fit: BoxFit.cover,
                                height: storyCircleSize + 10,
                                width: storyCircleSize + 10,
                                placeholder: (context, url) => SizedBox(
                                    height: 20,
                                    width: 20,
                                    child:
                                        const CircularProgressIndicator().p16),
                                errorWidget: (context, url, error) =>
                                    const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Icon(Icons.error)),
                              )
                            : SizedBox(
                                height: storyCircleSize + 10,
                                width: storyCircleSize + 10,
                                child: Center(
                                  child: BodyMediumText(
                                      stories[index - 1].userName.getInitials),
                                ),
                              ),
                      )
                          .borderWithRadius(
                        value: 2,
                        radius: 40,
                        gradient: stories[index - 1].isViewed
                            ? null // no gradient for viewed (disabled)
                            : stories[index - 1].isLive
                                ? LinearGradient(
                                    colors: [
                                      Colors.red,
                                      const Color.fromARGB(255, 227, 67, 67),
                                      const Color.fromARGB(255, 228, 141, 141)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ) // red gradient for live
                                : LinearGradient(
                                    colors: [
                                      Colors.green,
                                      Colors.lightGreenAccent
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ), // green gradient for normal story
                        color: stories[index - 1].isViewed
                            ? AppColorConstants.disabledColor
                            : null,
                      )
                          .ripple(() {
                        viewStoryCallback(stories[index - 1]);
                      }),
                      // MediaThumbnailView(
                      //   borderColor:
                      //   stories[index  - 1].isViewed == true
                      //       ? AppColorConstants.disabledColor
                      //       : AppColorConstants.themeColor,
                      //   media: stories[index  - 1].media.last,
                      // ).ripple(() {
                      //   viewStoryCallback(stories[index  - 1]);
                      // }),
                      const SizedBox(
                        height: 4,
                      ),
                      Expanded(
                        child: BodySmallText(stories[index - 1].userName,
                                maxLines: 1, weight: TextWeight.medium)
                            .hP4,
                      ),
                    ],
                  )),
              // Positioned(
              //     bottom: 40,
              //     right: 0,
              //     child: Container(
              //       width: 32,
              //       height: 14,
              //       decoration: BoxDecoration(
              //           color: Colors.red,
              //           borderRadius: BorderRadius.circular(8)),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Container(
              //             width: 20,
              //             height: 20,
              //             decoration: BoxDecoration(
              //               shape: BoxShape.circle,
              //               color: AppColorConstants.backgroundColor,
              //             ),
              //           ),
              //           width(value: 2.0),
              //           BodySmallText(
              //             "Live",
              //             color: AppColorConstants.backgroundColor,
              //           )
              //         ],
              //       ),
              //     )),
            ],
          );
        }
      },
    );
  }
}
