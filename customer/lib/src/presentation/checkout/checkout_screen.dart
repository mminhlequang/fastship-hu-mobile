import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:app/src/utils/utils.dart';

import 'cubit/checkout_cubit.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late final CheckoutCubit _cubit;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _selectedPaymentMethod = '';

  @override
  void initState() {
    super.initState();
    _cubit = checkoutCubit;
    // Điền các thông tin mặc định nếu có
    if (_cubit.state.contactInfo.isNotEmpty) {
      _nameController.text = _cubit.state.contactInfo['name'] ?? '';
      _phoneController.text = _cubit.state.contactInfo['phone'] ?? '';
      _emailController.text = _cubit.state.contactInfo['email'] ?? '';
    }
    if (_cubit.state.deliveryAddress.isNotEmpty) {
      _addressController.text =
          _cubit.state.deliveryAddress['full_address'] ?? '';
    }
    _noteController.text = _cubit.state.orderNote;
    _selectedPaymentMethod = _cubit.state.paymentMethod;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _updateContactInfo() {
    _cubit.updateContactInfo({
      'name': _nameController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
    });
  }

  void _updateDeliveryAddress() {
    _cubit.updateDeliveryAddress({
      'full_address': _addressController.text,
      'lat': 10.7769, // Giả sử tọa độ
      'lng': 106.7009, // Giả sử tọa độ
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Thanh toán',
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
      ),
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        bloc: _cubit,
        listener: (context, state) {
          if (state.status == CheckoutStatus.success) {
            // Hiển thị thông báo đặt hàng thành công
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đặt hàng thành công!'),
                backgroundColor: Colors.green,
              ),
            );

            // Quay về trang chủ
            Future.delayed(Duration(seconds: 2), () {
              context.go('/navigation');
            });
          } else if (state.status == CheckoutStatus.failed) {
            // Hiển thị thông báo lỗi
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đặt hàng thất bại: ${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == CheckoutStatus.loading) {
            return Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Thông tin liên hệ'),
                _buildTextField(
                  controller: _nameController,
                  label: 'Họ tên',
                  hint: 'Nhập họ tên người nhận',
                  onChanged: (_) => _updateContactInfo(),
                ),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Số điện thoại',
                  hint: 'Nhập số điện thoại',
                  keyboardType: TextInputType.phone,
                  onChanged: (_) => _updateContactInfo(),
                ),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Nhập email (không bắt buộc)',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) => _updateContactInfo(),
                ),
                const Gap(24),
                _buildSectionTitle('Địa chỉ giao hàng'),
                _buildTextField(
                  controller: _addressController,
                  label: 'Địa chỉ đầy đủ',
                  hint: 'Nhập địa chỉ giao hàng',
                  maxLines: 2,
                  onChanged: (_) => _updateDeliveryAddress(),
                ),
                const Gap(24),
                _buildSectionTitle('Phương thức thanh toán'),
                _buildPaymentMethod('Tiền mặt khi nhận hàng', 'cash'),
                _buildPaymentMethod('Thanh toán qua ví điện tử', 'ewallet'),
                _buildPaymentMethod('Thẻ tín dụng/ghi nợ', 'card'),
                const Gap(24),
                _buildSectionTitle('Ghi chú đơn hàng'),
                _buildTextField(
                  controller: _noteController,
                  label: 'Ghi chú',
                  hint: 'Nhập ghi chú cho đơn hàng (không bắt buộc)',
                  maxLines: 3,
                  onChanged: (value) => _cubit.updateOrderNote(value),
                ),
                const Gap(24),
                _buildOrderSummary(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
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
          child: BlocBuilder<CheckoutCubit, CheckoutState>(
            bloc: _cubit,
            builder: (context, state) {
              return Column(
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
                        '₫${_cubit.cartCubit.state.total.toStringAsFixed(2)}',
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
                    onPressed: state.status == CheckoutStatus.loading
                        ? null
                        : () {
                            if (_cubit.canPlaceOrder()) {
                              _cubit.placeOrder();
                            } else {
                              // Hiển thị thông báo cung cấp đầy đủ thông tin
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Vui lòng điền đầy đủ thông tin thanh toán'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Xác nhận đặt hàng',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            keyboardType: keyboardType,
            maxLines: maxLines,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(String title, String value) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
          _cubit.updatePaymentMethod(value);
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: _selectedPaymentMethod == value
                ? Colors.green
                : Colors.grey.shade300,
            width: _selectedPaymentMethod == value ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              _selectedPaymentMethod == value
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color:
                  _selectedPaymentMethod == value ? Colors.green : Colors.grey,
            ),
            const Gap(12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: _selectedPaymentMethod == value
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    final cartState = _cubit.cartCubit.state;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tóm tắt đơn hàng',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(12),
          ...cartState.items.map((item) => _buildOrderItem(item)),
          Divider(height: 24, thickness: 1),
          _buildOrderSummaryRow(
              'Tạm tính', '₫${cartState.subtotal.toStringAsFixed(2)}'),
          _buildOrderSummaryRow(
              'Phí giao hàng', '₫${cartState.shippingFee.toStringAsFixed(2)}'),
          _buildOrderSummaryRow(
              'Giảm giá', '-₫${cartState.discount.toStringAsFixed(2)}',
              isDiscount: true),
          Divider(height: 24, thickness: 1),
          _buildOrderSummaryRow(
              'Tổng cộng', '₫${cartState.total.toStringAsFixed(2)}',
              isBold: true),
        ],
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> item) {
    final quantity = item['quantity'] ?? 1;
    final price = item['discountPrice'] ?? item['price'] ?? 0.0;
    final total = price * quantity;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '${item['name']} x $quantity',
              style: TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '₫${total.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryRow(String label, String value,
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
