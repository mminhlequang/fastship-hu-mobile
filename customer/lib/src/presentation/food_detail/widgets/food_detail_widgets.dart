import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

// Tệp này sẽ chứa các widget tùy chỉnh cho trang chi tiết món ăn

/// Widget hiển thị badge khuyến mãi
class PromotionBadge extends StatelessWidget {
  final String text;
  final Color color;

  const PromotionBadge({
    super.key,
    required this.text,
    this.color = Colors.orange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Widget hiển thị nút điều khiển số lượng
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
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () => onChanged(quantity - 1 > 0 ? quantity - 1 : 1),
          ),
          Text(
            quantity.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => onChanged(quantity + 1),
          ),
        ],
      ),
    );
  }
}

/// Widget hiển thị thông tin dinh dưỡng
class NutritionItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const NutritionItem({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.circle,
            color: color,
            size: 24,
          ),
        ),
        const Gap(8),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

/// Widget hiển thị badge nguyên liệu
class IngredientBadge extends StatelessWidget {
  final String text;

  const IngredientBadge({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}

/// Widget hiển thị thông tin nhà hàng
class RestaurantInfoCard extends StatelessWidget {
  final Map<String, dynamic> restaurant;
  final VoidCallback onTap;

  const RestaurantInfoCard({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: Text(
                restaurant['name']?.substring(0, 1) ?? 'R',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant['name'] ?? 'Nhà hàng',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Khoảng cách: ${restaurant['distance'] ?? ''}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
