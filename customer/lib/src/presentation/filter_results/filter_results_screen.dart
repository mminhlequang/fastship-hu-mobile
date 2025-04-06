import 'package:flutter/material.dart';

import '../widgets/widget_search_field.dart';

class ListFood extends StatelessWidget {
  const ListFood({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.only(bottom: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: const Color(0xFFF9F8F6),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 12,
                  bottom: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '9:41',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Urbanist',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const SizedBox(
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: WidgetSearchField(
                            onTap: () {
                              // Handle search
                            },
                          ),
                        ),
                        Container(
                          width: 44,
                          padding: const EdgeInsets.all(10),
                          child: Image.network(
                            'https://cdn.builder.io/api/v1/image/assets/TEMP/f9d9522407f52f22ccdbd742ccfa27453c4ed725?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 17),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cafe near me',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 32,
                              fontFamily: 'Fredoka',
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Image.network(
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/46077d169b8fe4f3bcf5223e5ba54a905d425ec9?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                              width: 24,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FoodFilterChip(
                            label: 'Espresso Coffee',
                            isSelected: true,
                          ),
                          const SizedBox(width: 8),
                          FoodFilterChip(
                            label: 'Traditional Coffee',
                            isSelected: false,
                          ),
                          const SizedBox(width: 8),
                          FoodFilterChip(
                            label: 'Cappuccino Coffee',
                            isSelected: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 23),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            'All restaurants',
                            style: TextStyle(
                              color: const Color(0xFF847D79),
                              fontFamily: 'Fredoka',
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'All food',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Fredoka',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Image.network(
                  'https://cdn.builder.io/api/v1/image/assets/TEMP/1f398861c064554f2c2170428b181c3d5cd313d3?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                  width: 175,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.75,
                      children: const [
                        FoodItemCard(
                          imageUrl:
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/37de13feba83b89e5d0184ed9a35387931d323c8?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                          name: 'Macchiato',
                          price: 2.20,
                          originalPrice: 3.30,
                          rating: 4.5,
                          distance: '200m',
                          restaurantName: 'Playa Outdoor',
                          restaurantLogo:
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/304767ab2aba27c75ce3c785ba548137a9f53f32?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                          discount: 1.20,
                        ),
                        FoodItemCard(
                          imageUrl:
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/ae83f352e884c905df4f793abfca173cce2c8d2c?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                          name: 'Traditional Coffee',
                          price: 2.20,
                          originalPrice: 3.30,
                          rating: 4.5,
                          distance: '20m',
                          restaurantName: 'Playa Outdoor',
                          restaurantLogo:
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/760da60a84bac2411a9cdba824de49cbceef1398?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                          discount: 2.20,
                        ),
                        FoodItemCard(
                          imageUrl:
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/95b492ee43d7cdcfa72270691552506e9bd48b7e?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                          name: 'Latte',
                          price: 2.20,
                          originalPrice: 3.30,
                          rating: 4.5,
                          distance: '200m',
                          restaurantName: 'Playa Outdoor',
                          restaurantLogo:
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/11be37dd42008bbda5e50ac00ebf0910c8998fbb?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                          discount: 1.20,
                        ),
                        FoodItemCard(
                          imageUrl:
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/68a58645830b225b909e36382c4afe4f7cfcf2ff?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                          name: 'Latte',
                          price: 2.20,
                          originalPrice: 3.30,
                          rating: 4.5,
                          distance: '15m',
                          restaurantName: 'Playa Outdoor',
                          restaurantLogo:
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/304767ab2aba27c75ce3c785ba548137a9f53f32?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                          discount: 2.20,
                        ),
                        FoodItemCard(
                          imageUrl:
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/168b62483e1259bc74928edd1f64599fe05acfaa?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                          name: 'Espresso',
                          price: 2.20,
                          originalPrice: 3.30,
                          rating: 4.5,
                          distance: '200m',
                          restaurantName: 'Playa Outdoor',
                          restaurantLogo:
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/50271b7067760b27fdb534ccc4f233094dc01f01?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                          discount: 1.20,
                        ),
                        FoodItemCard(
                          imageUrl:
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/1812aeaa6b8d994a0d3f3e75142c20c38ae7abfd?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                          name: 'Instant coffee',
                          price: 2.20,
                          originalPrice: 3.30,
                          rating: 4.5,
                          distance: '15m',
                          restaurantName: 'Playa Outdoor',
                          restaurantLogo:
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/0259121d8f2d3fb26cee5cc308191e970a347365?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                          discount: 2.20,
                        ),
                        FoodItemCard(
                          imageUrl:
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/dacb73ca75b696b59039c5a373680e04012402e8?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                          name: 'Black coffee',
                          price: 2.20,
                          originalPrice: 3.30,
                          rating: 4.5,
                          distance: '200m',
                          restaurantName: 'Playa Outdoor',
                          restaurantLogo:
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/bdffe3c9f489d966154e4a4c5fa5f7b1532a6e03?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                          discount: 1.20,
                        ),
                        FoodItemCard(
                          imageUrl:
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/268bf66a0d968310d361d7a25a8071431abd4189?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                          name: 'Instant coffee',
                          price: 2.20,
                          originalPrice: 3.30,
                          rating: 4.5,
                          distance: '15m',
                          restaurantName: 'Playa Outdoor',
                          restaurantLogo:
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/0259121d8f2d3fb26cee5cc308191e970a347365?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                          discount: 2.20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FoodFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const FoodFilterChip({
    Key? key,
    required this.label,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFF9F8F6) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFFF17228) : const Color(0xFFF1EFE9),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? const Color(0xFFF17228) : const Color(0xFF847D79),
          fontFamily: 'Fredoka',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.28,
          height: 1.2,
        ),
      ),
    );
  }
}

class FoodItemCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double price;
  final double originalPrice;
  final double rating;
  final String distance;
  final String restaurantName;
  final String restaurantLogo;
  final double discount;

  const FoodItemCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.distance,
    required this.restaurantName,
    required this.restaurantLogo,
    required this.discount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 146,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 5,
              left: 5,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(123),
                ),
                child: Center(
                  child: Image.network(
                    'https://cdn.builder.io/api/v1/image/assets/TEMP/d79c26fb1d5dfd86c1ad48ea6283aa258b25b41c?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
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
                  color: const Color(0xFFF17228),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 14,
                      height: 14,
                    ),
                    Text(
                      '\$$discount off',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Fredoka',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                    ),
                  ],
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: Image.network(
                    restaurantLogo,
                    width: 18,
                    height: 18,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  restaurantName,
                  style: TextStyle(
                    color: const Color(0xFF847D79),
                    fontFamily: 'Fredoka',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Color(0xFFFC8A06),
                  size: 14,
                ),
                const SizedBox(width: 3),
                Text(
                  rating.toString(),
                  style: TextStyle(
                    color: const Color(0xFFFC8A06),
                    fontFamily: 'Fredoka',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.06,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Fredoka',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: Color(0xFFA6A0A0),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  distance,
                  style: TextStyle(
                    color: const Color(0xFFA6A0A0),
                    fontFamily: 'Fredoka',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '\$${originalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: const Color(0xFFA6A0A0),
                    fontFamily: 'Fredoka',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.lineThrough,
                    letterSpacing: -0.12,
                  ),
                ),
                const SizedBox(width: 3),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: const Color(0xFFED653B),
                    fontFamily: 'Fredoka',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
