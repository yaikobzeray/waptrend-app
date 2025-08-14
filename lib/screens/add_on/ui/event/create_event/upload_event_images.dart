import 'package:foap/helper/imports/common_import.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import '../../../controller/event/create_event/add_event_controller.dart';

class UploadEventImages extends StatefulWidget {
  const UploadEventImages({super.key});

  @override
  State<UploadEventImages> createState() => _UploadEventImagesState();
}

class _UploadEventImagesState extends State<UploadEventImages> {
  final picker = ImagePicker();
  final AddEventController addEventController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: Column(
        children: [
          backNavigationBar(title: uploadPhotoString.tr),
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 15),
                coverImageView(),
                SizedBox(height: 15),
                Expanded(
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BodySmallText(
                            galleryOptionalString.tr,
                            weight: TextWeight.semiBold,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SingleChildScrollView(
                            child: addImagesGridView(),
                          ).vP8,
                        ],
                      ),
                      SizedBox(height: Get.height * 0.9),
                      Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: AppThemeButton(
                            text: submitString.tr,
                            onPress: () {
                              submitBtnClicked();
                            },
                          ))
                    ],
                  ),
                ),
              ],
            ).hp(DesignConstants.horizontalPadding),
          )
        ],
      ),
    );
  }

  coverImageView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodySmallText(
          coverPhotoString.tr,
          weight: TextWeight.semiBold,
        ),
        const SizedBox(
          height: 10,
        ),
        Obx(() => InkWell(
            onTap: () async {
              openImagePickingPopup(true);
            },
            child: SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: addEventController.creatingEvent.value.image == null
                        ? Center(
                            child: Icon(
                              Iconsax.gallery_add_outline,
                              size: 50,
                              color: AppColorConstants.themeColor.darken(),
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl:
                                addEventController.creatingEvent.value.image!,
                            fit: BoxFit.cover,
                            height: double.infinity,
                            width: double.infinity))
                .borderWithRadius(value: 1, radius: 10))),
      ],
    );
  }

  addImagesGridView() {
    final double itemWidth = (Get.width - 30) / 2;
    double itemHeight = itemWidth;

    return Obx(() => GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: itemWidth / itemHeight, //0.78,
        ),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: (addEventController.creatingEvent.value.gallery).length + 1,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () async {
                if (index ==
                    (addEventController.creatingEvent.value.gallery).length) {
                  openImagePickingPopup(false);
                }
              },
              child: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: index ==
                              (addEventController.creatingEvent.value.gallery)
                                  .length
                          ? Center(
                              child: Icon(
                              color: AppColorConstants.themeColor.darken(),
                              Iconsax.gallery_add_outline,
                              size: 50,
                            ))
                          : Stack(
                              children: [
                                CachedNetworkImage(
                                    imageUrl: (addEventController
                                        .creatingEvent.value.gallery)[index],
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                    width: double.infinity),
                                Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      color: AppColorConstants.themeColor,
                                      child: ThemeIconWidget(
                                        ThemeIcon.delete,
                                        color: Colors.white,
                                      ).p8,
                                    ).round(10).ripple(() {
                                      addEventController.removeImageAt(index);
                                    }))
                              ],
                            ))
                  .borderWithRadius(value: 1, radius: 10));
        }));
  }

  void openImagePickingPopup(bool isCoverImage) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              decoration: BoxDecoration(
                color: AppColorConstants.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                    child: BodyLargeText(
                      addPhotoString.tr,
                      color: AppColorConstants.mainTextColor,
                      weight: TextWeight.semiBold,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Divider(height: 1, thickness: 0.5),
                  ListTile(
                    leading: Icon(
                      Iconsax.camera_bold,
                      color: AppColorConstants.themeColor.darken(),
                    ),
                    title: BodyLargeText(cameraString.tr),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    minLeadingWidth: 24,
                    onTap: () => chooseImage(ImageSource.camera, isCoverImage),
                  ),
                  const Divider(height: 1, thickness: 0.5),
                  ListTile(
                    leading: Icon(
                      Iconsax.gallery_bold,
                      color: AppColorConstants.themeColor.darken(),
                    ),
                    title: BodyLargeText(galleryString.tr),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    minLeadingWidth: 24,
                    onTap: () => chooseImage(ImageSource.gallery, isCoverImage),
                  ),
                  const Divider(height: 1, thickness: 0.5),
                  ListTile(
                    leading: Icon(
                      Iconsax.close_circle_bold,
                      color: AppColorConstants.red,
                    ),
                    title: BodyLargeText(
                      cancelString.tr,
                      color: AppColorConstants.red,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    minLeadingWidth: 24,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ));
  }

  submitBtnClicked() {
    if (addEventController.creatingEvent.value.image == null) {
      AppUtil.showToast(
          message: pleaseUploadCoverImageString.tr, isSuccess: false);
      return;
    }

    addEventController.submitEvent();
  }

  chooseImage(ImageSource source, bool isCoverImage) async {
    Navigator.of(context).pop();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      uploadAdImagesApi(pickedFile, isCoverImage);
    }
  }

  void uploadAdImagesApi(XFile pickedImage, bool isCoverImage) {
    try {
      Loader.show();
      if (isCoverImage) {
        addEventController.uploadCoverImage(
            pickedFile: pickedImage, successCallback: (filePath) {});
      } else {
        addEventController.uploadGalleryImage(
            pickedFile: pickedImage, successCallback: (filePath) {});
      }
    } catch (error) {
      Loader.dismiss();
      AppUtil.showToast(message: errorMessageString.tr, isSuccess: false);
    }
  }
}
