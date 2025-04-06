import 'package:app/src/presentation/widgets/widget_appbar.dart';
import 'package:app/src/presentation/widgets/widget_search_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_core/internal_core.dart';
import 'package:app/src/constants/constants.dart';

// Contact Option Tile Widget
class ContactOptionTile extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;

  const ContactOptionTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: appColorBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset(
                icon,
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: w400TextStyle(
                fontSize: 16,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  bool isFAQ = true;

  int _selectedCategoryIndex = 0;
  int _expandedFaqIndex = 0;

  final List<String> _categories = ['General', 'Account', 'Service', 'Payment'];
  final List<Map<String, String?>> _faqs = [
    {
      'question': 'What is Foodu?',
      'answer':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    },
    {
      'question': 'How I can make a payment?',
      'answer': null,
    },
    {
      'question': 'How do I can cancel orders?',
      'answer': null,
    },
    {
      'question': 'How do I can delete my account?',
      'answer': null,
    },
    {
      'question': 'How do I exit the app?',
      'answer': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColorBackground,
      body: Column(
        children: [
          WidgetAppBar(
            showBackButton: true,
            title: 'Help Center'.tr(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: WidgetInkWellTransparent(
                              onTap: () {
                                appHaptic();
                                setState(() {
                                  isFAQ = true;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.sw),
                                child: Center(
                                  child: Text(
                                    'FAQ'.tr(),
                                    style: w400TextStyle(
                                        fontSize: 18.sw,
                                        color: isFAQ
                                            ? appColorText
                                            : Color(0xFF847D79)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: WidgetInkWellTransparent(
                              onTap: () {
                                appHaptic();
                                setState(() {
                                  isFAQ = false;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.sw),
                                child: Center(
                                  child: Text(
                                    'Contact Us'.tr(),
                                    style: w400TextStyle(
                                        fontSize: 18.sw,
                                        color: !isFAQ
                                            ? appColorText
                                            : Color(0xFF847D79)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 300),
                        left: isFAQ ? 0 : context.width / 2 - 16 + 12,
                        child: Container(
                          width: context.width / 2 - 16 - 12,
                          height: 2,
                          color: appColorText2,
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: isFAQ
                        ? _buildFaqTab()
                        : SingleChildScrollView(
                            child: Column(
                              spacing: 12.sw,
                              children: [
                                SizedBox(height: 12.sw),
                                _buildContactItem(
                                    'icon80', 'Customer Service', ''),
                                _buildContactItem('icon75', 'WhatsApp', ''),
                                _buildContactItem('icon76', 'Website', ''),
                                _buildContactItem('icon77', 'Facebook', ''),
                                _buildContactItem('icon78', 'Twitter', ''),
                                _buildContactItem('icon79', 'Instagram', ''),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(icon, text, link) {
    return Container(
      height: 48.sw,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: hexColor('#F9F8F6'),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          WidgetAppSVG(icon, width: 24, height: 24),
          SizedBox(width: 12),
          Text(
            text,
            style: w400TextStyle(fontSize: 16, height: 1.2),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqTab() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(height: 20),
        WidgetSearchField(),
        const SizedBox(height: 16),
        _buildCategories(),
        const SizedBox(height: 16),
        _buildFaqList(),
      ],
    );
  }

  Widget _buildCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          _categories.length,
          (index) => Padding(
            padding: EdgeInsets.only(
              right: index != _categories.length - 1 ? 12 : 0,
            ),
            child: CategoryChip(
              label: _categories[index],
              isSelected: _selectedCategoryIndex == index,
              onTap: () => setState(() => _selectedCategoryIndex = index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFaqList() {
    return Column(
      children: List.generate(
        _faqs.length,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: index != _faqs.length - 1 ? 12 : 0),
          child: FaqItem(
            question: _faqs[index]['question']!,
            answer: _faqs[index]['answer'],
            isExpanded: _expandedFaqIndex == index,
            onTap: () => setState(() => _expandedFaqIndex = index),
          ),
        ),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? appColorPrimary : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: !isSelected ? Border.all(color: appColorBorder) : null,
        ),
        child: Text(
          label,
          style: w500TextStyle(
            fontSize: 14,
            height: 1,
            color: isSelected ? Colors.white : appColorText2,
          ),
        ),
      ),
    );
  }
}

// FAQ Item Widget
class FaqItem extends StatelessWidget {
  final String question;
  final String? answer;
  final bool isExpanded;
  final VoidCallback onTap;

  const FaqItem({
    Key? key,
    required this.question,
    this.answer,
    required this.isExpanded,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isExpanded ? Colors.white : appColorBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isExpanded
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: w500TextStyle(fontSize: 16),
                  ),
                ),
                Transform.rotate(
                  angle: isExpanded ? 3.14159 : 0,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: appColorText,
                  ),
                ),
              ],
            ),
          ),
          if (isExpanded && answer != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Divider(
                height: 1,
                color: appColorBorder,
              ),
            ),
            Text(
              answer!,
              style: w300TextStyle(fontSize: 14, height: 1.4),
            ),
          ],
        ],
      ),
    );
  }
}
