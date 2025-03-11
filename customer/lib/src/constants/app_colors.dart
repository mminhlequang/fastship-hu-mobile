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

// Màu chính của ứng dụng
const Color appGreenColor = Color(0xFF4CAF50);
const Color appLightGreenColor = Color(0xFF8BC34A);
const Color appRedColor = Color(0xFFE53935);
const Color appBlueColor = Color(0xFF2196F3);
const Color appGreyColor = Color(0xFF9E9E9E);
const Color appLightGreyColor = Color(0xFFE0E0E0);
const Color appBackgroundColor = Color(0xFFF5F5F5);

// Màu gradient cho các nút và header
const List<Color> appGreenGradient = [
  Color(0xFF66BB6A),
  Color(0xFF4CAF50),
];

const List<Color> appRedGradient = [
  Color(0xFFEF5350),
  Color(0xFFE53935),
];

// Màu text
const Color appTextDarkColor = Color(0xFF212121);
const Color appTextMediumColor = Color(0xFF424242);
const Color appTextLightColor = Color(0xFF757575);

// Màu border và divider
const Color appBorderColor = Color(0xFFE0E0E0);
const Color appDividerColor = Color(0xFFEEEEEE);

// Shadow
const Color appShadowColor = Color(0x40000000);

// Màu trạng thái đơn hàng
const Color appOrderAcceptedColor = Color(0xFF4CAF50); // Đã nhận
const Color appOrderDeliveryColor = Color(0xFF2196F3); // Đang giao
const Color appOrderCompletedColor = Color(0xFF8BC34A); // Hoàn thành
const Color appOrderCanceledColor = Color(0xFFE53935); // Đã hủy
const Color appOrderPendingColor = Color(0xFFFF9800); // Chờ xác nhận
