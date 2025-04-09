part of 'cart_cubit.dart';

class CartState {
  final bool isLoading;
  final List<CartModel> items;

  int get totalItems {
    int total = 0;
    for (var element in items) {
      total += element.cartItems!.length;
    }
    return total;
  }

  CartState({
    required this.isLoading,
    required this.items,
  });

  CartState copyWith({bool? isLoading, List<CartModel>? items}) {
    return CartState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
    );
  }
}

 