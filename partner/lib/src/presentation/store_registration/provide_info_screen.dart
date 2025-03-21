import 'dart:convert';

import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/store_registration/widgets/widget_bottomsheet.dart';
import 'package:app/src/presentation/store_registration/widgets/widget_form_profile_1.dart';
import 'package:app/src/presentation/store_registration/widgets/widget_form_profile_2.dart';
import 'package:app/src/presentation/store_registration/widgets/widget_form_profile_3.dart';
import 'package:app/src/presentation/store_registration/widgets/widget_form_profile_4.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/app_prefs.dart';
import 'package:app/src/utils/app_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internal_core/extensions/context_extension.dart';
import 'package:internal_core/extensions/date_extension.dart';
import 'package:internal_core/setup/app_textstyles.dart';
import 'package:internal_core/setup/app_utils.dart';
import 'package:internal_core/internal_core.dart';
import 'package:app/src/network_resources/auth/models/models.dart';

class ProvideInfoScreen extends StatefulWidget {
  const ProvideInfoScreen({super.key});

  @override
  State<ProvideInfoScreen> createState() => _ProvideInfoScreenState();
}

class _ProvideInfoScreenState extends State<ProvideInfoScreen> {
  List<String> allSteps = [
    'Basic Information'.tr(),
    'Representative Information'.tr(),
    'Bank Information'.tr(),
    'Detail Information'.tr()
  ];
  int step = 0;

  Map<String, dynamic> personalInfo = {};
  Map<String, dynamic> idCardImages = {};
  Map<String, dynamic> emergencyContact = {};

  bool get isEnableContinue => kDebugMode
      ? true
      : switch (step) {
          0 => personalInfo['fullName'] != null &&
              personalInfo['birthday'] != null &&
              personalInfo['gender'] != null &&
              personalInfo['address'] != null,
          1 => kDebugMode
              ? true
              : (idCardImages['imageIDCardFront'] != null &&
                  idCardImages['imageIDCardBack'] != null),
          2 => ((emergencyContact['emergencyContacts'] ?? []) as List).isNotEmpty == true,
          _ => true,
        };

  final ValueNotifier<String> _processor = ValueNotifier('no');

  _updateProfile({bool showBottomSheet = true}) async {
    _processor.value = 'loading';
    if (showBottomSheet) {
      appOpenBottomSheet(
        WidgetBottomSheetProcess(
          processer: _processor,
          onTryAgain: () {
            _updateProfile(showBottomSheet: false);
          },
        ),
        isDismissible: false,
      ).then((r) {
        if (r == true) {
          AccountModel user = AppPrefs.instance.user!;
          user.profile!.stepId = 2;
          AppPrefs.instance.user = user;
          if (mounted) context.pop();
        }
      });
    }

    String? urlImage_cccd_before;
    String? urlImage_cccd_after;
    String? urlImage_license_before;
    String? urlImage_license_after;

    // Upload ảnh và lấy URL
    try {
      // final futures = await Future.wait([
      //   if (idCardImages['imageIDCardFront'] != null)
      //     MerchantRepo()
      //         .uploadFile((idCardImages['imageIDCardFront'] as XFile).path, 'image_cccd_before'),
      //   if (idCardImages['imageIDCardBack'] != null)
      //     MerchantRepo()
      //         .uploadFile((idCardImages['imageIDCardBack'] as XFile).path, 'image_cccd_after'),
      //   if (idCardImages['imageDrivingLicenseFront'] != null)
      //     MerchantRepo().uploadFile(
      //         (idCardImages['imageDrivingLicenseFront'] as XFile).path, 'image_license_before'),
      //   if (idCardImages['imageDrivingLicenseBack'] != null)
      //     MerchantRepo().uploadFile(
      //         (idCardImages['imageDrivingLicenseBack'] as XFile).path, 'image_license_after'),
      // ]);

      // // Lưu URL của các ảnh đã upload
      // if (idCardImages['imageIDCardFront'] != null) {
      //   if (futures[0].isSuccess) {
      //     urlImage_cccd_before = futures[0].data;
      //   }
      // }
      // if (idCardImages['imageIDCardBack'] != null) {
      //   if (futures[1].isSuccess) {
      //     urlImage_cccd_after = futures[1].data;
      //   }
      // }
      // if (idCardImages['imageDrivingLicenseFront'] != null) {
      //   if (futures[2].isSuccess) {
      //     urlImage_license_before = futures[2].data;
      //   }
      // }
      // if (idCardImages['imageDrivingLicenseBack'] != null) {
      //   if (futures[3].isSuccess) {
      //     urlImage_license_after = futures[3].data;
      //   }
      // }
    } catch (e, trace) {
      _processor.value = 'error';
      print('Error uploading image: $e');
      print('Error uploading image: $trace');
      appShowSnackBar(
        msg: 'Error uploading image: $e'.tr(),
        context: context,
        type: AppSnackBarType.error,
      );
      return;
    }

    try {
      // Chuẩn bị dữ liệu từ các bước
      final Map<String, dynamic> requestData = {
        // Thông tin cá nhân
        'name': personalInfo['fullName'],
        'sex': personalInfo['gender'],
        'birthday': (personalInfo['birthday'] as DateTime).formatDate(formatType: 'yyyy-MM-dd'),
        'address': (personalInfo['address'] as HereSearchResult).address,

        // Thông tin CCCD
        'image_cccd_before': urlImage_cccd_before,
        'image_cccd_after': urlImage_cccd_after,

        // Thông tin giấy phép lái xe
        'image_license_before': urlImage_license_before,
        'image_license_after': urlImage_license_after,

        // Liên hệ khẩn cấp
        'contacts': jsonEncode(emergencyContact['emergencyContacts']),

        'step_id': 2,
      };

      // Gọi API cập nhật thông tin
      // final response = await MerchantRepo().updateProfile(requestData);

      // if (response.isSuccess) {
      //   _processor.value = 'success';
      // } else {
      //   _processor.value = 'error';
      //   print(response.msg);
      // }
    } catch (e, trace) {
      _processor.value = 'error';

      print('Error updating profile: $e, $trace');
    }
  }

  Widget _buildStepper() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: 8.sw,
        right: 24.sw,
        top: 4.sw + context.mediaQueryPadding.top,
        bottom: 20.sw,
      ),
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
                icon: WidgetAppSVG('chevron-left', width: 24.sw),
              ),
              Gap(12.sw),
              Expanded(
                child: Row(
                  spacing: 8.sw,
                  children: List.generate(
                    allSteps.length,
                    (index) {
                      return Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: index <= step ? appColorPrimary : grey7,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          height: 5.sw,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Gap(8.sw),
          Padding(
            padding: EdgeInsets.only(left: 8.sw),
            child: Text(
              allSteps[step],
              style: w500TextStyle(fontSize: 18.sw),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: appHideKeyboard,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepper(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: switch (step) {
                    0 => WidgetFormProfile1(
                        initialData: personalInfo,
                        onChanged: (data) {
                          setState(() {
                            personalInfo = data;
                          });
                        },
                      ),
                    1 => WidgetFormProfile2(
                        initialData: idCardImages,
                        onChanged: (data) {
                          setState(() {
                            idCardImages = data;
                          });
                        },
                      ),
                    2 => WidgetFormProfile3(
                        initialData: emergencyContact,
                        onChanged: (data) {
                          setState(() {
                            emergencyContact = data;
                          });
                        },
                      ),
                    _ => WidgetFormProfile4(),
                  },
                ),
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.sw, 10.sw, 16.sw, 10.sw + context.mediaQueryPadding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: appColorBackground)),
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
              label: 'Back'.tr(),
              height: 48.sw,
            ),
          ),
          Gap(10.sw),
          Expanded(
            child: WidgetAppButtonOK(
              loading: _processor.value == 'loading',
              onTap: () {
                appHaptic();
                if (step < 3) {
                  setState(() {
                    step++;
                  });
                } else {
                  _updateProfile();
                }
              },
              enable: isEnableContinue,
              label: 'Continue'.tr(),
              height: 48.sw,
            ),
          ),
        ],
      ),
    );
  }
}
