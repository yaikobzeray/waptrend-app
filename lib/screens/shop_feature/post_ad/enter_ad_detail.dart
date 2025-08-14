import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/model/shop_model/category.dart';
import 'package:foap/screens/shop_feature/post_ad/upload_product_images.dart';
import '../../../model/shop_model/ad_model.dart';

class EnterAdDetail extends StatefulWidget {
  final AdModel adModel;

  const EnterAdDetail(this.adModel, {super.key});

  @override
  State<EnterAdDetail> createState() => _EnterAdDetailState();
}

class _EnterAdDetailState extends State<EnterAdDetail> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String _currency = "\$";

  @override
  void initState() {
    super.initState();
    _fillForm();
  }

  void _fillForm() {
    _titleController.text = widget.adModel.title ?? '';
    _descriptionController.text = widget.adModel.description ?? '';
    _priceController.text =
        widget.adModel.price == null ? '' : '${widget.adModel.price}';
    _currency = widget.adModel.currency ?? '\$';
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: DesignConstants.horizontalPadding,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormCard(
                      children: [
                        _buildSectionTitle(enterProductDetailString.tr),
                        const SizedBox(height: 25),
                        _buildTitleField(),
                        const SizedBox(height: 25),
                        _buildDescriptionField(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildFormCard(
                      children: [
                        _buildSectionTitle(enterProductDetailString.tr),
                        const SizedBox(height: 15),
                        _buildPriceSection(),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.1),
                  ],
                ),
              ),
            ),
          ),
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColorConstants.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppColorConstants.dividerColor.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: backNavigationBar(title: enterProductDetailString.tr),
    );
  }

  Widget _buildFormCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColorConstants.themeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColorConstants.dividerColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Heading6Text(
      title,
      weight: TextWeight.bold,
      color: AppColorConstants.themeColor,
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyMediumText(
          titleString.tr,
          color: AppColorConstants.subHeadingTextColor,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColorConstants.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColorConstants.dividerColor.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: enterTitleString.tr,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: AppColorConstants.subHeadingTextColor.withOpacity(0.5),
              ),
            ),
            onChanged: (value) => widget.adModel.title = value,
            style: TextStyle(
              color: AppColorConstants.mainTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyMediumText(
          descriptionString.tr,
          color: AppColorConstants.subHeadingTextColor,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColorConstants.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColorConstants.dividerColor.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _descriptionController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: enterDescriptionString.tr,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: AppColorConstants.subHeadingTextColor.withOpacity(0.5),
              ),
            ),
            onChanged: (value) => widget.adModel.description = value,
            style: TextStyle(
              color: AppColorConstants.mainTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyMediumText(
          priceString.tr,
          color: AppColorConstants.subHeadingTextColor,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColorConstants.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColorConstants.dividerColor.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: enterPriceString.tr,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: AppColorConstants.subHeadingTextColor
                          .withOpacity(0.5),
                    ),
                  ),
                  onChanged: (value) => widget.adModel.price = value,
                  style: TextStyle(
                    color: AppColorConstants.mainTextColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButton<String>(
                  value: _currency,
                  underline: Container(),
                  items: <String>['\$', '€', '£', '₹', '¥']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _currency = newValue!;
                      widget.adModel.currency = newValue;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColorConstants.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppColorConstants.dividerColor.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: AppThemeButton(
          text: nextString.tr,
          onPress: _validateAndProceed,
          cornerRadius: 10,
        ),
      ),
    );
  }

  void _validateAndProceed() {
    if (widget.adModel.categoryId == null) {
      AppUtil.showToast(message: selectAdTypeString, isSuccess: false);
      return;
    }

    if (_titleController.text.isEmpty) {
      AppUtil.showToast(message: enterTitleString, isSuccess: false);
      return;
    }

    if (_descriptionController.text.isEmpty) {
      AppUtil.showToast(message: enterDescriptionString, isSuccess: false);
      return;
    }

    if (_priceController.text.isEmpty) {
      AppUtil.showToast(message: enterPriceString, isSuccess: false);
      return;
    }

    Get.to(() => UploadProductImages(widget.adModel));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
