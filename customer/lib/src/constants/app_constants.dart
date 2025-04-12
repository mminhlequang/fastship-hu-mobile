import 'package:app/src/utils/utils.dart';
import 'package:flutter/foundation.dart';

const String appName = "FastshipHu";
const String appCurrency = "EUR";
const String appCurrencySymbol = "€";

String get appMapUrlTemplate =>
    kDebugMode ? appMapUrlTemplateGg : appMapUrlTemplateHERE;

const String hereMapApiKey = "HxCn0uXDho1pV2wM59D_QWzCgPtWB_E5aIiqIdnBnV0";
String get appMapUrlTemplateHERE =>
    "https://maps.hereapi.com/v3/base/mc/{z}/{x}/{y}/png8?lang=${AppPrefs.instance.languageCode}&size=256&style=lite.day&apiKey=$hereMapApiKey";
const String appMapUrlTemplateGg =
    "https://mt.google.com/vt/lyrs=m&hl=en&x={x}&y={y}&z={z}";

const String socketIOUrl =
    kDebugMode ? "http://192.168.1.7:3000" : 
    "http://138.197.136.45:3000";
