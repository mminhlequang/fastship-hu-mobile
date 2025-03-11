import 'package:bloc/bloc.dart';
import 'package:app/src/utils/utils.dart';
import 'package:app/src/presentation/cart/cubit/cart_cubit.dart';

part 'checkout_state.dart';

CheckoutCubit get checkoutCubit => findInstance<CheckoutCubit>();

class CheckoutCubit extends Cubit<CheckoutState> {
  final CartCubit cartCubit;

  CheckoutCubit({required this.cartCubit}) : super(CheckoutState.initial());

  // Cập nhật địa chỉ giao hàng
  void updateDeliveryAddress(Map<String, dynamic> address) {
    emit(state.copyWith(deliveryAddress: address));
  }

  // Cập nhật thông tin liên hệ
  void updateContactInfo(Map<String, dynamic> contactInfo) {
    emit(state.copyWith(contactInfo: contactInfo));
  }

  // Cập nhật phương thức thanh toán
  void updatePaymentMethod(String method) {
    emit(state.copyWith(paymentMethod: method));
  }

  // Cập nhật ghi chú đơn hàng
  void updateOrderNote(String note) {
    emit(state.copyWith(orderNote: note));
  }

  // Kiểm tra xem thông tin đã đầy đủ để có thể đặt hàng chưa
  bool canPlaceOrder() {
    if (cartCubit.state.isEmpty) return false;
    if (state.deliveryAddress.isEmpty) return false;
    if (state.contactInfo['name']?.isEmpty ?? true) return false;
    if (state.contactInfo['phone']?.isEmpty ?? true) return false;
    if (state.paymentMethod.isEmpty) return false;

    return true;
  }

  // Tạo đơn hàng
  Future<void> placeOrder() async {
    try {
      emit(state.copyWith(status: CheckoutStatus.loading));

      // Mô phỏng gọi API để tạo đơn hàng - thực tế sẽ gọi backend
      await Future.delayed(const Duration(seconds: 2));

      // Tạo thông tin đơn hàng
      final orderItems = cartCubit.state.items;
      final subtotal = cartCubit.state.subtotal;
      final shippingFee = cartCubit.state.shippingFee;
      final discount = cartCubit.state.discount;
      final total = cartCubit.state.total;

      final orderData = {
        'id': 'ORDER-${DateTime.now().millisecondsSinceEpoch}',
        'items': orderItems,
        'subtotal': subtotal,
        'shipping_fee': shippingFee,
        'discount': discount,
        'total': total,
        'payment_method': state.paymentMethod,
        'delivery_address': state.deliveryAddress,
        'contact_info': state.contactInfo,
        'order_note': state.orderNote,
        'status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
      };

      // Lưu thông tin đơn hàng thành công
      emit(state.copyWith(
        status: CheckoutStatus.success,
        order: orderData,
      ));

      // Xóa giỏ hàng sau khi đặt hàng thành công
      cartCubit.clearCart();
    } catch (e) {
      emit(state.copyWith(
        status: CheckoutStatus.failed,
        error: 'Đặt hàng không thành công: ${e.toString()}',
      ));
    }
  }

  // Đặt lại trạng thái ban đầu sau khi thanh toán thành công hoặc thất bại
  void resetCheckout() {
    emit(CheckoutState.initial());
  }
}
