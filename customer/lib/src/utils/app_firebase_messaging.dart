import 'package:app/src/utils/app_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:internal_core/internal_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:network_resources/auth/repo.dart';

import '../presentation/widgets/widget_dialog_confirm.dart';

Future<void> backgroundMessageHandler(RemoteMessage message) async {}
String? fcmToken;

class FirebaseCloudMessaging {
  static final FirebaseMessaging instance = FirebaseMessaging.instance;

  static initFirebaseMessaging() async {
    FirebaseMessaging.onMessage.listen((message) {
      appDebugPrint("OnMessage: ${message.toMap()}");
      _handler(message, onlyShow: true);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      appDebugPrint("OnMessageOpenedApp: ${message.toMap()}");
      _handler(message);
    });
    RemoteMessage? initMessage = await instance.getInitialMessage();
    if (initMessage != null) {
      _handler(initMessage);
    }

    await permission();
  }

  static permission() async {
    NotificationSettings setting = await instance.getNotificationSettings();
    if (setting.authorizationStatus != AuthorizationStatus.authorized) {
      final r = await appOpenDialog(WidgetDialogConfirm(
        asset: Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: WidgetAppSVG(
            'icon88',
            height: 100,
          ),
        ),
        title: "Would you like to receive notifications from us?".tr(),
        message: "To receive news, promotions or important updates".tr(),
        confirmText: "Allow".tr(),
        cancelText: "Deny".tr(),
      ));
      if (r == true) {
        setting = await instance.requestPermission();
      }
    }

    if (setting.authorizationStatus == AuthorizationStatus.authorized) {
      fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null && (await appPrefs.getNormalToken()) != null) {
        AuthRepo().updateDeviceToken({"device_token": fcmToken});
      }
    }
  }

  static _handler(RemoteMessage message, {bool onlyShow = false}) {
    if (onlyShow) {
    } else {}
  }
}
