import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';
import 'package:go_router/go_router.dart';
import 'package:app/src/utils/utils.dart';

import 'cubit/food_detail_cubit.dart';
import 'widgets/food_detail_widgets.dart';

class FoodDetailScreen extends StatefulWidget {
  final String foodId;

  const FoodDetailScreen({
    super.key,
    required this.foodId,
  });

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  late final FoodDetailCubit _cubit;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    _cubit = foodDetailCubit;
    _cubit.getFoodDetail(widget.foodId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<FoodDetailCubit, FoodDetailState>(
        bloc: _cubit,
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.error,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    onPressed: () => _cubit.getFoodDetail(widget.foodId),
                    child: Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          if (state.foodDetail == null) {
            return Center(
              child: Text('Không tìm thấy thông tin món ăn'),
            );
          }

          final food = state.foodDetail!;
          return CustomScrollView(
            slivers: [
              _buildAppBar(food),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              food['name'] ?? '',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              food['isFavorite'] == true
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: food['isFavorite'] == true
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () => _cubit.updateFavorite(),
                          ),
                        ],
                      ),
                      const Gap(8),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          Text(
                            ' ${food['rating']} (${food['reviews']} đánh giá)',
                            style: TextStyle(fontSize: 14),
                          ),
                          const Gap(16),
                          Icon(Icons.location_on, color: Colors.grey, size: 16),
                          Text(
                            ' ${food['restaurant']?['distance'] ?? ''}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const Gap(16),
                      Row(
                        children: [
                          Text(
                            '₫ ${food['price']?.toStringAsFixed(2) ?? '0.00'}',
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          const Gap(12),
                          Text(
                            '₫ ${food['discountPrice']?.toStringAsFixed(2) ?? '0.00'}',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                      const Gap(24),
                      Text(
                        'Mô tả',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        food['description'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      const Gap(24),
                      Text(
                        'Nguyên liệu',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(12),
                      _buildIngredientsList(
                          food['ingredients'] as List<dynamic>? ?? []),
                      const Gap(24),
                      Text(
                        'Nhà hàng',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(12),
                      _buildRestaurantInfo(
                          food['restaurant'] as Map<String, dynamic>? ?? {}),
                      const Gap(24),
                      Text(
                        'Dinh dưỡng',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(12),
                      _buildNutritionInfo(
                          food['nutrition'] as Map<String, dynamic>? ?? {}),
                      const Gap(40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<FoodDetailCubit, FoodDetailState>(
        bloc: _cubit,
        builder: (context, state) {
          if (state.foodDetail == null) return SizedBox();

          final food = state.foodDetail!;
          final quantity = food['quantity'] ?? 1;

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => _cubit.updateQuantity(quantity - 1),
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
                        onPressed: () => _cubit.updateQuantity(quantity + 1),
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Xử lý thêm vào giỏ hàng
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Đã thêm vào giỏ hàng'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Thêm vào giỏ hàng - ₫${(food['discountPrice'] * quantity).toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(Map<String, dynamic> food) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(Icons.share, color: Colors.black),
          ),
          onPressed: () {
            // Xử lý chia sẻ
          },
        ),
        const Gap(16),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              food['image'] ?? 'assets/images/pancake.png',
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientsList(List<dynamic> ingredients) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ingredients.map((ingredient) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            ingredient.toString(),
            style: TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRestaurantInfo(Map<String, dynamic> restaurant) {
    return GestureDetector(
      onTap: () {
        // Điều hướng đến trang chi tiết nhà hàng
        if (restaurant['id'] != null) {
          context.push('/restaurant-detail/${restaurant['id']}');
        }
      },
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

  Widget _buildNutritionInfo(Map<String, dynamic> nutrition) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNutritionItem(
            'Calo', '${nutrition['calories'] ?? 0}', Colors.orange),
        _buildNutritionItem(
            'Protein', '${nutrition['proteins'] ?? 0}g', Colors.green),
        _buildNutritionItem(
            'Carbs', '${nutrition['carbs'] ?? 0}g', Colors.blue),
        _buildNutritionItem(
            'Chất béo', '${nutrition['fats'] ?? 0}g', Colors.red),
      ],
    );
  }

  Widget _buildNutritionItem(String label, String value, Color color) {
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
