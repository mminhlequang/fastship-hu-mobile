import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/orders_cubit.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Khởi tạo dữ liệu khi cần
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      bloc: ordersCubit,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Đơn hàng'),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Đang giao'),
                Tab(text: 'Hoàn thành'),
                Tab(text: 'Đã hủy'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              // Tab Đang giao
              _buildOrderList(OrderStatus.inProgress),

              // Tab Hoàn thành
              _buildOrderList(OrderStatus.completed),

              // Tab Đã hủy
              _buildOrderList(OrderStatus.cancelled),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderList(OrderStatus status) {
    return Center(
      child: Text('Danh sách đơn hàng ${status.name}'),
    );
  }
}

enum OrderStatus {
  inProgress,
  completed,
  cancelled,
}
