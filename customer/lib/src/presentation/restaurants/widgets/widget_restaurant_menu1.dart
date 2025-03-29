import 'package:flutter/material.dart';

class RestaurantMenu extends StatelessWidget {
  const RestaurantMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      constraints: const BoxConstraints(maxWidth: 480),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Time display
                Padding(
                  padding: const EdgeInsets.only(left: 11),
                  child: Text(
                    '9:41',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                      height: 1.4,
                    ),
                  ),
                ),

                // Top navigation bar
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                          width: 24, height: 24), // Left icon placeholder
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Image.network(
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/ac736bec68a5c7fa808a24ff3a52270532506c44?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                              width: 24,
                              height: 24,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 44,
                            height: 44,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Image.network(
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/d58b7e51323f3db59aa46990b858bacd504e84e8?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                              width: 24,
                              height: 24,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Restaurant image
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://cdn.builder.io/api/v1/image/assets/TEMP/9fbe08ff6443674890f4ea7e1a23a525c9dd8cb0?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Order information section
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border:
                                  Border.all(color: const Color(0xFFE7E7E7)),
                              color: Colors.white,
                            ),
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Fredoka',
                                  fontSize: 14,
                                  letterSpacing: 0.14,
                                  color: Color(0xFF7A838C),
                                ),
                                children: [
                                  TextSpan(text: 'Min. order: '),
                                  TextSpan(
                                    text: '\$1,00',
                                    style: TextStyle(color: Color(0xFF3C3836)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border:
                                  Border.all(color: const Color(0xFFE7E7E7)),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Image.network(
                                  'https://cdn.builder.io/api/v1/image/assets/TEMP/877e98d6e10d675f20cc13e3f115e5f361c6274a?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  '\$2,00',
                                  style: TextStyle(
                                    fontFamily: 'Fredoka',
                                    fontSize: 14,
                                    color: Color(0xFF3C3836),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border:
                                  Border.all(color: const Color(0xFFE7E7E7)),
                              color: Colors.white,
                            ),
                            child: const Text(
                              'More',
                              style: TextStyle(
                                fontFamily: 'Fredoka',
                                fontSize: 14,
                                color: Color(0xFFF17228),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Image.network(
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/ac736bec68a5c7fa808a24ff3a52270532506c44?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                              width: 24,
                              height: 24,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Container(
                            width: 38,
                            height: 38,
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: const Color(0xFFF4F4F4),
                            ),
                            child: Image.network(
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/46077d169b8fe4f3bcf5223e5ba54a905d425ec9?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                              width: 24,
                              height: 24,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Menu sections
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Most ordered section
                const Text(
                  'Most ordered 🧀',
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.4,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'This is a limited quantity item!',
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 14,
                    letterSpacing: 0.14,
                    color: Color(0xFF847D79),
                  ),
                ),
                const SizedBox(height: 15),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildMenuItem(
                          'https://cdn.builder.io/api/v1/image/assets/TEMP/224c42c723ec093c48f7775799c73488a82b5349?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215'),
                      const SizedBox(width: 12),
                      _buildMenuItem(
                          'https://cdn.builder.io/api/v1/image/assets/TEMP/8fc8769ad833dca8a975a126352ca2b9c3f0f840?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215'),
                      const SizedBox(width: 12),
                      Container(
                        width: 174,
                        height: 223,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color(0xFFF9F8F6),
                        ),
                      ),
                    ],
                  ),
                ),

                // Cheese section
                const SizedBox(height: 12),
                const Text(
                  'Cheese! Cheese! Cheese! 🧀',
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.4,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'This is a limited quantity item!',
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 14,
                    letterSpacing: 0.14,
                    color: Color(0xFF847D79),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildMenuItem(
                          'https://cdn.builder.io/api/v1/image/assets/TEMP/224c42c723ec093c48f7775799c73488a82b5349?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215'),
                      const SizedBox(width: 12),
                      _buildMenuItem(
                          'https://cdn.builder.io/api/v1/image/assets/TEMP/6858314a1c725226a8c82e6a7e877e86bc6d0386?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String imageUrl) {
    return Container(
      width: 175,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFF9F8F6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 159,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Moss cheese burger',
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: const [
              Text(
                '\$3.30',
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 16,
                  color: Color(0xFFA6A0A0),
                  decoration: TextDecoration.lineThrough,
                  letterSpacing: 0.16,
                ),
              ),
              SizedBox(width: 4),
              Text(
                '\$2.20',
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 16,
                  color: Color(0xFFF17228),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
