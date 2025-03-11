import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/orders_cubit.dart';
import 'widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersCubit(),
      child: const OrdersScreenContent(),
    );
  }
}

class OrdersScreenContent extends StatefulWidget {
  const OrdersScreenContent({Key? key}) : super(key: key);

  @override
  State<OrdersScreenContent> createState() => _OrdersScreenContentState();
}

class _OrdersScreenContentState extends State<OrdersScreenContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Khi tab thay đổi, cập nhật trạng thái trong Cubit
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        return;
      }

      final cubit = context.read<OrdersCubit>();
      switch (_tabController.index) {
        case 0:
          cubit.changeTab(OrdersTab.preOrder);
          break;
        case 1:
          cubit.changeTab(OrdersTab.new_);
          break;
        case 2:
          cubit.changeTab(OrdersTab.confirmed);
          break;
        case 3:
          cubit.changeTab(OrdersTab.completed);
          break;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        // Đồng bộ tab controller với state
        if (_tabController.index != state.selectedTab.index) {
          _tabController.animateTo(state.selectedTab.index);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Đơn hàng'),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Đặt trước'),
                Tab(text: 'Mới'),
                Tab(text: 'Xác nhận'),
                Tab(text: 'Hoàn thành'),
              ],
              indicatorColor: Colors.green,
              labelColor: Colors.green,
              unselectedLabelColor: Colors.grey,
            ),
          ),
          body: Column(
            children: [
              // Thanh tìm kiếm
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm đơn hàng',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),

              // Nội dung tab
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab 1: Đặt trước
                    _buildOrdersList(context, OrdersTab.preOrder),

                    // Tab 2: Mới
                    _buildOrdersList(context, OrdersTab.new_),

                    // Tab 3: Xác nhận
                    _buildOrdersList(context, OrdersTab.confirmed),

                    // Tab 4: Hoàn thành
                    _buildOrdersList(context, OrdersTab.completed),
                  ],
                ),
              ),
            ],
          ),
       
        );
      },
    );
  }

  Widget _buildOrdersList(BuildContext context, OrdersTab tab) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<OrdersCubit>().fetchOrders(),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        final filteredOrders = context.read<OrdersCubit>().getFilteredOrders();

        if (filteredOrders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  _getEmptyMessage(tab),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: filteredOrders.length,
          itemBuilder: (context, index) {
            return OrderItem(order: filteredOrders[index]);
          },
        );
      },
    );
  }

  String _getEmptyMessage(OrdersTab tab) {
    switch (tab) {
      case OrdersTab.preOrder:
        return 'Chưa có đơn đặt trước';
      case OrdersTab.new_:
        return 'Chưa có đơn mới';
      case OrdersTab.confirmed:
        return 'Chưa có đơn xác nhận';
      case OrdersTab.completed:
        return 'Chưa có đơn hoàn thành';
    }
  }
}
