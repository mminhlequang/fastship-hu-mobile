import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

const String appName = "Driver-FastshipHu";

const String appHotlineNumber = "19008028";
const String appMessengerUrl = "https://m.me/fastship.vn";
const String appWhatsappUrl = "https://wa.me/84909090909";

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
