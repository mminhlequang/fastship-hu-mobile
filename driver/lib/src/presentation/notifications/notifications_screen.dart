import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widget_app_tabbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:network_resources/notification/models/models.dart';
import 'package:intl/intl.dart';
import 'package:internal_core/internal_core.dart';

import 'cubit/notification_cubit.dart';
import 'widgets/notification_shimmer.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    notificationCubit.readAllNotifications().then((value) {
      notificationCubit.fetchNotifications();
    });
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColorBackground,
      appBar: AppBar(
        title: Text('Notifications'.tr()),
        elevation: 0,
        backgroundColor: appColorPrimary,
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            bloc: notificationCubit,
            builder: (context, state) {
              final unreadCount = state.unreadCount;
              if (unreadCount > 0) {
                return Padding(
                  padding: EdgeInsets.only(right: 16.sw),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.sw,
                        vertical: 4.sw,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12.sw),
                      ),
                      child: Text(
                        unreadCount > 99 ? '99+' : unreadCount.toString(),
                        style: w500TextStyle(
                          fontSize: 12.sw,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        bloc: notificationCubit,
        builder: (context, state) {
          if (state.isLoading) {
            return const NotificationShimmer();
          }

          final orderNotifications =
              state.items.where((item) => item.type == 'order').toList();
          final allNotifications = state.items;

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.sw),
                topRight: Radius.circular(20.sw),
              ),
            ),
            child: WidgetAppTabBar(
              tabController: _tabController,
              tabs: [
                'Orders'.tr(),
                'All'.tr(),
              ],
              children: [
                _buildNotificationsList(orderNotifications),
                _buildNotificationsList(allNotifications),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build notifications list with pull to refresh
  Widget _buildNotificationsList(List<NotificationModel> notifications) {
    return RefreshIndicator(
      onRefresh: () async {
        await notificationCubit.fetchNotifications();
      },
      color: appColorPrimary,
      child: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 16.sw),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => Gap(8.sw),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _buildNotificationCard(notification);
              },
            ),
    );
  }

  /// Build improved empty state
  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(32.sw),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120.sw,
                height: 120.sw,
                decoration: BoxDecoration(
                  color: grey8,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: 60.sw,
                  color: grey4,
                ),
              ),
              Gap(24.sw),
              Text(
                'No notifications yet'.tr(),
                style: w600TextStyle(
                  fontSize: 18.sw,
                  color: appColorText,
                ),
                textAlign: TextAlign.center,
              ),
              Gap(8.sw),
              Text(
                'You will receive notifications about orders, promotions and system updates here'
                    .tr(),
                style: w400TextStyle(
                  fontSize: 14.sw,
                  color: grey1,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build modern notification card with improved design
  Widget _buildNotificationCard(NotificationModel notification) {
    final isUnread = notification.isRead == 0;
    final timeAgo = _getTimeAgo(notification.createdAt);

    return GestureDetector(
      onTap: () => _onNotificationTap(notification),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isUnread ? appColorPrimary.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16.sw),
          border: Border.all(
            color: isUnread ? appColorPrimary.withOpacity(0.2) : grey8,
            width: 1.sw,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8.sw,
              offset: Offset(0, 2.sw),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _onNotificationTap(notification),
            borderRadius: BorderRadius.circular(16.sw),
            child: Padding(
              padding: EdgeInsets.all(16.sw),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon container
                  Container(
                    width: 48.sw,
                    height: 48.sw,
                    decoration: BoxDecoration(
                      color: _getNotificationColor(notification.type)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.sw),
                    ),
                    child: Icon(
                      notification.icon,
                      size: 24.sw,
                      color: _getNotificationColor(notification.type),
                    ),
                  ),
                  Gap(12.sw),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification.title ?? '',
                                style: w600TextStyle(
                                  fontSize: 16.sw,
                                  color: appColorText,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isUnread)
                              Container(
                                width: 8.sw,
                                height: 8.sw,
                                decoration: BoxDecoration(
                                  color: appColorPrimary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        Gap(4.sw),
                        Text(
                          notification.description ?? '',
                          style: w400TextStyle(
                            fontSize: 14.sw,
                            color: grey1,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Gap(8.sw),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 14.sw,
                              color: grey4,
                            ),
                            Gap(4.sw),
                            Text(
                              timeAgo,
                              style: w400TextStyle(
                                fontSize: 12.sw,
                                color: grey4,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.sw,
                                vertical: 2.sw,
                              ),
                              decoration: BoxDecoration(
                                color: _getNotificationColor(notification.type)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.sw),
                              ),
                              child: Text(
                                _getNotificationTypeLabel(notification.type),
                                style: w500TextStyle(
                                  fontSize: 10.sw,
                                  color:
                                      _getNotificationColor(notification.type),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Get notification color based on type
  Color _getNotificationColor(String? type) {
    switch (type) {
      case 'order':
        return appColorPrimary;
      case 'promotion':
        return orange1;
      case 'system':
        return blue1;
      case 'transaction':
        return green1;
      default:
        return grey1;
    }
  }

  /// Get notification type label
  String _getNotificationTypeLabel(String? type) {
    switch (type) {
      case 'order':
        return 'Order'.tr();
      case 'promotion':
        return 'Promotion'.tr();
      case 'system':
        return 'System'.tr();
      case 'transaction':
        return 'Transaction'.tr();
      default:
        return 'General'.tr();
    }
  }

  /// Get relative time (e.g., "2 hours ago")
  String _getTimeAgo(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'Just now'.tr();
    }

    try {
      final DateTime notificationTime = DateTime.parse(dateString);
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(notificationTime);

      if (difference.inMinutes < 1) {
        return 'Just now'.tr();
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} ${'minutes ago'.tr()}';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} ${'hours ago'.tr()}';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} ${'days ago'.tr()}';
      } else {
        return DateFormat('MMM dd, yyyy').format(notificationTime);
      }
    } catch (e) {
      return dateString;
    }
  }

  /// Handle notification tap
  void _onNotificationTap(NotificationModel notification) {
    // Mark as read if unread
    if (notification.isRead == 0) {
      _markAsRead(notification);
    }

    // Handle navigation based on notification type
    notification.openDetail();
  }

  /// Mark notification as read
  void _markAsRead(NotificationModel notification) {
    if (notification.id != null) {
      notificationCubit.markAsRead(notification.id);
    }
  }
}
