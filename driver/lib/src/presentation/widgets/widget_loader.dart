import 'package:app/src/constants/constants.dart';
import 'package:flutter/material.dart';

class WidgetAppLoader extends StatelessWidget {
  const WidgetAppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: appColorPrimary,
        strokeCap: StrokeCap.round,
        valueColor: AlwaysStoppedAnimation<Color>(appColorPrimary),
        backgroundColor: appColorElement,
        strokeWidth: 5.sw,
        trackGap: 1.sw,
      ),
    );
  }
}
