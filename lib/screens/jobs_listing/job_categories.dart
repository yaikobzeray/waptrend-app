import 'package:foap/controllers/job/job_controller.dart';
import '../../components/group_avatars/group_avatar1.dart';
import '../../helper/imports/common_import.dart';
import '../../model/category_model.dart';
import 'job_by_category.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class JobCategories extends StatefulWidget {
  const JobCategories({super.key});

  @override
  State<JobCategories> createState() => _JobCategoriesState();
}

class _JobCategoriesState extends State<JobCategories> {
  final JobController jobController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      jobController.getCategories();
    });
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
              categoriesString.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColorConstants.mainTextColor,
              ),
            ),
          ),
          GetBuilder<JobController>(
            init: jobController,
            builder: (ctx) {
              return jobController.isLoadingCategories.value
                  ? SliverFillRemaining(child: CategoryShimmerGrid())
                  : jobController.categories.isEmpty
                      ? SliverFillRemaining(
                          child: Center(
                            child: emptyData(
                              title: "No Categories Found".tr,
                              subTitle: '',
                            ),
                          ),
                        )
                      : SliverPadding(
                          padding: EdgeInsets.only(
                            top: 20,
                            left: DesignConstants.horizontalPadding,
                            right: DesignConstants.horizontalPadding,
                            bottom: 50,
                          ),
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 16.0,
                              childAspectRatio: 1,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final category =
                                    jobController.categories[index];
                                return AnimationConfiguration.staggeredGrid(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  columnCount: 2,
                                  child: ScaleAnimation(
                                    child: FadeInAnimation(
                                      child: _CategoryCard(
                                        category: category,
                                        onTap: () {
                                          jobController
                                              .setCategoryId(category.id);
                                          Get.to(() => JobsByCategory(
                                                  category: category))!
                                              .then((value) {
                                            jobController.setCategoryId(null);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                              childCount: jobController.categories.length,
                            ),
                          ),
                        );
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColorConstants.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColorConstants.shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: AppColorConstants.themeColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColorConstants.themeColor.withOpacity(0.05),
                    AppColorConstants.themeColor.withOpacity(0.02),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Category Icon/Image
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColorConstants.themeColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.work_outline,
                      size: 30,
                      color: AppColorConstants.themeColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Category Name
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColorConstants.mainTextColor,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Explore Text with Arrow
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        exploreString.tr,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColorConstants.themeColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: AppColorConstants.themeColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryShimmerGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(
        top: 20,
        left: DesignConstants.horizontalPadding,
        right: DesignConstants.horizontalPadding,
        bottom: 50,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: AppColorConstants.cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColorConstants.subHeadingTextColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 80,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColorConstants.subHeadingTextColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 60,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColorConstants.subHeadingTextColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Add these string constants if they don't exist
extension JobCategoriesStrings on String {
  String get noCategoriesFoundString => 'No categories found';
  String get exploreString => 'Explore';
}
