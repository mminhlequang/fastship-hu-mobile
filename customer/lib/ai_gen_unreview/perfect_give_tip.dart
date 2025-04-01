import 'package:flutter/material.dart';

// Theme Constants
class AppColors {
  static const Color primary = Color(0xFF538D33);
  static const Color secondary = Color(0xFFF17228);
  static const Color success = Color(0xFF74CA45);
  static const Color background = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF120F0F);
  static const Color textSecondary = Color(0xFF3C3836);
  static const Color border = Color(0xFFF1EFE9);
  static const Color placeholder = Color(0xFFCEC6C5);
  static const Color divider = Color(0xFFF3F3F3);
}

class AppTextStyles {
  static const String fontFamily = 'Fredoka';

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    height: 1.2,
    color: AppColors.text,
  );

  static const TextStyle header = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 1.2,
    letterSpacing: 0.32,
    color: AppColors.secondary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 1.4,
    letterSpacing: 0.16,
    color: AppColors.text,
  );

  static const TextStyle tipAmount = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    height: 1.2,
    color: AppColors.primary,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    height: 1.2,
    color: AppColors.background,
  );

  static const TextStyle buttonOutlined = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    height: 1.2,
    color: AppColors.textSecondary,
  );

  static const TextStyle input = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 1.5,
    letterSpacing: 0.16,
    color: AppColors.placeholder,
  );
}

// Custom App Bar Widget
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(90);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        children: [
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '9:41',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                // Status bar icons would go here
              ],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const Text('Support', style: AppTextStyles.header),
                const SizedBox(width: 40), // For balance
              ],
            ),
          ),
        ],
      ),
    );
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
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Center(
          child: Text(
            '\$$amount',
            style: AppTextStyles.tipAmount.copyWith(
              color: isSelected ? AppColors.background : AppColors.primary,
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

// Main Screen
class TipScreen extends StatefulWidget {
  const TipScreen({Key? key}) : super(key: key);

  @override
  _TipScreenState createState() => _TipScreenState();
}

class _TipScreenState extends State<TipScreen> {
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
          color: AppColors.secondary,
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
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: _customAmountController,
        decoration: const InputDecoration(
          hintText: 'Enter custom amount',
          hintStyle: AppTextStyles.input,
          border: InputBorder.none,
        ),
        style: AppTextStyles.body,
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
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(120),
                  border: Border.all(color: AppColors.placeholder),
                ),
                child: Text(tag,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
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
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: _commentController,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: 'Specific (not required)',
          hintStyle: AppTextStyles.input,
          border: InputBorder.none,
        ),
        style: AppTextStyles.body,
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        color: AppColors.background,
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
                      side: const BorderSide(color: AppColors.placeholder),
                    ),
                  ),
                  child: const Text('No, thanks',
                      style: AppTextStyles.buttonOutlined),
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
                    backgroundColor: AppColors.success,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(120),
                    ),
                  ),
                  child: const Text('Pay Tip', style: AppTextStyles.button),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: 140,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.textSecondary,
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
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 112),
              child: Column(
                children: [
                  const Text('Perfect', style: AppTextStyles.title),
                  const SizedBox(height: 16),
                  _buildStarRating(),
                  const SizedBox(height: 16),
                  const Text(
                    'Send a tip as a thank you, the driver will receive 100% of this amount',
                    style: AppTextStyles.body,
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
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'What makes you most satisfied?',
                      style: AppTextStyles.body,
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
