part of 'notification_cubit.dart';

class NotificationState {
  final List<NotificationModel> items;
  final bool isLoading;

  int get unreadCount => items.where((element) => element.isRead == 0).length;

  const NotificationState({
    required this.items,
    required this.isLoading,
  });

  NotificationState copyWith({
    List<NotificationModel>? items,
    bool? isLoading,
  }) {
    return NotificationState(
        items: items ?? this.items, isLoading: isLoading ?? this.isLoading);
  }
}

extension XNotificationModel on NotificationModel {
  void openDetail() {
    appHaptic();
    switch (type) {
      case NotificationModelType.order:
        break;
      case NotificationModelType.promotion:
        break;
      case NotificationModelType.system:
        break;
      case NotificationModelType.transaction:
        break;
      case NotificationModelType.news:
        break;
    }
  }
}
