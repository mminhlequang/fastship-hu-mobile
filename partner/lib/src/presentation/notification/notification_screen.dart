import 'package:app/src/base/auth/auth_cubit.dart';
import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:network_resources/notification/models/notification.dart';
import 'package:network_resources/notification/repo.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/presentation/widgets/widget_notification_shimmer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';
import 'package:internal_core/setup/app_textstyles.dart';

import 'cubit/notification_cubit.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    notificationCubit.fetchNotifications();
    notificationCubit.readAllNotifications();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Refresh data function
  Future<void> _refreshData() async {
    await notificationCubit.fetchNotifications();
  }

  // Filter notifications by type
  List<NotificationModel> _getNotificationsByType(String type) {
    return notificationCubit.state.items
        .where((notification) => notification.type == type)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      bloc: notificationCubit,
      builder: (context, state) {
        return WidgetAppTabBar(
          tabController: _tabController,
          tabWidgets: List.generate(
            3,
            (index) {
              final items = state.items
                  .where((e) => index == 0
                      ? e.type == NotificationModelType.order
                      : index == 1
                          ? e.type == NotificationModelType.news
                          : true)
                  .where((e) => e.isRead != 1)
                  .toList();
              return Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      index == 0
                          ? 'Order'.tr()
                          : index == 1
                              ? 'News'.tr()
                              : 'All'.tr(),
                    ),
                    if (items.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(left: 4.sw),
                        child: Container(
                          height: 13.sw,
                          width: 17.sw,
                          decoration: BoxDecoration(
                            color: appColorPrimary,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Center(
                            child: Text(
                              '${items.length}',
                              style: w400TextStyle(
                                  fontSize: 10.sw, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          children: [
            _buildTabContent(
                state.items
                    .where((e) => e.type == NotificationModelType.order)
                    .toList(),
                state.isLoading),
            _buildTabContent(
                state.items
                    .where((e) => e.type == NotificationModelType.news)
                    .toList(),
                state.isLoading),
            _buildTabContent(state.items, state.isLoading),
          ],
        );
      },
    );
  }

  Widget _buildTabContent(
      List<NotificationModel> orderNotifications, bool isLoading) {
    return isLoading
        ? ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
            itemCount: 3,
            separatorBuilder: (context, index) => Gap(8.sw),
            itemBuilder: (context, index) => const WidgetNotificationShimmer(),
          )
        : orderNotifications.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const WidgetAppSVG('ic_empty_order'),
                  Gap(16.sw),
                  Text(
                    "There's nothing here...yet".tr(),
                    style: w500TextStyle(fontSize: 18.sw),
                  ),
                  Gap(4.sw),
                  Text(
                    "We'll let you know when we get news for you".tr(),
                    style: w400TextStyle(color: grey1),
                  ),
                ],
              )
            : RefreshIndicator(
                onRefresh: _refreshData,
                child: ListView.separated(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
                  itemCount: orderNotifications.length,
                  separatorBuilder: (context, index) => Gap(8.sw),
                  itemBuilder: (context, index) {
                    final notification = orderNotifications[index];
                    return WidgetRippleButton(
                      onTap: () {
                        // Todo: go detail
                        notification.openDetail();
                      },
                      radius: 12.sw,
                      child: Padding(
                        padding: EdgeInsets.all(12.sw),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WidgetAppImage(
                              imageUrl: notification.image ?? '',
                              height: 32.sw,
                              width: 32.sw,
                              radius: 4.sw,
                            ),
                            Gap(8.sw),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notification.title ?? '',
                                    style: w500TextStyle(),
                                  ),
                                  Gap(4.sw),
                                  Text(
                                    notification.content ?? '',
                                    style: w400TextStyle(
                                        fontSize: 12.sw, color: grey10),
                                  ),
                                  Gap(4.sw),
                                  Text(
                                    notification.createdAt ?? '',
                                    style: w400TextStyle(
                                        fontSize: 10.sw, color: grey1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
  }
}
