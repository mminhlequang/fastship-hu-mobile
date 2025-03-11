import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:app/src/utils/utils.dart';

import 'cubit/cart_cubit.dart';
import 'widgets/cart_widgets.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartCubit _cartCubit;
  final TextEditingController _promoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cartCubit = cartCubit;
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Giỏ hàng',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Xác nhận xóa toàn bộ giỏ hàng
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Xóa giỏ hàng'),
                  content: Text('Bạn có chắc muốn xóa toàn bộ giỏ hàng?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Hủy'),
                    ),
                    TextButton(
                      onPressed: () {
                        _cartCubit.clearCart();
                        Navigator.pop(context);
                      },
                      child: Text('Xóa', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
            child: Text(
              'Xóa tất cả',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        bloc: _cartCubit,
        builder: (context, state) {
          if (state.isEmpty) {
            return _buildEmptyCart();
          }

          return _buildCartContent(state);
        },
      ),
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        bloc: _cartCubit,
        builder: (context, state) {
          if (state.isEmpty) return SizedBox();

          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(0, -3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng cộng',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '₫${state.total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),
                  ElevatedButton(
                    onPressed: () {
                      // Điều hướng đến trang thanh toán
                      context.push('/checkout');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Tiến hành thanh toán',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const Gap(16),
          Text(
            'Giỏ hàng của bạn đang trống',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(8),
          Text(
            'Hãy thêm món ăn vào giỏ hàng để đặt hàng',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const Gap(24),
          ElevatedButton(
            onPressed: () {
              // Quay lại trang chủ để chọn món ăn
              context.go('/navigation');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Khám phá menu',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(CartState state) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              // Danh sách các món trong giỏ hàng
              ...state.items.map((item) => CartItemCard(
                    food: item,
                    onQuantityChanged: (quantity) {
                      _cartCubit.updateQuantity(item['id'], quantity);
                    },
                    onRemove: () {
                      _cartCubit.removeFromCart(item['id']);
                    },
                  )),

              const Gap(24),

              // Phần mã giảm giá
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mã giảm giá',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _promoController,
                            decoration: InputDecoration(
                              hintText: 'Nhập mã giảm giá',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ),
                        const Gap(12),
                        ElevatedButton(
                          onPressed: () {
                            if (_promoController.text.isNotEmpty) {
                              _cartCubit.applyPromoCode(_promoController.text);
                              FocusScope.of(context).unfocus();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Áp dụng',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    if (state.promoMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          state.promoMessage!,
                          style: TextStyle(
                            color:
                                state.discount > 0 ? Colors.green : Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const Gap(24),

              // Thông tin thanh toán
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thông tin thanh toán',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(16),
                    _buildPaymentRow(
                        'Tạm tính', '₫${state.subtotal.toStringAsFixed(2)}'),
                    _buildPaymentRow('Phí vận chuyển',
                        '₫${state.shippingFee.toStringAsFixed(2)}'),
                    if (state.discount > 0)
                      _buildPaymentRow(
                          'Giảm giá', '-₫${state.discount.toStringAsFixed(2)}',
                          isDiscount: true),
                    Divider(height: 24),
                    _buildPaymentRow(
                        'Tổng cộng', '₫${state.total.toStringAsFixed(2)}',
                        isBold: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentRow(String label, String value,
      {bool isBold = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
