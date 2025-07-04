import 'package:app/src/base/bloc.dart';
import 'package:app/src/utils/app_get.dart';
import 'package:app/src/utils/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/notification/models/models.dart';
import 'package:network_resources/notification/repo.dart';

part 'notification_state.dart';

NotificationCubit get notificationCubit => findInstance<NotificationCubit>();

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationState(items: [], isLoading: false));

  Future<void> fetchNotifications() async {
    emit(state.copyWith(isLoading: true));
    final response = await NotificationRepo().getNotifications({
      "store_id": authCubit.storeId,
      "limit": 500,
    });
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
