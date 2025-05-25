import 'package:app/src/presentation/widgets/widget_button.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';
import 'package:app/src/constants/constants.dart';

class WidgetDialogConfirm extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final Widget? asset;
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  const WidgetDialogConfirm({
    super.key,
    required this.title,
    required this.message,
    this.onCancel,
    this.onConfirm,
    this.asset,
    this.confirmText,
    this.cancelText,
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
                  if (asset != null) asset!,
                  Text(
                    title,
                    style: w500TextStyle(
                      fontSize: 24.sw,
                      height: 1.2,
                    ),
                  ),
                  16.h,
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: w400TextStyle(
                      fontSize: 16,
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
                    child: WidgetButtonCancel(
                      onPressed: () {
                        appHaptic();
                        if (onCancel != null) {
                          onCancel?.call();
                        } else {
                          Navigator.pop(context, false);
                        }
                      },
                      text: cancelText,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: WidgetButtonConfirm(
                      onPressed: () {
                        appHaptic();
                        if (onConfirm != null) {
                          onConfirm?.call();
                        } else {
                          Navigator.pop(context, true);
                        }
                      },
                      text: confirmText,
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
