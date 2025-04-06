import 'package:app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';
import 'package:app/src/constants/constants.dart';
 

class WidgetRatingDriver extends StatefulWidget {
  const WidgetRatingDriver({Key? key}) : super(key: key);

  @override
  _WidgetRatingDriverState createState() => _WidgetRatingDriverState();
}

class _WidgetRatingDriverState extends State<WidgetRatingDriver> {
  int _selectedAmount = 2;
  final TextEditingController _customAmountController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final List<String> _satisfactionTags = [
    'Fast delivery',
    'friendly',
    'Fast delivery',
    'Fast delivery',
    'Fast delivery',
  ];

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) => Icon(
          Icons.star,
          color: appColorPrimaryOrange,
          size: 48,
        ),
      ),
    );
  }

  Widget _buildCustomAmountInput() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appColorBorder),
      ),
      child: TextField(
        controller: _customAmountController,
        decoration: InputDecoration(
          hintText: 'Enter custom amount',
          hintStyle: w400TextStyle(color: appColorText2),
          border: InputBorder.none,
        ),
        style: w400TextStyle(),
      ),
    );
  }

  Widget _buildSatisfactionTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _satisfactionTags
          .map((tag) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: appColorBackground,
                  borderRadius: BorderRadius.circular(120),
                  border: Border.all(color: appColorBorder),
                ),
                child: Text(tag,
                    style: w400TextStyle(
                      color: appColorText2,
                    )),
              ))
          .toList(),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appColorBorder),
      ),
      child: TextField(
        controller: _commentController,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Specific (not required)',
          hintStyle: w400TextStyle(color: appColorText2),
          border: InputBorder.none,
        ),
        style: w400TextStyle(),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        color: appColorBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(120),
                      side: BorderSide(color: appColorBorder),
                    ),
                  ),
                  child: Text('No, thanks',
                      style: w500TextStyle(color: appColorText)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    // Handle tip payment
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: appColorPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(120),
                    ),
                  ),
                  child: Text('Pay Tip',
                      style: w500TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: 140,
            height: 5,
            decoration: BoxDecoration(
              color: appColorText2,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColorBackground,
       
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 112),
              child: Column(
                children: [
                  Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        appHaptic();
                        appContext.pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: WidgetAppSVG('icon40', width: 24, height: 24),
                      ),
                    ),
                    
                  ],
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    appHaptic();
                  },
                  child: Text(
                    'Cancel',
                    style: w400TextStyle(
                      fontSize: 16,
                      color: const Color(0xFFF17228),
                    ),
                  ),
                ),
              ],
            ),
          ), 
                  Text('Perfect', style: w700TextStyle(fontSize: 24)),
                  const SizedBox(height: 16),
                  _buildStarRating(),
                  const SizedBox(height: 16),
                  Text(
                    'Send a tip as a thank you, the driver will receive 100% of this amount',
                    style: w400TextStyle(),
                  ),
                  const SizedBox(height: 16),
                  TipAmountGrid(
                    selectedAmount: _selectedAmount,
                    onAmountSelected: (amount) {
                      setState(() => _selectedAmount = amount);
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildCustomAmountInput(),
                  const SizedBox(height: 16),
                  Divider(color: appColorBorder),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'What makes you most satisfied?',
                      style: w500TextStyle(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSatisfactionTags(),
                  const SizedBox(height: 16),
                  _buildCommentInput(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBar(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _customAmountController.dispose();
    _commentController.dispose();
    super.dispose();
  }
}



// Tip Amount Grid Widget
class TipAmountGrid extends StatelessWidget {
  final int selectedAmount;
  final Function(int) onAmountSelected;

  const TipAmountGrid({
    Key? key,
    required this.selectedAmount,
    required this.onAmountSelected,
  }) : super(key: key);

  Widget _buildTipButton(int amount) {
    final isSelected = amount == selectedAmount;
    return GestureDetector(
      onTap: () => onAmountSelected(amount),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? appColorPrimary : appColorBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? appColorPrimary : appColorBorder,
          ),
        ),
        child: Center(
          child: Text(
            '\$$amount',
            style: w500TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.white : appColorPrimary,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 5,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.2,
          physics: const NeverScrollableScrollPhysics(),
          children:
              [1, 2, 4, 6, 7].map((amount) => _buildTipButton(amount)).toList(),
        ),
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 5,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.2,
          physics: const NeverScrollableScrollPhysics(),
          children: [8, 9, 10, 11, 12]
              .map((amount) => _buildTipButton(amount))
              .toList(),
        ),
      ],
    );
  }
}
