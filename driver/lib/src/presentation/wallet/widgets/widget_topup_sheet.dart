import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widget_bottom_sheet_base.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/utils.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';
import 'package:intl/intl.dart';

class WidgetTopUpSheet extends StatefulWidget {
  const WidgetTopUpSheet({super.key});

  @override
  State<WidgetTopUpSheet> createState() => _WidgetTopUpSheetState();
}

class _WidgetTopUpSheetState extends State<WidgetTopUpSheet> {
  final controller = TextEditingController();

  bool get isValidAmount {
    final cleanedText = controller.text.replaceAll(RegExp(r'[^\d.]'), '');
    if (cleanedText.isNotEmpty) {
      final amount = double.parse(cleanedText);
      return amount > 0;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WidgetAppBaseSheet(
      title: 'Top Up'.tr(),
      padding: EdgeInsets.fromLTRB(
          20.sw, 32.sw, 20.sw, 12 + context.mediaQueryPadding.bottom),
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: w600TextStyle(fontSize: 32.sw, color: appColorText),
            textAlign: TextAlign.center,
            onChanged: (value) {
              setState(() {});
            },
            inputFormatters: [
              CurrencyTextInputFormatter.currency(
                locale: 'en_EU',
                symbol: '',
                enableNegative: false,
                decimalDigits: 2,
              ),
            ],
            decoration: InputDecoration(
              prefixText: '${AppPrefs.instance.currencySymbol} ',
              hintText: '0.00',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
          Gap(32.sw),
          WidgetAppButtonOK(
              label: "Confirm".tr(),
              enable: isValidAmount,
              onTap: () {
                appHaptic();
                final cleanedText =
                    controller.text.replaceAll(RegExp(r'[^\d.]'), '');
                if (cleanedText.isNotEmpty) {
                  final amount = double.parse(cleanedText);
                  context.pop(amount);
                }
              }),
        ],
      ),
    );
  }
}



class WidgetWithDrawSheet extends StatefulWidget {
  const WidgetWithDrawSheet({super.key});

  @override
  State<WidgetWithDrawSheet> createState() => _WidgetWithDrawSheetState();
}

class _WidgetWithDrawSheetState extends State<WidgetWithDrawSheet> {
  final controller = TextEditingController();

  bool get isValidAmount {
    final cleanedText = controller.text.replaceAll(RegExp(r'[^\d.]'), '');
    if (cleanedText.isNotEmpty) {
      final amount = double.parse(cleanedText);
      return amount > 0;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WidgetAppBaseSheet(
      title: 'Withdraw'.tr(),
      padding: EdgeInsets.fromLTRB(
          20.sw, 32.sw, 20.sw, 12 + context.mediaQueryPadding.bottom),
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: w600TextStyle(fontSize: 32.sw, color: appColorText),
            textAlign: TextAlign.center,
            onChanged: (value) {
              setState(() {});
            },
            inputFormatters: [
              CurrencyTextInputFormatter.currency(
                locale: 'en_EU',
                symbol: '',
                enableNegative: false,
                decimalDigits: 2,
              ),
            ],
            decoration: InputDecoration(
              prefixText: '${AppPrefs.instance.currencySymbol} ',
              hintText: '0.00',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
          Gap(32.sw),
          WidgetAppButtonOK(
              label: "Confirm".tr(),
              enable: isValidAmount,
              onTap: () {
                appHaptic();
                final cleanedText =
                    controller.text.replaceAll(RegExp(r'[^\d.]'), '');
                if (cleanedText.isNotEmpty) {
                  final amount = double.parse(cleanedText);
                  context.pop(amount);
                }
              }),
        ],
      ),
    );
  }
}
