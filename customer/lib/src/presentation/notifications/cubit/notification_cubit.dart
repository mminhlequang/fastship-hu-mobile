import 'package:app/src/utils/app_get.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/setup/app_utils.dart';
import 'package:network_resources/notification/models/models.dart';
import 'package:network_resources/notification/repo.dart';

part 'notification_state.dart';

NotificationCubit get notificationCubit => findInstance<NotificationCubit>();

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationState(items: [], isLoading: false));

  Future<void> fetchNotifications() async {
    emit(state.copyWith(isLoading: true));
    final response = await NotificationRepo().getNotifications({});
    emit(state.copyWith(isLoading: false, items: response.data));
  }

  Future<void> readAllNotifications() async {
    await NotificationRepo().readAllNotifications();
    emit(state.copyWith(
        items: state.items.map((e) {
      e.isRead = 1;
      return e;
    }).toList()));
  }
}
