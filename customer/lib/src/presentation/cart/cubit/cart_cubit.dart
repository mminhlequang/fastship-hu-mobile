import 'package:network_resources/product/model/product.dart';
import 'package:network_resources/store/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/utils/utils.dart';
import 'package:bloc/bloc.dart';

part 'cart_state.dart';

CartCubit get cartCubit => findInstance<CartCubit>();

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState(isLoading: false, items: []));

  /// Thêm sản phẩm vào giỏ hàng
  /// Nếu sản phẩm đã tồn tại, tăng số lượng
  void addToCart(StoreModel store, ProductModel product, int quantity,
      {List<VariationValue> selectedVariationValues = const []}) {
    final currentItems = List<CartItemModel>.from(state.items);

    // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
    final existingItemIndex = currentItems.indexWhere((item) =>
        item.product.id == product.id &&
        item.store.id == store.id &&
        _areVariationsEqual(
            item.selectedVariationValues, selectedVariationValues));

    if (existingItemIndex != -1) {
      // Nếu sản phẩm đã tồn tại, tăng số lượng
      final existingItem = currentItems[existingItemIndex];
      currentItems[existingItemIndex] = CartItemModel(
          store: existingItem.store,
          product: existingItem.product,
          quantity: existingItem.quantity + quantity,
          selectedVariationValues: existingItem.selectedVariationValues);
    } else {
      // Nếu sản phẩm chưa tồn tại, thêm mới
      currentItems.add(CartItemModel(
          store: store,
          product: product,
          quantity: quantity,
          selectedVariationValues: selectedVariationValues));
    }

    emit(state.copyWith(items: currentItems));

    // Lưu giỏ hàng vào bộ nhớ cục bộ
    _saveCartToLocalStorage();
  }

  /// Kiểm tra xem hai danh sách biến thể có giống nhau không
  bool _areVariationsEqual(
      List<VariationValue> list1, List<VariationValue> list2) {
    if (list1.length != list2.length) return false;

    for (int i = 0; i < list1.length; i++) {
      bool found = false;
      for (int j = 0; j < list2.length; j++) {
        if (list1[i].id == list2[j].id &&
            list1[i].parentId == list2[j].parentId) {
          found = true;
          break;
        }
      }
      if (!found) return false;
    }

    return true;
  }

  /// Cập nhật số lượng sản phẩm trong giỏ hàng
  void updateQuantity(CartItemModel item, int newQuantity) {
    if (newQuantity <= 0) {
      // Nếu số lượng <= 0, xóa sản phẩm khỏi giỏ hàng
      removeFromCart(item);
      return;
    }

    final currentItems = List<CartItemModel>.from(state.items);
    final index = currentItems.indexWhere((cartItem) =>
        cartItem.product.id == item.product.id &&
        cartItem.store.id == item.store.id &&
        _areVariationsEqual(
            cartItem.selectedVariationValues, item.selectedVariationValues));

    if (index != -1) {
      currentItems[index] = CartItemModel(
          store: item.store,
          product: item.product,
          quantity: newQuantity,
          selectedVariationValues: item.selectedVariationValues);

      emit(state.copyWith(items: currentItems));
      _saveCartToLocalStorage();
    }
  }

  /// Tăng số lượng sản phẩm trong giỏ hàng
  void incrementQuantity(CartItemModel item) {
    updateQuantity(item, item.quantity + 1);
  }

  /// Giảm số lượng sản phẩm trong giỏ hàng
  void decrementQuantity(CartItemModel item) {
    updateQuantity(item, item.quantity - 1);
  }

  /// Xóa sản phẩm khỏi giỏ hàng
  void removeFromCart(CartItemModel item) {
    final currentItems = List<CartItemModel>.from(state.items);
    currentItems.removeWhere((cartItem) =>
        cartItem.product.id == item.product.id &&
        cartItem.store.id == item.store.id &&
        _areVariationsEqual(
            cartItem.selectedVariationValues, item.selectedVariationValues));

    emit(state.copyWith(items: currentItems));
    _saveCartToLocalStorage();
  }

  /// Xóa tất cả sản phẩm trong giỏ hàng
  void clearCart() {
    emit(state.copyWith(items: []));
    _saveCartToLocalStorage();
  }

  /// Tính tổng giá trị giỏ hàng
  double get totalCartValue {
    return state.items.fold(0, (total, item) => total + item.totalPrice);
  }

  /// Lưu giỏ hàng vào bộ nhớ cục bộ
  void _saveCartToLocalStorage() {
    // TODO: Implement local storage saving
    // Có thể sử dụng Hive hoặc SharedPreferences để lưu trữ
  }

  /// Tải giỏ hàng từ bộ nhớ cục bộ
  Future<void> loadCartFromLocalStorage() async {
    // TODO: Implement local storage loading
    // Có thể sử dụng Hive hoặc SharedPreferences để đọc dữ liệu

    // Mẫu code:
    // final cartData = await _storage.get('cart');
    // if (cartData != null) {
    //   final List<dynamic> items = jsonDecode(cartData);
    //   final cartItems = items.map((item) => CartItem.fromJson(item)).toList();
    //   emit(state.copyWith(items: cartItems));
    // }
  }
}
