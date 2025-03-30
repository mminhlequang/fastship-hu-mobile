import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/restaurants/widgets/widget_restaurant_menu2.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';
import 'package:internal_core/widgets/widget_commons.dart';

import '../home/home_screen.dart';
import '../home/widgets/widget_category_card.dart';
import '../home/widgets/widget_dialog_filters.dart';
import '../home/widgets/widget_dish_card.dart';
import '../home/widgets/widget_restaurant_card.dart';
import 'widgets/widget_restaurant_menu.dart';

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({super.key});

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  bool isRestaurant = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              SingleChildScrollView(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    WidgetCategoryCard(
                      title: 'Fast food',
                      imageUrl:
                          'https://cdn.builder.io/api/v1/image/assets/TEMP/a8be57d563f93ab9da52030d499ceec3468bfd5e?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                    ),
                    WidgetCategoryCard(
                      title: 'Pizza',
                      imageUrl:
                          'https://cdn.builder.io/api/v1/image/assets/TEMP/1ff32d092e27f7da815fb412366e9b7dfa1dbb24?placeholderIfAbsent=true',
                    ),
                    WidgetCategoryCard(
                      title: 'Salads',
                      imageUrl:
                          'https://cdn.builder.io/api/v1/image/assets/TEMP/2c0135a4d0f9ab2d25c3250fe57ae4880eaa6754?placeholderIfAbsent=true',
                    ),
                    WidgetCategoryCard(
                      title: 'Pasta',
                      imageUrl:
                          'https://cdn.builder.io/api/v1/image/assets/TEMP/0608d453482ad8711c95c8ac779f52129c3b010d?placeholderIfAbsent=true',
                    ),
                    WidgetCategoryCard(
                      title: 'Pasta',
                      imageUrl:
                          'https://cdn.builder.io/api/v1/image/assets/TEMP/6f12e27793b20d57d6eaab5c6fbc361679070313?placeholderIfAbsent=true',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              _buildFilters(),
              SizedBox(height: 12),
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
          GestureDetector(
            onTap: () {
              appHaptic();
              appOpenDialog(WidgetDialogFilters());
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFFEEE)),
              ),
              child: Center(
                child: WidgetAppSVG.network(
                    'https://cdn.builder.io/api/v1/image/assets/TEMP/a7e295daaf2ab6767c0335df283dbfbe576b8816?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                    width: 24,
                    height: 24),
              ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: WidgetInkWellTransparent(
                      onTap: () {
                        appHaptic();
                        setState(() {
                          isRestaurant = true;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.sw),
                        child: Center(
                          child: Text(
                            'All restaurants',
                            style: w400TextStyle(
                                fontSize: 18.sw,
                                color: isRestaurant
                                    ? appColorText
                                    : Color(0xFF847D79)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: WidgetInkWellTransparent(
                      onTap: () {
                        appHaptic();
                        setState(() {
                          isRestaurant = false;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.sw),
                        child: Center(
                          child: Text(
                            'All foods',
                            style: w400TextStyle(
                                fontSize: 18.sw,
                                color: !isRestaurant
                                    ? appColorText
                                    : Color(0xFF847D79)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                left: isRestaurant ? 0 : context.width / 2 - 16 + 12,
                child: Container(
                  width: context.width / 2 - 16 - 12,
                  height: 2,
                  color: appColorText2,
                ),
              )
            ],
          ),
          SizedBox(height: 16),
          if (isRestaurant)
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: WidgetRestaurantCard(
                    name: 'Restaurant $index',
                    imageUrl:
                        'https://cdn.builder.io/api/v1/image/assets/TEMP/ac736bec68a5c7fa808a24ff3a52270532506c44?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                    logoUrl: '',
                    category: '',
                    rating: 4.5,
                    deliveryFee: 10,
                    deliveryTime: '30',
                  ),
                );
              },
            )
          else
            Wrap(
              spacing: 16.sw,
              runSpacing: 20.sw,
              children: List.generate(
                  12,
                  (index) => WidgetDishCard(
                        width: context.width / 2 - 16 - 8.sw,
                        imageUrl:
                            'https://cdn.builder.io/api/v1/image/assets/TEMP/685b03b5e849fe57da8a7292cedbbff9c23976ac?placeholderIfAbsent=true',
                        name: 'Pizza Hut - Lumintu',
                        rating: '4.5',
                        deliveryTime: '15-20m',
                        originalPrice: '\$ 3.30',
                        discountedPrice: '\$ 2.20',
                        discountPercentage: '20%',
                      )),
            ),
          SizedBox(height: 110),
        ],
      ),
    );
  }
}
