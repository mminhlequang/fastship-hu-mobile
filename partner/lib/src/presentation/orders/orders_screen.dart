import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/widgets/widget_app_divider.dart';
import 'package:app/src/presentation/widgets/widget_app_tabbar.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/setup/app_textstyles.dart';
import 'package:internal_core/widgets/widgets.dart';

enum OrderStatus {
  preOrder,
  newOrder,
  confirmed,
  completed,
  canceled;

  String get title => switch (this) {
        preOrder => 'Pre-order'.tr(),
        newOrder => 'New'.tr(),
        confirmed => 'Confirmed'.tr(),
        completed => 'Completed'.tr(),
        canceled => 'Canceled'.tr(),
      };
}

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  OrderStatus _currentStatus = OrderStatus.preOrder;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetAppTabBar(
      tabController: _tabController,
      physics: const NeverScrollableScrollPhysics(),
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      onTap: (index) {
        setState(() {
          _currentStatus = OrderStatus.values[index];
        });
      },
      tabs: OrderStatus.values.map((e) => e.title).toList(),
      body: _ordersByStatus,
    );
  }

  Widget get _ordersByStatus {
    return _currentStatus == OrderStatus.canceled
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const WidgetAppSVG('ic_empty_order'),
              Gap(16.sw),
              Text(
                'There’s nothing here...yet'.tr(),
                style: w500TextStyle(fontSize: 18.sw),
              ),
              Gap(4.sw),
              Text(
                'We’ll let you know when you have new order'.tr(),
                style: w400TextStyle(color: grey1),
              ),
            ],
          )
        : RefreshIndicator(
            onRefresh: () async {
              // Todo: refresh orders
            },
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
              itemCount: 3,
              separatorBuilder: (context, index) => Gap(8.sw),
              itemBuilder: (context, index) {
                return WidgetRippleButton(
                  // Todo: truyền model order qua màn detail-order
                  onTap: () => appContext.push('/detail-order', extra: null),
                  radius: 8.sw,
                  child: Padding(
                    padding: EdgeInsets.all(12.sw),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '#4314323',
                          style: w600TextStyle(fontSize: 16.sw, color: appColorPrimary),
                        ),
                        Gap(2.sw),
                        Text(
                          '${'Delivery at'.tr()} 20:00 (${'within'.tr()} 1h3m)',
                          style: w400TextStyle(fontSize: 12.sw, color: grey1),
                        ),
                        Gap(16.sw),
                        Text(
                          'User123',
                          style: w400TextStyle(),
                        ),
                        _divider,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Status'.tr(),
                              style: w400TextStyle(),
                            ),
                            Text(
                              // Chờ xác nhận/Đã xác nhận/Đang tìm Shipper/Đã tìm được Shipper/Giao thành công/Hoàn thành/Đã hủy
                              'Waiting to confirm'.tr(),
                              style: w400TextStyle(),
                            ),
                          ],
                        ),
                        _divider,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '5 ${'items'.tr()}',
                              style: w400TextStyle(),
                            ),
                            Text(
                              '\$10',
                              style: w400TextStyle(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }

  Widget get _divider => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.sw),
        child: const AppDivider(),
      );
}
