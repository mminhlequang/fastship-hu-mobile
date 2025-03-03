import 'package:app/src/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:internal_core/internal_core.dart';
import 'package:flutter/material.dart';

class WidgetAppButtonOK extends StatelessWidget {
  final bool enable;
  final bool loading;
  final String label;
  final VoidCallback? onTap;

  const WidgetAppButtonOK({
    super.key,
    this.enable = true,
    this.loading = false,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: !enable || loading ? null : onTap,
        child: Ink(
          height: 52.sw,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: enable ? appColorPrimary : appColorPrimary.withOpacity(0.45),
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
                    style: w400TextStyle(color: Colors.white, fontSize: 18.sw),
                  ),
          ),
        ),
      ),
    );
  }
}
