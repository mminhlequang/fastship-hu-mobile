import 'package:network_resources/network_resources.dart';
import 'dart:ui';

import 'package:app/src/base/auth/auth_cubit.dart';
import 'package:app/src/constants/constants.dart';
import 'package:network_resources/transaction/models/models.dart';
import 'package:network_resources/transaction/repo.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';

import '../widgets/widgets.dart';
import 'widgets/widget_topup_sheet.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool isLoading = false;
  List<TransactionModel>? transactions;
  bool _isLoadingTransactions = true;
  bool hidePass = true;

  Future<void> onTopUp(num amount) async {
    setState(() {
      isLoading = true;
    });
    try {
      // Gọi API backend để lấy clientSecret

      final response = await TransactionRepo()
          .requestTopUp({'amount': amount, 'currency': appCurrency});
      if (response.isSuccess) {
        final data = response.data;
        print(data);

        // Lấy thông tin khách hàng từ API response (giả sử backend trả về)
        final clientSecret = data['clientSecret'];

        // Hiển thị giao diện thanh toán
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: clientSecret,
            merchantDisplayName: 'FastshipHu', // Tên app của Minh
            customerId: AppPrefs.instance.user?.uid, // ID khách hàng từ Stripe
            // customerEphemeralKeySecret:
            //     ephemeralKeySecret, // Khóa tạm thời để xác thực
            // Cấu hình bổ sung cho khách hàng
            billingDetails: BillingDetails(
              name: AppPrefs.instance.user?.name,
              email: AppPrefs.instance.user?.email,
              phone: AppPrefs.instance.user?.phone,
              // address: const Address(
              //   city: 'Hà Nội',
              //   country: 'VN',
              //   line1: 'Địa chỉ nhà, phố',
              //   line2: 'Quận/Huyện',
              //   postalCode: '100000',
              //   state: 'Hà Nội',
              // ),
            ),
            applePay: PaymentSheetApplePay(
              merchantCountryCode: 'US', // Thay bằng mã quốc gia hợp lệ
            ),
            googlePay: PaymentSheetGooglePay(
              merchantCountryCode: 'US', // Thay bằng mã quốc gia hợp lệ
              testEnv: kDebugMode, // Bỏ `testEnv: true` khi lên production
            ),
          ),
        );

        // Mở Payment Sheet
        await Stripe.instance.presentPaymentSheet();

        await appShowSnackBar(
          context: context,
          msg: "We received your payment!",
          type: AppSnackBarType.success,
        );
        _fetchTransactions();
      } else {
        await appShowSnackBar(
          context: context,
          msg: "Oops! Something went wrong, please try again!",
          type: AppSnackBarType.error,
        );
      }
    } catch (e) {
      print("Lỗi thanh toán: $e");
      //TODO: error
      await appShowSnackBar(
        context: context,
        msg: "Oops! Something went wrong: $e",
        type: AppSnackBarType.error,
      );
    }
  }

  // params: {'amount': amount, 'account': account}
  Future<void> onRequestWithdraw(Map params) async {
    setState(() {
      isLoading = true;
    });

    final response = await TransactionRepo().requestWithdraw({
      'amount': params['amount'],
      'currency': appCurrency,
      'payment_account_id': params['account'].id,
    });
    if (response.isSuccess) {
      await appShowSnackBar(
        context: context,
        msg: "Withdrawal request sent successfully!",
        type: AppSnackBarType.success,
      );
      _fetchTransactions();
    } else {
      await appShowSnackBar(
        context: context,
        msg: "Oops! Something went wrong, please try again!",
        type: AppSnackBarType.error,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    authCubit.fetchWallet();
    setState(() {
      _isLoadingTransactions = true;
    });
    final response = await TransactionRepo().getTransactions({
      "store_id": authCubit.storeId,
    });
    setState(() {
      transactions = response.data ?? [];
      _isLoadingTransactions = false;
    });
  }

  _verifyPassword({required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Center(
                child: Material(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(
                    width: appContext.width - 112.sw,
                    padding: EdgeInsets.all(20.sw),
                    constraints: BoxConstraints(maxWidth: 264.sw),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Enter password'.tr(),
                          style: w600TextStyle(fontSize: 16.sw),
                        ),
                        Gap(12.sw),
                        TextFormField(
                          style: w400TextStyle(fontSize: 16.sw),
                          obscureText: hidePass,
                          decoration: InputDecoration(
                            isDense: true,
                            isCollapsed: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.sw, vertical: 8.sw),
                            filled: true,
                            fillColor: appColorBackground,
                            hintText: 'Password'.tr(),
                            hintStyle: w400TextStyle(
                              fontSize: 16.sw,
                              color: hexColor('#8A8C91'),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8.sw),
                            ),
                            suffixIcon: Padding(
                              padding: EdgeInsets.only(right: 8.sw),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    hidePass = !hidePass;
                                  });
                                },
                                child: WidgetAppSVG(
                                  hidePass ? 'ic_eye' : 'ic_eye_off',
                                  width: 20.sw,
                                ),
                              ),
                            ),
                            suffixIconConstraints: BoxConstraints(
                                maxHeight: 24.sw, minWidth: 28.sw),
                          ),
                        ),
                        Gap(20.sw),
                        Row(
                          children: [
                            Expanded(
                              child: WidgetRippleButton(
                                onTap: () {
                                  Navigator.of(dialogContext).pop();
                                },
                                radius: 8,
                                borderSide: BorderSide(color: appColorPrimary),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.sw),
                                  child: Center(
                                    child: Text(
                                      'Close'.tr(),
                                      style: w500TextStyle(
                                        fontSize: 16.sw,
                                        color: appColorPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Gap(10.sw),
                            Expanded(
                              child: WidgetRippleButton(
                                onTap: () {
                                  Navigator.of(dialogContext).pop();
                                  // Todo: check password
                                  onConfirm.call();
                                },
                                radius: 8,
                                color: appColorPrimary,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.sw),
                                  child: Center(
                                    child: Text(
                                      'Ok'.tr(),
                                      style: w500TextStyle(
                                        fontSize: 16.sw,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: appColorPrimary,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(assetpng('app_background')),
            alignment: Alignment.topCenter,
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Store Wallet'.tr()),
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                icon: WidgetAppSVG('ic_settings'),
                onPressed: () {
                  appContext.push('/my-wallet/banks-cards');
                },
              ),
              Gap(4.sw),
            ],
          ),
          body: Column(
            children: [
              Gap(24.sw),
              BlocBuilder<AuthCubit, AuthState>(
                bloc: authCubit,
                builder: (context, state) {
                  return Column(
                    children: [
                      Text(
                        NumberFormat.currency(
                          symbol: AppPrefs.instance.currencySymbol,
                          decimalDigits: 1,
                        ).format(state.wallet?.availableBalance ?? 0),
                        style: w500TextStyle(
                          fontSize: 40.sw,
                          color: Colors.white,
                        ),
                      ),
                      Gap(4.sw),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.sw, vertical: 4.sw),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .2),
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: .5)),
                        ),
                        child: Text(
                          '${'Pending'.tr()} ${NumberFormat.currency(
                            symbol: AppPrefs.instance.currencySymbol,
                            decimalDigits: 1,
                          ).format(state.wallet?.frozenBalance ?? 0)}',
                          style: w400TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Gap(24.sw),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sw),
                child: Row(
                  children: [
                    // Expanded(
                    //   child: Container(
                    //     padding: EdgeInsets.only(bottom: 3.sw),
                    //     decoration: BoxDecoration(
                    //       color: hexColor('#EDEDED'),
                    //       borderRadius: BorderRadius.circular(10.sw),
                    //     ),
                    //     child: WidgetRippleButton(
                    //       onTap: () async {
                    //         appHaptic();
                    //         final r =
                    //             await appOpenBottomSheet(WidgetTopUpSheet());
                    //         if (r is num) {
                    //           _verifyPassword(onConfirm: () => onTopUp(r));
                    //         }
                    //       },
                    //       radius: 10.sw,
                    //       child: Center(
                    //         child: Padding(
                    //           padding: EdgeInsets.symmetric(vertical: 14.5.sw),
                    //           child: Text(
                    //             'Top Up'.tr(),
                    //             style: w500TextStyle(fontSize: 16.sw),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Gap(12.sw),
                    Spacer(
                      flex: 1,
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.only(bottom: 3.sw),
                        decoration: BoxDecoration(
                          color: hexColor('#EDEDED'),
                          borderRadius: BorderRadius.circular(10.sw),
                        ),
                        child: WidgetRippleButton(
                          onTap: () async {
                            appHaptic();
                            appContext
                                .push('/my-wallet/banks-cards', extra: true)
                                .then((value) async {
                              if (value is PaymentAccount) {
                                final r = await appOpenBottomSheet(
                                    WidgetWithdrawSheet(account: value));
                                if (r is Map) {
                                  _verifyPassword(
                                      onConfirm: () => onRequestWithdraw(r));
                                }
                              }
                            });
                          },
                          radius: 10.sw,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 14.5.sw),
                              child: Text(
                                'Withdraw'.tr(),
                                style: w500TextStyle(fontSize: 16.sw),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                  ],
                ),
              ),
              Gap(12.sw),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.sw),
                      topRight: Radius.circular(20.sw),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WidgetInkWellTransparent(
                        onTap: () {
                          appContext.push('/my-wallet/transactions');
                        },
                        enableInkWell: false,
                        child: Padding(
                          padding: EdgeInsets.all(16.sw),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Transactions'.tr(),
                                  style: w600TextStyle(
                                    fontSize: 16.sw,
                                    color: hexColor('#4F4F4F'),
                                  ),
                                ),
                              ),
                              Text(
                                'View all'.tr(),
                                style: w400TextStyle(
                                  fontSize: 12.sw,
                                  height: 2,
                                  decoration: TextDecoration.underline,
                                  color: appColorPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: _isLoadingTransactions
                            ? ListView.separated(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 16.sw),
                                itemCount: 10,
                                separatorBuilder: (context, index) =>
                                    const AppDivider(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      top: index == 0 ? 0 : 8.sw,
                                      bottom: 8.sw,
                                    ),
                                    child: Row(
                                      children: [
                                        WidgetAppShimmer(
                                          height: 32.sw,
                                          width: 32.sw,
                                          borderRadius:
                                              BorderRadius.circular(16.sw),
                                        ),
                                        Gap(8.sw),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  WidgetAppShimmer(
                                                    height: 17.sw,
                                                    width: 120.sw,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  WidgetAppShimmer(
                                                    height: 17.sw,
                                                    width: 56.sw,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                ],
                                              ),
                                              Gap(4.sw),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  WidgetAppShimmer(
                                                    height: 15.sw,
                                                    width: 105.sw,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  WidgetAppShimmer(
                                                    height: 15.sw,
                                                    width: 48.sw,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : transactions!.isEmpty
                                ? Padding(
                                    padding: EdgeInsets.only(top: 20.sw),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        WidgetAppSVG('ic_empty_transaction'),
                                        Gap(16.sw),
                                        Text(
                                          'There’s nothing here...yet'.tr(),
                                          style: w500TextStyle(fontSize: 18.sw),
                                          textAlign: TextAlign.center,
                                        ),
                                        Gap(4.sw),
                                        Text(
                                          'We’ll let you know when we get news for you'
                                              .tr(),
                                          style: w400TextStyle(color: grey1),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  )
                                : RefreshIndicator(
                                    onRefresh: () async =>
                                        await _fetchTransactions(),
                                    child: ListView.separated(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.sw),
                                      itemCount: transactions!.length,
                                      separatorBuilder: (context, index) =>
                                          const AppDivider(),
                                      itemBuilder: (context, index) {
                                        final transaction =
                                            transactions![index];
                                        bool isDeposit =
                                            transaction.type?.toLowerCase() ==
                                                'deposit';

                                        return Padding(
                                          padding: EdgeInsets.only(
                                            top: index == 0 ? 0 : 8.sw,
                                            bottom: 8.sw,
                                          ),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 16.sw,
                                                backgroundColor:
                                                    hexColor('#F9F9F9'),
                                                child: WidgetAppSVG(
                                                  isDeposit
                                                      ? 'wallet-add'
                                                      : 'wallet-minus',
                                                  width: 24.sw,
                                                ),
                                              ),
                                              Gap(8.sw),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          isDeposit
                                                              ? 'Depositing money'
                                                                  .tr()
                                                              : 'Withdrawing money'
                                                                  .tr(),
                                                          style:
                                                              w400TextStyle(),
                                                        ),
                                                        Text(
                                                          currencyFormatted(
                                                              transaction
                                                                  .price),
                                                          style:
                                                              w400TextStyle(),
                                                        ),
                                                      ],
                                                    ),
                                                    Gap(2.sw),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          string2DateTime(transaction
                                                                      .createdAt!)
                                                                  ?.toLocal()
                                                                  .formatDateTime() ??
                                                              '',
                                                          style: w400TextStyle(
                                                            fontSize: 12.sw,
                                                            color: grey1,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Success'.tr(),
                                                          style: w400TextStyle(
                                                            fontSize: 12.sw,
                                                            color: green2,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
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
      ),
    );
  }
}

enum TransactionType { deposit, withdraw }

class Transaction {
  final TransactionType type;
  final double amount;
  final DateTime date;

  Transaction({
    required this.type,
    required this.amount,
    required this.date,
  });
}
