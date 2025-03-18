import 'dart:io';

import 'package:app/src/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internal_core/setup/app_textstyles.dart';
import 'package:internal_core/widgets/widgets.dart';

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
  XFile? _imageIDCardFront;
  XFile? _imageIDCardBack;
  XFile? _imageDrivingLicenseFront;
  XFile? _imageDrivingLicenseBack;
  XFile? _imageVehicleRegistration;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _imageIDCardFront = widget.initialData!['imageIDCardFront'];
      _imageIDCardBack = widget.initialData!['imageIDCardBack'];
      _imageDrivingLicenseFront =
          widget.initialData!['imageDrivingLicenseFront'];
      _imageDrivingLicenseBack = widget.initialData!['imageDrivingLicenseBack'];
      _imageVehicleRegistration =
          widget.initialData!['imageVehicleRegistration'];
    }
  }

  void _onChanged() {
    widget.onChanged({
      'imageIDCardFront': _imageIDCardFront,
      'imageIDCardBack': _imageIDCardBack,
      'imageDrivingLicenseFront': _imageDrivingLicenseFront,
      'imageDrivingLicenseBack': _imageDrivingLicenseBack,
      'imageVehicleRegistration': _imageVehicleRegistration,
    });
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
                'National ID Card or Passport'.tr(),
                style: w500TextStyle(fontSize: 14.sw),
              ),
              Gap(4.sw),
              Text(
                'Upload clear photos of both sides to verify your identity and ensure compliance.'
                    .tr(),
                style: w300TextStyle(
                  fontSize: 14.sw,
                ),
              ),
              Gap(12.sw),
              Row(
                children: [
                  _buildUploadBox(
                    'Front side'.tr(),
                    isBack: false,
                    image: _imageIDCardFront,
                    onTap: () {
                      ImagePicker()
                          .pickImage(source: ImageSource.camera)
                          .then((value) {
                        if (value != null) {
                          setState(() {
                            _imageIDCardFront = value;
                          });
                          _onChanged();
                        }
                      });
                    },
                  ),
                  Gap(12.sw),
                  _buildUploadBox(
                    'Back side'.tr(),
                    isBack: true,
                    image: _imageIDCardBack,
                    onTap: () {
                      ImagePicker()
                          .pickImage(source: ImageSource.camera)
                          .then((value) {
                        if (value != null) {
                          setState(() {
                            _imageIDCardBack = value;
                          });
                          _onChanged();
                        }
                      });
                    },
                  ),
                ],
              ),
              Gap(24.sw),
              Text(
                'Driving License'.tr(),
                style: w500TextStyle(fontSize: 14.sw),
              ),
              Gap(4.sw),
              Text(
                'Upload both sides to verify your driving ability and license validity.'
                    .tr(),
                style: w300TextStyle(
                  fontSize: 14.sw,
                ),
              ),
              Gap(12.sw),
              Row(
                children: [
                  _buildUploadBox(
                    'Front side'.tr(),
                    isBack: false,
                    image: _imageDrivingLicenseFront,
                    onTap: () {
                      ImagePicker()
                          .pickImage(source: ImageSource.camera)
                          .then((value) {
                        if (value != null) {
                          setState(() {
                            _imageDrivingLicenseFront = value;
                          });
                          _onChanged();
                        }
                      });
                    },
                  ),
                  Gap(12.sw),
                  _buildUploadBox(
                    'Back side'.tr(),
                    isBack: true,
                    image: _imageDrivingLicenseBack,
                    onTap: () {
                      ImagePicker()
                          .pickImage(source: ImageSource.camera)
                          .then((value) {
                        if (value != null) {
                          setState(() {
                            _imageDrivingLicenseBack = value;
                          });
                          _onChanged();
                        }
                      });
                    },
                  ),
                ],
              ),
              Gap(24.sw),
              Text(
                'Vehicle Registration Certificate'.tr(),
                style: w500TextStyle(fontSize: 14.sw),
              ),
              Gap(4.sw),
              Text(
                'Upload to verify your vehicle ownership and ensure safety standards.'
                    .tr(),
                style: w300TextStyle(
                  fontSize: 14.sw,
                ),
              ),
              Gap(12.sw),
              Row(
                children: [
                  _buildUploadBox(
                    'Upload certificate'.tr(),
                    image: _imageVehicleRegistration,
                    onTap: () {
                      ImagePicker()
                          .pickImage(source: ImageSource.camera)
                          .then((value) {
                        if (value != null) {
                          setState(() {
                            _imageVehicleRegistration = value;
                          });
                          _onChanged();
                        }
                      });
                    },
                  ),
                  Gap(12.sw),
                  Spacer(),
                ],
              ),
              Gap(12.sw),
            ],
          ),
        ),
        Gap(32),
      ],
    );
  }

  Widget _buildUploadBox(
    String title, {
    XFile? image,
    bool isBack = false,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null)
              Image.file(
                File(image.path),
                width: double.infinity,
                height: 120.sw,
                fit: BoxFit.fill,
              )
            else
              WidgetAppSVG(
                isBack ? 'cccd_back' : 'cccd_front',
                width: double.infinity,
                height: 120.sw,
                fit: BoxFit.fill,
              ),
            Gap(12.sw),
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
