import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Widget hiển thị một món ăn trong giỏ hàng
class CartItemCard extends StatelessWidget {
  final Map<String, dynamic> food;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.food,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final quantity = food['quantity'] ?? 1;
    final price = food['discountPrice'] ?? food['price'] ?? 0.0;
    final total = price * quantity;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              food['image'] ?? 'assets/images/pancake.png',
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        food['name'] ?? 'Món ăn',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, size: 16, color: Colors.grey),
                      constraints: BoxConstraints(),
                      padding: EdgeInsets.zero,
                      onPressed: onRemove,
                    ),
                  ],
                ),
                const Gap(4),
                Text(
                  '₫${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    QuantityControl(
                      quantity: quantity,
                      onChanged: onQuantityChanged,
                    ),
                    Text(
                      '₫${total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget điều khiển số lượng món ăn
class QuantityControl extends StatelessWidget {
  final int quantity;
  final Function(int) onChanged;

  const QuantityControl({
    super.key,
    required this.quantity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildButton(
            icon: Icons.remove,
            onPressed: () {
              if (quantity > 1) {
                onChanged(quantity - 1);
              }
            },
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              quantity.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          _buildButton(
            icon: Icons.add,
            onPressed: () => onChanged(quantity + 1),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(6),
        child: Icon(icon, size: 16),
      ),
    );
  }
}

/// Widget hiển thị thẻ mã giảm giá
class PromoCodeCard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onApply;
  final String? message;
  final bool isValid;

  const PromoCodeCard({
    super.key,
    required this.controller,
    required this.onApply,
    this.message,
    this.isValid = false,
  });

  @override
  Widget build(BuildContext context) {
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
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Nhập mã giảm giá',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              const Gap(12),
              ElevatedButton(
                onPressed: onApply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
          if (message != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                message!,
                style: TextStyle(
                  color: isValid ? Colors.green : Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
