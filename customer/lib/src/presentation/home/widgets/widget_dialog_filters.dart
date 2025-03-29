import 'package:flutter/material.dart';

class WidgetDialogFilters extends StatefulWidget {
  const WidgetDialogFilters({Key? key}) : super(key: key);

  @override
  State<WidgetDialogFilters> createState() => _WidgetDialogFiltersState();
}

class _WidgetDialogFiltersState extends State<WidgetDialogFilters> {
  String selectedSort = 'Recommended';
  RangeValues priceRange = const RangeValues(5.0, 100.0);
  final List<String> sortOptions = [
    'Recommended',
    'Delivery price',
    'Rating',
    'Distance',
    'Delivery time',
    'Distance',
  ];

  final List<String> foodTypes = [
    'American',
    'Asian',
    'Chinese',
    'Indian',
    'French',
    'Italian',
    'Japanese',
    'Korean',
    'Mexican',
    'Nepalese',
    'Vietnamese',
    'Bakery',
    'BBQ',
    'Bagel',
    'Bento',
    'Bowl',
    'Breakfast',
    'Burger',
    'Cafe',
    'Chicken',
    'Crepe',
    'Curry',
    'Dessert',
    'Fish',
    'Healthy',
    'Ice cream',
    'Pasta',
    'Noodles',
    'Pizza',
    'Ramen',
    'Salad',
    'Sandwich',
    'Smoothie',
    'Soup',
    'Steak',
    'Street Food',
    'Sushi',
    'Takoyaki',
    'Thai',
    'Tsukemen',
    'Udon',
    'Waffles',
    'Western',
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: MediaQuery.of(context)
            .padding
            .add(const EdgeInsets.symmetric(horizontal: 16)),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 24, 12, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildSearchBar(),
                const SizedBox(height: 12),
                _buildSortBySection(),
                _buildDivider(),
                _buildTypeFoodSection(),
                _buildSeeAllFilter(),
                _buildDivider(),
                _buildPriceRangeSection(),
                _buildDivider(),
                _buildBottomButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Filter',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Fredoka',
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF363853)),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFF8F1F0)),
        borderRadius: BorderRadius.circular(56),
        color: Colors.white,
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Color(0xFF636F7E), size: 24),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Search food, restaurant ...',
              style: TextStyle(
                color: Color(0xFFAFAFAF),
                fontFamily: 'Fredoka',
                fontSize: 16,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF74CA45),
              borderRadius: BorderRadius.circular(56),
            ),
            child: const Text(
              'Search',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Fredoka',
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortBySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sort by',
          style: TextStyle(
            color: Color(0xFF120F0F),
            fontFamily: 'Fredoka',
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children:
              sortOptions.map((option) => _buildSortOption(option)).toList(),
        ),
      ],
    );
  }

  Widget _buildSortOption(String option) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selectedSort == option
                    ? const Color(0xFF74CA45)
                    : const Color(0xFFBDBDBD),
                width: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            option,
            style: const TextStyle(
              color: Color(0xFF120F0F),
              fontFamily: 'Fredoka',
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeFoodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Type food',
          style: TextStyle(
            color: Color(0xFF120F0F),
            fontFamily: 'Fredoka',
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: foodTypes.map((type) => _buildFoodTypeChip(type)).toList(),
        ),
      ],
    );
  }

  Widget _buildFoodTypeChip(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE7E7E7)),
        borderRadius: BorderRadius.circular(46),
        color: Colors.white,
      ),
      child: Text(
        type,
        style: const TextStyle(
          color: Color(0xFF120F0F),
          fontFamily: 'Fredoka',
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildSeeAllFilter() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(Icons.add, color: const Color(0xFFF17228)),
          const SizedBox(width: 6),
          Text(
            'See all filter',
            style: TextStyle(
              color: const Color(0xFFF17228),
              fontFamily: 'Fredoka',
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRangeSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Price',
              style: TextStyle(
                color: Color(0xFF120F0F),
                fontFamily: 'Fredoka',
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '\$${priceRange.start.toStringAsFixed(2)} - \$${priceRange.end.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Color(0xFF453D3D),
                fontFamily: 'Fredoka',
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text(
              '\$1.00',
              style: TextStyle(
                color: Color(0xFF847D79),
                fontFamily: 'Fredoka',
                fontSize: 14,
              ),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  rangeThumbShape: RoundRangeSliderThumbShape(
                    enabledThumbRadius: 8,
                  ),
                  activeTrackColor: const Color(0xFFF17228),
                  inactiveTrackColor: const Color(0xFFD6D8E7),
                  thumbColor: Colors.white,
                  overlayColor: const Color(0xFFF17228).withOpacity(0.2),
                ),
                child: RangeSlider(
                  values: priceRange,
                  min: 1.0,
                  max: 100.0,
                  onChanged: (RangeValues values) {
                    setState(() {
                      priceRange = values;
                    });
                  },
                ),
              ),
            ),
            const Text(
              '\$100.0',
              style: TextStyle(
                color: Color(0xFF847D79),
                fontFamily: 'Fredoka',
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        height: 1,
        color: const Color(0xFFD1D1D1),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x26000000),
            offset: Offset(17, 10),
            blurRadius: 30,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFCEC6C5)),
                borderRadius: BorderRadius.circular(120),
              ),
              child: const Center(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color(0xFF120F0F),
                    fontFamily: 'Fredoka',
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF74CA45),
              borderRadius: BorderRadius.circular(120),
            ),
            child: const Text(
              'Apply ( 10 results found )',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Fredoka',
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
