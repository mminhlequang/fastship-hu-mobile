import 'package:flutter/material.dart';
import 'package:internal_core/widgets/widgets.dart';

class AppColors {
  static const primary = Color(0xFF538D33);
  static const secondary = Color(0xFFF17228);
  static const background = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF000000);
  static const textSecondary = Color(0xFF757575);
  static const textGrey = Color(0xFF616161);
  static const divider = Color(0xFFEEE);
  static const cardBackground = Color(0xFFF9F9FC);
  static const ratingColor = Color(0xFFFC8A06);
  static const discountBadge = Color(0xFFF17228);
  static const greenButton = Color(0xFF74CA45);
}

class AppTextStyles {
  static const urbanist = TextStyle(
    fontFamily: 'Urbanist',
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  static const fredoka = TextStyle(
    fontFamily: 'Fredoka',
    fontWeight: FontWeight.w400,
  );

  static TextStyle heading1 = fredoka.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle heading2 = fredoka.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle body1 = fredoka.copyWith(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static TextStyle body2 = fredoka.copyWith(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static TextStyle caption = fredoka.copyWith(
    fontSize: 12,
    color: AppColors.textGrey,
  );
}

class LocationHeader extends StatelessWidget {
  const LocationHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.network(
              'https://cdn.builder.io/api/v1/image/assets/TEMP/6fe75dc75f6a2d908bc17000d0b54417d6e6a0d9?placeholderIfAbsent=true',
              width: 48,
              height: 48,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deliver to',
                  style: AppTextStyles.body2
                      .copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    WidgetAppSVG.network(
                      'https://cdn.builder.io/api/v1/image/assets/TEMP/7b1d8ae7002bb251f986db962a721d67ea805c97?placeholderIfAbsent=true',
                      width: 18,
                      height: 18,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Regent, London',
                      style: AppTextStyles.body1,
                    ),
                    const SizedBox(width: 4),
                    WidgetAppSVG.network(
                      'https://cdn.builder.io/api/v1/image/assets/TEMP/723312f5d170b02ba79de143973053b9ba04467b?placeholderIfAbsent=true',
                      width: 18,
                      height: 18,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                ),
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: WidgetAppSVG.network(
                  'https://cdn.builder.io/api/v1/image/assets/TEMP/9935934676c6d1f9986d6ad0ef54c80ff5eb3dd8?placeholderIfAbsent=true',
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                const SizedBox(height: 92),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

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
          WidgetAppSVG.network(
            'https://cdn.builder.io/api/v1/image/assets/TEMP/ac736bec68a5c7fa808a24ff3a52270532506c44?placeholderIfAbsent=true',
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'What are you craving?.....',
              style: AppTextStyles.body1.copyWith(
                color: const Color(0xFFACA9A9),
                letterSpacing: 0.08,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PromoBanner extends StatelessWidget {
  const PromoBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.primary,
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
                  style: AppTextStyles.heading2.copyWith(
                    color: Colors.white,
                    letterSpacing: 0.51,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Get special discount',
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.white,
                    letterSpacing: 0.12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$ 12.88',
                  style: AppTextStyles.heading1.copyWith(
                    color: Colors.white,
                    letterSpacing: 0.54,
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
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.greenButton,
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
    );
  }
}

class CategorySection extends StatelessWidget {
  const CategorySection({Key? key}) : super(key: key);

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
              style: AppTextStyles.heading1,
            ),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: AppColors.divider),
                color: Colors.white,
              ),
              child: Center(
                child: WidgetAppSVG.network(
                  'https://cdn.builder.io/api/v1/image/assets/TEMP/46077d169b8fe4f3bcf5223e5ba54a905d425ec9?placeholderIfAbsent=true',
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildCategoryItem('Fast food',
                  'https://cdn.builder.io/api/v1/image/assets/TEMP/e822d097aadea12787a2bd37e3b03955429c24ef?placeholderIfAbsent=true'),
              _buildCategoryItem('Pizza',
                  'https://cdn.builder.io/api/v1/image/assets/TEMP/1ff32d092e27f7da815fb412366e9b7dfa1dbb24?placeholderIfAbsent=true'),
              _buildCategoryItem('Salads',
                  'https://cdn.builder.io/api/v1/image/assets/TEMP/2c0135a4d0f9ab2d25c3250fe57ae4880eaa6754?placeholderIfAbsent=true'),
              _buildCategoryItem('Pasta',
                  'https://cdn.builder.io/api/v1/image/assets/TEMP/0608d453482ad8711c95c8ac779f52129c3b010d?placeholderIfAbsent=true'),
              _buildCategoryItem('Pasta',
                  'https://cdn.builder.io/api/v1/image/assets/TEMP/6f12e27793b20d57d6eaab5c6fbc361679070313?placeholderIfAbsent=true'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(String title, String imageUrl) {
    return Container(
      width: 84,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Column(
        children: [
          WidgetAppSVG.network(
            imageUrl,
            width: 48,
            height: 48,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String rating;
  final String deliveryTime;
  final String originalPrice;
  final String discountedPrice;
  final String discountPercentage;

  const RestaurantCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.deliveryTime,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 175,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  height: 146,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(123),
                  ),
                  child: Center(
                    child: Image.network(
                      'https://cdn.builder.io/api/v1/image/assets/TEMP/ec2b7a9981a6520af27f53530b2498576b254006?placeholderIfAbsent=true',
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 5,
                left: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.discountBadge,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$discountPercentage off',
                    style: AppTextStyles.caption.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.network(
                    'https://cdn.builder.io/api/v1/image/assets/TEMP/473a7b3b713820da1587d9e18f45e3600a86de71?placeholderIfAbsent=true',
                    width: 18,
                    height: 18,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    name,
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: AppColors.ratingColor,
                    size: 14,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    rating,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.ratingColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: AppTextStyles.body1,
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: Color(0xFFA6A0A0),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    deliveryTime,
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFFA6A0A0),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    originalPrice,
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFFA6A0A0),
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    discountedPrice,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final String imageUrl;
  final String date;
  final String title;

  const NewsCard({
    Key? key,
    required this.imageUrl,
    required this.date,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 287,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EFE9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 145,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Blog',
                style: AppTextStyles.caption.copyWith(
                  color: const Color(0xFF939191),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 1,
                height: 11,
                color: const Color(0xFFD0D0D0),
              ),
              const SizedBox(width: 8),
              Text(
                date,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.secondary,
                  letterSpacing: 0.12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.body2.copyWith(
              color: const Color(0xFF0B0B0B),
              height: 1.4,
              letterSpacing: 0.14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class FastestDeliverySection extends StatelessWidget {
  const FastestDeliverySection({Key? key}) : super(key: key);

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
              style: AppTextStyles.heading1,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 24),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              RestaurantCard(
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
              RestaurantCard(
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
  const DiscountSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Discount Guaranteed! 👌',
          style: AppTextStyles.heading1,
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildDiscountCard(
                'https://cdn.builder.io/api/v1/image/assets/TEMP/2c973547f4b25e32f0bf83b49a720ee383206fa5?placeholderIfAbsent=true',
                '40% off',
                '5',
              ),
              const SizedBox(width: 12),
              _buildDiscountCard(
                'https://cdn.builder.io/api/v1/image/assets/TEMP/8a3959e64f4431841283cdb9191500efa585eff2?placeholderIfAbsent=true',
                '40% off',
                '5',
                title: 'Chef Burgers London',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.greenButton : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Colors.transparent : const Color(0xFFF1F1F1),
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.body2.copyWith(
          color: isSelected ? Colors.white : const Color(0xFF57585D),
        ),
      ),
    );
  }

  Widget _buildDiscountCard(String imageUrl, String discount, String rating,
      {String? title}) {
    return Container(
      width: 269,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    discount,
                    style: AppTextStyles.caption.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          if (title != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppTextStyles.heading2,
                ),
                Row(
                  children: [
                    Text(
                      rating,
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.ratingColor,
                      ),
                    ),
                    const Icon(
                      Icons.star,
                      color: AppColors.ratingColor,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class RecommendedSection extends StatelessWidget {
  const RecommendedSection({Key? key}) : super(key: key);

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
              style: AppTextStyles.heading1,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 24),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              RestaurantCard(
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
              RestaurantCard(
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
  const BestSellerSection({Key? key}) : super(key: key);

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
              style: AppTextStyles.heading1,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 24),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildBestSellerCard(),
              const SizedBox(width: 12),
              _buildBestSellerCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBestSellerCard() {
    return Container(
      width: 287,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Image.network(
                          'URL_TICKET_ICON',
                          width: 14,
                          height: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '20% off',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 13),
                  Text(
                    'Blueberry\npancake',
                    style: AppTextStyles.heading1,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '\$ 3.30',
                        style: AppTextStyles.body1.copyWith(
                          color: const Color(0xFFA6A0A0),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '\$ 2.20',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Image.network(
                'https://cdn.builder.io/api/v1/image/assets/TEMP/82c707a2dc11de621b524952c587df0767d67239?placeholderIfAbsent=true',
                width: 138,
                height: 138,
                fit: BoxFit.cover,
              ),
            ],
          ),
          const Divider(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                    'https://cdn.builder.io/api/v1/image/assets/TEMP/faa0a8ddc8f18a4a4a6a54bb26a8e6610500992d?placeholderIfAbsent=true'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Restaurant name',
                      style: AppTextStyles.caption,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '15-20m',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 1,
                          height: 11,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(width: 4),
                        Row(
                          children: [
                            Image.network(
                              'URL_DELIVERY_ICON',
                              width: 18,
                              height: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '\$1.30',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: AppColors.ratingColor,
                    size: 14,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '4.5',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.ratingColor,
                    ),
                  ),
                  Text(
                    ' (1.9k)',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NewsSection extends StatelessWidget {
  const NewsSection({Key? key}) : super(key: key);

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
              style: AppTextStyles.heading1.copyWith(
                fontSize: 24,
              ),
            ),
            Text(
              'View all',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              NewsCard(
                imageUrl:
                    'https://cdn.builder.io/api/v1/image/assets/TEMP/03c146378bbce8c0c7c42a41cf29a2d45ebbe72c?placeholderIfAbsent=true',
                date: 'Mar 4, 2025',
                title:
                    'Introducing GrabAds and the Top 3 GrabAds Campaigns That Really ...',
              ),
              SizedBox(width: 12),
              NewsCard(
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
  const PartnerSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Let's be partners now!",
          style: AppTextStyles.heading1,
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildPartnerCard(
                'Signup as a business',
                'Partner with us',
                'https://cdn.builder.io/api/v1/image/assets/TEMP/db5e0eca3384e72f7a39529714db31b33f57e8e8?placeholderIfAbsent=true',
                'Get Started',
                'https://cdn.builder.io/api/v1/image/assets/TEMP/a8e942bb9e8e4bcdd697e2ab0313c08e987509ad?placeholderIfAbsent=true',
              ),
              const SizedBox(width: 12),
              _buildPartnerCard(
                'Ride with us',
                'Ride with us',
                'https://cdn.builder.io/api/v1/image/assets/TEMP/ba2b483a577d0e0a267ca77ade923c2cc6780b5d?placeholderIfAbsent=true',
                'Get Started',
                'https://cdn.builder.io/api/v1/image/assets/TEMP/7975bd946fd7b618aff7120a93e603204ddfdea3?placeholderIfAbsent=true',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPartnerCard(
    String subtitle,
    String title,
    String imageUrl,
    String buttonText,
    String arrowIconUrl,
  ) {
    return Container(
      width: 175,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: NetworkImage(
              'https://cdn.builder.io/api/v1/image/assets/TEMP/8763ad78ab5cfb7bc215f643d78505101d659557?placeholderIfAbsent=true'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: AppTextStyles.caption.copyWith(
              color: const Color(0xFF636363),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.heading1,
          ),
          const SizedBox(height: 16),
          Center(
            child: Image.network(
              imageUrl,
              width: 118,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                buttonText,
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.secondary,
                  decoration: TextDecoration.underline,
                ),
              ),
              Image.network(
                arrowIconUrl,
                width: 24,
                height: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
