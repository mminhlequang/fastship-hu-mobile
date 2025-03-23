import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/network_resources/transaction/models/models.dart';
import 'package:app/src/network_resources/transaction/repo.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';

import '../widgets/widget_loader.dart';
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
  void initState() {
    super.initState();
    _fetchData();
  }

  bool isLoading = true;
  List<PaymentAccount> paymentAccounts = [];
  List<PaymentWalletProvider> paymentWalletProvider = [];
  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });

    var accountsResponse = await TransactionRepo().getPaymentAccounts();
    if (accountsResponse.isSuccess) {
      setState(() {
        paymentAccounts = accountsResponse.data;
      });
    }

    var providerResponse = await TransactionRepo().getPaymentWalletProvider();
    if (providerResponse.isSuccess) {
      setState(() {
        paymentWalletProvider = providerResponse.data;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bank Accounts/Wallets'.tr()),
        // actions: [
        //   if (paymentAccounts.isNotEmpty)
        //     TextButton(
        //       onPressed: () {
        //         appHaptic();
        //         _refreshData();
        //       },
        //       child: Text(
        //         'Refresh'.tr(),
        //         style: w400TextStyle(color: Colors.white),
        //       ),
        //     ),
        //   Gap(4.sw),
        // ],
      ),
      body: isLoading
          ? const WidgetAppLoader() //TODO: add shimmer
          : SingleChildScrollView(
              child: Column(
                children: [
                  // BANK ACCOUNTS SECTION
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
                        Gap(6.sw),
                        _buildBankAccountsList(),
                        const AppDivider(),
                        WidgetInkWellTransparent(
                          onTap: () {
                            appHaptic();
                            appContext.push('/my-wallet/banks-cards/add-card',
                                extra: {'type': 'bank'});
                          },
                          radius: 0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.sw),
                            child: Row(
                              children: [
                                WidgetAppSVG('ic_add',
                                    width: 24.sw, color: darkGreen),
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
                  // WALLET SECTION
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16.sw),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(16.sw),
                        Text(
                          'WALLET'.tr(),
                          style: w400TextStyle(color: grey1),
                        ),
                        Gap(6.sw),
                        _buildWalletsList(),
                        const AppDivider(),
                        WidgetInkWellTransparent(
                          onTap: () {
                            appHaptic();
                            appContext.push('/my-wallet/banks-cards/add-card',
                                extra: {
                                  'type': 'wallet',
                                  'providers': paymentWalletProvider
                                });
                          },
                          radius: 0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.sw),
                            child: Row(
                              children: [
                                WidgetAppSVG('ic_add',
                                    width: 24.sw, color: darkGreen),
                                Gap(8.sw),
                                Text(
                                  'Add wallet'.tr(),
                                  style: w400TextStyle(),
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
            ),
    );
  }

  Widget _buildBankAccountsList() {
    final bankAccounts = paymentAccounts
        .where((account) => account.accountType == 'bank')
        .toList();

    if (bankAccounts.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.sw),
        child: Center(
          child: Text(
            'No bank accounts found'.tr(),
            style: w400TextStyle(color: grey1),
          ),
        ),
      );
    }

    return Column(
      children: [
        ...bankAccounts.map((account) => _buildAccountItem(account)),
      ],
    );
  }

  Widget _buildWalletsList() {
    final wallets = paymentAccounts
        .where((account) => account.accountType == 'wallet')
        .toList();

    if (wallets.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.sw),
        child: Center(
          child: Text(
            'No wallets found'.tr(),
            style: w400TextStyle(color: grey1),
          ),
        ),
      );
    }

    return Column(
      children: [
        ...wallets.map((account) => _buildAccountItem(account)),
      ],
    );
  }

  Widget _buildAccountItem(PaymentAccount account) {
    final bool isDefault = account.isDefault == 1;
    return WidgetInkWellTransparent(
      onTap: () {
        _showAccountOptions(account);
      },
      radius: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.sw),
        child: Row(
          children: [
            if (isDefault)
              WidgetAppSVG('radio-check', width: 24.sw)
            else
              WidgetAppSVG('radio-uncheck', width: 24.sw),
            if (account.accountType != 'bank') ...[
              Gap(12.sw),
              WidgetAppImage(
                imageUrl: account.paymentWalletProvider?.iconUrl ?? '',
                height: 32.sw,
                width: 32.sw,
                radius: 10.sw,
              ),
            ],
            Gap(12.sw),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.accountName ?? '',
                    style: w400TextStyle(fontSize: 16.sw),
                  ),
                  Text(
                    account.accountType == 'bank'
                        ? '${account.bankName} · ${_maskAccountNumber(account.accountNumber)}'
                        : '${account.paymentWalletProvider?.name ?? ''} · ${_maskAccountNumber(account.accountNumber)}',
                    style: w400TextStyle(color: grey1),
                  ),
                ],
              ),
            ),
            if (account.isVerified == 1)
              WidgetAppSVG('ic_verified', width: 24.sw, color: darkGreen),
          ],
        ),
      ),
    );
  }

  String _maskAccountNumber(String? accountNumber) {
    if (accountNumber == null || accountNumber.length < 5) return '';

    final visiblePart = accountNumber.substring(accountNumber.length - 4);
    return '**** $visiblePart';
  }

  void _showAccountOptions(PaymentAccount account) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.sw),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Account Options'.tr(),
              style: w400TextStyle(
                fontSize: 18.sw,
              ),
            ),
            Gap(16.sw),
            ListTile(
              leading: WidgetAppSVG('ic_edit'),
              title: Text('Edit'.tr()),
              onTap: () {
                Navigator.pop(context);
                _editAccount(account);
              },
            ),
            if (account.isDefault != 1)
              ListTile(
                leading: WidgetAppSVG('ic_default'),
                title: Text('Set as default'.tr()),
                onTap: () {
                  Navigator.pop(context);
                  _setAsDefault(account);
                },
              ),
            ListTile(
              leading: WidgetAppSVG('ic_delete', color: Colors.red),
              title: Text(
                'Delete'.tr(),
                style: w400TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(account);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editAccount(PaymentAccount account) {
    // Điều hướng đến màn hình chỉnh sửa với account được chọn
    appContext.push('/my-wallet/banks-cards/add-card', extra: {
      'type': account.accountType == 'bank' ? 'bank' : 'wallet',
      'account': account,
      'providers': paymentWalletProvider,
    });
  }

  Future<void> _setAsDefault(PaymentAccount account) async {
    setState(() {
      isLoading = true;
    });

    // // Giả sử có API để set làm mặc định
    // final response =
    //     await TransactionRepo().setDefaultPaymentAccount(account.id!);

    // if (response.isSuccess) {
    //   await appShowSnackBar(
    //     context: context,
    //     msg: 'Default account updated successfully'.tr(),
    //     type: AppSnackBarType.success,
    //   );
    //   await _fetchData();
    // } else {
    //   await appShowSnackBar(
    //     context: context,
    //     msg: 'Failed to update default account'.tr(),
    //     type: AppSnackBarType.error,
    //   );
    //   setState(() {
    //     isLoading = false;
    //   });
    // }
  }

  void _confirmDelete(PaymentAccount account) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deletion'.tr()),
        content: Text(
          'Are you sure you want to delete this account?'.tr(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount(account);
            },
            child: Text(
              'Delete'.tr(),
              style: w400TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount(PaymentAccount account) async {
    setState(() {
      isLoading = true;
    });

    // Giả sử có API để xóa tài khoản
    final response =
        await TransactionRepo().deletePaymentAccounts({"id": account.id});

    if (response.isSuccess) {
      await appShowSnackBar(
        context: context,
        msg: 'Account deleted successfully'.tr(),
        type: AppSnackBarType.success,
      );
      await _fetchData();
    } else {
      await appShowSnackBar(
        context: context,
        msg: 'Failed to delete account'.tr(),
        type: AppSnackBarType.error,
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await _fetchData();
    await appShowSnackBar(
      context: context,
      msg: 'Data refreshed'.tr(),
      type: AppSnackBarType.success,
    );
  }
}
