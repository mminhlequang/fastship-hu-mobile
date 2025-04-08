import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';
import 'package:app/src/constants/constants.dart';

class WidgetDialogNotification extends StatelessWidget {
  final String? icon;
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;
  const WidgetDialogNotification({
    super.key,
    this.icon,
    required this.title,
    required this.message,
    required this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
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
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null)
                  WidgetAppSVG(
                    icon!,
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: w700TextStyle(fontSize: 18.sw),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  message,
                  style: w400TextStyle(fontSize: 14.sw, height: 1.4),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      appHaptic();
                      if (onPressed != null) {
                        onPressed!();
                      } else {
                        context.pop();
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: appColorPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(120),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: w600TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
