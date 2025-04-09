import 'package:network_resources/cart/models/models.dart';
import 'package:network_resources/cart/repo.dart';
import 'package:network_resources/product/model/product.dart';
import 'package:network_resources/store/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/utils/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:network_resources/topping/models/models.dart';

part 'cart_state.dart';

CartCubit get cartCubit => findInstance<CartCubit>();

class CartCubit extends Cubit<CartState> {
  final CartRepo cartRepo = CartRepo();
  CartCubit() : super(CartState(isLoading: false, items: []));

  Future<void> fetchCarts() async {
    emit(state.copyWith(isLoading: true));
    final response = await cartRepo.getCarts({});
    emit(state.copyWith(isLoading: false, items: response.data));
  }

  /// Thêm sản phẩm vào giỏ hàng
  /// Nếu sản phẩm đã tồn tại, tăng số lượng
  void addToCart(
    StoreModel store,
    ProductModel product,
    int quantity, {
    List<VariationValue> selectedVariationValues = const [],
    List<ToppingModel> selectedTopping = const [],
  }) {
    requestLoginWrapper(() async {
      final response = await cartRepo.createCart({
        "store_id": store.id,
        "product_id": product.id,
        "quantity": quantity,
        "variations": [
          ...selectedVariationValues.map((e) => {"variation_value": e.id})
        ],
        "topping_ids": [
          ...selectedTopping.map((e) => {"id": e.id, "quantity": e.quantity})
        ],
      });

      if (response.isSuccess) {
        appShowSnackBar(
            msg: "Add to cart successfully", type: AppSnackBarType.success);
      }

      await fetchCarts();
    });
  }

  Future<void> updateCart(CartItemModel cartItem) async {
    final response = await CartRepo().updateCart({
      "id": cartItem.id,
      "quantity": cartItem.quantity,
      "variations": [
        ...cartItem.variations
                ?.map((e) => {"variation_value": e.id})
                .toList() ??
            [],
      ],
      "topping_ids": [
        ...cartItem.toppings
                ?.map((e) => {"id": e.id, "quantity": e.quantity})
                .toList() ??
            [],
      ]
    });

    await fetchCarts();
  }

  Future<void> removeCartItem(int id) async {
    final response = await CartRepo().deleteCart(id);
    if (response.isSuccess) {
      appShowSnackBar(
          msg: "Remove cart item successfully", type: AppSnackBarType.success);
    }
    await fetchCarts();
  }
}
