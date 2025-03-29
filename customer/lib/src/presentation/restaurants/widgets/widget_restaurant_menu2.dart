import 'package:flutter/material.dart';

class RestaurantMenuScroll extends StatelessWidget {
  const RestaurantMenuScroll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildMostOrdered(),
            _buildBestSeller(),
            _buildOrderSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '9:41',
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    color: Colors.transparent,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Kentucky .....',
                    style: TextStyle(
                      fontFamily: 'Fredoka',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF120F0F),
                    ),
                  ),
                ],
              ),
              Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                    'https://cdn.builder.io/api/v1/image/assets/TEMP/d58b7e51323f3db59aa46990b858bacd504e84e8?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE7E7E7)),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Image.network(
                  'https://cdn.builder.io/api/v1/image/assets/TEMP/ac736bec68a5c7fa808a24ff3a52270532506c44?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'What are you craving?.....',
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 16,
                    color: Color(0xFF847D79),
                    letterSpacing: 0.08,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: const Color(0xFFF4F4F4),
          ),
          child: Center(
            child: Image.network(
              'https://cdn.builder.io/api/v1/image/assets/TEMP/46077d169b8fe4f3bcf5223e5ba54a905d425ec9?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
              width: 24,
              height: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMostOrdered() {
    return Padding(
      padding: const EdgeInsets.all(19),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Most ordered 🧀',
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'This is a limited quantity item!',
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 14,
              color: Color(0xFF847D79),
              letterSpacing: 0.14,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 223,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  width: 175,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color(0xFFF9F8F6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        'https://cdn.builder.io/api/v1/image/assets/TEMP/224c42c723ec093c48f7775799c73488a82b5349?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                        width: 159,
                        height: 151,
                        fit: BoxFit.cover,
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
                              color: Color(0xFFA6A0A0),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '\$2.20',
                            style: TextStyle(
                              color: Color(0xFFF17228),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestSeller() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Best seller 🧀',
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'This is a limited quantity item!',
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 14,
              color: Color(0xFF847D79),
              letterSpacing: 0.14,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFF9F8F6),
                ),
                child: Row(
                  children: [
                    Image.network(
                      'https://cdn.builder.io/api/v1/image/assets/TEMP/4d434c9fb90a544d07ab0a41e2250a1c5abcbd92?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                      width: 105,
                      height: 105,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Food name',
                            style: TextStyle(
                              fontFamily: 'Fredoka',
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'This is a limited quantity item!',
                            style: TextStyle(
                              fontFamily: 'Fredoka',
                              fontSize: 14,
                              color: Color(0xFF847D79),
                              letterSpacing: 0.14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '\$2.20',
                            style: TextStyle(
                              color: Color(0xFFF17228),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0xFFDEEFD3),
                              ),
                              child: Center(
                                child: Image.network(
                                  'https://cdn.builder.io/api/v1/image/assets/TEMP/2680f8833bc8e040a65353708c2971d719ab5a3c?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 34),
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(120),
          color: const Color(0xFF74CA45),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  '2',
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Container(
                  width: 1,
                  height: 16,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  color: const Color(0xFFE6FBDA),
                ),
                const Text(
                  'View order',
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const Text(
              '\$ 4,00',
              style: TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
