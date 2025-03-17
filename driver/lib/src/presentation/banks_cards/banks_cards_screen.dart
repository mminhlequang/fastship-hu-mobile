import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';

import '../widgets/widgets.dart';

class BanksCardsScreen extends StatefulWidget {
  const BanksCardsScreen({super.key});

  @override
  State<BanksCardsScreen> createState() => _BanksCardsScreenState();
}

class _BanksCardsScreenState extends State<BanksCardsScreen> {
  int cardIndex = 0;
  bool withPaypal = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bank Accounts/Cards'.tr()),
        actions: [
          TextButton(
            onPressed: () {
              appHaptic();
              // Todo:
            },
            child: Text(
              'Save'.tr(),
              style: w400TextStyle(color: Colors.white),
            ),
          ),
          Gap(4.sw),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(16.sw),
                Text(
                  'CREDIT/DEBIT CARD'.tr(),
                  style: w400TextStyle(color: grey1),
                ),
                Gap(6.sw),
                ...List.generate(
                  2,
                  (index) {
                    bool isSelected = index == cardIndex;
                    return WidgetInkWellTransparent(
                      onTap: () {
                        setState(() {
                          cardIndex = index;
                        });
                      },
                      radius: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.sw),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WidgetAppSVG(
                                isSelected ? 'radio-check' : 'radio-uncheck'),
                            Gap(8.sw),
                            Text(
                              'Techcombank',
                              style: w400TextStyle(),
                            ),
                            const Spacer(),
                            Text(
                              '*3241',
                              style: w400TextStyle(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Gap(6.sw),
                const AppDivider(),
                WidgetInkWellTransparent(
                  onTap: () {
                    appContext.push('/my-wallet/banks-cards/add-card');
                  },
                  radius: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.sw),
                    child: Row(
                      children: [
                        WidgetAppSVG('ic_add', width: 24.sw, color: darkGreen),
                        Gap(8.sw),
                        Text(
                          'Add new card'.tr(),
                          style: w400TextStyle(),
                        ),
                        const Spacer(),
                        WidgetAppSVG('ic_visa'),
                        Gap(4.sw),
                        WidgetAppSVG('ic_mastercard'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gap(8.sw),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(16.sw),
                Text(
                  'BANK ACCOUNT'.tr(),
                  style: w400TextStyle(color: grey1),
                ),
                WidgetInkWellTransparent(
                  onTap: () {
                    // Todo:
                  },
                  radius: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.sw),
                    child: Row(
                      children: [
                        WidgetAppSVG('ic_add', width: 24.sw, color: darkGreen),
                        Gap(8.sw),
                        Text(
                          'Add bank account'.tr(),
                          style: w400TextStyle(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gap(8.sw),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(16.sw),
                Text(
                  'PAYPAL'.tr(),
                  style: w400TextStyle(color: grey1),
                ),
                WidgetInkWellTransparent(
                  onTap: () {
                    setState(() {
                      withPaypal = !withPaypal;
                    });
                  },
                  radius: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.sw),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            WidgetAppSVG(
                              withPaypal ? 'radio-check' : 'radio-uncheck',
                              width: 24.sw,
                            ),
                            Gap(8.sw),
                            Text(
                              'With Paypal'.tr(),
                              style: w400TextStyle(),
                            ),
                            const Spacer(),
                            WidgetAppSVG('ic_paypal'),
                          ],
                        ),
                        if (withPaypal)
                          Padding(
                            padding: EdgeInsets.only(
                                left: 32.sw, top: 4.sw, bottom: 4.sw),
                            child: Text(
                              'After clicking “Confirm” a pop-up will appear asking you to log in to your Paypal account.'
                                  .tr(),
                              style:
                                  w400TextStyle(fontSize: 12.sw, color: grey1),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
