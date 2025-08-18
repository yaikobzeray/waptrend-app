import 'package:flutter/material.dart';
import 'package:foap/components/app_scaffold.dart';
import 'package:foap/components/custom_texts.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/screens/add_on/ui/event/event_detail.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../components/post_card/post_card.dart';
import '../../../../controllers/post/add_post_controller.dart';
import '../../../../model/post_model.dart';
import '../../controller/event/event_controller.dart';

class EventFeedScreen extends StatefulWidget {
  const EventFeedScreen({super.key});

  @override
  EventFeedScreenState createState() => EventFeedScreenState();
}

class EventFeedScreenState extends State<EventFeedScreen> {
  final EventsController _eventsController = Get.find();
  final AddPostController _addPostController = Get.find();
  final RefreshController _refreshController = RefreshController();
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  loadData() {
    _eventsController.loadMorePosts(callback: () {
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
    });
  }

  refreshData() {
    _eventsController.refreshPosts(callback: () {
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
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
              postsString.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColorConstants.mainTextColor,
              ),
            ),
          ),
          SliverToBoxAdapter(child: postingView()),
          Obx(() {
            final posts = _eventsController.posts;
            return _eventsController.isLoadingEvents.value
                ? SliverFillRemaining(child: PostBoxShimmer())
                : posts.isEmpty
                    ? SliverFillRemaining(
                        child: Center(
                            child: emptyData(
                          title: noPostFoundString.tr,
                          subTitle: '',
                        )),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final post = posts[index];
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: PostCard(
                                      model: post,
                                      removePostHandler: () {
                                        _eventsController
                                            .removePostFromList(post);
                                      },
                                      blockUserHandler: () {
                                        _eventsController
                                            .removeUsersAllPostFromList(post);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: posts.length,
                        ),
                      );
          }),
        ],
      ),
    );
  }

  Widget postingView() {
    return Obx(() => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _addPostController.isPosting.value
              ? Container(
                  key: const ValueKey('posting-view'),
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
                      if (_addPostController.postingMedia.isNotEmpty &&
                          _addPostController.postingMedia.first.mediaType !=
                              GalleryMediaType.gif)
                        _addPostController.postingMedia.first.thumbnail != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  _addPostController
                                      .postingMedia.first.thumbnail!,
                                  fit: BoxFit.cover,
                                  width: 40,
                                  height: 40,
                                ),
                              )
                            : _addPostController.postingMedia.first.mediaType ==
                                    GalleryMediaType.photo
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      _addPostController
                                          .postingMedia.first.file!,
                                      fit: BoxFit.cover,
                                      width: 40,
                                      height: 40,
                                    ),
                                  )
                                : Container(),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: BodyMediumText(
                                    _addPostController.isErrorInPosting.value
                                        ? postFailedString.tr
                                        : postingString.tr,
                                    color: AppColorConstants.mainTextColor,
                                  ),
                                ),
                                if (!_addPostController.isErrorInPosting.value)
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColorConstants.themeColor),
                                    ),
                                  ),
                              ],
                            ),
                            if (_addPostController.isErrorInPosting.value)
                              const SizedBox(height: 8),
                            if (_addPostController.isErrorInPosting.value)
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColorConstants.themeColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: BodyMediumText(
                                      discardString.tr,
                                      color: AppColorConstants.themeColor,
                                    ).ripple(() {
                                      _addPostController.discardFailedPost();
                                    }),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColorConstants.themeColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: BodyMediumText(
                                      retryString.tr,
                                      color: Colors.white,
                                    ).ripple(() {
                                      _addPostController.retryPublish();
                                    }),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(key: const ValueKey('empty-container')),
        ));
  }
}
