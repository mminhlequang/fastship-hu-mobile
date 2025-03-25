import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widget_app_divider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/setup/app_textstyles.dart';
import 'package:internal_core/widgets/widgets.dart';

class OrderSettingsScreen extends StatefulWidget {
  const OrderSettingsScreen({super.key});

  @override
  State<OrderSettingsScreen> createState() => _OrderSettingsScreenState();
}

class _OrderSettingsScreenState extends State<OrderSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order settings'.tr())),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            WidgetRippleButton(
              onTap: () {
                // Todo
              },
              radius: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Preparing time'.tr(),
                      style: w400TextStyle(fontSize: 16.sw),
                    ),
                    const WidgetAppSVG('chevron-right'),
                  ],
                ),
              ),
            ),
            AppDivider(
              color: grey8,
              padding: EdgeInsets.symmetric(horizontal: 16.sw),
            ),
            WidgetRippleButton(
              onTap: () {
                // Todo:
              },
              radius: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order confirmation'.tr(),
                      style: w400TextStyle(fontSize: 16.sw),
                    ),
                    const WidgetAppSVG('chevron-right'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
