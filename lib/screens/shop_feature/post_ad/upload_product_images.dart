import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/screens/chat/contact_detail.dart' hide ContactDetail;
import 'package:image_picker/image_picker.dart';
import '../../../model/shop_model/ad_model.dart';
import 'package:foap/controllers/shop/shop_controller.dart';
import 'contact_detail.dart';

class UploadProductImages extends StatefulWidget {
  final AdModel? adModel;

  const UploadProductImages(this.adModel, {super.key});

  @override
  State<UploadProductImages> createState() => _UploadProductImagesState();
}

class _UploadProductImagesState extends State<UploadProductImages> {
  final picker = ImagePicker();
  XFile? _pickedImage;
  final ShopController _shopController = Get.find();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: Column(
              children: [
                _buildInstructionText(),
                const SizedBox(height: 20),
                _buildImageGrid(),
                const Spacer(),
                _buildNextButton(),
              ],
            ).hp(DesignConstants.horizontalPadding),
          ),
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
      child: backNavigationBar(title: uploadPhotoString.tr),
    );
  }

  Widget _buildInstructionText() {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: BodyLargeText(
        "Please Upload the product images here".tr,
        color: AppColorConstants.subHeadingTextColor,
        weight: TextWeight.semiBold,
      ),
    );
  }

  Widget _buildImageGrid() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: (widget.adModel!.images).length + 1,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return _buildGridItem(index);
        },
      ),
    );
  }

  Widget _buildGridItem(int index) {
    final isAddButton = index == widget.adModel!.images.length;

    return GestureDetector(
      onTap: () => isAddButton ? _openImageSourceSelector() : _viewImage(index),
      child: Container(
        decoration: BoxDecoration(
          color: isAddButton
              ? AppColorConstants.themeColor.withOpacity(0.1)
              : AppColorConstants.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColorConstants.dividerColor.withOpacity(0.3),
            width: isAddButton ? 2 : 1,
          ),
        ),
        child: isAddButton
            ? Center(
                child: Icon(
                  Icons.add,
                  size: 30,
                  color: AppColorConstants.themeColor,
                ),
              )
            : Stack(
                children: [
                  _buildImagePreview(index),
                  _buildDeleteButton(index),
                ],
              ),
      ),
    );
  }

  Widget _buildImagePreview(int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: widget.adModel!.images[index],
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(
            color: AppColorConstants.themeColor,
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  Widget _buildDeleteButton(int index) {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColorConstants.red.withOpacity(0.8),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.close,
          color: Colors.white,
          size: 16,
        ),
      ).ripple(() {
        setState(() {
          widget.adModel!.images.removeAt(index);
        });
      }),
    );
  }

  Widget _buildNextButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 10),
        child: AppThemeButton(
          text: nextString.tr,
          onPress: _proceedToNextStep,
          cornerRadius: 10,
          width: double.infinity,
        ),
      ),
    );
  }

  void _openImageSourceSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColorConstants.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildImageSourceOptions(),
    );
  }

  Widget _buildImageSourceOptions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Heading6Text(
            addPhotoString.tr,
            weight: TextWeight.bold,
          ),
        ),
        _buildOptionTile(
          icon: Icons.camera_alt,
          title: cameraString.tr,
          onTap: _pickImageFromCamera,
        ),
        _buildOptionTile(
          icon: Icons.photo_library,
          title: galleryString.tr,
          onTap: _pickImageFromGallery,
        ),
        const Divider(height: 1),
        _buildOptionTile(
          icon: Icons.close,
          title: cancelString.tr,
          onTap: () => Navigator.pop(context),
          isCancel: true,
        ),
      ],
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isCancel = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isCancel ? AppColorConstants.red : AppColorConstants.themeColor,
      ),
      title: BodyLargeText(
        title,
        color:
            isCancel ? AppColorConstants.red : AppColorConstants.mainTextColor,
      ),
      onTap: onTap,
    );
  }

  Future<void> _pickImageFromCamera() async {
    Navigator.pop(context);
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _handlePickedImage(pickedFile);
    }
  }

  Future<void> _pickImageFromGallery() async {
    Navigator.pop(context);
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _handlePickedImage(pickedFile);
    }
  }

  void _handlePickedImage(XFile pickedFile) {
    setState(() {
      _pickedImage = pickedFile;
    });
    _uploadAdImage();
  }

  void _viewImage(int index) {
    // Get.to(() => EnlargeImageViewScreen(widget.adModel!.images[index]));
  }

  void _proceedToNextStep() {
    if (widget.adModel!.images.isEmpty) {
      AppUtil.showToast(message: pleaseUploadImageString.tr, isSuccess: false);
      return;
    }

    final imagesWithNames =
        widget.adModel!.images.map((e) => e.split('/').last).toList();

    widget.adModel?.images = imagesWithNames;
    Get.to(() => ContactDetail(adModel: widget.adModel!));
  }

  void _uploadAdImage() {
    if (_pickedImage == null) return;

    Loader.show();

    _shopController.uploadAdImage(
      pickedFile: _pickedImage!,
      successCallback: (filePath) {
        Loader.dismiss();
        setState(() {
          widget.adModel!.images.add(filePath);
        });
      },

      // failureCallback: (error) {
      //   Loader.dismiss();
      //   AppUtil.showToast(message: errorMessageString.tr, isSuccess: false);
      // },
    );
  }
}
