import 'package:flutter/material.dart';
import 'package:internal_core/widgets/widget_commons.dart';

class RestaurantsScreen extends StatelessWidget {
  const RestaurantsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildCategories(),
              _buildFilters(),
              _buildRestaurantList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '9:41',
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(height: 14),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xFFF4F4F4),
              borderRadius: BorderRadius.circular(56),
            ),
            child: Row(
              children: [
                WidgetAppSVG.network(
                    'https://cdn.builder.io/api/v1/image/assets/TEMP/ac736bec68a5c7fa808a24ff3a52270532506c44?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                    width: 24,
                    height: 24),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'What are you craving?.....',
                    style: TextStyle(
                      fontFamily: 'Fredoka',
                      color: Color(0xFF847D79),
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.08,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      Category(
          name: 'Salads',
          imageUrl:
              'https://cdn.builder.io/api/v1/image/assets/TEMP/2a0c54a2ec86a9cbdd54508194d7f3434a2df59d?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215'),
      Category(
          name: 'Pizza',
          imageUrl:
              'https://cdn.builder.io/api/v1/image/assets/TEMP/a8be57d563f93ab9da52030d499ceec3468bfd5e?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215'),
      Category(
          name: 'Pasta',
          imageUrl:
              'https://cdn.builder.io/api/v1/image/assets/TEMP/3ef9b98aa2315232548cf50a6da47e2f3c185e46?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215'),
      Category(
          name: 'Coffee',
          imageUrl:
              'https://cdn.builder.io/api/v1/image/assets/TEMP/93bc2016eece939954046d8b4b52a1daeb167472?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215'),
      Category(
          name: 'Fast food',
          imageUrl:
              'https://cdn.builder.io/api/v1/image/assets/TEMP/9611f8cc5c5c616f15994de1189fbc0ca2d3e4fe?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215'),
    ];

    return Container(
      height: 114,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return CategoryItem(category: categories[index]);
        },
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Wrap(
            spacing: 10,
            children: [
              _buildFilterChip('Promotion', isSelected: true),
              _buildFilterChip('shipping fee'),
              _buildFilterChip('Price'),
            ],
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xFFEEE)),
            ),
            child: Center(
              child: Image.network(
                  'https://cdn.builder.io/api/v1/image/assets/TEMP/a7e295daaf2ab6767c0335df283dbfbe576b8816?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                  width: 24,
                  height: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFFF9F8F6),
        borderRadius: BorderRadius.circular(12),
        border: isSelected ? Border.all(color: Color(0xFF74CA45)) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Fredoka',
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildRestaurantList() {
    final restaurants = [
      Restaurant(
        name: 'Kentucky Fried Chicken..',
        imageUrl:
            'https://cdn.builder.io/api/v1/image/assets/TEMP/bbe1e4f8d2b9d79f9eeea09a274c707915ee6a43?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
        logoUrl:
            'https://cdn.builder.io/api/v1/image/assets/TEMP/72af6b15cd389d7c8ae0fac0c6ad5d0d71b801e8?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
        category: 'Pizza',
        rating: 4.5,
        deliveryFee: 1.00,
        discount: '20% off',
        deliveryTime: '20-30 Mins',
      ),
      // Add more restaurants here
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'All restaurants',
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: RestaurantCard(restaurant: restaurants[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFF9F8F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              restaurant.imageUrl,
              width: 105,
              height: 105,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 9),
                _buildInfo(),
                SizedBox(height: 9),
                Divider(color: Color(0xFFF1EFE9)),
                SizedBox(height: 9),
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 11.5,
          backgroundImage: NetworkImage(restaurant.logoUrl),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            restaurant.name,
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              restaurant.category,
              style: TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 14,
                color: Color(0xFF847D79),
              ),
            ),
            SizedBox(width: 12),
            Container(
              width: 1,
              height: 16,
              color: Color(0xFFF1EFE9),
            ),
            SizedBox(width: 12),
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: 14,
                  color: Color(0xFFFC8A06),
                ),
                SizedBox(width: 3),
                Text(
                  restaurant.rating.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFC8A06),
                    letterSpacing: 0.06,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            WidgetAppSVG.network(
              'https://cdn.builder.io/api/v1/image/assets/TEMP/e2823b525107b0083e65551c21cd6bf62a92eae8?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
              width: 20,
              height: 20,
            ),
            SizedBox(width: 4),
            Text(
              '\$${restaurant.deliveryFee.toStringAsFixed(2)}',
              style: TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        if (restaurant.discount != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFFF17228),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                WidgetAppSVG.network('URL_DISCOUNT_ICON',
                    width: 14, height: 14),
                SizedBox(width: 2),
                Text(
                  restaurant.discount!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Fredoka',
                  ),
                ),
              ],
            ),
          ),
        SizedBox(width: 12),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFFFAB17)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              WidgetAppSVG.network('URL_CLOCK_ICON', width: 16, height: 16),
              SizedBox(width: 2),
              Text(
                restaurant.deliveryTime,
                style: TextStyle(
                  color: Color(0xFFFFAB17),
                  fontSize: 14,
                  fontFamily: 'Fredoka',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CategoryItem extends StatelessWidget {
  final Category category;

  const CategoryItem({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      padding: EdgeInsets.all(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WidgetAppSVG.network(
            category.imageUrl,
            width: 48,
            height: 48,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 4),
          Text(
            category.name,
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 12,
              color: Color(0xFF03081F),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class Restaurant {
  final String name;
  final String imageUrl;
  final String logoUrl;
  final String category;
  final double rating;
  final double deliveryFee;
  final String? discount;
  final String deliveryTime;

  Restaurant({
    required this.name,
    required this.imageUrl,
    required this.logoUrl,
    required this.category,
    required this.rating,
    required this.deliveryFee,
    this.discount,
    required this.deliveryTime,
  });
}

class Category {
  final String name;
  final String imageUrl;

  Category({
    required this.name,
    required this.imageUrl,
  });
}
