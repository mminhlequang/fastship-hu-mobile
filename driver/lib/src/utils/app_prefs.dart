import 'package:network_resources/enums.dart';
import 'dart:io';
import 'dart:convert';

import 'package:network_resources/auth/models/models.dart';
import 'package:network_resources/auth/repo.dart';
import 'package:internal_core/setup/app_base.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/app_constants.dart';

class AppPrefs {
  AppPrefs._();

  static final AppPrefs _instance = AppPrefs._();

  static AppPrefs get instance => _instance;

  late Box _boxData;
  late Box _boxAuth;
  bool _initialized = false;

  Future initialize() async {
    if (_initialized) return;
    if (!kIsWeb) {
      Directory appDocDirectory = await getApplicationDocumentsDirectory();
      Hive.init(appDocDirectory.path);
    }
    _boxData = await Hive.openBox('data');
    _boxAuth = await Hive.openBox(
      'auth',
      encryptionCipher: HiveAesCipher(base64Url.decode(
        const String.fromEnvironment(
          'SECRET_KEY',
          defaultValue: 'jgGYXtQC6hIAROYyI_bbBZu4jFVHiqUICSf8yN2zp_8=',
        ),
      )),
    );
    _initialized = true;
  }

  Stream watch(key) => _boxData.watch(key: key);

  void clear() {
    _boxAuth.deleteAll([
      keyAccessToken,
      keyRefreshToken,
    ]);
    _boxData.deleteAll([
      keyThemeMode,
      keyLanguageCode,
      "user_info",
    ]);
  }

  bool get isDarkTheme => AppPrefs.instance.themeModel == keyThemeModeDark;

  set themeModel(String? value) => _boxData.put(keyThemeMode, value);

  String? get themeModel => _boxData.get(keyThemeMode);

  set languageCode(String? value) => _boxData.put(keyLanguageCode, value);

  String get languageCode => _boxData.get(keyLanguageCode) ?? 'en';

  set dateFormat(String value) => _boxData.put('dateFormat', value);

  String get dateFormat => _boxData.get('dateFormat') ?? 'dd/MM/yyyy';

  set timeFormat(String value) => _boxData.put('timeFormat', value);

  String get timeFormat => _boxData.get('timeFormat') ?? 'HH:mm';

  Future saveAccountToken(ResponseLogin response) async {
    await Future.wait([
      _boxAuth.put(keyAccessToken, response.accessToken),
      _boxAuth.put(keyRefreshToken, response.refreshToken)
    ]);
  }

  dynamic getNormalToken() async {
    var result = await _boxAuth.get(keyAccessToken);
    if (result != null) {
      DateTime? expiryDate = Jwt.getExpiryDate(result.toString());
      if (expiryDate != null &&
          expiryDate.millisecondsSinceEpoch <
              DateTime.now().millisecondsSinceEpoch) {
        String? refresh = await _boxAuth.get(keyRefreshToken);
        if (refresh != null) {
          NetworkResponse response =
              await AuthRepo().refreshToken({"refresh_token": refresh});
          if (response.data?.accessToken != null) {
            result = response.data?.accessToken;
            saveAccountToken(response.data!);
          }
        }
      }
    }
    return result;
  }

  AccountModel? get user {
    final objectString = _boxData.get('user_info');
    if (objectString != null) {
      final jsonMap = jsonDecode(objectString);
      return AccountModel.fromJson(jsonMap);
    }
    return null;
  }

  set user(userInfo) {
    if (userInfo != null) {
      final string = json.encode(userInfo.toJson());
      _boxData.put('user_info', string);
    } else {
      _boxData.delete('user_info');
    }
  }

  String? get currency => _boxData.get('currency') ?? appCurrency;

  set currency(String? value) => _boxData.put('currency', value);

  String? get currencySymbol =>
      _boxData.get('currency_symbol') ?? appCurrencySymbol;

  set currencySymbol(String? value) => _boxData.put('currency_symbol', value);

  bool get autoActiveOnlineStatus =>
      _boxData.get('auto_active_online_status') ?? true;

  set autoActiveOnlineStatus(bool value) =>
      _boxData.put('auto_active_online_status', value);
}
