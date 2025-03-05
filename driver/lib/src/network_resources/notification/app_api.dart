import 'package:app/src/utils/utils.dart';
import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import 'models/models.dart';

class _MyAppEndpoint {
  _MyAppEndpoint._();
  static String notification() => "/api/v1/notification";
  static String notificationDetail() => "/api/v1/notification/detail";
  static String deleteNotification() => "/api/v1/notification/delete";
  static String readAllNotification() => "/api/v1/notification/read_all";
}

abstract class MyAppApi {
  Future<NetworkResponse> getNotifications();
  Future<NetworkResponse> getNotificationDetail(String id);
  Future<NetworkResponse> deleteNotification(String id);
  Future<NetworkResponse> readAllNotifications();
}

class MyAppApiImp extends MyAppApi {
  @override
  Future<NetworkResponse> getNotifications() async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).get(_MyAppEndpoint.notification());
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => NotificationModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getNotificationDetail(String id) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).get('${_MyAppEndpoint.notificationDetail()}/$id');
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => NotificationModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> deleteNotification(String id) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post('${_MyAppEndpoint.deleteNotification()}/$id');
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
        ).post(_MyAppEndpoint.readAllNotification());
        return NetworkResponse.fromResponse(response);
      },
    );
  }
}
