import 'package:app/src/base/auth/auth_cubit.dart';
import 'package:app/src/constants/constants.dart';
import 'package:network_resources/transaction/models/models.dart';
import 'package:app/src/presentation/wallet_banks_cards/banks_cards_screen.dart';
import 'package:app/src/presentation/widgets/widget_bottom_sheet_base.dart';
import 'package:app/src/utils/utils.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';

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
    return BlocBuilder<AuthCubit, AuthState>(
        bloc: authCubit,
        builder: (context, state) {
          return WidgetAppBaseSheet(
            color: Colors.white,
            title: 'Top Up'.tr().toUpperCase(),
            padding: EdgeInsets.fromLTRB(
                16.sw, 56.sw, 16.sw, 16.sw + context.mediaQueryPadding.bottom),
            child: Column(
              children: [
                TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: w600TextStyle(fontSize: 32.sw, height: 24 / 32),
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    setState(() {});
                  },
                  inputFormatters: [
                    CurrencyTextInputFormatter.currency(
                      locale: 'en_EU',
                      symbol: AppPrefs.instance.currencySymbol,
                      enableNegative: false,
                      decimalDigits: 2,
                    ),
                  ],
                  decoration: InputDecoration(
                    hintText: '${AppPrefs.instance.currencySymbol}0.00',
                    hintStyle: w600TextStyle(
                      fontSize: 32.sw,
                      height: 24 / 32,
                      color: grey1,
                    ),
                    border: InputBorder.none,
                  ),
                ),
                Text(
                  '${'Balance available'.tr()}: ${NumberFormat.currency(
                    symbol: AppPrefs.instance.currencySymbol,
                    decimalDigits: 2,
                  ).format(state.wallet?.availableBalance ?? 0)}',
                  style: w400TextStyle(color: grey1),
                ),
                Gap(40.sw),
                WidgetRippleButton(
                  onTap: () {
                    appHaptic();
                    final cleanedText =
                        controller.text.replaceAll(RegExp(r'[^\d.]'), '');
                    if (cleanedText.isNotEmpty) {
                      final amount = double.parse(cleanedText);
                      context.pop(amount);
                    }
                  },
                  radius: 99,
                  enable: isValidAmount,
                  color: isValidAmount ? appColorPrimary : grey9,
                  child: SizedBox(
                    height: 48.sw,
                    child: Center(
                      child: Text(
                        'Confirm'.tr(),
                        style: w500TextStyle(
                          fontSize: 16.sw,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class WidgetWithdrawSheet extends StatefulWidget {
  final PaymentAccount account;
  const WidgetWithdrawSheet({super.key, required this.account});

  @override
  State<WidgetWithdrawSheet> createState() => _WidgetWithdrawSheetState();
}

class _WidgetWithdrawSheetState extends State<WidgetWithdrawSheet> {
  late PaymentAccount selectedAccount = widget.account;
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
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: authCubit,
      builder: (context, state) {
        return WidgetAppBaseSheet(
          color: Colors.white,
          title: 'Withdraw'.tr().toUpperCase(),
          padding: EdgeInsets.fromLTRB(
              16.sw, 56.sw, 16.sw, 16.sw + context.mediaQueryPadding.bottom),
          child: Column(
            children: [
              TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                style: w600TextStyle(fontSize: 32.sw, height: 24 / 32),
                textAlign: TextAlign.center,
                onChanged: (value) {
                  setState(() {});
                },
                inputFormatters: [
                  CurrencyTextInputFormatter.currency(
                    locale: 'en_EU',
                    symbol: AppPrefs.instance.currencySymbol,
                    enableNegative: false,
                    decimalDigits: 2,
                  ),
                ],
                decoration: InputDecoration(
                  hintText: '${AppPrefs.instance.currencySymbol}0.00',
                  hintStyle: w600TextStyle(
                    fontSize: 32.sw,
                    height: 24 / 32,
                    color: grey1,
                  ),
                  border: InputBorder.none,
                ),
              ),
              Text(
                '${'Balance available'.tr()}: ${NumberFormat.currency(
                  symbol: AppPrefs.instance.currencySymbol,
                  decimalDigits: 2,
                ).format(state.wallet?.availableBalance ?? 0)}',
                style: w400TextStyle(color: grey1),
              ),
              Gap(40.sw),
              WidgetRippleButton(
                onTap: () {
                  appOpenBottomSheet(
                    BanksCardsScreen(isSelector: true),
                  ).then((value) {
                    if (value is PaymentAccount && mounted) {
                      setState(() {
                        selectedAccount = value;
                      });
                    }
                  });
                },
                radius: 8.sw,
                color: hexColor('#F4F4F6'),
                child: Padding(
                  padding: EdgeInsets.all(8.sw),
                  child: Row(
                    children: [
                      if (selectedAccount.accountType == 'bank')
                        Image.asset(
                          assetpng('card'),
                          width: 32.sw,
                          height: 32.sw,
                          fit: BoxFit.cover,
                        )
                      else
                        WidgetAppImage(
                          imageUrl:
                              selectedAccount.paymentWalletProvider?.iconUrl ??
                                  '',
                          width: 32.sw,
                          height: 32.sw,
                          radius: 10.sw,
                        ),
                      Gap(12.sw),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedAccount.accountName ?? '',
                              style: w400TextStyle(),
                            ),
                            Gap(2.sw),
                            Text(
                              selectedAccount.accountType == 'bank'
                                  ? '${selectedAccount.bankName} · ${_maskAccountNumber(selectedAccount.accountNumber)}'
                                  : '${selectedAccount.paymentWalletProvider?.name ?? ''} · ${_maskAccountNumber(selectedAccount.accountNumber)}',
                              style:
                                  w400TextStyle(fontSize: 12.sw, color: grey1),
                            ),
                          ],
                        ),
                      ),
                      WidgetAppSVG('chevron_right', width: 20.sw, color: grey1)
                    ],
                  ),
                ),
              ),
              Gap(12.sw),
              WidgetRippleButton(
                onTap: () {
                  appHaptic();
                  final cleanedText =
                      controller.text.replaceAll(RegExp(r'[^\d.]'), '');
                  if (cleanedText.isNotEmpty) {
                    final amount = double.parse(cleanedText);
                    context.pop({'amount': amount, 'account': selectedAccount});
                  }
                },
                radius: 99,
                enable: isValidAmount,
                color: isValidAmount ? appColorPrimary : grey9,
                child: SizedBox(
                  height: 48.sw,
                  child: Center(
                    child: Text(
                      'Confirm'.tr(),
                      style: w500TextStyle(
                        fontSize: 16.sw,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

String _maskAccountNumber(String? accountNumber) {
  if (accountNumber == null || accountNumber.length < 5) return '';

  final visiblePart = accountNumber.substring(accountNumber.length - 4);
  return '**** $visiblePart';
}
