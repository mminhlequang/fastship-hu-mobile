import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widget_loading_wrapper.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:internal_core/internal_core.dart';

enum SheetProcessStatus {
  loading,
  findingDriver,
  findingDriverSuccess,
  createPickupSuccess,
  error_payment,
  error_create_order,
  error_no_driver;

  dynamic getIcon() {
    switch (this) {
      case SheetProcessStatus.loading:
        return WidgetAppLoader();
      case SheetProcessStatus.createPickupSuccess:
        return WidgetAssetImage.png('image3', width: 100.sw, height: 100.sw);
      case SheetProcessStatus.findingDriverSuccess:
        return 'icon56';
      case SheetProcessStatus.findingDriver:
        return 'icon87';

      case SheetProcessStatus.error_payment:
        return 'icon84';
      case SheetProcessStatus.error_create_order:
        return 'icon83';
      case SheetProcessStatus.error_no_driver:
        return 'icon82';
    }
  }

  String get text1 {
    switch (this) {
      case SheetProcessStatus.loading:
        return 'Processing...';
      case SheetProcessStatus.findingDriver:
        return 'Finding Driver';
      case SheetProcessStatus.createPickupSuccess:
        return 'Success!';
      case SheetProcessStatus.findingDriverSuccess:
        return 'Success!';
      case SheetProcessStatus.error_payment:
        return 'Payment Error!';
      case SheetProcessStatus.error_create_order:
        return 'Order creation failed!';
      case SheetProcessStatus.error_no_driver:
        return 'No active drivers available!';
      default:
        return '';
    }
  }

  String get text2 {
    switch (this) {
      case SheetProcessStatus.loading:
        return 'We are processing your order'.tr();
      case SheetProcessStatus.findingDriver:
        return 'We are finding a suitable driver for your order'.tr();
      case SheetProcessStatus.createPickupSuccess:
        return 'Your order has been created successfully'.tr();
      case SheetProcessStatus.findingDriverSuccess:
        return 'Driver has accepted and is picking up your order for delivery'
            .tr();
      case SheetProcessStatus.error_payment:
        return 'Payment processing failed. Please check your payment method and try again'
            .tr();
      case SheetProcessStatus.error_create_order:
        return 'Oops! Unable to create your order. Please try again later'.tr();
      case SheetProcessStatus.error_no_driver:
        return 'All drivers are busy. We also enable to pick up your self if possible. Thank you for your understanding'
            .tr();
    }
  }
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
            children: [
              Gap(40.sw),
              value.getIcon() is Widget
                  ? value.getIcon()
                  : WidgetAppSVG(
                      value.getIcon(),
                      width: 86.sw,
                    ),
              Gap(32.sw),
              Text(
                value.text1,
                style: w500TextStyle(fontSize: 24.sw),
              ),
              Gap(16.sw),
              Text(
                value.text2,
                style: w300TextStyle(fontSize: 14.sw, height: 1.4),
                textAlign: TextAlign.center,
              ),
              if (value.index > 3) ...[
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
              ]
            ],
          );
        },
      ),
    );
  }
}
