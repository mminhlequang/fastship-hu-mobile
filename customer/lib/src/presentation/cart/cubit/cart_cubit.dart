import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/utils/utils.dart';
import 'package:bloc/bloc.dart';

part 'cart_state.dart';

CartCubit get cartCubit => findInstance<CartCubit>();

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState.initial());

  // Thêm món ăn vào giỏ hàng
  void addToCart(Map<String, dynamic> food, int quantity) {
    final currentItems = List<Map<String, dynamic>>.from(state.items);

    // Kiểm tra xem món ăn đã có trong giỏ hàng chưa
    int existingIndex =
        currentItems.indexWhere((item) => item['id'] == food['id']);

    if (existingIndex >= 0) {
      // Nếu món ăn đã tồn tại, cập nhật số lượng
      final updatedItem =
          Map<String, dynamic>.from(currentItems[existingIndex]);
      updatedItem['quantity'] = (updatedItem['quantity'] ?? 1) + quantity;
      currentItems[existingIndex] = updatedItem;
    } else {
      // Nếu món ăn chưa tồn tại, thêm mới
      final newItem = Map<String, dynamic>.from(food);
      newItem['quantity'] = quantity;
      currentItems.add(newItem);
    }

    emit(_recalculateTotal(currentItems));
  }

  // Cập nhật số lượng món ăn trong giỏ hàng
  void updateQuantity(String foodId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(foodId); // Xóa nếu số lượng <= 0
      return;
    }

    final currentItems = List<Map<String, dynamic>>.from(state.items);
    int itemIndex = currentItems.indexWhere((item) => item['id'] == foodId);

    if (itemIndex >= 0) {
      final updatedItem = Map<String, dynamic>.from(currentItems[itemIndex]);
      updatedItem['quantity'] = newQuantity;
      currentItems[itemIndex] = updatedItem;

      emit(_recalculateTotal(currentItems));
    }
  }

  // Xóa món ăn khỏi giỏ hàng
  void removeFromCart(String foodId) {
    final currentItems = List<Map<String, dynamic>>.from(state.items);
    currentItems.removeWhere((item) => item['id'] == foodId);

    emit(_recalculateTotal(currentItems));
  }

  // Xóa toàn bộ giỏ hàng
  void clearCart() {
    emit(CartState.initial());
  }

  // Áp dụng mã giảm giá
  void applyPromoCode(String code) {
    // Mô phỏng xử lý mã giảm giá - có thể triển khai gọi API thực tế ở đây
    double discount = 0;
    String message = '';

    if (code.toLowerCase() == 'welcome20') {
      discount = 0.2; // Giảm 20%
      message = 'Đã áp dụng mã giảm 20%';
    } else if (code.toLowerCase() == 'freeship') {
      discount = 15000; // Giảm 15000đ phí vận chuyển
      message = 'Đã áp dụng mã miễn phí vận chuyển';
    } else {
      message = 'Mã giảm giá không hợp lệ';
    }

    emit(state.copyWith(
      discount: discount,
      promoCode: discount > 0 ? code : null,
      promoMessage: message,
    ));
  }

  // Tính lại tổng tiền dựa trên các món trong giỏ hàng
  CartState _recalculateTotal(List<Map<String, dynamic>> items) {
    double subtotal = 0;
    int totalItems = 0;

    for (var item in items) {
      int quantity = item['quantity'] ?? 1;
      double price = item['discountPrice'] ?? item['price'] ?? 0;
      subtotal += price * quantity;
      totalItems += quantity;
    }

    // Phí vận chuyển mẫu - có thể tính dựa trên khoảng cách thực tế
    double shippingFee = subtotal > 0 ? 15000 : 0;

    double discount = state.discount;
    if (discount > 0 && discount < 1) {
      // Nếu là phần trăm (ví dụ: 0.2 tương đương 20%)
      discount = subtotal * discount;
    }

    double total = subtotal + shippingFee - discount;
    if (total < 0) total = 0;

    return CartState(
      items: items,
      subtotal: subtotal,
      shippingFee: shippingFee,
      discount: state.discount,
      total: total,
      promoCode: state.promoCode,
      promoMessage: state.promoMessage,
    );
  }
}
