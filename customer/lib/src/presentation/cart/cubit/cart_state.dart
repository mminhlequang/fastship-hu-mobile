part of 'cart_cubit.dart';

class CartState {
  final List<Map<String, dynamic>> items; // Danh sách món ăn trong giỏ hàng
  final double subtotal; // Tổng tiền các món
  final double shippingFee; // Phí vận chuyển
  final double discount; // Giảm giá (có thể là số tiền hoặc tỷ lệ phần trăm)
  final double total; // Tổng tiền thanh toán
  final String? promoCode; // Mã giảm giá
  final String? promoMessage; // Thông báo về mã giảm giá

  CartState({
    required this.items,
    required this.subtotal,
    required this.shippingFee,
    required this.discount,
    required this.total,
    this.promoCode,
    this.promoMessage,
  });

  // Trạng thái khởi tạo ban đầu
  factory CartState.initial() {
    return CartState(
      items: [],
      subtotal: 0,
      shippingFee: 0,
      discount: 0,
      total: 0,
      promoCode: null,
      promoMessage: null,
    );
  }

  // Copy trạng thái với các thông số mới
  CartState copyWith({
    List<Map<String, dynamic>>? items,
    double? subtotal,
    double? shippingFee,
    double? discount,
    double? total,
    String? promoCode,
    String? promoMessage,
  }) {
    return CartState(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      shippingFee: shippingFee ?? this.shippingFee,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      promoCode: promoCode ?? this.promoCode,
      promoMessage: promoMessage ?? this.promoMessage,
    );
  }

  // Kiểm tra xem giỏ hàng có trống không
  bool get isEmpty => items.isEmpty;

  // Tổng số lượng các món trong giỏ hàng
  int get totalQuantity {
    int total = 0;
    for (var item in items) {
      total += item['quantity'] as int? ?? 1;
    }
    return total;
  }
}
