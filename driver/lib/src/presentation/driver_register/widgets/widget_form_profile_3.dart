import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';
import 'package:gap/gap.dart';
import 'package:app/src/constants/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:app/src/presentation/widgets/widget_textfield.dart';
import 'package:app/src/utils/utils.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

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
  final List<EmergencyContact> _emergencyContacts = [];
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  EmergencyContactType _selectedRelationship = EmergencyContactType.family;
  PhoneNumber? _phoneNumber;
  bool _isValidPhoneNumber = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null &&
        widget.initialData!['emergencyContacts'] != null) {
      final List<dynamic> contacts = widget.initialData!['emergencyContacts'];
      _emergencyContacts.addAll(
        contacts.map((contact) => EmergencyContact(
              name: contact['name'],
              relationship: EmergencyContactType.values.firstWhere(
                (e) => e.value == contact['relationship'],
              ),
              phoneNumber: contact['phoneNumber'],
            )),
      );
    }
  }

  void _onChanged() {
    widget.onChanged({
      'emergencyContacts': _emergencyContacts.map((e) => e.toJson()).toList(),
    });
  }

  void _addEmergencyContact() {
    if (_nameController.text.isNotEmpty && _isValidPhoneNumber) {
      setState(() {
        _emergencyContacts.add(
          EmergencyContact(
            name: _nameController.text,
            relationship: _selectedRelationship,
            phoneNumber: _phoneNumber!.phoneNumber!,
          ),
        );
        _phoneController.clear();
        _nameController.clear();
        _phoneNumber = null;
        _isValidPhoneNumber = false;
        _selectedRelationship = EmergencyContactType.family;
      });
      _onChanged();
    }
  }

  void _removeEmergencyContact(int index) {
    setState(() {
      _emergencyContacts.removeAt(index);
    });
    _onChanged();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sw),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Emergency Contacts".tr(),
                style: w500TextStyle(fontSize: 14.sw),
              ),
              Gap(4.sw),
              Text(
                "Add emergency contacts who can be reached in case of need."
                    .tr(),
                style: w300TextStyle(
                  fontSize: 14.sw,
                ),
              ),
              Gap(12.sw),
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _emergencyContacts.length,
                itemBuilder: (context, index) {
                  final contact = _emergencyContacts[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 8.sw),
                    padding: EdgeInsets.all(12.sw),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.instance.grey5),
                      borderRadius: BorderRadius.circular(8.sw),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                contact.name,
                                style: w500TextStyle(fontSize: 16.sw),
                              ),
                              Gap(4.sw),
                              Text(
                                contact.relationship.name,
                                style: w300TextStyle(
                                  fontSize: 12.sw,
                                  color: appColorText.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          contact.phoneNumber,
                          style: w500TextStyle(fontSize: 14.sw),
                        ),
                        Gap(12.sw),
                        GestureDetector(
                          onTap: () => _removeEmergencyContact(index),
                          child: Icon(
                            CupertinoIcons.delete,
                            color: Colors.red,
                            size: 20.sw,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Gap(12.sw),
              WidgetTextField(
                controller: _nameController,
                hint: "Full name".tr(),
                label: "Name".tr(),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              Gap(12.sw),
              WidgetTextFieldPhone(
                controller: _phoneController,
                initialValue: _phoneNumber?.phoneNumber,
                initialCountryCode: _phoneNumber?.isoCode ?? 'HU',
                onPhoneNumberChanged: (phoneNumber) {
                  setState(() {
                    _phoneNumber = phoneNumber;
                  });
                },
                onInputValidated: (isValid) {
                  setState(() {
                    _isValidPhoneNumber = isValid;
                  });
                },
                hint: "Contact phone".tr(),
                label: "Phone number".tr(),
              ),
              Gap(12.sw),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 3,
                    child: WidgetDropSelectorBuilder(
                      items: EmergencyContactType.values,
                      selectedItem: _selectedRelationship,
                      titleBuilder: (item) => item.name,
                      onChanged: (item) {
                        setState(() {
                          _selectedRelationship = item;
                        });
                      },
                      child: IgnorePointer(
                        ignoring: true,
                        child: WidgetTextField(
                          controller: TextEditingController(
                            text: _selectedRelationship?.name,
                          ),
                          label: "Relationship*".tr(),
                          hint: "Select".tr(),
                          sufixIconWidget: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.instance.grey1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gap(12.sw),
                  Expanded(
                    child: WidgetAppButtonOK(
                      onTap: _addEmergencyContact,
                      enable: _nameController.text.isNotEmpty &&
                          _isValidPhoneNumber,
                      label: "Add".tr(),
                      height: 48.sw,
                    ),
                  ),
                ],
              ),
              Gap(12.sw),
            ],
          ),
        ),
      ],
    );
  }
}
