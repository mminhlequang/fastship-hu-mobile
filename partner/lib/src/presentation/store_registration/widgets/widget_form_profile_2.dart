import 'dart:io';

import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/app_utils.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internal_core/extensions/context_extension.dart';
import 'package:internal_core/internal_core.dart';
import 'package:internal_core/setup/app_textstyles.dart';
import 'package:internal_core/setup/app_utils.dart';
import 'package:internal_core/widgets/widgets.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'widget_bottomsheet.dart';

enum RepresentativeType {
  personal,
  householdBusiness,
  enterprise;

  String get displayName => switch (this) {
        personal => 'Personal'.tr(),
        householdBusiness => 'Household Business'.tr(),
        enterprise => 'Enterprise'.tr(),
      };
}

class WidgetFormProfile2 extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onChanged;
  final Map<String, dynamic>? initialData;
  const WidgetFormProfile2({
    super.key,
    required this.onChanged,
    this.initialData,
  });

  @override
  State<WidgetFormProfile2> createState() => _WidgetFormProfile2State();
}

class _WidgetFormProfile2State extends State<WidgetFormProfile2> {
  RepresentativeType type = RepresentativeType.personal;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  PhoneNumber? _phoneNumber;
  final TextEditingController _idController = TextEditingController(); // cccd
  DateTime? _issueDate; // ngày cấp cccd
  final TextEditingController _taxCodeController = TextEditingController();

  /// Hộ kinh doanh
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessAddressController =
      TextEditingController();

  /// Doanh nghiệp
  final TextEditingController _enterpriseNameController =
      TextEditingController();
  final TextEditingController _enterpriseAddressController =
      TextEditingController();

  XFile? _imageIDCardFront;
  XFile? _imageIDCardBack;
  XFile? _imageBusinessLicense;
  XFile? _imageTaxCode;
  XFile? _imageRelatedDocument;

  // Thêm FocusNode cho mỗi trường nhập liệu
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _idFocusNode = FocusNode();
  final FocusNode _taxCodeFocusNode = FocusNode();
  final FocusNode _businessNameFocusNode = FocusNode();
  final FocusNode _businessAddressFocusNode = FocusNode();
  final FocusNode _enterpriseNameFocusNode = FocusNode();
  final FocusNode _enterpriseAddressFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _imageIDCardFront = widget.initialData!['imageIDCardFront'];
      _imageIDCardBack = widget.initialData!['imageIDCardBack'];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _idController.dispose();
    _taxCodeController.dispose();
    _businessNameController.dispose();
    _businessAddressController.dispose();
    _enterpriseNameController.dispose();
    _enterpriseAddressController.dispose();

    // Giải phóng các FocusNode
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _idFocusNode.dispose();
    _taxCodeFocusNode.dispose();
    _businessNameFocusNode.dispose();
    _businessAddressFocusNode.dispose();
    _enterpriseNameFocusNode.dispose();
    _enterpriseAddressFocusNode.dispose();

    super.dispose();
  }

  _onChanged() {
    Map<String, dynamic> data = {};
    if (type == RepresentativeType.personal) {
      data = {
        'type': type,
        'name': _nameController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneNumber?.phoneNumber,
        'id': _idController.text,
        'issueDate': _issueDate,
        'taxCode': _taxCodeController.text,
        'imageIDCardFront': _imageIDCardFront,
        'imageIDCardBack': _imageIDCardBack,
        'imageBusinessLicense': _imageBusinessLicense,
        'imageRelatedDocument': _imageRelatedDocument,
      };
    } else if (type == RepresentativeType.householdBusiness) {}

    // {
    //   'type': type,
    //   'name': _nameController.text,
    //   'email': _emailController.text,
    //   'phoneNumber': _phoneNumber?.phoneNumber,
    //   'id': _idController.text,
    //   'issueDate': _issueDate,
    //   'taxCode': _taxCodeController.text,
    //   'businessName': _businessNameController.text,
    //   'businessAddress': _businessAddressController.text,
    //   'enterpriseName': _enterpriseNameController.text,
    //   'enterpriseAddress': _enterpriseAddressController.text,
    //   'imageIDCardFront': _imageIDCardFront,
    //   'imageIDCardBack': _imageIDCardBack,
    //   'imageBusinessLicense': _imageBusinessLicense,
    //   'imageTaxCode': _imageTaxCode,
    //   'imageRelatedDocument': _imageRelatedDocument,
    // }

    widget.onChanged(data);
  }

  _seeInstruction(String title) {
    appHaptic();
    appOpenBottomSheet(
      WidgetBottomSheetGuideTakePhoto(),
    );
  }

  Future<void> _pickImage(
      ImageSource source, Function(XFile) onImagePicked) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        onImagePicked(image);
        _onChanged();
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showImageSourceOptions(Function(XFile) onImagePicked) {
    appHaptic();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text('Take a photo'.tr()),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera, onImagePicked);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text('Choose from gallery'.tr()),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery, onImagePicked);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sw),
              child: Row(
                children: RepresentativeType.values.map((e) {
                  bool isSelected = e == type;
                  return Expanded(
                    flex: e == RepresentativeType.householdBusiness ? 3 : 2,
                    child: WidgetRippleButton(
                      onTap: () {
                        if (!isSelected) {
                          setState(() {
                            type = e;
                          });
                        }
                      },
                      color: isSelected
                          ? hexColor('#74CA45').withValues(alpha: .05)
                          : Colors.white,
                      borderSide: BorderSide(
                        color: isSelected ? appColorPrimary : grey8,
                      ),
                      radius: 0,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.sw),
                          child: Text(
                            e.displayName,
                            style: w400TextStyle(
                              color: isSelected ? appColorPrimary : grey1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            if (type == RepresentativeType.enterprise) ...[
              Gap(24.sw),
              AppTextField(
                controller: _enterpriseNameController,
                focusNode: _enterpriseNameFocusNode,
                title: 'Company name'.tr(),
                hintText: 'Enter company name'.tr(),
                padding: EdgeInsets.symmetric(horizontal: 16.sw),
                onSubmitted: (_) {
                  _enterpriseAddressFocusNode.requestFocus();
                },
                onChanged: (_) {
                  _onChanged();
                },
              ),
              Gap(24.sw),
              AppTextField(
                controller: _enterpriseAddressController,
                focusNode: _enterpriseAddressFocusNode,
                title: 'Company address'.tr(),
                hintText: 'Enter company address'.tr(),
                padding: EdgeInsets.symmetric(horizontal: 16.sw),
                onSubmitted: (_) {
                  _nameFocusNode.requestFocus();
                },
                onChanged: (_) {
                  _onChanged();
                },
              ),
              Gap(24.sw),
              Container(height: 8.sw, color: appColorBackground),
            ],
            Gap(24.sw),
            AppTextField(
              controller: _nameController,
              focusNode: _nameFocusNode,
              title: 'Full name'.tr(),
              hintText: 'Enter full name'.tr(),
              padding: EdgeInsets.symmetric(horizontal: 16.sw),
              onSubmitted: (_) {
                _emailFocusNode.requestFocus();
              },
              onChanged: (_) {
                _onChanged();
              },
            ),
            Gap(24.sw),
            AppTextField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              title: 'Email'.tr(),
              hintText: 'Enter email'.tr(),
              keyboardType: TextInputType.emailAddress,
              padding: EdgeInsets.symmetric(horizontal: 16.sw),
              onSubmitted: (_) {
                _phoneFocusNode.requestFocus();
              },
              onChanged: (_) {
                _onChanged();
              },
            ),
            Gap(24.sw),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sw),
              child: WidgetAppTextFieldPhone(
                initialValue: _phoneNumber,
                focusNode: _phoneFocusNode,
                title: 'Phone number'.tr(),
                isRequired: true,
                hintText: 'Enter phone number'.tr(),
                onChanged: (_) {
                  _phoneNumber = _;
                  _onChanged();
                },
                onSubmitted: (_) {
                  _idFocusNode.requestFocus();
                },
              ),
            ),
            Gap(24.sw),
            AppTextField(
              controller: _idController,
              focusNode: _idFocusNode,
              title: 'ID Card number'.tr(),
              hintText: 'Enter ID Card number'.tr(),
              keyboardType: TextInputType.number,
              padding: EdgeInsets.symmetric(horizontal: 16.sw),
              onSubmitted: (_) {
                // Tiếp tục sang trường tiếp theo tùy theo loại
                if (type == RepresentativeType.householdBusiness) {
                  _businessNameFocusNode.requestFocus();
                } else {
                  _taxCodeFocusNode.requestFocus();
                }
              },
              onChanged: (_) {
                _onChanged();
              },
            ),
            Gap(24.sw),
            AppTextField(
              key: ValueKey(_issueDate),
              controller: TextEditingController(
                text: _issueDate?.formatDate(),
              ),
              title: 'Issue date'.tr(),
              hintText: 'dd/mm/yyyy',
              readOnly: true,
              padding: EdgeInsets.symmetric(horizontal: 16.sw),
              onTap: () {
                appHaptic();
                appOpenDateTimePicker(
                  DateTime.now(),
                  (date) {
                    setState(() {
                      _issueDate = date;
                    });
                    _onChanged();
                  },
                );
              },
            ),
            Gap(24.sw),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sw),
              child: Text.rich(
                TextSpan(
                  text: 'ID Card images'.tr(),
                  style: w600TextStyle(),
                  children: [
                    TextSpan(
                      text: '*',
                      style: w600TextStyle(color: appColorError),
                    )
                  ],
                ),
              ),
            ),
            Gap(4.sw),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sw),
              child: GestureDetector(
                onTap: () {
                  appHaptic();
                  _seeInstruction('ID Card images');
                },
                child: Text(
                  'See instruction'.tr(),
                  style: w400TextStyle(
                    decoration: TextDecoration.underline,
                    color: blue1,
                  ),
                ),
              ),
            ),
            Gap(16.sw),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sw),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppUploadImage2(
                          assetSvg: 'cccd_front',
                          onPickImage: (image) {
                            setState(() {
                              _imageIDCardFront = image;
                            });
                            _onChanged();
                          },
                          image: _imageIDCardFront,
                        ),
                        Gap(12.sw),
                        Text(
                          '1. ${'Front'.tr()}',
                          style: w400TextStyle(color: grey1),
                        ),
                      ],
                    ),
                  ),
                  Gap(23.sw),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppUploadImage2(
                          assetSvg: 'cccd_back',
                          onPickImage: (image) {
                            setState(() {
                              _imageIDCardBack = image;
                            });
                            _onChanged();
                          },
                          image: _imageIDCardBack,
                        ),
                        Gap(12.sw),
                        Text(
                          '2. ${'Back'.tr()}',
                          style: w400TextStyle(color: grey1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Gap(24.sw),
            if (type == RepresentativeType.householdBusiness) ...[
              AppTextField(
                controller: _businessNameController,
                focusNode: _businessNameFocusNode,
                title: 'Household business name'.tr(),
                hintText: 'Enter name'.tr(),
                padding: EdgeInsets.symmetric(horizontal: 16.sw),
                onSubmitted: (_) {
                  _businessAddressFocusNode.requestFocus();
                },
                onChanged: (_) {
                  _onChanged();
                },
              ),
              Gap(24.sw),
              AppTextField(
                controller: _businessAddressController,
                focusNode: _businessAddressFocusNode,
                title: 'Business address'.tr(),
                hintText: 'Enter address'.tr(),
                padding: EdgeInsets.symmetric(horizontal: 16.sw),
                onSubmitted: (_) {
                  _taxCodeFocusNode.requestFocus();
                },
                onChanged: (_) {
                  _onChanged();
                },
              ),
              Gap(24.sw),
            ],
            AppUploadImage(
              title: 'Business license'.tr(),
              image: _imageBusinessLicense,
              padding: EdgeInsets.symmetric(horizontal: 16.sw),
              onSeeInstruction: () {
                _seeInstruction('Business license');
              },
              onPickImage: (image) {
                setState(() {
                  _imageBusinessLicense = image;
                });
                _onChanged();
              },
            ),
            Gap(24.sw),
            Container(height: 8, color: appColorBackground),
            Gap(24.sw),
            AppTextField(
              controller: _taxCodeController,
              focusNode: _taxCodeFocusNode,
              title: 'Tax code'.tr(),
              hintText: 'Enter tax code'.tr(),
              keyboardType: TextInputType.number,
              padding: EdgeInsets.symmetric(horizontal: 16.sw),
              onSubmitted: (_) {
                // Bỏ focus của trường cuối cùng
                FocusScope.of(context).unfocus();
              },
              onChanged: (_) {
                _onChanged();
              },
            ),
            // Gap(24.sw),
            // AppUploadImage(
            //   title: 'Tax code image'.tr(),
            //   image: _imageTaxCode,
            //   padding: EdgeInsets.symmetric(horizontal: 16.sw),
            //   onSeeInstruction: () {
            //     _seeInstruction('Tax code image');
            //   },
            //   onPickImage: (image) {
            //     setState(() {
            //       _imageTaxCode = image;
            //     });
            //     _onChanged();
            //   },
            // ),
            Gap(24.sw),
            AppUploadImage(
              title: 'Related documents'.tr(),
              padding: EdgeInsets.symmetric(horizontal: 16.sw),
              onSeeInstruction: () {
                _seeInstruction('Related documents');
              },
              image: _imageRelatedDocument,
              onPickImage: (image) {
                setState(() {
                  _imageRelatedDocument = image;
                });
                _onChanged();
              },
            ),
            Gap(24.sw),
          ],
        ),
      ),
    );
  }
}
