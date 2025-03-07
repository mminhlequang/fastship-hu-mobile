import 'package:app/src/constants/constants.dart';
import 'package:app/src/network_resources/transaction/models/models.dart';
import 'package:app/src/network_resources/transaction/repo.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:internal_core/internal_core.dart';

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

  void onTopUp(num amount) async {
    setState(() {
      isLoading = true;
    });
    try {
      // Gọi API backend để lấy clientSecret

      final response = await TransactionRepo()
          .requestTopUp({'amount': amount, 'currency': 'eur'});
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

        await appShowSnackBar(context: context,
          msg: "We received your payment!",
          type: AppSnackBarType.success,
        );
        _fetchTransactions();
      } else {
        await appShowSnackBar(context: context,
          msg: "Oops! Something went wrong, please try again!",
          type: AppSnackBarType.error,
        );
      }
    } catch (e) {
      print("Lỗi thanh toán: $e");
      //TODO: error
      await appShowSnackBar(context: context,
        msg: "Oops! Something went wrong: $e",
        type: AppSnackBarType.error,
      );
    }
  }

  onRequestWithdraw(num amount) async {
    setState(() {
      isLoading = true;
    });

    final response = await TransactionRepo()
        .requestWithdraw({'amount': amount, 'currency': 'eur'});
    if (response.isSuccess) {
      await appShowSnackBar(context: context,
        msg: "Withdrawal request sent successfully!",
        type: AppSnackBarType.success,
      );
    } else {
      await appShowSnackBar(context: context,
        msg: "Oops! Something went wrong, please try again!",
        type: AppSnackBarType.error,
      );
    }
    _fetchTransactions();
  }

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  _fetchTransactions() async {
    setState(() {
      _isLoadingTransactions = true;
    });
    final response = await TransactionRepo().getTransactions();
    setState(() {
      transactions = response.data ?? [];
      _isLoadingTransactions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: appColorPrimary,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(assetpng('setting_backgorund')),
            alignment: Alignment.topCenter,
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'My Wallet'.tr(),
              style: w500TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 24.sw,
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: Column(
            children: [
              const SizedBox(height: 32),
              // Balance Section
              Text(
                '\$255.06',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              // Buttons Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          appHaptic();
                          final r =
                              await appOpenBottomSheet(WidgetTopUpSheet());
                          if (r is num) {
                            onTopUp(r);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Top Up',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          appHaptic();
                          final r =
                              await appOpenBottomSheet(WidgetWithDrawSheet());
                          if (r is num) {
                            onRequestWithdraw(r);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Withdraw',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Transactions Section
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Transactions',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _isLoadingTransactions
                            ? ListView.builder(
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: Row(
                                      children: [
                                        WidgetAppShimmer(
                                          height: 40,
                                          width: 40,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              WidgetAppShimmer(
                                                height: 16,
                                                width: 120,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              const SizedBox(height: 8),
                                              WidgetAppShimmer(
                                                height: 14,
                                                width: 80,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ],
                                          ),
                                        ),
                                        WidgetAppShimmer(
                                          height: 16,
                                          width: 60,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : transactions!.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.receipt_long_outlined,
                                          size: 64,
                                          color: Colors.grey[400],
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Không có giao dịch nào',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: transactions!.length,
                                    itemBuilder: (context, index) {
                                      final transaction = transactions![index];
                                      return ListTile(
                                        leading: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade100,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            transaction.type == 'deposit'
                                                ? Icons.add
                                                : Icons.remove,
                                            color: Colors.green,
                                          ),
                                        ),
                                        title: Text(
                                          transaction.type == 'deposit'
                                              ? 'Depositing money'
                                              : 'Withdrawing money',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subtitle: Text(
                                          string2DateTime(
                                                      transaction.createdAt!)
                                                  ?.toLocal()
                                                  .formatDateTime() ??
                                              '',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        trailing: Text(
                                          '\$${(transaction.price ?? 0).toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      );
                                    },
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
