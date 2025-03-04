import 'dart:convert';

import 'package:app/src/constants/constants.dart';
import 'package:app/src/network_resources/driver/repo.dart';
import 'package:app/src/presentation/driver_register/widgets/widget_form_profile_3.dart';
import 'package:app/src/presentation/widgets/widget_search_place_builder.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internal_core/internal_core.dart';
import 'package:gap/gap.dart';
import 'package:app/src/presentation/widgets/widget_textfield.dart';
import 'package:app/src/constants/app_colors.dart';

import 'widget_form_profile_1.dart';
import 'widget_form_profile_2.dart';
import 'widget_form_profile_4.dart';

class WidgetFormProfile extends StatefulWidget {
  const WidgetFormProfile({super.key});

  @override
  State<WidgetFormProfile> createState() => _WidgetFormProfileState();
}

class _WidgetFormProfileState extends State<WidgetFormProfile> {
  //1. personal information
  //2. images: id card, driver license, vehicle registration, vehicle inspection
  //3. emergency contact
  //4. payment method

  int step = 0;
  String get nameStep => switch (step) {
        0 => 'Personal Information',
        1 => 'Documents',
        2 => 'Emergency Contact',
        3 => 'Complete',
        _ => 'Unknown'
      };

  Widget? get actionButton => switch (step) {
        1 => Text(
            "See the guide".tr(),
            style: w300TextStyle(
              fontSize: 14.sw,
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        _ => null,
      };
  Map<String, dynamic> personalInfo = {};
  Map<String, dynamic> idCardImages = {};
  Map<String, dynamic> emergencyContact = {};

  bool get isEnableContinue => switch (step) {
        0 => personalInfo['fullName'] != null &&
            personalInfo['birthday'] != null &&
            personalInfo['gender'] != null &&
            personalInfo['address'] != null,
        1 => idCardImages['imageIDCardFront'] != null &&
            idCardImages['imageIDCardBack'] != null,
        2 => emergencyContact.isNotEmpty,
        _ => true,
      };

  bool _loading = false;
  _updateProfile() async {
    setState(() {
      _loading = true;
    });

    String? urlImage_cccd_before;
    String? urlImage_cccd_after;
    String? urlImage_license_before;
    String? urlImage_license_after;

    // Upload ảnh và lấy URL
    try {
      final futures = await Future.wait([
        if (idCardImages['imageIDCardFront'] != null)
          DriverRepo().uploadFile(
              (idCardImages['imageIDCardFront'] as XFile).path,
              'image_cccd_before'),
        if (idCardImages['imageIDCardBack'] != null)
          DriverRepo().uploadFile(
              (idCardImages['imageIDCardBack'] as XFile).path,
              'image_cccd_after'),
        if (idCardImages['imageDrivingLicenseFront'] != null)
          DriverRepo().uploadFile(
              (idCardImages['imageDrivingLicenseFront'] as XFile).path,
              'image_license_before'),
        if (idCardImages['imageDrivingLicenseBack'] != null)
          DriverRepo().uploadFile(
              (idCardImages['imageDrivingLicenseBack'] as XFile).path,
              'image_license_after'),
      ]);

      // Lưu URL của các ảnh đã upload
      if (idCardImages['imageIDCardFront'] != null) {
        if (futures[0].isSuccess) {
          urlImage_cccd_before = futures[0].data;
        }
      }
      if (idCardImages['imageIDCardBack'] != null) {
        if (futures[1].isSuccess) {
          urlImage_cccd_after = futures[1].data;
        }
      }
      if (idCardImages['imageDrivingLicenseFront'] != null) {
        if (futures[2].isSuccess) {
          urlImage_license_before = futures[2].data;
        }
      }
      if (idCardImages['imageDrivingLicenseBack'] != null) {
        if (futures[3].isSuccess) {
          urlImage_license_after = futures[3].data;
        }
      }
    } catch (e, trace) {
      _loading = false;
      setState(() {});
      print("Error uploading image: $e");
      print("Error uploading image: $trace");
      appShowSnackBar(
          msg: "Error uploading image: $e".tr(),
          context: context,
          type: AppSnackBarType.error);
      return;
    }

    try {
      // Chuẩn bị dữ liệu từ các bước
      final Map<String, dynamic> requestData = {
        // Thông tin cá nhân
        "name": personalInfo['fullName'],
        "sex": personalInfo['gender'],
        "birthday": personalInfo['birthday'],
        "address": (personalInfo['address'] as HereSearchResult).address,

        // Thông tin CCCD
        "image_cccd_before": urlImage_cccd_before,
        "image_cccd_after": urlImage_cccd_after,

        // Thông tin giấy phép lái xe
        "image_license_before": urlImage_license_before,
        "image_license_after": urlImage_license_after,
        // "license": personalInfo['drivingLicenseNumber']  ,

        // Địa chỉ tạm trú
        // "address_temp":
        //     personalInfo['temporaryAddress'] ?? personalInfo['address']  ,

        // Thông tin thuế
        // "is_tax_code": personalInfo['hasTaxCode'] == true ? 1 : 0,
        // "tax_code": personalInfo['taxCode']  ,

        // Thông tin xe
        // "car_id": personalInfo['carId'] ?? 1,

        // Phương thức thanh toán
        // "payment_method": 1,
        // "card_number": "",
        // "card_expires": "",
        // "card_cvv": "",

        // Liên hệ khẩn cấp
        "contacts": jsonEncode(emergencyContact["emergencyContacts"]),
      };

      // Gọi API cập nhật thông tin
      final response = await DriverRepo().updateProfile(requestData);

      if (response.isSuccess) {
        appShowSnackBar(
            msg: "Cập nhật thông tin thành công".tr(),
            context: context,
            type: AppSnackBarType.success);

        // Cập nhật thông tin người dùng trong AuthCubit
        // await authCubit.load(delayRedirect: Duration.zero);
      } else {
        appShowSnackBar(
            msg: response.msg ?? "Cập nhật thông tin thất bại".tr(),
            context: context,
            type: AppSnackBarType.error);
      }
    } catch (e, trace) {
      _loading = false;
      setState(() {});
      appShowSnackBar(
          msg: "Error updating profile: $e".tr(),
          context: context,
          type: AppSnackBarType.error);
      print("Error updating profile: $e");
      print("Error updating profile: $trace");
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget _buildStepper() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          16.sw, 4.sw + context.mediaQueryPadding.top, 16.sw, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  appHaptic();
                  context.pop();
                },
                icon: WidgetAppSVG(
                  'chevron-left',
                  width: 24.sw,
                ),
              ),
              Gap(12.sw),
              Expanded(
                child: Row(
                  spacing: 6.sw,
                  children: List.generate(4, (index) {
                    return Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: index <= step
                              ? appColorPrimary
                              : AppColors.instance.grey5,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        height: 5.sw,
                      ),
                    );
                  }),
                ),
              ),
              Gap(12.sw),
              Opacity(
                opacity: 0,
                child: IconButton(
                  onPressed: null,
                  icon: WidgetAppSVG(
                    'chevron-left',
                    width: 24.sw,
                  ),
                ),
              ),
            ],
          ),
          Gap(4.sw),
          Row(
            children: [
              Expanded(
                child: Text(
                  nameStep,
                  style: w500TextStyle(fontSize: 20.sw),
                ),
              ),
              Gap(12.sw),
              if (actionButton != null) actionButton!,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20.sw, 12.sw, 20.sw, 8.sw + context.mediaQueryPadding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: appColorText.withOpacity(0.1),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: appColorText.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: WidgetAppButtonCancel(
              onTap: () {
                appHaptic();
                if (step > 0) {
                  setState(() {
                    step--;
                  });
                } else {
                  context.pop();
                }
              },
              label: "Back",
              height: 48.sw,
            ),
          ),
          Gap(16.sw),
          Expanded(
            child: WidgetAppButtonOK(
              loading: _loading,
              onTap: () {
                appHaptic();
                if (step < 2) {
                  setState(() {
                    step++;
                  });
                } else {
                  _updateProfile();
                }
              },
              enable: isEnableContinue,
              label: "Continue",
              height: 48.sw,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepper(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.sw),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: switch (step) {
                    0 => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.sw),
                        child: WidgetFormProfile1(onChanged: (data) {
                          setState(() {
                            personalInfo = data;
                          });
                        }),
                      ),
                    1 => WidgetFormProfile2(onChanged: (data) {
                        setState(() {
                          idCardImages = data;
                        });
                      }),
                    2 => WidgetFormProfile3(onChanged: (data) {
                        setState(() {
                          emergencyContact = data;
                        });
                      }),
                    3 => WidgetFormProfile4(onChanged: (data) {
                        (() {});
                      }),
                    _ => SizedBox.shrink(),
                  },
                ),
              ),
            ),
          ),
          _buildBottomNavigation(),
        ],
      ),
    );
  }
}
