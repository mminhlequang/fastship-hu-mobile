import 'package:internal_network/network_resources/resources.dart';

import 'app_api.dart';

class NotificationRepo {
  NotificationRepo._();

  static NotificationRepo? _instance;

  factory NotificationRepo([MyAppApi? api]) {
    _instance ??= NotificationRepo._();
    _instance!._api = api ?? MyAppApiImp();
    return _instance!;
  }

  late MyAppApi _api;

  Future<NetworkResponse> getNotifications() async {
    return await _api.getNotifications();
  }

  Future<NetworkResponse> getNotificationDetail(String id) async {
    return await _api.getNotificationDetail(id);
  }

  Future<NetworkResponse> deleteNotification(String id) async {
    return await _api.deleteNotification(id);
  }

  Future<NetworkResponse> readAllNotifications() async {
    return await _api.readAllNotifications();
  }
}
