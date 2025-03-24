import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

const String appName = "Driver-FastshipHu";
const String appCurrency = "EUR";

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

const String socketIOUrl = "http://138.197.136.45:3000";

const String supportPhoneNumber = "+84909090909";
const String supportEmail = "support@fastship.vn";
const String supportAddress = "123 Main St, Anytown, USA";

// Các loại tài khoản trong hệ thống
enum AccountType {
  customer(1),
  driver(2),
  partner(3);

  final int value;
  const AccountType(this.value);

  static AccountType fromValue(int value) {
    return AccountType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => AccountType.customer,
    );
  }

  String get name {
    switch (this) {
      case AccountType.customer:
        return 'Customer'.tr();
      case AccountType.driver:
        return 'Driver'.tr();
      case AccountType.partner:
        return 'Partner'.tr();
    }
  }
}

enum Gender {
  male(1),
  female(2),
  other(3);

  final int value;
  const Gender(this.value);

  static Gender fromValue(int value) {
    return Gender.values.firstWhere(
      (type) => type.value == value,
      orElse: () => Gender.other,
    );
  }

  String get name {
    switch (this) {
      case Gender.male:
        return 'Male'.tr();
      case Gender.female:
        return 'Female'.tr();
      case Gender.other:
        return 'Other'.tr();
    }
  }
}

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

const List<Map> euroCounries = [
  {"name": "Andorra", "code": "AD"},
  {"name": "Albania", "code": "AL"},
  {"name": "Austria", "code": "AT"},
  {"name": "Åland Islands", "code": "AX"},
  {"name": "Bosnia and Herzegovina", "code": "BA"},
  {"name": "Belgium", "code": "BE"},
  {"name": "Bulgaria", "code": "BG"},
  {"name": "Belarus", "code": "BY"},
  {"name": "Switzerland", "code": "CH"},
  {"name": "Cyprus", "code": "CY"},
  {"name": "Czech Republic", "code": "CZ"},
  {"name": "Germany", "code": "DE"},
  {"name": "Denmark", "code": "DK"},
  {"name": "Estonia", "code": "EE"},
  {"name": "Spain", "code": "ES"},
  {"name": "Finland", "code": "FI"},
  {"name": "Faroe Islands", "code": "FO"},
  {"name": "France", "code": "FR"},
  {"name": "United Kingdom", "code": "GB"},
  {"name": "Guernsey", "code": "GG"},
  {"name": "Greece", "code": "GR"},
  {"name": "Croatia", "code": "HR"},
  {"name": "Hungary", "code": "HU"},
  {"name": "Ireland", "code": "IE"},
  {"name": "Isle of Man", "code": "IM"},
  {"name": "Iceland", "code": "IC"},
  {"name": "Italy", "code": "IT"},
  {"name": "Jersey", "code": "JE"},
  {"name": "Liechtenstein", "code": "LI"},
  {"name": "Lithuania", "code": "LT"},
  {"name": "Luxembourg", "code": "LU"},
  {"name": "Latvia", "code": "LV"},
  {"name": "Monaco", "code": "MC"},
  {"name": "Moldova, Republic of", "code": "MD"},
  {"name": "Macedonia, The Former Yugoslav Republic of", "code": "MK"},
  {"name": "Malta", "code": "MT"},
  {"name": "Netherlands", "code": "NL"},
  {"name": "Norway", "code": "NO"},
  {"name": "Poland", "code": "PL"},
  {"name": "Portugal", "code": "PT"},
  {"name": "Romania", "code": "RO"},
  {"name": "Russian Federation", "code": "RU"},
  {"name": "Sweden", "code": "SE"},
  {"name": "Slovenia", "code": "SI"},
  {"name": "Svalbard and Jan Mayen", "code": "SJ"},
  {"name": "Slovakia", "code": "SK"},
  {"name": "San Marino", "code": "SM"},
  {"name": "Ukraine", "code": "UA"},
  {"name": "Holy See (Vatican City State)", "code": "VA"}
];
