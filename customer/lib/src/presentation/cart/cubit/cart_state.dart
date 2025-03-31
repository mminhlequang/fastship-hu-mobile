part of 'cart_cubit.dart';



class CartState {
  final bool isLoading;
  final List<CartItem> items;

  CartState({
    required this.isLoading,
    required this.items,
  });

  CartState copyWith({bool? isLoading, List<CartItem>? items}) {
    return CartState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
    );
  }
}


class CartItem {
  StoreModel store;
  ProductModel product;
  int quantity;

  CartItem({required this.store, required this.product, required this.quantity});

  double get totalPrice => product.price! * quantity.toDouble();

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      store: StoreModel.fromJson(json['store']),
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store': store.toJson(),
      'product': product.toJson(),
      'quantity': quantity,
    };
  }
}
