import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

// Tệp này sẽ chứa các widget tùy chỉnh cho trang chi tiết nhà hàng

/// Widget hiển thị thông tin cơ bản của nhà hàng
class RestaurantInfoHeader extends StatelessWidget {
  final Map<String, dynamic> restaurant;
  final VoidCallback onFavoriteToggle;

  const RestaurantInfoHeader({
    super.key,
    required this.restaurant,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                restaurant['name'] ?? '',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(
                restaurant['isFavorite'] == true
                    ? Icons.favorite
                    : Icons.favorite_border,
                color:
                    restaurant['isFavorite'] == true ? Colors.red : Colors.grey,
              ),
              onPressed: onFavoriteToggle,
            ),
          ],
        ),
        const Gap(8),
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber, size: 20),
            Text(
              ' ${restaurant['rating']} (${restaurant['reviewCount']} đánh giá)',
              style: TextStyle(fontSize: 14),
            ),
            const Gap(16),
            Text(
              restaurant['priceRange'] ?? '',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const Gap(16),
            Icon(Icons.location_on, color: Colors.grey, size: 16),
            Text(
              ' ${restaurant['distance'] ?? ''}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Widget hiển thị các tab
class RestaurantTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;

  const RestaurantTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          _buildTabItem('Món ăn', 0),
          _buildTabItem('Đánh giá', 1),
          _buildTabItem('Thông tin', 2),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    final isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(index),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.green : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.green : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget hiển thị thẻ món ăn
class FoodItemCard extends StatelessWidget {
  final Map<String, dynamic> food;
  final Function(String) onFavoriteToggle;
  final Function(String) onTap;

  const FoodItemCard({
    super.key,
    required this.food,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(food['id']),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.asset(
                food['image'] ?? 'assets/images/pancake.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (food['isPopular'] == true)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Phổ biến',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        Expanded(
                          child: Text(
                            food['name'] ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Gap(4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 14),
                        Text(
                          ' ${food['rating']} (${food['reviewCount']})',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const Gap(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₫ ${food['price']?.toStringAsFixed(2) ?? '0.00'}',
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '₫ ${food['discountPrice']?.toStringAsFixed(2) ?? '0.00'}',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(
                            food['isFavorite'] == true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: food['isFavorite'] == true
                                ? Colors.red
                                : Colors.grey,
                            size: 20,
                          ),
                          onPressed: () => onFavoriteToggle(food['id']),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget hiển thị thông tin liên hệ
class ContactInfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String info;
  final VoidCallback? onTap;

  const ContactInfoItem({
    super.key,
    required this.icon,
    required this.title,
    required this.info,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.black),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    info,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null) Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}

/// Widget hiển thị danh sách danh mục
class CategoryList extends StatelessWidget {
  final List<dynamic> categories;

  const CategoryList({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            category.toString(),
            style: TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
    );
  }
}
