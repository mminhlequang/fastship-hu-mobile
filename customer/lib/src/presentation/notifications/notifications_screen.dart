import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widget_appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/notification/models/models.dart';

import 'cubit/notification_cubit.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    notificationCubit.fetchNotifications().then((value) {
      if (notificationCubit.state.unreadCount > 0) {
        notificationCubit.readAllNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexColor('#F4F4F4'),
      body: BlocBuilder<NotificationCubit, NotificationState>(
          bloc: notificationCubit,
          builder: (context, state) {
            return Column(
              children: [
                WidgetAppBar(
                  title: 'Notification'.tr() +
                      (state.unreadCount > 0 ? ' (${state.unreadCount})' : ''),
                ),
                Expanded(
                  child: state.isLoading
                      ? _buildShimmerState()
                      : state.items.isEmpty
                          ? Center(
                              child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                WidgetAppSVG(
                                  'icon8',
                                  width: 167,
                                  height: 167,
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Empty'.tr(),
                                  style: w500TextStyle(
                                    fontSize: 24,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'You don\'t have any notifications at this time'
                                      .tr(),
                                  textAlign: TextAlign.center,
                                  style: w400TextStyle(
                                    fontSize: 16,
                                    color: appColorText2,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 48),
                              ],
                            ))
                          : ListView(
                              padding: const EdgeInsets.all(16),
                              children: _buildGroupedNotifications(state.items),
                            ),
                ),
              ],
            );
          }),
    );
  }

  Widget _buildShimmerState() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionShimmer('Today'.tr()),
        const SizedBox(height: 12),
        _buildSectionShimmer('Yesterday'.tr()),
        const SizedBox(height: 12),
        _buildSectionShimmer('Last Week'.tr()),
      ],
    );
  }

  Widget _buildSectionShimmer(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WidgetAppShimmer(
          width: 100.sw,
          height: 16.sw,
        ),
        SizedBox(height: 12.sw),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.separated(
            itemCount: 3,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => Container(
              height: 1,
              color: hexColor('#EDEDED'),
            ),
            itemBuilder: (context, index) => _buildNotificationItemShimmer(),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationItemShimmer() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetAppShimmer(
            width: 48.sw,
            height: 48.sw,
            borderRadius: BorderRadius.circular(12),
          ),
          SizedBox(width: 12.sw),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetAppShimmer(
                  width: double.infinity,
                  height: 20.sw,
                ),
                SizedBox(height: 4.sw),
                WidgetAppShimmer(
                  width: double.infinity,
                  height: 16.sw,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.sw),
          WidgetAppShimmer(
            width: 10.sw,
            height: 10.sw,
            borderRadius: BorderRadius.circular(5),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGroupedNotifications(List<NotificationModel> items) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final todayItems = <NotificationModel>[];
    final yesterdayItems = <NotificationModel>[];
    final otherItems = <String, List<NotificationModel>>{};

    for (final item in items) {
      if (item.createdAt == null) continue;

      final date =
          string2DateTime(item.createdAt!, format: "dd-MM-yyyy HH:mm")!;
      final dateKey = date.formatDate();

      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        todayItems.add(item);
      } else if (date.year == yesterday.year &&
          date.month == yesterday.month &&
          date.day == yesterday.day) {
        yesterdayItems.add(item);
      } else {
        if (!otherItems.containsKey(dateKey)) {
          otherItems[dateKey] = [];
        }
        otherItems[dateKey]!.add(item);
      }
    }

    final widgets = <Widget>[];

    if (todayItems.isNotEmpty) {
      widgets.add(_buildSection(
        title: 'Today'.tr(),
        items: todayItems,
      ));
    }

    if (yesterdayItems.isNotEmpty) {
      widgets.add(_buildSection(
        title: 'Yesterday'.tr(),
        items: yesterdayItems,
      ));
    }

    otherItems.forEach((date, items) {
      widgets.add(_buildSection(
        title: date,
        items: items,
      ));
    });

    return widgets;
  }

  Widget _buildSection({
    required String title,
    required List<NotificationModel> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: w400TextStyle(
            fontSize: 14,
            color: appColorText2,
          ),
        ),
        SizedBox(height: 12.sw),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.separated(
            itemCount: items.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => Container(
              height: 1,
              color: hexColor('#EDEDED'),
            ),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => items[index].openDetail(),
              child: _buildNotificationItem(
                item: items[index],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Color _getIconColorByType(String? type) {
    switch (type?.toLowerCase()) {
      case 'order':
        return const Color(0xFF52A533);
      case 'promotion':
        return const Color(0xFFFFAB17);
      case 'system':
        return const Color(0xFF848484);
      case 'payment':
        return const Color(0xFFF17228);
      case 'account':
        return const Color(0xFF848484);
      default:
        return const Color(0xFF848484);
    }
  }

  Widget _buildNotificationItem({required NotificationModel item}) {
    return  
        GestureDetector(
          onTap: () => item.openDetail(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.icon,
                    color: _getIconColorByType(item.type),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: w500TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: w400TextStyle(
                          fontSize: 14,
                          color: appColorText2,
                        ),
                      ),
                    ],
                  ),
                ),
                if (item.isRead == 0)
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: appColorPrimaryOrange,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: appColorPrimaryOrange.withOpacity(0.2),
                        width: 3,
                      ),
                    ),
                  ),
              ],
            ),
          
              ),
        );
  }
}
