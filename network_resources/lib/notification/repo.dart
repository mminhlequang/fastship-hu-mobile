import 'package:internal_network/network_resources/resources.dart';

import 'app_api.dart';

class NotificationRepo {
  NotificationRepo._();

  static NotificationRepo? _instance;

  factory NotificationRepo([NotificationApi? api]) {
    _instance ??= NotificationRepo._();
    _instance!._api = api ?? NotificationApiImp();
    return _instance!;
  }

  late NotificationApi _api;

  Future<NetworkResponse> getNotifications(Map<String, dynamic> params) async {
    return await _api.getNotifications(params);
  }

  Future<NetworkResponse> getNotificationDetail(int id) async {
    return await _api.getNotificationDetail(id);
  }

  Future<NetworkResponse> deleteNotification(int id) async {
    return await _api.deleteNotification(id);
  }

  Future<NetworkResponse> readAllNotifications() async {
    return await _api.readAllNotifications();
  }
}
