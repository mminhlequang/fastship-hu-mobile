part of 'orders_cubit.dart';

enum OrderStatus {
  searching, // Đang tìm Shipper
  found, // Đã tìm được Shipper
  inProgress, // Đang giao hàng
  completed, // Hoàn thành
  cancelled // Đã hủy
}

class Order {
  final String id;
  final String deliveryTime;
  final String timeRemaining;
  final String username;
  final OrderStatus status;
  final List<String> items;
  final double price;

  const Order({
    required this.id,
    required this.deliveryTime,
    required this.timeRemaining,
    required this.username,
    required this.status,
    required this.items,
    required this.price,
  });
}

enum OrdersTab { preOrder, new_, confirmed, completed }

class OrdersState extends Equatable {
  final List<Order> orders;
  final bool isLoading;
  final OrdersTab selectedTab;
  final String? errorMessage;

  const OrdersState({
    this.orders = const [],
    this.isLoading = false,
    this.selectedTab = OrdersTab.confirmed,
    this.errorMessage,
  });

  OrdersState copyWith({
    List<Order>? orders,
    bool? isLoading,
    OrdersTab? selectedTab,
    String? errorMessage,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      selectedTab: selectedTab ?? this.selectedTab,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [orders, isLoading, selectedTab, errorMessage];
}
