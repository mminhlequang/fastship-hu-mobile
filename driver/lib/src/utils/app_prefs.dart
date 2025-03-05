import 'dart:io';
import 'dart:convert';

import 'package:app/src/network_resources/auth/repo.dart';
import 'package:internal_core/setup/app_base.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:path_provider/path_provider.dart';

import '../network_resources/auth/models/models.dart';

class AppPrefs extends AppPrefsBase {
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
      AppPrefsBase.accessTokenKey,
      AppPrefsBase.refreshTokenKey,
    ]);
    _boxData.deleteAll([
      AppPrefsBase.themeModeKey,
      AppPrefsBase.languageCodeKey,
      "user_info",
    ]);
  }

  bool get isDarkTheme =>
      AppPrefs.instance.themeModel == AppPrefsBase.themeModeDarkKey;

  set themeModel(String? value) =>
      _boxData.put(AppPrefsBase.themeModeKey, value);

  String? get themeModel => _boxData.get(AppPrefsBase.themeModeKey);

  @override
  set languageCode(String? value) =>
      _boxData.put(AppPrefsBase.languageCodeKey, value);

  @override
  String get languageCode => _boxData.get(AppPrefsBase.languageCodeKey) ?? 'en';

  @override
  set dateFormat(String value) => _boxData.put('dateFormat', value);

  @override
  String get dateFormat => _boxData.get('dateFormat') ?? 'dd/MM/yyyy';

  @override
  set timeFormat(String value) => _boxData.put('timeFormat', value);

  @override
  String get timeFormat => _boxData.get('timeFormat') ?? 'HH:mm';

  Future saveAccountToken(ResponseLogin response) async {
    await Future.wait([
      _boxAuth.put(AppPrefsBase.accessTokenKey, response.accessToken),
      _boxAuth.put(AppPrefsBase.refreshTokenKey, response.refreshToken)
    ]);
  }

  dynamic getNormalToken() async {
    var result = await _boxAuth.get(AppPrefsBase.accessTokenKey);
    if (result != null) {
      DateTime? expiryDate = Jwt.getExpiryDate(result.toString());
      if (expiryDate != null &&
          expiryDate.millisecondsSinceEpoch <
              DateTime.now().millisecondsSinceEpoch) {
        String? refresh = await _boxAuth.get(AppPrefsBase.refreshTokenKey);
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
}
