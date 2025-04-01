part of 'cart_cubit.dart';

class CartState {
  final bool isLoading;
  final List<CartItemModel> items;

  CartState({
    required this.isLoading,
    required this.items,
  });

  CartState copyWith({bool? isLoading, List<CartItemModel>? items}) {
    return CartState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
    );
  }
}

class CartItemModel {
  StoreModel store;
  ProductModel product;
  List<VariationValue> selectedVariationValues;
  int quantity;

  CartItemModel(
      {required this.store,
      required this.product,
      required this.quantity,
      required this.selectedVariationValues});

  double get totalPrice => product.price! * quantity.toDouble();

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      store: StoreModel.fromJson(json['store']),
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'],
      selectedVariationValues: json['selectedVariationValues'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store': store.toJson(),
      'product': product.toJson(),
      'quantity': quantity,
      'selectedVariationValues': selectedVariationValues,
    };
  }
}
