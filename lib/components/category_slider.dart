import '../helper/imports/common_import.dart';
import '../model/category_model.dart';
import '../util/constant_util.dart';

// If your CategoryModel has an icon field, use this version:

class CategorySlider extends StatefulWidget {
  final List<CategoryModel> categories;
  final Function(CategoryModel?) onSelection;

  const CategorySlider(
      {super.key, required this.categories, required this.onSelection});

  @override
  State<CategorySlider> createState() => _CategorySliderState();
}

class _CategorySliderState extends State<CategorySlider> {
  CategoryModel? selectCategory;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        padding: EdgeInsets.symmetric(
          horizontal: DesignConstants.horizontalPadding,
          vertical: 8,
        ),
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          final isSelected = category == selectCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectCategory = null;
                  widget.onSelection(null);
                } else {
                  selectCategory = category;
                  widget.onSelection(category);
                }
              });
            },
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColorConstants.themeColor
                        : AppColorConstants.backgroundColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColorConstants.themeColor
                          : AppColorConstants.mainTextColor.withOpacity(0.2),
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color:
                                  AppColorConstants.themeColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: AppColorConstants.shadowColor
                                  .withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                  ),
                  child: Icon(
                    Icons.category,
                    size: 20,
                    color: isSelected
                        ? AppColorConstants.backgroundColor
                        : AppColorConstants.mainTextColor.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  // width: 80,
                  child: Center(
                    child: BodySmallText(
                      category.name,
                      maxLines: 1,
                      weight:
                          isSelected ? TextWeight.semiBold : TextWeight.regular,
                      color: isSelected
                          ? AppColorConstants.themeColor
                          : AppColorConstants.mainTextColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(width: 12);
        },
      ),
    );
  }
}
