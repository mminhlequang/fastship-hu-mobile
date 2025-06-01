import 'package:app/src/utils/app_get.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/notification/models/models.dart';
import 'package:network_resources/notification/repo.dart';

part 'notification_state.dart';

NotificationCubit get notificationCubit => findInstance<NotificationCubit>();

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationState(items: [], isLoading: false));

  Future<void> fetchNotifications() async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await NotificationRepo().getNotifications({});
      emit(state.copyWith(isLoading: false, items: response.data ?? []));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      debugPrint('Error fetching notifications: $e');
    }
  }

  Future<void> readAllNotifications() async {
    try {
      await NotificationRepo().readAllNotifications();
      final updatedItems = state.items.map((e) {
        e.isRead = 1;
        return e;
      }).toList();
      emit(state.copyWith(items: updatedItems));
    } catch (e) {
      debugPrint('Error marking all notifications as read: $e');
    }
  }

  Future<void> markAsRead(dynamic notificationId) async {
    try {
      // TODO: Implement single notification mark as read API
      // await NotificationRepo().markAsRead(notificationId);

      final updatedItems = state.items.map((item) {
        if (item.id == notificationId ||
            item.id.toString() == notificationId.toString()) {
          item.isRead = 1;
        }
        return item;
      }).toList();

      emit(state.copyWith(items: updatedItems));
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  Future<void> deleteNotification(dynamic notificationId) async {
    try {
      // TODO: Implement delete notification API
      // await NotificationRepo().deleteNotification(notificationId);

      final updatedItems = state.items
          .where((item) =>
              item.id != notificationId &&
              item.id.toString() != notificationId.toString())
          .toList();

      emit(state.copyWith(items: updatedItems));
    } catch (e) {
      debugPrint('Error deleting notification: $e');
    }
  }

  void refreshNotifications() {
    fetchNotifications();
  }
}
