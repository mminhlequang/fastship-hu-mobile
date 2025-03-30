import 'package:app/src/base/bloc.dart';
import 'package:app/src/base/cubit/location_cubit.dart';
import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/navigation/cubit/navigation_cubit.dart';
import 'package:app/src/utils/utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';
import 'package:internal_core/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/widget_category_card.dart';
import 'widgets/widget_dialog_filters.dart';
import 'widgets/widget_dish_card.dart';
import 'widgets/widget_news_card.dart';
import 'widgets/widget_restaurant_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColorBackground,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              16.sw,
              12.sw + context.mediaQueryPadding.top,
              16.sw,
              16.sw + context.mediaQueryPadding.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LocationHeader(),
              const SizedBox(height: 17),
              const SearchBar(),
              const SizedBox(height: 17),
              const PromoBanner(),
              const SizedBox(height: 24),
              const CategorySection(),
              const SizedBox(height: 24),
              const FastestDeliverySection(),
              const SizedBox(height: 32),
              const DiscountSection(),
              const SizedBox(height: 32),
              const BestSellerSection(),
              const SizedBox(height: 32),
              const RecommendedSection(),
              const SizedBox(height: 32),
              const PartnerSection(),
              const SizedBox(height: 32),
              const NewsSection(),
              const SizedBox(height: 110),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(56),
      ),
      child: Row(
        children: [
          WidgetAppSVG(
            'icon29',
            width: 24.sw,
            height: 24.sw,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'What are you craving?.....'.tr(),
              style: w400TextStyle(
                fontSize: 16.sw,
                color: const Color(0xFFACA9A9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 146.sw,
        viewportFraction: 0.8,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        enlargeCenterPage: true,
      ),
      items: List.generate(
        3,
        (index) => Container(
          decoration: BoxDecoration(
            color: appColorPrimary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 14,
                top: 13,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '30% Discount only valid for today!',
                      style: w600TextStyle(
                        fontSize: 18.sw,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Get special discount',
                      style: w400TextStyle(
                        fontSize: 14.sw,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$ 12.88',
                      style: w700TextStyle(
                        fontSize: 22.sw,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Order now',
                            style: w500TextStyle(
                              fontSize: 14.sw,
                              color: appColorPrimary,
                            ),
                          ),
                          const SizedBox(width: 2),
                          WidgetAppSVG.network(
                            'https://cdn.builder.io/api/v1/image/assets/TEMP/2e52ece8ff2046a9cd87f0fcbb0cce173dcb2d83?placeholderIfAbsent=true',
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Image.network(
                  'https://cdn.builder.io/api/v1/image/assets/TEMP/d0b25aa58ede91377611d3f24eef01ac7beb6672?placeholderIfAbsent=true',
                  width: 141,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Popular Categories',
              style: w400TextStyle(fontSize: 20.sw),
            ),
            GestureDetector(
              onTap: () {
                appHaptic();
                appOpenDialog(WidgetDialogFilters());
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: hexColor('#EEEEEE')),
                  color: Colors.white,
                ),
                child: Center(
                  child: WidgetAppSVG(
                    'icon30',
                    width: 24.sw,
                    height: 24.sw,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
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
      ],
    );
  }
}

class FastestDeliverySection extends StatelessWidget {
  const FastestDeliverySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Fastest delivery',
              style: w400TextStyle(fontSize: 20.sw),
            ),
            WidgetAppSVG(
              'icon28',
              width: 24.sw,
              height: 24.sw,
              fit: BoxFit.contain,
            ),
          ],
        ),
        const SizedBox(height: 24),
        SingleChildScrollView(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              WidgetDishCard(
                imageUrl:
                    'https://cdn.builder.io/api/v1/image/assets/TEMP/7d07bcadbd5b9a672e0e03bc56c0838f9edb3dfc?placeholderIfAbsent=true',
                name: 'Vegetarian Noodles',
                rating: '4.5',
                deliveryTime: '15-20m',
                originalPrice: '\$ 3.30',
                discountedPrice: '\$ 2.20',
                discountPercentage: '20%',
              ),
              SizedBox(width: 12),
              WidgetDishCard(
                imageUrl:
                    'https://cdn.builder.io/api/v1/image/assets/TEMP/685b03b5e849fe57da8a7292cedbbff9c23976ac?placeholderIfAbsent=true',
                name: 'Pizza Hut - Lumintu',
                rating: '4.5',
                deliveryTime: '15-20m',
                originalPrice: '\$ 3.30',
                discountedPrice: '\$ 2.20',
                discountPercentage: '20%',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DiscountSection extends StatelessWidget {
  const DiscountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Discount Guaranteed! 👌',
          style: w400TextStyle(fontSize: 20.sw),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('Vegan', false),
              const SizedBox(width: 10),
              _buildFilterChip('Pizza & Fast food', true),
              const SizedBox(width: 10),
              _buildFilterChip('Sushi', false),
              const SizedBox(width: 10),
              _buildFilterChip('others +', false),
            ],
          ),
        ),
        const SizedBox(height: 24),
        CarouselSlider(
          options: CarouselOptions(
            height: 220.sw,
            viewportFraction: 0.68,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
          ),
          items: List.generate(
            3,
            (index) => WidgetRestaurantDiscountCard(
              imageUrl:
                  'https://cdn.builder.io/api/v1/image/assets/TEMP/8a3959e64f4431841283cdb9191500efa585eff2?placeholderIfAbsent=true',
              discount: '40% off',
              rating: '5',
              title: 'Chef Burgers London',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? appColorPrimary : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Colors.transparent : const Color(0xFFF1F1F1),
        ),
      ),
      child: Text(
        label,
        style: w400TextStyle(
          fontSize: 14.sw,
          color: isSelected ? Colors.white : const Color(0xFF57585D),
        ),
      ),
    );
  }
}

class RecommendedSection extends StatelessWidget {
  const RecommendedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recommended For You !',
              style: w400TextStyle(fontSize: 20.sw),
            ),
            WidgetAppSVG(
              'icon28',
              width: 24.sw,
              height: 24.sw,
            ),
          ],
        ),
        const SizedBox(height: 24),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              WidgetDishCard(
                imageUrl:
                    'https://cdn.builder.io/api/v1/image/assets/TEMP/7d07bcadbd5b9a672e0e03bc56c0838f9edb3dfc?placeholderIfAbsent=true',
                name: 'Vegetarian Noodles',
                rating: '4.5',
                deliveryTime: '15-20m',
                originalPrice: '\$ 3.30',
                discountedPrice: '\$ 2.20',
                discountPercentage: '20%',
              ),
              SizedBox(width: 12),
              WidgetDishCard(
                imageUrl:
                    'https://cdn.builder.io/api/v1/image/assets/TEMP/685b03b5e849fe57da8a7292cedbbff9c23976ac?placeholderIfAbsent=true',
                name: 'Pizza Hut - Lumintu',
                rating: '4.5',
                deliveryTime: '15-20m',
                originalPrice: '\$ 3.30',
                discountedPrice: '\$ 2.20',
                discountPercentage: '20%',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BestSellerSection extends StatelessWidget {
  const BestSellerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Best seller',
              style: w400TextStyle(fontSize: 20.sw),
            ),
            WidgetAppSVG(
              'icon28',
              width: 24.sw,
              height: 24.sw,
              fit: BoxFit.contain,
            ),
          ],
        ),
        const SizedBox(height: 24),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              WidgetDishCardV2(
                imageUrl:
                    'https://cdn.builder.io/api/v1/image/assets/TEMP/685b03b5e849fe57da8a7292cedbbff9c23976ac?placeholderIfAbsent=true',
                name: 'Pizza Hut - Lumintu',
                rating: '4.5',
                deliveryTime: '15-20m',
                originalPrice: '\$ 3.30',
                discountedPrice: '\$ 2.20',
                discountPercentage: '20%',
                restaurantName: 'Pizza Hut',
                reviewCount: '100',
                deliveryFee: '\$ 1.00',
              ),
              const SizedBox(width: 12),
              WidgetDishCardV2(
                imageUrl:
                    'https://cdn.builder.io/api/v1/image/assets/TEMP/685b03b5e849fe57da8a7292cedbbff9c23976ac?placeholderIfAbsent=true',
                name: 'Pizza Hut - Lumintu',
                rating: '4.5',
                deliveryTime: '15-20m',
                originalPrice: '\$ 3.30',
                discountedPrice: '\$ 2.20',
                discountPercentage: '20%',
                restaurantName: 'Pizza Hut',
                reviewCount: '100',
                deliveryFee: '\$ 1.00',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NewsSection extends StatelessWidget {
  const NewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'News',
              style: w400TextStyle(fontSize: 20.sw),
            ),
            Text(
              'View all',
              style: w400TextStyle(
                fontSize: 14.sw,
                color: appColorPrimary,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              WidgetNewsCard(
                imageUrl:
                    'https://cdn.builder.io/api/v1/image/assets/TEMP/03c146378bbce8c0c7c42a41cf29a2d45ebbe72c?placeholderIfAbsent=true',
                date: 'Mar 4, 2025',
                title:
                    'Introducing GrabAds and the Top 3 GrabAds Campaigns That Really ...',
              ),
              SizedBox(width: 12),
              WidgetNewsCard(
                imageUrl:
                    'https://cdn.builder.io/api/v1/image/assets/TEMP/d5593d9d67a6d52326cdc1f261075c9e6ce6927d?placeholderIfAbsent=true',
                date: 'Mar 4, 2025',
                title:
                    'Introducing GrabAds and the Top 3 GrabAds Campaigns That Really ...',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PartnerSection extends StatelessWidget {
  const PartnerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Let's be partners now!",
          style: w400TextStyle(fontSize: 20.sw),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildPartnerCard(
              'Signup as a business',
              'Partner with us',
              'icon7',
              'https://www.google.com', //TODO: change to external link
            ),
            const SizedBox(width: 12),
            _buildPartnerCard(
              'Ride with us',
              'Ride with us',
              'icon4',
              'https://www.google.com', //TODO: change to external link
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPartnerCard(
      String subtitle, String title, String icon, String externalLink) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          appHaptic();
          launchUrl(Uri.parse(externalLink));
        },
        child: Container(
          padding: EdgeInsets.all(12.sw),
          decoration: BoxDecoration(
            color: hexColor('#F1EFE9'),
            borderRadius: BorderRadius.circular(12.sw),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle,
                style: w400TextStyle(
                  fontSize: 14.sw,
                  color: hexColor('#636363'),
                ),
              ),
              SizedBox(height: 4.sw),
              Text(
                title,
                style: w500TextStyle(fontSize: 20.sw),
              ),
              SizedBox(height: 16.sw),
              Center(
                child: WidgetAppSVG(
                  icon,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 16.sw),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Get Started'.tr(),
                    style: w400TextStyle(
                      color: hexColor('#F17228'),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  WidgetAppSVG(
                    'icon36',
                    width: 24,
                    height: 24,
                    color: hexColor('#F17228'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LocationHeader extends StatelessWidget {
  const LocationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocBuilder<AuthCubit, AuthState>(
            bloc: authCubit,
            builder: (context, state) {
              if (state.stateType != AuthStateType.logged) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: EdgeInsets.only(right: 8.sw),
                child: WidgetAvatar(
                  imageUrl: state.user?.avatar ?? "",
                  radius1: 48.sw / 2,
                  radius2: 48.sw / 2 - 1.5,
                  radius3: 48.sw / 2 - 1.5,
                  borderColor: appColorBorder,
                ),
              );
            }),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Deliver to',
                style:
                    w400TextStyle(fontSize: 14.sw, color: hexColor('#757575')),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  WidgetAppSVG(
                    'icon23',
                    width: 18.sw,
                    height: 18.sw,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 4),
                  BlocBuilder<LocationCubit, LocationState>(
                      bloc: locationCubit,
                      builder: (context, state) {
                        return ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 200.sw),
                          child: Text(
                            state.formattedAddress ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: w400TextStyle(
                              fontSize: 14.sw,
                            ),
                          ),
                        );
                      }),
                  const SizedBox(width: 4),
                  WidgetAppSVG(
                    'icon3',
                    width: 18.sw,
                    height: 18.sw,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            appHaptic();
            navigationCubit.changeIndex(2);
          },
          child: Container(
            width: 44.sw,
            height: 44.sw,
            child: Center(
              child: WidgetAppSVG(
                'icon2',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            appHaptic();
            context.push('/notifications');
          },
          child: Container(
            width: 44.sw,
            height: 44.sw,
            child: Center(
              child: WidgetAppSVG(
                'icon11',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
