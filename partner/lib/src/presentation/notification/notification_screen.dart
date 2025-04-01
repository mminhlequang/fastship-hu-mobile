import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:network_resources/notification/models/notification.dart';
import 'package:network_resources/notification/repo.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/presentation/widgets/widget_notification_shimmer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';
import 'package:internal_core/setup/app_textstyles.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final NotificationRepo _notificationRepo = NotificationRepo();
  bool _isLoading = true;
  List<NotificationModel> _orderNotifications = [];
  List<NotificationModel> _newsNotifications = [];
  List<NotificationModel> _promotionNotifications = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _notificationRepo.getNotifications({
        'type': 'all',
      });

      if (response.data != null) {
        final List<NotificationModel> notifications = response.data;
        setState(() {
          _orderNotifications =
              notifications.where((n) => n.type == 'order').toList();
          _newsNotifications =
              notifications.where((n) => n.type == 'news').toList();
          _promotionNotifications =
              notifications.where((n) => n.type == 'promotion').toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error loading notifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WidgetAppTabBar(
      tabController: _tabController,
      tabWidgets: List.generate(
        3,
        (index) => Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                index == 0
                    ? 'Order'.tr()
                    : index == 1
                        ? 'News'.tr()
                        : 'Promotion'.tr(),
              ),
              if (index == 0 && _orderNotifications.isNotEmpty)
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
                        '${_orderNotifications.length}',
                        style:
                            w400TextStyle(fontSize: 10.sw, color: Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      children: [_buildOrderTab(), _buildNewsTab(), _buildPromotionTab()],
    );
  }

  Widget _buildOrderTab() {
    return _isLoading
        ? ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
            itemCount: 3,
            separatorBuilder: (context, index) => Gap(8.sw),
            itemBuilder: (context, index) => const WidgetNotificationShimmer(),
          )
        : _orderNotifications.isEmpty
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
                onRefresh: _loadData,
                child: ListView.separated(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
                  itemCount: _orderNotifications.length,
                  separatorBuilder: (context, index) => Gap(8.sw),
                  itemBuilder: (context, index) {
                    final notification = _orderNotifications[index];
                    return WidgetRippleButton(
                      onTap: () {
                        // Todo: go detail
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

  Widget _buildNewsTab() {
    return _isLoading
        ? ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
            itemCount: 3,
            separatorBuilder: (context, index) => Gap(8.sw),
            itemBuilder: (context, index) => const WidgetNotificationShimmer(),
          )
        : _newsNotifications.isEmpty
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
                onRefresh: _loadData,
                child: ListView.separated(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
                  itemCount: _newsNotifications.length,
                  separatorBuilder: (context, index) => Gap(8.sw),
                  itemBuilder: (context, index) {
                    final notification = _newsNotifications[index];
                    return WidgetRippleButton(
                      onTap: () {
                        // Todo: go detail
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

  Widget _buildPromotionTab() {
    return _isLoading
        ? ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
            itemCount: 3,
            separatorBuilder: (context, index) => Gap(8.sw),
            itemBuilder: (context, index) => const WidgetNotificationShimmer(),
          )
        : _promotionNotifications.isEmpty
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
                onRefresh: _loadData,
                child: ListView.separated(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
                  itemCount: _promotionNotifications.length,
                  separatorBuilder: (context, index) => Gap(8.sw),
                  itemBuilder: (context, index) {
                    final notification = _promotionNotifications[index];
                    return WidgetRippleButton(
                      onTap: () {
                        // Todo: go detail
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
