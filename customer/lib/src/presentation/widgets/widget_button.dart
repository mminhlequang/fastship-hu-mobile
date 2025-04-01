import 'package:app/src/constants/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:internal_core/internal_core.dart';
import 'package:flutter/material.dart';

class WidgetButtonCancel extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  const WidgetButtonCancel(
      {super.key, required this.onPressed, this.text, this.width, this.height});
  @override
  Widget build(BuildContext context) {
    return _buildButton(
      text: text ?? 'Cancel'.tr(),
      isOutlined: true,
      onPressed: onPressed,
      width: width,
      height: height,
    );
  }
}

class WidgetButtonConfirm extends StatelessWidget {
  final String? text;
  final double? width;
  final double? height;

  final VoidCallback? onPressed;

  final bool isLoading;
  final bool isEnabled;

  const WidgetButtonConfirm(
      {super.key,
      this.text,
      required this.onPressed,
      this.isLoading = false,
      this.isEnabled = true,
      this.width,
      this.height});

  @override
  Widget build(BuildContext context) {
    return _buildButton(
      text: text ?? 'Confirm'.tr(),
      isOutlined: false,
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      width: width,
      height: height,
    );
  }
}

Widget _buildButton({
  required String text,
  required bool isOutlined,
  required VoidCallback? onPressed,
  bool isLoading = false,
  bool isEnabled = true,
  double? width,
  double? height,
}) {
  return GestureDetector(
    onTap: isEnabled
        ? () {
            appHaptic();
            onPressed?.call();
          }
        : null,
    child: Container(
      width: width,
      height: height ?? 50.sw,
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
                  color: isOutlined ? appColorText2 : Colors.white,
                ),
              ),
      ),
    ),
  );
}
