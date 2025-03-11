import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/utils/utils.dart';

part 'orders_state.dart';

OrdersCubit get ordersCubit => findInstance<OrdersCubit>();

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersInitial());

  // Thêm các hàm xử lý logic cho màn hình Orders
  void fetchOrders() {
    emit(OrdersLoading());

    // TODO: Gọi API hoặc lấy dữ liệu từ local
    // Giả lập dữ liệu thành công
    emit(OrdersLoaded());
  }

  void cancelOrder(String orderId) {
    // TODO: Thêm logic xử lý hủy đơn hàng
  }
}
