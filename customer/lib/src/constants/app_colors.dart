import 'package:internal_core/internal_core.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

Color get appColorBackground => AppColors.instance.background;

Color get appColorBackground3 => AppColors.instance.background3;
Color get appColorElement => AppColors.instance.element;

Color get appColorPrimary => AppColors.instance.primary;
Color get appColorPrimaryOrange => hexColor('#F17228');
Color get appColorPrimaryRed => hexColor('#FF0000');

Color get appColorText => AppColors.instance.text;

Color get appColorText2 => AppColors.instance.text2;
Color get appColorBorder => hexColor('#EEEEEE');
Color get appColorBorder2 => hexColor('#CEC6C5');

class AppColors {
  AppColors._();

  static final AppColors _instance = AppColors._();

  static AppColors get instance => _instance;

  Color get text => appValueByTheme(hexColor('#0B0B0B'), kdark: Colors.white);

  Color get text2 => appValueByTheme(hexColor('#54535A'), kdark: Colors.white);

  Color get background => appValueByTheme(Colors.white, kdark: Colors.black);
  Color get background3 => hexColor('F9F8F6');

  Color get element =>
      appValueByTheme(Colors.grey[200]!, kdark: Colors.grey[200]!);

  Color get primary => appValueByTheme(hexColor('74CA45'));

  Color get shimmerHighlightColor => appValueByTheme(Colors.grey[100]!);

  Color get shimmerBaseColor => appValueByTheme(Colors.grey[300]!);

  Color get hoverColor =>
      appValueByTheme(hexColor('#F5F5F5'), kdark: hexColor('#2C2C2C'));
}

appValueByTheme(klight, {kdark}) {
  if (AppPrefs.instance.isDarkTheme) {
    return kdark ?? klight;
  }
  return klight;
}
