import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:internal_core/internal_core.dart';
import 'package:internal_core/internal_core.dart';

class WidgetBottomSheetGuideTakePhoto extends StatelessWidget {
  const WidgetBottomSheetGuideTakePhoto({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetAppBottomSheet(
      title: 'Photo Guidelines'.tr(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              20.sw,
              24.sw,
              20.sw,
              20.sw + MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Please ensure:".tr(),
                  style: w500TextStyle(fontSize: 16.sw),
                ),
                Gap(8.sw),
                _buildGuideItem(
                    "Photos are not blurry, dark, or overexposed".tr()),
                _buildGuideItem(
                    "Documents have no missing corners or holes".tr()),
                _buildGuideItem("Documents are original and valid".tr()),
                Gap(16.sw),
                Text(
                  "Unacceptable cases:".tr(),
                  style: w500TextStyle(fontSize: 16.sw),
                ),
                Gap(12.sw),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    _buildGuideItem2("Blurry".tr(), "cccd_error_1"),
                    _buildGuideItem2("Too dark".tr(), "cccd_error_2"),
                    _buildGuideItem2("Cut corners".tr(), "cccd_error_3"),
                  ],
                ),
                Gap(20.sw),
                WidgetAppButtonOK(
                  onTap: () {
                    appHaptic();
                    Navigator.of(context).pop();
                  },
                  label: "I understand".tr(),
                  height: 48.sw,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.sw),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetAppSVG('ic_check_circle_green', width: 20.sw),
          Gap(8.sw),
          Expanded(
            child: Text(
              text,
              style: w300TextStyle(
                fontSize: 14.sw,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideItem2(String text, String image) {
    return Expanded(
      child: Column(
        children: [
          WidgetAssetImage.png(image, width: double.infinity),
          Gap(8.sw),
          Text(
            text,
            style: w300TextStyle(
              fontSize: 14.sw,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class WidgetBottomSheetProcess extends StatefulWidget {
  final ValueNotifier<String> processer;
  final VoidCallback onTryAgain;
  const WidgetBottomSheetProcess(
      {super.key, required this.processer, required this.onTryAgain});

  @override
  State<WidgetBottomSheetProcess> createState() =>
      _WidgetBottomSheetProcessState();
}

class _WidgetBottomSheetProcessState extends State<WidgetBottomSheetProcess> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.sw),
          topRight: Radius.circular(24.sw),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20.sw, 32.sw, 20.sw,
          48.sw + MediaQuery.of(context).viewInsets.bottom),
      child: ValueListenableBuilder(
        valueListenable: widget.processer,
        builder: (context, value, child) {
          print('value: $value');
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: switch (value) {
              'loading' => [
                  WidgetAppSVG(
                    'ic_loading', //TODO: replace
                    width: 72.sw,
                  ),
                  Gap(32.sw),
                  Text(
                    "Processing...",
                    style: w500TextStyle(fontSize: 24.sw),
                  ),
                  Gap(16.sw),
                  Text(
                    "Your profile is being processed.\nPlease wait while we upload your information"
                        .tr(),
                    style: w300TextStyle(fontSize: 14.sw, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  Gap(40.sw),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(appColorPrimary),
                  ),
                ],
              'success' => [
                  WidgetAppSVG(
                    'ic_done',
                    width: 72.sw,
                  ),
                  Gap(32.sw),
                  Text(
                    "Congrats!",
                    style: w500TextStyle(fontSize: 24.sw),
                  ),
                  Gap(16.sw),
                  Text(
                    "Profile added successfully.\nThe FastShip team has received your application and will contact you soon"
                        .tr(),
                    style: w300TextStyle(fontSize: 14.sw, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  Gap(40.sw),
                  WidgetAppButtonOK(
                    label: "Done",
                    onTap: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ],
              'error' => [
                  WidgetAppSVG(
                    'ic_error', //TODO: replace
                    width: 72.sw,
                  ),
                  Gap(32.sw),
                  Text(
                    "Incomplete!",
                    style: w500TextStyle(fontSize: 24.sw),
                  ),
                  Gap(16.sw),
                  Text(
                    "Your profile is not complete yet.\nPlease make sure to fill in all required information to proceed"
                        .tr(),
                    style: w300TextStyle(fontSize: 14.sw, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  Gap(40.sw),
                  Row(
                    spacing: 16.sw,
                    children: [
                      Expanded(
                        child: WidgetAppButtonCancel(
                          label: "Back",
                          onTap: () {
                            Navigator.pop(context, false);
                          },
                        ),
                      ),
                      Expanded(
                        child: WidgetAppButtonOK(
                          label: "Try again",
                          onTap: () {
                            widget.onTryAgain();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              _ => [],
            },
          );
        },
      ),
    );
  }
}
