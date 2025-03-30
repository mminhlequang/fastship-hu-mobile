import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';

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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.sw),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
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
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Filter',
          style: w500TextStyle(fontSize: 20.sw),
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
          WidgetAppSVG(
            'icon29',
            width: 24.sw,
            height: 24.sw,
          ),
          const SizedBox(width: 8),
          Expanded(
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
        Text(
          'Sort by',
          style: w500TextStyle(fontSize: 18.sw),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10.sw,
          runSpacing: 10.sw,
          children:
              sortOptions.map((option) => _buildSortOption(option)).toList(),
        ),
      ],
    );
  }

  Widget _buildSortOption(String option) {
    return SizedBox(
      width: context.width * 0.4,
      child: Padding(
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
      ),
    );
  }

  Widget _buildTypeFoodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type food',
          style: w500TextStyle(fontSize: 18.sw),
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
            Text(
              'Price',
              style: w500TextStyle(fontSize: 18.sw),
            ),
            Text(
              '\$${priceRange.start.toStringAsFixed(2)} - \$${priceRange.end.toStringAsFixed(2)}',
              style: w400TextStyle(
                fontSize: 16.sw,
                color: Color(0xFF453D3D),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              '\$1.00',
              style: w400TextStyle(
                color: Color(0xFF847D79),
                fontSize: 14.sw,
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
            Text(
              '\$100.0',
              style: w400TextStyle(
                color: Color(0xFF847D79),
                fontSize: 14.sw,
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
      child: DottedLine(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        lineLength: double.infinity,
        lineThickness: 1.0,
        dashLength: 4.0,
        dashColor: hexColor('#D1D1D1'),
        dashRadius: 0.0,
        dashGapLength: 4.0,
        dashGapColor: Colors.transparent,
        dashGapRadius: 0.0,
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.sw),
          bottomRight: Radius.circular(24.sw),
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
          WidgetButtonCancel(
            text: 'Cancel',
            onPressed: () {
              context.pop();
            },
            width: 120.sw,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: WidgetButtonConfirm(
              text: 'Apply ( 10 results found )',
              onPressed: () {
                context.pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
