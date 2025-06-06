import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widget_loading_wrapper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:internal_core/internal_core.dart';
import 'package:flutter/material.dart';

class WidgetButtonCancel extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final Color? color;
  final double? borderRadius;
  const WidgetButtonCancel({
    super.key,
    required this.onPressed,
    this.text,
    this.width,
    this.height,
    this.color,
    this.borderRadius,
  });
  @override
  Widget build(BuildContext context) {
    return _buildButton(
      text: text ?? 'Cancel'.tr(),
      isOutlined: true,
      onPressed: onPressed,
      width: width,
      height: height,
      color: color,
      borderRadius: borderRadius,
    );
  }
}

class WidgetButtonConfirm extends StatelessWidget {
  final String? text;
  final double? width;
  final double? height;
  final Color? color;
  final double? borderRadius;

  final VoidCallback? onPressed;

  final bool isLoading;
  final bool isEnabled;

  const WidgetButtonConfirm({
    super.key,
    this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.color,
    this.borderRadius,
  });

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
      color: color,
      borderRadius: borderRadius,
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
  Color? color,
  double? borderRadius,
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
      height: height ?? 48.sw,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 26),
        border: !isEnabled
            ? Border()
            : Border.all(
                color: isOutlined
                    ? hexColor('#DEDEDE')
                    : (color ?? appColorPrimary)),
        color: isOutlined
            ? Colors.white
            : (color ?? appColorPrimary).withOpacity(isEnabled ? 1 : 0.25),
      ),
      child: Center(
        child: isLoading
            ? SizedBox(
                width: 28.sw,
                height: 28.sw,
                child: WidgetAppLoader(),
              )
            : Text(
                text,
                style: w600TextStyle(
                  fontSize: 18.sw,
                  color: isOutlined
                      ? appColorText2
                      : Colors.white.withOpacity(isEnabled ? 1 : .65),
                ),
              ),
      ),
    ),
  );
}
