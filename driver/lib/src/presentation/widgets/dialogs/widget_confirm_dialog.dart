import 'dart:ui';

import 'package:app/src/constants/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';

class WidgetConfirmDialog extends StatelessWidget {
  const WidgetConfirmDialog({
    super.key,
    required this.title,
    required this.subTitle,
    required this.onConfirm,
    this.onCancel,
  });

  final String title;
  final String subTitle;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Center(
        child: Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: context.width - 112.sw,
            padding: EdgeInsets.all(20.sw),
            constraints: BoxConstraints(maxWidth: 264.sw),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: w600TextStyle(fontSize: 16.sw),
                ),
                Gap(4.sw),
                Text(
                  subTitle,
                  style: w400TextStyle(color: grey1),
                  textAlign: TextAlign.center,
                ),
                Gap(12.sw),
                Row(
                  children: [
                    Expanded(
                      child: WidgetRippleButton(
                        onTap: () {
                          Navigator.of(context).pop();
                          onConfirm.call();
                        },
                        radius: 8,
                        border: Border.all(color: appColorPrimary),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.sw),
                          child: Center(
                            child: Text(
                              'Yes'.tr(),
                              style: w500TextStyle(
                                fontSize: 16.sw,
                                color: appColorPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Gap(10.sw),
                    Expanded(
                      child: WidgetRippleButton(
                        onTap: () {
                          Navigator.of(context).pop();
                          onCancel?.call();
                        },
                        radius: 8,
                        color: appColorPrimary,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.sw),
                          child: Center(
                            child: Text(
                              'Go back'.tr(),
                              style: w500TextStyle(
                                fontSize: 16.sw,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
