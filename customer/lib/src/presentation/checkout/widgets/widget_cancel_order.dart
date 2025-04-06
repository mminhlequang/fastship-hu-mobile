import 'package:app/src/presentation/widgets/widget_appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';
import 'package:app/src/constants/constants.dart';

class CancelOrderScreen extends StatefulWidget {
  const CancelOrderScreen({Key? key}) : super(key: key);

  @override
  State<CancelOrderScreen> createState() => _CancelOrderScreenState();
}

class _CancelOrderScreenState extends State<CancelOrderScreen> {
  int? selectedReason;
  final TextEditingController _noteController = TextEditingController();

  final List<String> cancelReasons = [
    'Waiting for long time',
    'Unable to contact driver',
    'Driver denied to go to destination',
    'Driver denied to come to pickup',
    'Wrong address shown',
    'The price is not reasonable',
    'I want to order another restaurant',
    'I just want to cancel',
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Widget _buildReasonItem(int index, String reason) {
    final bool isSelected = selectedReason == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedReason = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                reason,
                style: w400TextStyle(
                  fontSize: 16,
                  color: appColorText,
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? appColorPrimary : const Color(0xFFBDBDBD),
                  width: 1,
                ),
                color: isSelected ? appColorPrimary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            WidgetAppBar(
              title: 'Cancel Order'.tr(),
              showBackButton: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: appColorBorder,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        'Please select the reason for cancellation:'.tr(),
                        style: w500TextStyle(
                          fontSize: 18,
                          color: appColorText,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...List.generate(
                      cancelReasons.length,
                      (index) => _buildReasonItem(index, cancelReasons[index]),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Others',
                      style: w500TextStyle(
                        fontSize: 16,
                        color: appColorText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F8F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _noteController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write a note for the restaurant',
                          hintStyle: w400TextStyle(
                            fontSize: 14,
                            color: appColorText2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        decoration: BoxDecoration(
          color: Colors.white,
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
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(120),
                        side: BorderSide(color: appColorBorder),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: w400TextStyle(
                        fontSize: 18,
                        color: appColorText,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      // Handle submit action
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: appColorPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(120),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: w400TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: 140,
              height: 5.5,
              decoration: BoxDecoration(
                color: const Color(0xFF3C3836),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
