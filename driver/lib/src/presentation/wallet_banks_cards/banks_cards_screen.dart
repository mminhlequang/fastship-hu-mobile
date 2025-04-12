import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:network_resources/transaction/models/models.dart';
import 'package:network_resources/transaction/repo.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';

import '../widgets/widgets.dart';

class BanksCardsScreen extends StatefulWidget {
  final bool isSelector;
  const BanksCardsScreen({super.key, this.isSelector = false});

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

    var providerResponse = await TransactionRepo()
        .getPaymentWalletProvider({"is_order_payment": 0});
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
        title: Text(
          widget.isSelector
              ? 'Select Bank Account/Wallet'.tr()
              : 'Bank Accounts/Wallets'.tr(),
        ),
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
          ? _buildShimmer()
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
                                extra: {'type': 'bank'}).then((value) {
                              if (mounted) _fetchData();
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
                                }).then((value) {
                              if (mounted) _fetchData();
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
        if (widget.isSelector) {
          appContext.pop(account);
        } else {
          _showAccountOptions(account);
        }
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
            ...[
              Gap(12.sw),
              if (account.accountType != 'bank')
                WidgetAppImage(
                  imageUrl: account.paymentWalletProvider?.iconUrl ?? '',
                  height: 32.sw,
                  width: 32.sw,
                  radius: 10.sw,
                )
              else
                Image.asset(
                  assetpng('card'),
                  width: 32.sw,
                  height: 32.sw,
                  fit: BoxFit.cover,
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
      backgroundColor: Colors.white,
      builder: (context) => SafeArea(
        top: false,
        child: Container(
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
                leading: Icon(CupertinoIcons.pencil),
                title: Text('Edit'.tr()),
                onTap: () {
                  Navigator.pop(context);
                  _editAccount(account);
                },
              ),
              if (account.isDefault != 1)
                ListTile(
                  leading: Icon(CupertinoIcons.star),
                  title: Text('Set as default'.tr()),
                  onTap: () {
                    Navigator.pop(context);
                    _setAsDefault(account);
                  },
                ),
              ListTile(
                leading: Icon(CupertinoIcons.delete, color: Colors.red),
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
      ),
    );
  }

  void _editAccount(PaymentAccount account) {
    // Điều hướng đến màn hình chỉnh sửa với account được chọn
    appContext.push('/my-wallet/banks-cards/add-card', extra: {
      'type': account.accountType == 'bank' ? 'bank' : 'wallet',
      'account': account,
      'providers': paymentWalletProvider,
    }).then((value) {
      if (mounted) _fetchData();
    });
  }

  Future<void> _setAsDefault(PaymentAccount account) async {
    // // Giả sử có API để set làm mặc định
    final response = await TransactionRepo().updatePaymentAccounts({
      "is_default": 1,
      "id": account.id,
    });

    if (response.isSuccess) {
      await appShowSnackBar(
        context: context,
        msg: 'Default account updated successfully'.tr(),
        type: AppSnackBarType.success,
      );
      await _fetchData();
    } else {
      await appShowSnackBar(
        context: context,
        msg: 'Failed to update default account'.tr(),
        type: AppSnackBarType.error,
      );
    }
  }

  void _confirmDelete(PaymentAccount account) {
    showDialog(
      context: context,
      builder: (context) {
        return WidgetConfirmDialog(
          title: 'Confirm Deletion'.tr(),
          subTitle:
              'Are you sure you want to delete this payment account?'.tr(),
          onConfirm: () {
            _deleteAccount(account);
          },
        );
      },
    );
  }

  Future<void> _deleteAccount(PaymentAccount account) async {
    setState(() {
      isLoading = true;
    });

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

  Widget _buildShimmer() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // SHIMMER CHO PHẦN BANK ACCOUNT
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(16.sw),
                // Tiêu đề phần
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 100.sw,
                    height: 14.sw,
                    color: Colors.white,
                  ),
                ),
                Gap(16.sw),
                // Danh sách ngân hàng
                ...List.generate(3, (index) => _buildShimmerAccountItem()),
                const AppDivider(),
                // Nút thêm tài khoản
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.sw),
                    child: Row(
                      children: [
                        Container(
                          width: 24.sw,
                          height: 24.sw,
                          color: Colors.white,
                        ),
                        Gap(8.sw),
                        Container(
                          width: 120.sw,
                          height: 16.sw,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gap(8.sw),
          // SHIMMER CHO PHẦN WALLET
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(16.sw),
                // Tiêu đề phần
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 80.sw,
                    height: 14.sw,
                    color: Colors.white,
                  ),
                ),
                Gap(16.sw),
                // Danh sách ví
                ...List.generate(2, (index) => _buildShimmerAccountItem()),
                const AppDivider(),
                // Nút thêm ví
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.sw),
                    child: Row(
                      children: [
                        Container(
                          width: 24.sw,
                          height: 24.sw,
                          color: Colors.white,
                        ),
                        Gap(8.sw),
                        Container(
                          width: 100.sw,
                          height: 16.sw,
                          color: Colors.white,
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

  Widget _buildShimmerAccountItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.sw),
        child: Row(
          children: [
            // Radio button
            Container(
              width: 24.sw,
              height: 24.sw,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            Gap(12.sw),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16.sw,
                    color: Colors.white,
                  ),
                  Gap(4.sw),
                  Container(
                    width: 200.sw,
                    height: 14.sw,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
