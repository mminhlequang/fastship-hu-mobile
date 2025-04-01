import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widget_appbar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';

// Promotion Card Widget
class PromotionCard extends StatelessWidget {
  final String imageUrl;
  final bool isActive;
  final VoidCallback onTap;

  const PromotionCard({
    Key? key,
    required this.imageUrl,
    this.isActive = true,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 70.sw,
          height: 70.sw,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hexColor('#F8F1F0'),
              width: 1,
            ),
          ),
          child: WidgetAppImage(imageUrl: imageUrl),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: w500TextStyle(
                    fontSize: 20.sw,
                    color: isActive ? hexColor('#091230') : hexColor('#847D79'),
                  ),
                  children: [
                    TextSpan(text: 'Free shipping '),
                    TextSpan(
                      text: '\$1 off',
                      style: w400TextStyle(
                        color: isActive ? appColorPrimary : hexColor('#847D79'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$1 off, when you order \$3 more to enjoy this offer',
                style: w400TextStyle(
                  fontSize: 14.sw,
                  color: hexColor('#847D79'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isActive ? hexColor('#F8F1F0') : hexColor('#F8F1F0'),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add,
              color: isActive ? hexColor('#F8F1F0') : hexColor('#F8F1F0'),
            ),
          ),
        ),
      ],
    );
  }
}

class WidgetSheetVouchers extends StatefulWidget {
  const WidgetSheetVouchers({Key? key}) : super(key: key);

  @override
  State<WidgetSheetVouchers> createState() => _WidgetSheetVouchersState();
}

class _WidgetSheetVouchersState extends State<WidgetSheetVouchers> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          WidgetAppBar(
            title: "Discount or promotion".tr(),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: hexColor('#F9F8F6'),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _promoController,
                              style: w400TextStyle(
                                fontSize: 16.sw,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter promo code'.tr(),
                                hintStyle: w400TextStyle(
                                  fontSize: 16.sw,
                                  color: hexColor('#847D79'),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14.sw,
                                  vertical: 12.sw,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hexColor('#F17228'),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Apply',
                            style: w500TextStyle(
                              fontSize: 16.sw,
                              height: 1,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(12),
                      padding: const EdgeInsets.all(16),
                      strokeWidth: 1,
                      dashPattern: const [8, 4],
                      color: const Color(0xFFCEC6C5),
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        separatorBuilder: (context, index) => Container(
                          height: 1,
                          margin: EdgeInsets.symmetric(vertical: 16.sw),
                          width: context.width,
                          color: hexColor('#F1EFE9'),
                        ),
                        shrinkWrap: true,
                        itemCount: 4,
                        itemBuilder: (context, index) => PromotionCard(
                          imageUrl:
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/b18f737bfbabf9979cf7109b1aaa1ada2b8a0361',
                          isActive: index % 2 == 0,
                          onTap: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
