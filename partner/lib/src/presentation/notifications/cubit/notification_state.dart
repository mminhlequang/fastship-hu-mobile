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
  IconData get icon {
    switch (type) {
      case NotificationModelType.order:
        return Icons.delivery_dining_rounded;
      case NotificationModelType.promotion:
        return Icons.local_offer_rounded;
      case NotificationModelType.system:
        return Icons.info_rounded;
      case NotificationModelType.transaction:
        return Icons.credit_card_rounded;
      case NotificationModelType.news:
        return Icons.notifications_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  void openDetail() {
    print('openDetail: ${toJson()}');
    appHaptic();
    switch (type) {
      case NotificationModelType.order:
        appContext.push('/detail-order', extra: referenceId);
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
