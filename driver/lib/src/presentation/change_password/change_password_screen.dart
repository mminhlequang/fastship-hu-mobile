import 'package:app/src/constants/constants.dart';
import 'package:network_resources/auth/repo.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';

import '../widgets/widgets.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _currentPasswordFocusNode = FocusNode();
  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _currentPasswordFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _currentPasswordController.text.length > 4 &&
        _newPasswordController.text.length > 4 &&
        _confirmPasswordController.text == _newPasswordController.text;
  }

  Future<void> _changePassword() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Thực hiện API đổi mật khẩu ở đây
    final response = await AuthRepo().updatePassword({
      "current_password": _currentPasswordController.text,
      "password": _newPasswordController.text,
    });

    setState(() {
      _isLoading = false;
    });

    if (response.isSuccess) {
      appShowSnackBar(
          msg: 'Password changed successfully'.tr(),
          context: context,
          type: AppSnackBarType.success);
      Navigator.of(context).pop();
    } else {
      setState(() {
        _errorMessage =
            'Password change failed. Please check your information.'.tr();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Change Password'.tr())),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.sw, vertical: 24.sw),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_errorMessage != null)
              Container(
                padding: EdgeInsets.all(12.sw),
                margin: EdgeInsets.only(bottom: 16.sw),
                decoration: BoxDecoration(
                  color: appColorPrimaryRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.sw),
                ),
                child: Text(
                  _errorMessage!,
                  style: w400TextStyle(
                    fontSize: 14.sw,
                    color: appColorPrimaryRed,
                  ),
                ),
              ),
            WidgetTextField(
              controller: _currentPasswordController,
              focusNode: _currentPasswordFocusNode,
              hint: "Enter current password".tr(),
              label: "Current Password".tr(),
              isPassword: true,
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(_newPasswordFocusNode);
              },
            ),
            Gap(24.sw),
            WidgetTextField(
              controller: _newPasswordController,
              focusNode: _newPasswordFocusNode,
              hint: "Enter new password".tr(),
              label: "New Password".tr(),
              isPassword: true,
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
              },
            ),
            Gap(24.sw),
            WidgetTextField(
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocusNode,
              hint: "Confirm new password".tr(),
              label: "Confirm Password".tr(),
              isPassword: true,
              onSubmitted: (_) {
                if (_isFormValid) {
                  _changePassword();
                }
              },
            ),
            Gap(36.sw),
            WidgetAppButtonOK(
              loading: _isLoading,
              enable: _isFormValid,
              label: 'Confirm'.tr(),
              onTap: _changePassword,
            ),
          ],
        ),
      ),
    );
  }
}
