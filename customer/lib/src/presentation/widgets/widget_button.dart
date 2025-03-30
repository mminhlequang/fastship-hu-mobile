import 'package:app/src/constants/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:internal_core/internal_core.dart';
import 'package:flutter/material.dart';

class WidgetButtonCancel extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  const WidgetButtonCancel({super.key, required this.onPressed, this.text});

  @override
  Widget build(BuildContext context) {
    return _buildButton(
      text: text ?? 'Cancel'.tr(),
      isOutlined: true,
      onPressed: onPressed,
    );
  }
}

class WidgetButtonConfirm extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;

  final bool isLoading;
  final bool isEnabled;

  const WidgetButtonConfirm(
      {super.key,
      this.text,
      required this.onPressed,
      this.isLoading = false,
      this.isEnabled = true});

  @override
  Widget build(BuildContext context) {
    return _buildButton(
      text: text ?? 'Confirm'.tr(),
      isOutlined: false,
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
    );
  }
}

Widget _buildButton({
  required String text,
  required bool isOutlined,
  required VoidCallback onPressed,
  bool isLoading = false,
  bool isEnabled = true,
}) {
  return GestureDetector(
    onTap: isEnabled
        ? () {
            appHaptic();
            onPressed();
          }
        : null,
    child: Container(
      height: 50.sw,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
            color: isOutlined
                ? hexColor('#DEDEDE')
                : appColorPrimary.withOpacity(isEnabled ? 1 : 0.5)),
        color: isOutlined
            ? Colors.white
            : appColorPrimary.withOpacity(isEnabled ? 1 : 0.5),
      ),
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                text,
                style: w600TextStyle(
                  fontSize: 18.sw,
                  color: isOutlined ? appColorBackground : Colors.white,
                ),
              ),
      ),
    ),
  );
}
