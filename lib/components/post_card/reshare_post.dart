import 'package:foap/components/post_card_controller.dart';
import 'package:foap/components/user_card.dart';
import '../../helper/imports/common_import.dart';
import '../../model/post_model.dart';

class ReSharePost extends StatefulWidget {
  final PostModel post;

  const ReSharePost({super.key, required this.post});

  @override
  ReSharePostState createState() => ReSharePostState();
}

class ReSharePostState extends State<ReSharePost> {
  final TextEditingController commentInputField = TextEditingController();
  final PostCardController postCardController = Get.find();
  final UserProfileManager _userProfileManager = Get.find();

  @override
  Widget build(BuildContext context) {
    return _buildReshareContainer();
  }

  Widget _buildReshareContainer() {
    return Container(
      decoration: BoxDecoration(
        color: AppColorConstants.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Section
          _buildUserInfoSection(),
          const SizedBox(height: 16),

          // Comment Input Section
          _buildCommentInput(),
          const SizedBox(height: 16),

          // Controls Section
          _buildControlsSection(),
        ],
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Column(
      children: [
        UserInfo(model: _userProfileManager.user.value!),
        const SizedBox(height: 8),
        Divider(
          color: AppColorConstants.dividerColor,
          height: 1,
          thickness: 0.5,
        ),
      ],
    );
  }

  Widget _buildCommentInput() {
    return AppTextField(
      controller: commentInputField,
      maxLines: 3,
      hintText: pleaseEnterMessageString.tr,
      // borderColor: AppColorConstants.dividerColor,
      // borderRadius: 12,
      // fillColor: AppColorConstants.backgroundColor,
      // textStyle: TextStyle(
      //   color: AppColorConstants.mainTextColor,
      //   fontSize: FontSizes.b2,
      // ),
    );
  }

  Widget _buildControlsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Comments Toggle
        _buildCommentsToggle(),
        const SizedBox(width: 16),

        // Share Button
        _buildShareButton(),
      ],
    );
  }

  Widget _buildCommentsToggle() {
    return Obx(() => Row(
          children: [
            BodyMediumText(
              allowCommentsString.tr,
              weight: TextWeight.semiBold,
              color: AppColorConstants.subHeadingTextColor,
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: postCardController.enableComments.value
                    ? AppColorConstants.themeColor
                    : AppColorConstants.disabledColor.withOpacity(0.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ThemeIconWidget(
                  postCardController.enableComments.value
                      ? ThemeIcon.selectedCheckbox
                      : ThemeIcon.emptyCheckbox,
                  color: postCardController.enableComments.value
                      ? Colors.white
                      : AppColorConstants.iconColor,
                  size: 20,
                ),
              ),
            ).ripple(() {
              postCardController.toggleEnableComments();
            }),
          ],
        ));
  }

  Widget _buildShareButton() {
    return AppThemeButton(
      width: 100,
      height: 40,
      text: shareString.tr,
      cornerRadius: 20,
      onPress: _handleSharePost,
    );
  }

  void _handleSharePost() {
    postCardController.reSharePost(
      postId: widget.post.id,
      comment: commentInputField.text,
      enableComments: postCardController.enableComments.value,
    );
    Get.back();
  }

  @override
  void dispose() {
    commentInputField.dispose();
    super.dispose();
  }
}
