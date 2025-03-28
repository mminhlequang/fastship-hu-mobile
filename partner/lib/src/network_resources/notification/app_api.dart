import 'package:app/src/utils/utils.dart';
import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import 'models/models.dart';

class _NotificationEndpoint {
  _NotificationEndpoint._();
  static String getNotifications() => "/api/v1/notification/get_notifications";
  static String getNotificationDetail() => "/api/v1/notification/detail";
  static String deleteNotification() => "/api/v1/notification/delete";
  static String readAllNotifications() => "/api/v1/notification/read_all";
}

abstract class NotificationApi {
  Future<NetworkResponse> getNotifications(Map<String, dynamic> params);
  Future<NetworkResponse> getNotificationDetail(int id);
  Future<NetworkResponse> deleteNotification(int id);
  Future<NetworkResponse> readAllNotifications();
}

class NotificationApiImp extends NotificationApi {
  @override
  Future<NetworkResponse> getNotifications(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).get(_NotificationEndpoint.getNotifications(),
            queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) =>
              (json as List).map((e) => NotificationModel.fromJson(e)).toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getNotificationDetail(int id) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).get(_NotificationEndpoint.getNotificationDetail(),
            queryParameters: {'id': id});
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => NotificationModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> deleteNotification(int id) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_NotificationEndpoint.deleteNotification(), data: {'id': id});
        return NetworkResponse.fromResponse(response);
      },
    );
  }

  @override
  Future<NetworkResponse> readAllNotifications() async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_NotificationEndpoint.readAllNotifications());
        return NetworkResponse.fromResponse(response);
      },
    );
  }
}
