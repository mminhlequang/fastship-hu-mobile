import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widget_app_tabbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:network_resources/notification/models/models.dart';

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
      appBar: AppBar(title: Text('Notifications'.tr())),
      body: BlocBuilder<NotificationCubit, NotificationState>(
          bloc: notificationCubit,
          builder: (context, state) {
            if (state.isLoading) {
              return const NotificationShimmer();
            }

            final orderNotifications =
                state.items.where((item) => item.type == 'order').toList();
            final allNotifications = state.items;

            return WidgetAppTabBar(
              tabController: _tabController,
              tabs: ['Orders'.tr(), 'All'.tr()],
              children: [
                _buildNewsList(orderNotifications),
                _buildFollowList(allNotifications),
              ],
            );
          }),
    );
  }

  Widget _buildNewsList(List<NotificationModel> notifications) {
    if (notifications.isEmpty) {
      return Center(
        child: Text(
          'No order notifications'.tr(),
          style: TextStyle(
            fontSize: 16.sw,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => Gap(4.sw),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return Card(
          color: notification.isRead == 1 ? Colors.white : Colors.grey[100],
          child: Padding(
            padding: EdgeInsets.all(16.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title ?? '',
                  style: TextStyle(
                    fontSize: 16.sw,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(8.sw),
                Text(
                  notification.content ?? '',
                  style: TextStyle(
                    fontSize: 14.sw,
                    color: Colors.grey[600],
                  ),
                ),
                Gap(8.sw),
                Text(
                  notification.createdAt ?? '',
                  style: TextStyle(
                    fontSize: 12.sw,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFollowList(List<NotificationModel> notifications) {
    if (notifications.isEmpty) {
      return Center(
        child: Text(
          'No notifications'.tr(),
          style: TextStyle(
            fontSize: 16.sw,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => Gap(4.sw),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return Card(
          color: notification.isRead == 1 ? Colors.white : Colors.grey[100],
          child: Padding(
            padding: EdgeInsets.all(16.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title ?? '',
                  style: TextStyle(
                    fontSize: 16.sw,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(8.sw),
                Text(
                  notification.content ?? '',
                  style: TextStyle(
                    fontSize: 14.sw,
                    color: Colors.grey[600],
                  ),
                ),
                Gap(8.sw),
                Text(
                  notification.createdAt ?? '',
                  style: TextStyle(
                    fontSize: 12.sw,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
