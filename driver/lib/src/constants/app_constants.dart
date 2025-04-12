import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

const String appName = "Driver-FastshipHu";
const String appCurrency = "EUR";
const String appCurrencySymbol = "€";

const String appHotlineNumber = "19008028";
const String appMessengerUrl = "https://m.me/fastship.vn";
const String appWhatsappUrl = "https://wa.me/84909090909";

String get appMapUrlTemplate =>
    kDebugMode ? appMapUrlTemplateGg : appMapUrlTemplateHERE;

const String hereMapApiKey = "HxCn0uXDho1pV2wM59D_QWzCgPtWB_E5aIiqIdnBnV0";
String get appMapUrlTemplateHERE =>
    "https://maps.hereapi.com/v3/base/mc/{z}/{x}/{y}/png8?lang=${AppPrefs.instance.languageCode}&size=256&style=lite.day&apiKey=$hereMapApiKey";
const String appMapUrlTemplateGg =
    "https://mt.google.com/vt/lyrs=m&hl=en&x={x}&y={y}&z={z}";

const String socketIOUrl =
    kDebugMode ? "http://192.168.1.8:3000" : 
    "http://138.197.136.45:3000";

const String supportPhoneNumber = "+84909090909";
const String supportEmail = "support@fastship.vn";
const String supportAddress = "123 Main St, Anytown, USA";
 
enum EmergencyContactType {
  family(1),
  friend(2),
  colleague(3),
  other(4);

  final int value;
  const EmergencyContactType(this.value);

  static EmergencyContactType fromValue(int value) {
    return EmergencyContactType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => EmergencyContactType.other,
    );
  }

  String get name {
    switch (this) {
      case EmergencyContactType.family:
        return 'Family'.tr();
      case EmergencyContactType.friend:
        return 'Friend'.tr();
      case EmergencyContactType.colleague:
        return 'Colleague'.tr();
      case EmergencyContactType.other:
        return 'Other'.tr();
    }
  }
}
 