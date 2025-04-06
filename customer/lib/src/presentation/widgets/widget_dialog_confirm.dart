import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';
import 'package:app/src/constants/constants.dart';

class WidgetDialogConfirm extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final String title;
  final String message;
  const WidgetDialogConfirm({
    super.key,
    required this.title,
    required this.message,
    this.onCancel,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: context.width * 0.85,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 50,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  Text(
                    title,
                    style: w500TextStyle(
                      fontSize: 32,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: w400TextStyle(
                      fontSize: 18,
                      height: 1.4,
                      color: appColorText2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        appHaptic();
                        if (onCancel != null) {
                          onCancel?.call();
                        } else {
                          Navigator.pop(context, false);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 19,
                        ),
                        decoration: BoxDecoration(
                          color: appColorPrimary,
                          borderRadius: BorderRadius.circular(120),
                        ),
                        child: Text(
                          'Cancel'.tr(),
                          textAlign: TextAlign.center,
                          style: w400TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        appHaptic();
                        if (onConfirm != null) {
                          onConfirm?.call();
                        } else {
                          Navigator.pop(context, true);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 19,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(120),
                          border: Border.all(
                            color: appColorBorder,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Confirm'.tr(),
                          textAlign: TextAlign.center,
                          style: w400TextStyle(
                            fontSize: 18,
                            color: appColorText,
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
    );
  }
}
