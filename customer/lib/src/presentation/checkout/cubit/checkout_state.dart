part of 'checkout_cubit.dart';

enum CheckoutStatus { initial, loading, success, failed }

class CheckoutState {
  final CheckoutStatus status;
  final Map<String, dynamic> deliveryAddress;
  final Map<String, dynamic> contactInfo;
  final String paymentMethod;
  final String orderNote;
  final Map<String, dynamic>? order;
  final String error;

  CheckoutState({
    required this.status,
    required this.deliveryAddress,
    required this.contactInfo,
    required this.paymentMethod,
    required this.orderNote,
    this.order,
    required this.error,
  });

  // Trạng thái khởi tạo ban đầu
  factory CheckoutState.initial() {
    return CheckoutState(
      status: CheckoutStatus.initial,
      deliveryAddress: {},
      contactInfo: {'name': '', 'phone': '', 'email': ''},
      paymentMethod: '',
      orderNote: '',
      order: null,
      error: '',
    );
  }

  // Copy trạng thái với các thông số mới
  CheckoutState copyWith({
    CheckoutStatus? status,
    Map<String, dynamic>? deliveryAddress,
    Map<String, dynamic>? contactInfo,
    String? paymentMethod,
    String? orderNote,
    Map<String, dynamic>? order,
    String? error,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      contactInfo: contactInfo ?? this.contactInfo,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      orderNote: orderNote ?? this.orderNote,
      order: order ?? this.order,
      error: error ?? this.error,
    );
  }
}
