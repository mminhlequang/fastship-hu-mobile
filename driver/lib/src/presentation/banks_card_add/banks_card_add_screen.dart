import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/constants/constants.dart';
import 'package:app/src/network_resources/transaction/models/models.dart';
import 'package:app/src/network_resources/transaction/repo.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';

import '../widgets/widget_loader.dart';
import '../widgets/widgets.dart';

class BanksCardAddScreen extends StatefulWidget {
  final Map<String, dynamic> params;
  const BanksCardAddScreen({super.key, required this.params});

  @override
  State<BanksCardAddScreen> createState() => _BanksCardAddScreenState();
}

class _BanksCardAddScreenState extends State<BanksCardAddScreen> {
  bool get enableSubmit {
    if (accountType == 'bank') {
      return _accountNameController.text.isNotEmpty &&
          _accountNumberController.text.isNotEmpty &&
          _bankNameController.text.isNotEmpty &&
          _currencyController.text.isNotEmpty;
    } else {
      // wallet
      return _accountNameController.text.isNotEmpty &&
          _accountNumberController.text.isNotEmpty &&
          selectedProvider != null;
    }
  }

  bool isLoading = false;
  String accountType = 'bank';
  List<PaymentWalletProvider> providers = [];
  bool isEditMode = false;
  PaymentAccount? accountToEdit;

  // Controllers cho các trường input
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();

  PaymentWalletProvider? selectedProvider;

  @override
  void initState() {
    super.initState();
    _currencyController.text = appCurrency; // Đặt giá trị mặc định cho tiền tệ

    // Kiểm tra xem có phải đang chỉnh sửa không
    if (widget.params.containsKey('account')) {
      isEditMode = true;
      accountToEdit = widget.params['account'];
      _initEditMode();
    } else {
      if (widget.params.containsKey('type')) {
        accountType = widget.params['type'];
      }
    }

    if (widget.params.containsKey('providers')) {
      providers = widget.params['providers'];
      if (!isEditMode && providers.isNotEmpty) {
        selectedProvider = providers.first;
      }
    }

    // Lắng nghe sự thay đổi để cập nhật trạng thái của nút Submit
    _accountNameController.addListener(_validateForm);
    _accountNumberController.addListener(_validateForm);
    _bankNameController.addListener(_validateForm);
    _currencyController.addListener(_validateForm);
  }

  void _initEditMode() {
    if (accountToEdit != null) {
      accountType = accountToEdit!.accountType ?? 'bank';
      _accountNameController.text = accountToEdit!.accountName ?? '';
      _accountNumberController.text = accountToEdit!.accountNumber ?? '';

      if (accountType == 'bank') {
        _bankNameController.text = accountToEdit!.bankName ?? '';
        _currencyController.text = accountToEdit!.currency ?? appCurrency;
      } else if (accountType == 'wallet') {
        // Tìm provider tương ứng nếu có
        if (accountToEdit!.paymentWalletProvider != null) {
          // Đợi đến khi providers được khởi tạo đầy đủ
          selectedProvider = accountToEdit!.paymentWalletProvider;
        }
      }
    }
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    _accountNumberController.dispose();
    _bankNameController.dispose();
    _currencyController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(
              '${isEditMode ? 'Edit' : 'Add'} ${accountType == 'bank' ? 'Bank Account' : 'Wallet'}'
                  .tr())),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.sw),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Information'.tr(),
                        style: w500TextStyle(fontSize: 16.sw),
                      ),
                      Gap(16.sw),

                      // Tên tài khoản
                      Text('Account Name'.tr(), style: w400TextStyle()),
                      Gap(8.sw),
                      WidgetTextField(
                        controller: _accountNameController,
                        hint: 'Enter account name'.tr(),
                      ),
                      Gap(16.sw),

                      // Số tài khoản
                      Text('Account Number'.tr(), style: w400TextStyle()),
                      Gap(8.sw),
                      WidgetTextField(
                        controller: _accountNumberController,
                        hint: 'Enter account number'.tr(),
                        // keyboardType: TextInputType.number,
                        // isReadOnly:
                        //     isEditMode, // Không cho phép chỉnh sửa số tài khoản trong chế độ chỉnh sửa
                      ),
                      Gap(16.sw),

                      if (accountType == 'bank') ...[
                        // Tên ngân hàng (chỉ cho tài khoản ngân hàng)
                        Text('Bank Name'.tr(), style: w400TextStyle()),
                        Gap(8.sw),
                        WidgetTextField(
                          controller: _bankNameController,
                          hint: 'Enter bank name'.tr(),
                        ),
                        Gap(16.sw),

                        // Tiền tệ (chỉ cho tài khoản ngân hàng)
                        // Text('Currency'.tr(), style: w400TextStyle()),
                        // Gap(8.sw),
                        // WidgetTextField(
                        //   controller: _currencyController,
                        //   hint: 'Enter currency code'.tr(),
                        // ),
                        // Gap(16.sw),
                      ] else if (accountType == 'wallet') ...[
                        // Chọn nhà cung cấp ví (chỉ cho ví điện tử)
                        Text('Wallet Provider'.tr(), style: w400TextStyle()),
                        Gap(8.sw),
                        _buildProviderSelection(),
                        Gap(16.sw),
                      ],
                    ],
                  ),
                ),
              ),
              const AppDivider(),
              Padding(
                padding: EdgeInsets.fromLTRB(16.sw, 10.sw, 16.sw,
                    10.sw + context.mediaQueryPadding.bottom),
                child: WidgetRippleButton(
                  onTap: enableSubmit ? _submitForm : null,
                  radius: 10,
                  enable: enableSubmit,
                  color: appColorPrimary,
                  child: SizedBox(
                    height: 48.sw,
                    child: Center(
                      child: Text(
                        isEditMode ? 'Update'.tr() : 'Submit'.tr(),
                        style: w500TextStyle(
                          fontSize: 16.sw,
                          color: enableSubmit ? Colors.white : grey1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: WidgetAppLoader(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProviderSelection() {
    return Column(
      children: providers
          .map((provider) => WidgetInkWellTransparent(
                enableInkWell: false,
                onTap: () {
                  appHaptic();
                  setState(() {
                    selectedProvider = provider;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.sw),
                  child: Row(
                    children: [
                      WidgetAppImage(
                        imageUrl: provider.iconUrl!,
                        height: 32.sw,
                        width: 32.sw,
                        radius: 10.sw,
                      ),
                      Gap(12.sw),
                      Expanded(
                        child: Text(
                          provider.name ?? '',
                          style: w400TextStyle(),
                        ),
                      ),
                      Gap(12.sw),
                      if (selectedProvider?.id == provider.id)
                        WidgetAppSVG('radio-check', width: 24.sw)
                      else
                        WidgetAppSVG('radio-uncheck', width: 24.sw),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }

  Future<void> _submitForm() async {
    try {
      setState(() {
        isLoading = true;
      });

      Map<String, dynamic> data = {
        'account_type': accountType,
        'account_number': _accountNumberController.text,
        'account_name': _accountNameController.text,
      };

      if (accountType == 'bank') {
        data['bank_name'] = _bankNameController.text;
        data['currency'] = _currencyController.text;
      } else if (accountType == 'wallet' && selectedProvider != null) {
        data['payment_wallet_provider_id'] = selectedProvider!.id;
        data['bank_name'] = selectedProvider!.name;
        data['currency'] = appCurrency;
      }

      // Thêm ID tài khoản nếu đang ở chế độ chỉnh sửa
      if (isEditMode && accountToEdit != null) {
        data['id'] = accountToEdit!.id;
      }

      final response = isEditMode
          ? await TransactionRepo().updatePaymentAccounts(data)
          : await TransactionRepo().createPaymentAccounts(data);

      setState(() {
        isLoading = false;
      });

      if (response.isSuccess) {
        await appShowSnackBar(
          context: context,
          msg: isEditMode
              ? 'Account updated successfully'.tr()
              : (accountType == 'bank'
                  ? 'Bank account added successfully'.tr()
                  : 'Wallet added successfully'.tr()),
          type: AppSnackBarType.success,
        );
        context.pop(true); // Quay lại với kết quả thành công
      } else {
        await appShowSnackBar(
          context: context,
          msg: response.msg ?? 'Operation failed'.tr(),
          type: AppSnackBarType.error,
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      await appShowSnackBar(
        context: context,
        msg: 'An error occurred'.tr(),
        type: AppSnackBarType.error,
      );
    }
  }
}
