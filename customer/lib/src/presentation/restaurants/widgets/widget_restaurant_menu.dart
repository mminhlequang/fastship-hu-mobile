import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/network_resources.dart';
import 'package:provider/provider.dart';
import 'widget_restaurant_menu2.dart';

// State management class
class RestaurantMenuState extends ChangeNotifier {
  bool _isSearchMode = false;
  String _searchQuery = '';
  int _selectedItems = 0;
  double _totalPrice = 0.0;

  bool get isSearchMode => _isSearchMode;
  String get searchQuery => _searchQuery;
  int get selectedItems => _selectedItems;
  double get totalPrice => _totalPrice;

  void toggleSearchMode() {
    _isSearchMode = !_isSearchMode;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateOrder(int items, double price) {
    _selectedItems = items;
    _totalPrice = price;
    notifyListeners();
  }
}

class RestaurantMenu extends StatelessWidget {
  const RestaurantMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RestaurantMenuState(),
      child: Consumer<RestaurantMenuState>(
        builder: (context, state, child) {
          return Container(
            color: Colors.white,
            constraints: const BoxConstraints(maxWidth: 480),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context, state),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildSearchBar(context, state),
                        _buildMostOrdered(context),
                        _buildBestSeller(context),
                      ],
                    ),
                  ),
                ),
                if (state.selectedItems > 0) _buildOrderSummary(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, RestaurantMenuState state) {
    return Container(
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
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
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
                    _buildInfoChip('Min. order: ' + currencyFormatted(1000)),
                    const SizedBox(width: 4),
                    _buildInfoChip(currencyFormatted(2000), icon: true),
                    const SizedBox(width: 4),
                    _buildInfoChip('More', isLink: true),
                  ],
                ),
                Row(
                  children: [
                    _buildActionButton(
                      'https://cdn.builder.io/api/v1/image/assets/TEMP/ac736bec68a5c7fa808a24ff3a52270532506c44?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                    ),
                    _buildActionButton(
                      'https://cdn.builder.io/api/v1/image/assets/TEMP/46077d169b8fe4f3bcf5223e5ba54a905d425ec9?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                      backgroundColor: const Color(0xFFF4F4F4),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, RestaurantMenuState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
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
                  Expanded(
                    child: TextField(
                      onChanged: (value) => state.setSearchQuery(value),
                      decoration: const InputDecoration(
                        hintText: 'What are you craving?.....',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontFamily: 'Fredoka',
                          fontSize: 16,
                          color: Color(0xFF847D79),
                          letterSpacing: 0.08,
                        ),
                      ),
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
      ),
    );
  }

  Widget _buildMostOrdered(BuildContext context) {
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
                return _buildMenuItem(
                  'https://cdn.builder.io/api/v1/image/assets/TEMP/224c42c723ec093c48f7775799c73488a82b5349?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestSeller(BuildContext context) {
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
              return _buildBestSellerItem();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, RestaurantMenuState state) {
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
                Text(
                  '${state.selectedItems}',
                  style: const TextStyle(
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
            Text(
              currencyFormatted(state.totalPrice),
              style: w500TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, {bool icon = false, bool isLink = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7E7E7)),
        color: Colors.white,
      ),
      child: icon
          ? Row(
              children: [
                Image.network(
                  'https://cdn.builder.io/api/v1/image/assets/TEMP/877e98d6e10d675f20cc13e3f115e5f361c6274a?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 4),
                Text(
                  text,
                  style: const TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 14,
                    color: Color(0xFF3C3836),
                  ),
                ),
              ],
            )
          : Text(
              text,
              style: TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 14,
                color:
                    isLink ? const Color(0xFFF17228) : const Color(0xFF7A838C),
                decoration: isLink ? TextDecoration.underline : null,
              ),
            ),
    );
  }

  Widget _buildActionButton(String iconUrl, {Color? backgroundColor}) {
    return Container(
      width: 38,
      height: 38,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: backgroundColor,
      ),
      child: Image.network(
        iconUrl,
        width: 24,
        height: 24,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildMenuItem(String imageUrl) {
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
            imageUrl,
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
            children: [
              Text(
                currencyFormatted(3300),
                style: w400TextStyle(
                  color: Color(0xFFA6A0A0),
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              SizedBox(width: 4),
              Text(
                currencyFormatted(2200),
                style: w500TextStyle(
                  color: Color(0xFFF17228),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBestSellerItem() {
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
                Text(
                  currencyFormatted(2200),
                  style: w500TextStyle(
                    color: Color(0xFFF17228),
                    fontSize: 16,
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
  }
}
