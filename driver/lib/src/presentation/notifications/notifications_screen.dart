import 'package:app/src/constants/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';

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
      backgroundColor: appColorBackground,
      appBar: AppBar(
        backgroundColor: appColorPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Notifications'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'News'.tr()),
            Tab(text: 'Theo dõi'.tr()),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNewsList(),
          _buildFollowList(),
        ],
      ),
    );
  }

  Widget _buildNewsList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.sw),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.only(bottom: 12.sw),
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
    return ListView.builder(
      padding: EdgeInsets.all(16.sw),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.only(bottom: 12.sw),
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
