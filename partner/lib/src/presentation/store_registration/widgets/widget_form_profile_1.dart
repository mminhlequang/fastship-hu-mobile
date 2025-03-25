import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

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
  final TextEditingController _addressController = TextEditingController();
  HereSearchResult? _selectedAddress;
  PhoneNumber? _phoneNumber;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _storeNameController.text = widget.initialData!['storeName'] ?? '';
      _phoneNumber =
          PhoneNumber(phoneNumber: widget.initialData!['storePhone']);
      _addressController.text =
          (widget.initialData!['storeAddress'] as HereSearchResult?)?.title ??
              "";
    }
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  _onChanged() {
    widget.onChanged({
      'storeName': _storeNameController.text,
      'storePhone': _phoneNumber?.phoneNumber,
      'storeAddress': _selectedAddress,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.sw),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            controller: _storeNameController,
            title: 'Store name'.tr(),
            hintText: 'Enter store name'.tr(),
            onChanged: (_) => _onChanged(),
          ),
          Gap(24.sw),
          WidgetAppTextFieldPhone(
            initialValue: _phoneNumber,
            title: 'Phone number'.tr(),
            hintText: 'Enter phone number'.tr(),
            onChanged: (_) {
              _phoneNumber = _;
              _onChanged();
            },
          ),
          Gap(24.sw),
          WidgetSearchPlaceBuilder(
            controller: _addressController,
            builder: (onChanged, controller, isFocus, key) => AppTextField(
              controller: controller,
              title: 'Address'.tr(),
              hintText: 'Enter address'.tr(),
              onChanged: onChanged,
            ),
            onSubmitted: (value) {
              _selectedAddress = value;
              _onChanged();
            },
          ),
          Gap(24.sw),
        ],
      ),
    );
  }
}
