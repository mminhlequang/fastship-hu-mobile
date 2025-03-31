import 'package:app/src/network_resources/product/model/product.dart';
import 'package:app/src/network_resources/store/models/models.dart';
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
  void addToCart(StoreModel store, ProductModel product, int quantity) {
    final currentItems = List<CartItem>.from(state.items);
    
    // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
    final existingItemIndex = currentItems.indexWhere(
      (item) => item.product.id == product.id && item.store.id == store.id
    );
    
    if (existingItemIndex != -1) {
      // Nếu sản phẩm đã tồn tại, tăng số lượng
      final existingItem = currentItems[existingItemIndex];
      currentItems[existingItemIndex] = CartItem(
        store: existingItem.store,
        product: existingItem.product,
        quantity: existingItem.quantity + quantity
      );
    } else {
      // Nếu sản phẩm chưa tồn tại, thêm mới
      currentItems.add(CartItem(
        store: store,
        product: product,
        quantity: quantity
      ));
    }
    
    emit(state.copyWith(items: currentItems));
    
    // Lưu giỏ hàng vào bộ nhớ cục bộ
    _saveCartToLocalStorage();
  }
  
  /// Cập nhật số lượng sản phẩm trong giỏ hàng
  void updateQuantity(CartItem item, int newQuantity) {
    if (newQuantity <= 0) {
      // Nếu số lượng <= 0, xóa sản phẩm khỏi giỏ hàng
      removeFromCart(item);
      return;
    }
    
    final currentItems = List<CartItem>.from(state.items);
    final index = currentItems.indexWhere(
      (cartItem) => cartItem.product.id == item.product.id && cartItem.store.id == item.store.id
    );
    
    if (index != -1) {
      currentItems[index] = CartItem(
        store: item.store,
        product: item.product,
        quantity: newQuantity
      );
      
      emit(state.copyWith(items: currentItems));
      _saveCartToLocalStorage();
    }
  }
  
  /// Tăng số lượng sản phẩm trong giỏ hàng
  void incrementQuantity(CartItem item) {
    updateQuantity(item, item.quantity + 1);
  }
  
  /// Giảm số lượng sản phẩm trong giỏ hàng
  void decrementQuantity(CartItem item) {
    updateQuantity(item, item.quantity - 1);
  }
  
  /// Xóa sản phẩm khỏi giỏ hàng
  void removeFromCart(CartItem item) {
    final currentItems = List<CartItem>.from(state.items);
    currentItems.removeWhere(
      (cartItem) => cartItem.product.id == item.product.id && cartItem.store.id == item.store.id
    );
    
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
