import 'package:flutter/material.dart';

enum AppEnv { preprod, prod }

abstract class AppPrefsBase {
  static String accessTokenKey = "accessToken";
  static String refreshTokenKey = "refreshToken";
  static String themeModeKey = "themeMode";
  static String themeModeDarkKey = "themeModeDark";
  static String themeModeLightKey = "themeModeLight";
  static String languageCodeKey = "languageCode";

  set languageCode(String? value);
  String? get languageCode;

  set dateFormat(String value);
  String get dateFormat;

  set timeFormat(String value);
  String get timeFormat;
}

abstract class AppColorsBase {
  Color get primary;

  Color get background;

  Color get text;

  Color get error;

  /// green
  Color get green1;
  Color get green2;

  /// grey
  Color get grey1;
  Color get grey2;
  Color get grey3;
  Color get grey4;
  Color get grey5;
  Color get grey6;
  Color get grey7;
  Color get grey8;

  /// yellow
  Color get yellow1;

  /// orange
  Color get orange1;

  /// blue
  Color get blue1;

  Color get element;
  Color get shimmerBaseColor;
  Color get shimmerHighlightColor;
}

class AppTextStyleWrap {
  TextStyle Function(TextStyle style) fontWrap;
  double Function()? fontSize;
  double Function()? height;

  AppTextStyleWrap({
    required this.fontWrap,
    this.height,
    this.fontSize,
  });
}

abstract class PNetworkOptions {
  final String baseUrl;
  final String baseUrlAsset;
  final String? mqttUrl;
  final int? mqttPort;

  String appImageCorrectUrl(String url, {base}) {
    if (url.trim().indexOf('http') != 0) {
      if ((base ?? baseUrlAsset ?? '').endsWith('/')) {
        if (url.startsWith('/')) {
          return (base ?? baseUrlAsset ?? '') + url.substring(1);
        } else {
          return (base ?? baseUrlAsset ?? '') + url;
        }
      } else {
        if (url.startsWith('/')) {
          return (base ?? baseUrlAsset ?? '') + url;
        } else {
          return (base ?? baseUrlAsset ?? '') + '/' + url;
        }
      }
    }
    return url;
  }

  PNetworkOptions({
    required this.baseUrl,
    required this.baseUrlAsset,
    this.mqttUrl,
    this.mqttPort,
  });

  @override
  String toString() {
    return 'PNetworkOptions(baseUrl: $baseUrl, baseUrlAsset: $baseUrlAsset, mqttUrl: $mqttUrl, mqttPort: $mqttPort)';
  }
}

class PNetworkOptionsOther extends PNetworkOptions {
  PNetworkOptionsOther({super.baseUrl = '', super.baseUrlAsset = ''});
}
