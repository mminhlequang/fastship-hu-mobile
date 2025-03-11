import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';
import 'package:go_router/go_router.dart';
import 'package:app/src/utils/utils.dart';

import 'cubit/restaurant_detail_cubit.dart';
import 'widgets/restaurant_detail_widgets.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  late final RestaurantDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = restaurantDetailCubit;
    _cubit.getRestaurantDetail(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<RestaurantDetailCubit, RestaurantDetailState>(
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
                    onPressed: () =>
                        _cubit.getRestaurantDetail(widget.restaurantId),
                    child: Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          if (state.restaurantDetail == null) {
            return Center(
              child: Text('Không tìm thấy thông tin nhà hàng'),
            );
          }

          final restaurant = state.restaurantDetail!;
          return CustomScrollView(
            slivers: [
              _buildAppBar(restaurant),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RestaurantInfoHeader(
                        restaurant: restaurant,
                        onFavoriteToggle: () => _cubit.updateFavorite(),
                      ),
                      const Gap(24),
                      RestaurantTabBar(
                        selectedIndex: state.selectedTabIndex,
                        onTabChanged: (index) => _cubit.changeTab(index),
                      ),
                      const Gap(16),
                      _buildTabContent(state),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(Map<String, dynamic> restaurant) {
    return SliverAppBar(
      expandedHeight: 200,
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
              restaurant['coverImage'] ?? 'assets/images/restaurant_cover.png',
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(
                      restaurant['logo'] ?? 'assets/images/restaurant_logo.png',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(RestaurantDetailState state) {
    final restaurant = state.restaurantDetail!;

    switch (state.selectedTabIndex) {
      case 0:
        return _buildFoodTab(restaurant);
      case 1:
        return _buildReviewsTab(restaurant);
      case 2:
        return _buildInfoTab(restaurant);
      default:
        return _buildFoodTab(restaurant);
    }
  }

  Widget _buildFoodTab(Map<String, dynamic> restaurant) {
    final foodItems = restaurant['foodItems'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Danh sách món ăn',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(16),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: foodItems.length,
          itemBuilder: (context, index) {
            final food = foodItems[index] as Map<String, dynamic>;
            return FoodItemCard(
              food: food,
              onFavoriteToggle: (foodId) => _cubit.toggleFoodFavorite(foodId),
              onTap: (foodId) {
                context.push('/food-detail/$foodId');
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildReviewsTab(Map<String, dynamic> restaurant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Đánh giá từ khách hàng',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(16),
        Center(
          child: Column(
            children: [
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 48,
              ),
              Text(
                '${restaurant['rating']}',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'dựa trên ${restaurant['reviewCount']} đánh giá',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const Gap(16),
              ElevatedButton(
                onPressed: () {
                  // Chức năng thêm đánh giá
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Thêm đánh giá',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Gap(24),
        Text(
          'Tính năng đánh giá đang được phát triển.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildInfoTab(Map<String, dynamic> restaurant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin nhà hàng',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(16),
        Text(
          restaurant['description'] ?? '',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
        const Gap(24),
        Text(
          'Danh mục',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(12),
        CategoryList(
          categories: restaurant['categories'] as List<dynamic>? ?? [],
        ),
        const Gap(24),
        Text(
          'Thông tin liên hệ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(12),
        ContactInfoItem(
          icon: Icons.access_time,
          title: 'Giờ mở cửa',
          info: restaurant['openingHours'] ?? '',
        ),
        ContactInfoItem(
          icon: Icons.location_on,
          title: 'Địa chỉ',
          info: restaurant['location'] ?? '',
          onTap: () {
            // Mở bản đồ
          },
        ),
        ContactInfoItem(
          icon: Icons.call,
          title: 'Điện thoại',
          info: restaurant['phone'] ?? '',
          onTap: () {
            // Gọi điện
          },
        ),
      ],
    );
  }
}
