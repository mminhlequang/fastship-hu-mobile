import 'package:app/src/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:internal_core/internal_core.dart';
import 'package:flutter/material.dart';

double get _height => 52.sw;

class WidgetAppButtonOK extends StatelessWidget {
  final bool enable;
  final bool loading;
  final String label;
  final VoidCallback? onTap;
  final double? height;
  final BorderRadius? borderRadius;

  const WidgetAppButtonOK({
    super.key,
    this.enable = true,
    this.loading = false,
    required this.label,
    this.onTap,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: !enable || loading ? null : onTap,
        child: Ink(
          height: height ?? _height,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(12.sw),
            color: enable ? appColorPrimary : AppColors.instance.grey8,
          ),
          child: Center(
            child: loading
                ? SizedBox(
                    width: 32,
                    height: 32,
                    child: CupertinoActivityIndicator(
                      color: Colors.white,
                      radius: 14,
                    ),
                  )
                : Text(
                    label,
                    style: w400TextStyle(
                        color: enable ? Colors.white : AppColors.instance.grey1,
                        fontSize: 18.sw),
                  ),
          ),
        ),
      ),
    );
  }
}

class WidgetAppButtonCancel extends StatelessWidget {
  final bool enable;
  final bool loading;
  final String label;
  final VoidCallback? onTap;
  final double? height;

  const WidgetAppButtonCancel({
    super.key,
    this.enable = true,
    this.loading = false,
    required this.label,
    this.onTap,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: !enable || loading ? null : onTap,
        child: Ink(
          height: height ?? _height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.sw),
            color: Colors.transparent,
            border: Border.all(
              color:
                  enable ? appColorPrimary : appColorPrimary.withOpacity(0.45),
              width: 1.2,
            ),
          ),
          child: Center(
            child: loading
                ? SizedBox(
                    width: 32,
                    height: 32,
                    child: CupertinoActivityIndicator(
                      color: appColorPrimary,
                      radius: 14,
                    ),
                  )
                : Text(
                    label,
                    style:
                        w400TextStyle(color: appColorPrimary, fontSize: 18.sw),
                  ),
          ),
        ),
      ),
    );
  }
}
 