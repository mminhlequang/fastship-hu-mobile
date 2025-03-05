import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widget_bottom_sheet_base.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';
import 'package:intl/intl.dart';

class WidgetTopUpSheet extends StatefulWidget {
  const WidgetTopUpSheet({super.key});

  @override
  State<WidgetTopUpSheet> createState() => _WidgetTopUpSheetState();
}

class _WidgetTopUpSheetState extends State<WidgetTopUpSheet> {
  @override
  Widget build(BuildContext context) {
    return WidgetAppBaseSheet(
      title: 'Top Up'.tr(),
      padding: EdgeInsets.fromLTRB(
          20.sw, 32.sw, 20.sw, 12 + context.mediaQueryPadding.bottom),
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.number,
            style: w600TextStyle(fontSize: 32.sw, color: appColorText),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              prefixText: '€ ',
              hintText: '0.00',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                // Xử lý và format số tiền khi người dùng nhập
                final numericValue =
                    double.tryParse(value.replaceAll(',', '')) ?? 0.0;
                final formattedValue = NumberFormat.currency(
                  locale: 'en_EU',
                  symbol: '',
                  decimalDigits: 2,
                ).format(numericValue);

                // Cập nhật giá trị đã được format
                if (value != formattedValue) {
                  // Đặt con trỏ về vị trí cuối
                  final controller = TextEditingController(
                    text: formattedValue,
                  );
                  // Cập nhật controller
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        // Cập nhật state nếu cần
                      });
                    }
                  });
                }
              }
            },
          ),
          Gap(32.sw),
          WidgetAppButtonOK(label: "Confirm".tr(), onTap: () {}),
        ],
      ),
    );
  }
}
