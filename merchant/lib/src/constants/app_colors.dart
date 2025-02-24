import 'package:internal_core/internal_core.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

Color get appColorBackground => AppColors.instance.background;

Color get appColorElement => AppColors.instance.element;

Color get appColorPrimary => AppColors.instance.primary;

Color get appColorText => AppColors.instance.text;

class AppColors extends AppColorsBase {
  AppColors._();

  static final AppColors _instance = AppColors._();

  static AppColors get instance => _instance;

  @override
  Color get text => appValueByTheme(Colors.black, kdark: Colors.white);

  @override
  Color get background => appValueByTheme(Colors.white, kdark: Colors.black);

  @override
  Color get element =>
      appValueByTheme(Colors.grey[200]!, kdark: Colors.grey[200]!);

  @override
  Color get primary => appValueByTheme(hexColor('00BDF9'));

  @override
  Color get shimerHighlightColor => appValueByTheme(hexColor('#1C222C'));

  @override
  Color get shimmerBaseColor => appValueByTheme(hexColor('#1C222C'));
}

appValueByTheme(klight, {kdark}) {
  if (AppPrefs.instance.isDarkTheme) {
    return kdark ?? klight;
  }
  return klight;
}
