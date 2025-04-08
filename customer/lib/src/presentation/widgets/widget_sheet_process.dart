import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:internal_core/internal_core.dart';

enum SheetProcessStatus {
  loading,
  findingDriver,
  success,
  error_payment,
  error_create_order,
  error_no_driver
}

class WidgetBottomSheetProcess extends StatefulWidget {
  final ValueNotifier<SheetProcessStatus> processer;
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
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: switch (value) {
              SheetProcessStatus.loading => [
                  Gap(32.sw),
                  Text(
                    "Processing...".tr(),
                    style: w500TextStyle(fontSize: 24.sw),
                  ),
                  Gap(16.sw),
                  Text(
                    "Calling related APIs to process your order".tr(),
                    style: w300TextStyle(fontSize: 14.sw, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  Gap(40.sw),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(appColorPrimary),
                  ),
                ],
              SheetProcessStatus.findingDriver => [
                  Gap(32.sw),
                  Text(
                    "Finding Driver".tr(),
                    style: w500TextStyle(fontSize: 24.sw),
                  ),
                  Gap(16.sw),
                  Text(
                    "System is finding a suitable driver for your order".tr(),
                    style: w300TextStyle(fontSize: 14.sw, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  Gap(40.sw),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(appColorPrimary),
                  ),
                ],
              SheetProcessStatus.success => [
                  // WidgetAppSVG(
                  //   'ic_done',
                  //   width: 72.sw,
                  // ),
                  Gap(32.sw),
                  Text(
                    "Success!".tr(),
                    style: w500TextStyle(fontSize: 24.sw),
                  ),
                  Gap(16.sw),
                  Text(
                    "Driver has accepted and is picking up your order for delivery"
                        .tr(),
                    style: w300TextStyle(fontSize: 14.sw, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                ],
              SheetProcessStatus.error_create_order => [
                  Gap(32.sw),
                  Text(
                    "Error!".tr(),
                    style: w500TextStyle(fontSize: 24.sw),
                  ),
                  Gap(16.sw),
                  Text(
                    "Unable to create order. Please try again later".tr(),
                    style: w300TextStyle(fontSize: 14.sw, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  Gap(40.sw),
                  Row(
                    spacing: 16.sw,
                    children: [
                      Expanded(
                        child: WidgetButtonCancel(
                          text: "Back".tr(),
                          onPressed: () {
                            appHaptic();
                            Navigator.pop(context, false);
                          },
                        ),
                      ),
                      Expanded(
                        child: WidgetButtonConfirm(
                          text: "Try Again".tr(),
                          onPressed: () {
                            appHaptic();
                            widget.onTryAgain();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              SheetProcessStatus.error_no_driver => [
                  Gap(32.sw),
                  Text(
                    "Error!".tr(),
                    style: w500TextStyle(fontSize: 24.sw),
                  ),
                  Gap(16.sw),
                  Text(
                    "No active drivers available. Please try again later".tr(),
                    style: w300TextStyle(fontSize: 14.sw, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  Gap(40.sw),
                  Row(
                    spacing: 16.sw,
                    children: [
                      Expanded(
                        child: WidgetButtonCancel(
                          text: "Back".tr(),
                          onPressed: () {
                            appHaptic();
                            Navigator.pop(context, false);
                          },
                        ),
                      ),
                      Expanded(
                        child: WidgetButtonConfirm(
                          text: "Try Again".tr(),
                          onPressed: () {
                            appHaptic();
                            widget.onTryAgain();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              SheetProcessStatus.error_payment => [
                  Gap(32.sw),
                  Text(
                    "Payment Error!".tr(),
                    style: w500TextStyle(fontSize: 24.sw),
                  ),
                  Gap(16.sw),
                  Text(
                    "Payment processing failed. Please check your payment method and try again"
                        .tr(),
                    style: w300TextStyle(fontSize: 14.sw, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  Gap(40.sw),
                  Row(
                    spacing: 16.sw,
                    children: [
                      Expanded(
                        child: WidgetButtonCancel(
                          text: "Back".tr(),
                          onPressed: () {
                            appHaptic();
                            Navigator.pop(context, false);
                          },
                        ),
                      ),
                      Expanded(
                        child: WidgetButtonConfirm(
                          text: "Try Again".tr(),
                          onPressed: () {
                            appHaptic();
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
