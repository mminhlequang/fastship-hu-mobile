import 'package:app/src/presentation/widgets/widget_appbar.dart';
import 'package:app/src/presentation/widgets/widget_search_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';
import 'package:app/src/constants/constants.dart';
import 'package:network_resources/network_resources.dart';
import 'package:url_launcher/url_launcher.dart';

class FaqItem {
  String category;
  List<Map<String, String>> items;

  FaqItem({required this.category, required this.items});
}

List<FaqItem> _faqs = [
  FaqItem(category: 'General', items: [
    {
      'question': 'What is FastShip?',
      'answer':
          'FastShip is a delivery service platform that connects customers with reliable delivery partners to transport goods quickly and efficiently.'
    },
    {
      'question': 'How do I track my delivery?',
      'answer':
          'You can track your delivery by going to the "My Orders" section and selecting the specific order. The real-time tracking information will be displayed there.'
    },
    {
      'question': 'What are your delivery hours?',
      'answer':
          'Our delivery service operates 24/7. However, delivery times may vary depending on the location and type of service selected.'
    },
    {
      'question': 'How do I contact customer support?',
      'answer':
          'You can contact our customer support through the app by going to the Help Center and selecting "Contact Us". We are available 24/7 to assist you.'
    }
  ]),
  FaqItem(category: 'Account', items: [
    {
      'question': 'How do I create an account?',
      'answer':
          'To create an account, click on the "Sign Up" button and follow the registration process. You will need to provide your email address and create a password.'
    },
    {
      'question': 'How do I reset my password?',
      'answer':
          'Click on "Forgot Password" on the login screen. You will receive an email with instructions to reset your password.'
    },
    {
      'question': 'How do I update my profile information?',
      'answer':
          'Go to "My Profile" in the app menu, then click on "Edit Profile" to update your personal information.'
    },
    {
      'question': 'How do I delete my account?',
      'answer':
          'To delete your account, go to "Account Settings" and select "Delete Account". Please note that this action cannot be undone.'
    }
  ]),
  FaqItem(category: 'Service', items: [
    {
      'question': 'What types of items can I send?',
      'answer':
          'We accept most common items for delivery. However, there are restrictions on hazardous materials, illegal items, and certain fragile items. Please check our terms of service for details.'
    },
    {
      'question': 'How do I schedule a delivery?',
      'answer':
          'Open the app, click on "New Delivery", fill in the pickup and delivery details, select your preferred delivery option, and confirm the booking.'
    },
    {
      'question': 'Can I cancel a delivery?',
      'answer':
          'Yes, you can cancel a delivery before it is picked up. Go to "My Orders", select the order, and click "Cancel Delivery". Note that cancellation fees may apply.'
    },
    {
      'question': 'What happens if my delivery is delayed?',
      'answer':
          'If your delivery is delayed, you will be notified through the app. You can track the status in real-time and contact customer support for assistance.'
    }
  ]),
  FaqItem(category: 'Payment', items: [
    {
      'question': 'What payment methods are accepted?',
      'answer':
          'We accept credit/debit cards, digital wallets, and bank transfers. You can add and manage your payment methods in the "Payment" section.'
    },
    {
      'question': 'How do I get a receipt?',
      'answer':
          'After completing a delivery, you will receive an electronic receipt in the app. You can also request a copy by email through the "Order History" section.'
    },
    {
      'question': 'Can I get a refund?',
      'answer':
          'Refunds are processed according to our refund policy. If you believe you are eligible for a refund, please contact customer support with your order details.'
    },
    {
      'question': 'How do I add a new payment method?',
      'answer':
          'Go to "Payment Methods" in the app menu, click "Add New Payment Method", and follow the instructions to add your preferred payment option.'
    }
  ]),
];

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  bool isFAQ = true;
  int _selectedCategoryIndex = 0;
  int _expandedFaqIndex = 0;

  // Get categories from _faqs list
  List<String> get _categories => _faqs.map((e) => e.category).toList();

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
                                _buildContactItem('icon80', 'Customer Service',
                                    'tel: ${supportPhoneNumberRaw}'),
                                _buildContactItem('icon75', 'WhatsApp',
                                    'https://wa.me/${supportPhoneNumberRaw}'),
                                _buildContactItem('icon76', 'Website',
                                    'https://fastshiphu.com/'),
                                _buildContactItem('icon77', 'Facebook',
                                    'https://www.facebook.com/fastshiphu'),
                                _buildContactItem('icon78', 'Twitter',
                                    'https://www.twitter.com/fastshiphu'),
                                _buildContactItem('icon79', 'Instagram',
                                    'https://www.instagram.com/fastshiphu'),
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
    return GestureDetector(
      onTap: () {
        appHaptic();
        if (link.isNotEmpty) {
          launchUrl(Uri.parse(link));
        }
      },
      child: Container(
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
      ),
    );
  }

  Widget _buildFaqTab() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(height: 20),
        WidgetSearchField(),
        16.h,
        _buildCategories(),
        16.h,
        _buildFaqList(),
      ],
    );
  }

  Widget _buildCategories() {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
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
    // Get current category
    final currentCategory = _categories[_selectedCategoryIndex];
    // Get FAQs for current category
    final categoryFaqs =
        _faqs.firstWhere((e) => e.category == currentCategory).items;

    return Column(
      children: List.generate(
        categoryFaqs.length,
        (index) => Padding(
          padding: EdgeInsets.only(
              bottom: index != categoryFaqs.length - 1 ? 12 : 0),
          child: FaqItemWidget(
            question: categoryFaqs[index]['question']!,
            answer: categoryFaqs[index]['answer'],
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

// Rename FaqItem widget to avoid naming conflict
class FaqItemWidget extends StatelessWidget {
  final String question;
  final String? answer;
  final bool isExpanded;
  final VoidCallback onTap;

  const FaqItemWidget({
    super.key,
    required this.question,
    this.answer,
    required this.isExpanded,
    required this.onTap,
  });

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
                    color: appColorText2,
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
              style: w300TextStyle(
                  fontSize: 14, height: 1.4, color: appColorText2),
            ),
          ],
        ],
      ),
    );
  }
}
