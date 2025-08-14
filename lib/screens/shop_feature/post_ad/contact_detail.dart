import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/controllers/shop/shop_controller.dart';
import '../../../model/shop_model/ad_model.dart';

class ContactDetail extends StatefulWidget {
  final AdModel adModel;

  const ContactDetail({super.key, required this.adModel});

  @override
  State<ContactDetail> createState() => _ContactDetailState();
}

class _ContactDetailState extends State<ContactDetail> {
  final ShopController _shopController = Get.find();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    _addressController.text = widget.adModel.locations?.customLocation ?? '';
    _phoneController.text = widget.adModel.phone ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: DesignConstants.horizontalPadding,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderSection(),
                    const SizedBox(height: 30),
                    _buildPhoneField(),
                    const SizedBox(height: 25),
                    _buildAddressField(),
                    const SizedBox(height: 40),
                    _buildSubmitButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColorConstants.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppColorConstants.dividerColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: backNavigationBar(
        title: contactDetailString.tr,
        // centerTitle: true,
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Heading5Text(
          'Contact Information',
          weight: TextWeight.bold,
          color: AppColorConstants.themeColor,
        ),
        const SizedBox(height: 8),
        BodyMediumText(
          'Please provide your contact details for buyers to reach you',
          color: AppColorConstants.subHeadingTextColor,
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(phoneNumberString.tr),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColorConstants.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColorConstants.dividerColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: AppColorConstants.dividerColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: BodyLargeText(
                  '+1',
                  color: AppColorConstants.themeColor,
                  weight: TextWeight.semiBold,
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: '1234567899',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                    hintStyle: TextStyle(
                      color: AppColorConstants.subHeadingTextColor
                          .withOpacity(0.5),
                    ),
                  ),
                  onChanged: (value) => widget.adModel.phone = value,
                  style: TextStyle(
                    color: AppColorConstants.mainTextColor,
                    fontSize: FontSizes.b2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(addressString.tr),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColorConstants.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColorConstants.dividerColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: _addressController,
            maxLines: 4,
            minLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your address';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Shellway Rd, Ellesmere Port Cheshire West and Chester',
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: AppColorConstants.subHeadingTextColor.withOpacity(0.5),
              ),
            ),
            onChanged: (value) => widget.adModel.address = value,
            style: TextStyle(
              color: AppColorConstants.mainTextColor,
              fontSize: FontSizes.b2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String text) {
    return BodyLargeText(
      text,
      color: AppColorConstants.subHeadingTextColor,
      weight: TextWeight.semiBold,
    );
  }

  Widget _buildSubmitButton() {
    return AppThemeButton(
      text: submitString.tr,
      onPress: _validateAndSubmit,
      cornerRadius: 12,
      width: double.infinity,
      height: 50,
      // textStyle: TextStyle(
      //   fontSize: FontSizes.b2,
      //   fontWeight: TextWeight.bold,
      // ),
    );
  }

  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.adModel.address = _addressController.text;
      _shopController.postAd(ad: widget.adModel);
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
