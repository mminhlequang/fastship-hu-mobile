import 'package:internal_core/internal_core.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

Color get appColorPrimary => AppColors.instance.primary;
Color get appColorPrimaryRed => Colors.red;

Color get appColorPrimaryDark => hexColor('12AD2A');
Color get appColorBackground => AppColors.instance.background;
Color get appColorElement => AppColors.instance.element;
Color get appColorText => AppColors.instance.text;
Color get appColorTextLabel => AppColors.instance.text.withOpacity(0.85);
Color get appColorError => AppColors.instance.error;
Color get green1 => AppColors.instance.green1;
Color get green2 => AppColors.instance.green2;
Color get grey1 => AppColors.instance.grey1;
Color get grey2 => AppColors.instance.grey2;
Color get grey3 => AppColors.instance.grey3;
Color get grey4 => AppColors.instance.grey4;
Color get grey5 => AppColors.instance.grey5;
Color get grey6 => AppColors.instance.grey6;
Color get grey7 => AppColors.instance.grey7;
Color get grey8 => AppColors.instance.grey8;
Color get yellow1 => AppColors.instance.yellow1;
Color get orange1 => AppColors.instance.orange1;
Color get blue1 => AppColors.instance.blue1;

class AppColors extends AppColorsBase {
  AppColors._();

  static final AppColors _instance = AppColors._();

  static AppColors get instance => _instance;

  @override
  Color get primary => appValueByTheme(hexColor('#74CA45'));

  @override
  Color get background => appValueByTheme(Colors.white, kdark: Colors.black);

  @override
  Color get text => appValueByTheme(hexColor('#333333'), kdark: Colors.white);

  @override
  Color get error => appValueByTheme(hexColor('#EE4444'));

  @override
  Color get green1 => appValueByTheme(hexColor('#12AD2A'));

  @override
  Color get green2 => appValueByTheme(hexColor('#3EB05C'));

  @override
  Color get grey1 => appValueByTheme(hexColor('#828282'));

  @override
  Color get grey2 => appValueByTheme(hexColor('#F0F0F0'));

  @override
  Color get grey3 => appValueByTheme(hexColor('#E9EDF0'));

  @override
  Color get grey4 => appValueByTheme(hexColor('#B5B5B5'));

  @override
  Color get grey5 => appValueByTheme(hexColor('#DBDEE1'));

  @override
  Color get grey6 => appValueByTheme(hexColor('#F4F4F6'));

  @override
  Color get grey7 => appValueByTheme(hexColor('#D9D9D9'));

  @override
  Color get grey8 => appValueByTheme(hexColor('#F2F2F2'));

  @override
  Color get yellow1 => appValueByTheme(hexColor('#F8C435'));

  @override
  Color get orange1 => appValueByTheme(hexColor('#FFA142'));

  @override
  Color get blue1 => appValueByTheme(hexColor('#0085FF'));

  @override
  Color get element =>
      appValueByTheme(Colors.grey[200]!, kdark: Colors.grey[200]!);

  @override
  Color get shimmerHighlightColor => appValueByTheme(hexColor('#fafafa'));

  @override
  Color get shimmerBaseColor => appValueByTheme(Colors.grey[200]!);
}

appValueByTheme(klight, {kdark}) {
  if (AppPrefs.instance.isDarkTheme) {
    return kdark ?? klight;
  }
  return klight;
}
