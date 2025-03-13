import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widget_app_tabbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
      body: WidgetAppTabBar(
        tabController: _tabController,
        tabs: ['News'.tr(), 'Follow'.tr()],
        children: [
          _buildNewsList(),
          _buildFollowList(),
        ],
      ),
    );
  }

  Widget _buildNewsList() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
      itemCount: 10,
      separatorBuilder: (context, index) => Gap(4.sw),
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(16.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Driver wallet +500,000 VND',
                  style: TextStyle(
                    fontSize: 16.sw,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(8.sw),
                Text(
                  'Lorem ipsum dolor sit amet consectetur. Semper nibh sit tincidunt posuere aliquam tellus. Aliquam semper convallis a ut.',
                  style: TextStyle(
                    fontSize: 14.sw,
                    color: Colors.grey[600],
                  ),
                ),
                Gap(8.sw),
                Text(
                  '24/02/2025 11:11',
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

  Widget _buildFollowList() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
      itemCount: 10,
      separatorBuilder: (context, index) => Gap(4.sw),
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(16.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đơn hàng #123456 đã được giao thành công',
                  style: TextStyle(
                    fontSize: 16.sw,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(8.sw),
                Text(
                  'Bạn đã hoàn thành giao hàng thành công và nhận được 50,000 VND',
                  style: TextStyle(
                    fontSize: 14.sw,
                    color: Colors.grey[600],
                  ),
                ),
                Gap(8.sw),
                Text(
                  '24/02/2025 11:11',
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
