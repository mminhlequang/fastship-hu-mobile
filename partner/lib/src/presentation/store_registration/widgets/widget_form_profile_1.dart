import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:internal_core/extensions/date_extension.dart';
import 'package:internal_core/setup/app_textstyles.dart';
import 'package:internal_core/setup/app_utils.dart';

class WidgetFormProfile1 extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onChanged;
  final Map<String, dynamic>? initialData;

  const WidgetFormProfile1({
    super.key,
    required this.onChanged,
    this.initialData,
  });

  @override
  State<WidgetFormProfile1> createState() => _WidgetFormProfile1State();
}

class _WidgetFormProfile1State extends State<WidgetFormProfile1> {
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _storeNameController.text = widget.initialData!['storeName'] ?? '';
      _phoneController.text = widget.initialData!['storePhone'] ?? '';
      _addressController.text = widget.initialData!['storeAddress'] ?? '';
    }
  }

  _onChanged() {
    widget.onChanged({
      'storeName': _storeNameController.text,
      'storePhone': _phoneController.text,
      'storeAddress': _addressController.text,
    });
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sw),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            controller: _storeNameController,
            title: 'Store name'.tr(),
            hintText: 'Enter store name'.tr(),
          ),
          Gap(24.sw),
          AppTextField(
            controller: _phoneController,
            title: 'Phone number'.tr(),
            hintText: 'Enter phone number'.tr(),
            keyboardType: TextInputType.phone,
          ),
          Gap(24.sw),
          AppTextField(
            controller: _addressController,
            title: 'Address'.tr(),
            hintText: 'Enter address'.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadBox(String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120.sw,
        decoration: BoxDecoration(
          color: hexColor('#FAFAFA'),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: appColorText.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              color: appColorText.withValues(alpha: 0.5),
              size: 32.sw,
            ),
            Gap(8.sw),
            Text(
              title,
              style: w300TextStyle(
                fontSize: 12.sw,
                color: appColorText.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
