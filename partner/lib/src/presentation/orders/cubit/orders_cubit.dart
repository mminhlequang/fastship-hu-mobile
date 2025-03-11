import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(const OrdersState()) {
    fetchOrders();
  }

  // Mô phỏng việc lấy dữ liệu đơn hàng từ API
  Future<void> fetchOrders() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      // Giả lập delay khi gọi API
      await Future.delayed(const Duration(seconds: 1));

      // Dữ liệu mẫu
      final mockOrders = [
        Order(
          id: '#4314323',
          deliveryTime: '20h00',
          timeRemaining: 'Trong 1h3p',
          username: 'User123',
          status: OrderStatus.searching,
          items: ['5 món'],
          price: 10,
        ),
        Order(
          id: '#4314323',
          deliveryTime: '20h00',
          timeRemaining: 'Trong 1h3p',
          username: 'User123',
          status: OrderStatus.found,
          items: ['5 món'],
          price: 10,
        ),
        Order(
          id: '#5621478',
          deliveryTime: '18h30',
          timeRemaining: 'Trong 30p',
          username: 'User456',
          status: OrderStatus.inProgress,
          items: ['3 món'],
          price: 15,
        ),
      ];

      emit(state.copyWith(orders: mockOrders, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Không thể tải đơn hàng: $e',
      ));
    }
  }

  // Chuyển đổi tab
  void changeTab(OrdersTab tab) {
    emit(state.copyWith(selectedTab: tab));
  }

  // Lọc đơn hàng theo trạng thái tab
  List<Order> getFilteredOrders() {
    switch (state.selectedTab) {
      case OrdersTab.preOrder:
        return state.orders
            .where((order) => false)
            .toList(); // Chưa có đơn đặt trước
      case OrdersTab.new_:
        return state.orders
            .where((order) => order.status == OrderStatus.searching)
            .toList();
      case OrdersTab.confirmed:
        return state.orders
            .where((order) =>
                order.status == OrderStatus.found ||
                order.status == OrderStatus.inProgress)
            .toList();
      case OrdersTab.completed:
        return state.orders
            .where((order) =>
                order.status == OrderStatus.completed ||
                order.status == OrderStatus.cancelled)
            .toList();
    }
  }
}
