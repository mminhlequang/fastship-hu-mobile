import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:easy_localization/easy_localization.dart';

class EmergencyContact {
  final String name;
  final EmergencyContactType relationship;
  final String phoneNumber;

  EmergencyContact({
    required this.name,
    required this.relationship,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'relationship': relationship.value,
      'phoneNumber': phoneNumber,
    };
  }
}

class WidgetFormProfile3 extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onChanged;
  final Map<String, dynamic>? initialData;
  const WidgetFormProfile3({
    super.key,
    required this.onChanged,
    this.initialData,
  });

  @override
  State<WidgetFormProfile3> createState() => _WidgetFormProfile3State();
}

class _WidgetFormProfile3State extends State<WidgetFormProfile3> {
  final List<String> _banks = [
    'MBH',
    'UniCredit Hungary',
    'Erste',
    'Raiffeisen',
    'CIB',
    'MFB Magyar Fejlesztesi',
    'Granit',
    'Citibank'
  ];
  String? _selectedBank;
  final TextEditingController _bankNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _onChanged() {
    widget.onChanged({
      'bankName': _selectedBank,
      'bankNumber': _bankNumberController.text,
      'cardHolder': _cardHolderController.text,
    });
  }

  @override
  void dispose() {
    _bankNumberController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.sw),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppDropdown(
            items: _banks,
            selectedItem: _selectedBank,
            title: 'Bank name'.tr(),
            hintText: 'Select bank'.tr(),
            onChanged: (value) {
              setState(() {
                _selectedBank = value;
              });
            },
          ),
          Gap(24.sw),
          AppTextField(
            controller: _bankNumberController,
            title: 'Account number'.tr(),
            hintText: 'Enter account number'.tr(),
            keyboardType: TextInputType.number,
            onChanged: (_) => _onChanged(),
          ),
          Gap(24.sw),
          AppTextField(
            controller: _cardHolderController,
            title: 'Card holder'.tr(),
            hintText: 'Enter card holder name'.tr(),
            onChanged: (_) => _onChanged(),
          ),
          Gap(24.sw),
        ],
      ),
    );
  }
}
