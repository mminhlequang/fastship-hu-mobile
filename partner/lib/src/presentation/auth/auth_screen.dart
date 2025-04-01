// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:internal_core/widgets/widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:app/src/base/auth/auth_cubit.dart';
import 'package:app/src/constants/constants.dart';
import 'package:network_resources/auth/repo.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

enum AuthFormType { login, register, forgotPassword }

class _LoginScreenState extends State<LoginScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  PhoneNumber? _phoneNumber;
  bool _isValidPhoneNumber = false;

  final _otpController = TextEditingController();
  final _otpTextEditingController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _authRepo = AuthRepo();
  bool _isLoading = false;
  bool _showOtpField = false;
  bool _showEnterPasswordField = false;
  String? _verificationId;
  AuthFormType _currentForm = AuthFormType.login;

  @override
  void dispose() {
    _passwordController.dispose();
    _otpController.dispose();
    _otpTextEditingController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  void _toggleFormType() {
    setState(() {
      _currentForm = _currentForm == AuthFormType.login
          ? AuthFormType.register
          : AuthFormType.login;
      _showOtpField = false;
    });
  }

  Future<void> _login({phone, password}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authRepo.login({
        'phone': phone ?? _phoneNumber?.phoneNumber,
        'password': password ?? _passwordController.text,
        'type': AccountType.partner.value,
      });

      setState(() {
        _isLoading = false;
      });

      if (response.isSuccess) {
        // Xử lý đăng nhập thành công
        await AppPrefs.instance.saveAccountToken(response.data!);

        // Chuyển hướng đến màn hình chính
        authCubit.load(
          delayRedirect: const Duration(seconds: 2),
        );
        appShowSnackBar(
          msg: 'Login success, redirecting to home...'.tr(),
          context: context,
          type: AppSnackBarType.success,
        );
      } else {
        // Xử lý lỗi
        _showError(response.msg ?? 'Login failed, please try again!');
      }
    } catch (e, stackTrace) {
      setState(() {
        _isLoading = false;
      });
      _showError('Lỗi kết nối: $e');
      log("_login: $stackTrace");
    }
  }

  String? _idToken;
  Future<void> _verifyPhoneNumber() async {
    setState(() {
      _isLoading = true;
    });
    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneNumber!.phoneNumber!,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        print(
            'Phone number automatically verified and signed in: ${_auth.currentUser?.phoneNumber}');

        _idToken = await userCredential.user!.getIdToken();
        _showEnterPasswordField = true;
        _showOtpField = false;
        _isLoading = false;
        setState(() {});
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _isLoading = false;
        });
        if (e.code == 'invalid-phone-number') {
          _showError('Invalid phone number.');
        } else if (e.code == 'missing-client-identifier') {
          _showError('Missing client identifier.');
        } else if (e.code == 'too-many-requests') {
          _showError('Too many requests. Please try again later.');
        } else {
          _showError('Verification failed: ${e.message}');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _isLoading = false;
          _showOtpField = true;
          _verificationId = verificationId;
        });
        appShowSnackBar(
            msg: 'OTP sent to your phone number',
            context: context,
            type: AppSnackBarType.notitfication);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('Timeout: Mã OTP hết hạn.');
      },
    );
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final verificationId = _verificationId;
      if (verificationId == null) {
        throw Exception('Invalid verification ID or expired');
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: _otpController.text.trim(),
      );

      final userCredential = await _auth.signInWithCredential(credential);
      _idToken = await userCredential.user!.getIdToken();

      _showEnterPasswordField = true;
      _showOtpField = false;
      _isLoading = false;
      setState(() {});
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('OTP verification failed: $e');
    }
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
    });
    print("call register");
    final response = await _authRepo.register({
      'id_token': _idToken,
      'name': AccountType.partner.name,
      'phone': _phoneNumber?.phoneNumber,
      'password': _passwordController.text.tr(),
      'type': AccountType.partner.value,
    });

    setState(() {
      _isLoading = false;
    });

    if (response.isSuccess) {
      await AppPrefs.instance.saveAccountToken(response.data!);
      authCubit.load(
        delayRedirect: const Duration(seconds: 2),
      );

      // Xử lý đăng ký thành công
      appShowSnackBar(
          msg: 'Register success, redirecting to home...',
          context: context,
          type: AppSnackBarType.success);
    } else {
      setState(() {
        _isLoading = false;
      });
      // Xử lý lỗi
      _showError(response.msg ?? 'Register failed, please try again!');
    }
  }

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    // Gọi API reset mật khẩu
    final response = await _authRepo.resetPassword({
      "id_token": _idToken,
      "phone": _phoneNumber?.phoneNumber,
      "new_password": _passwordController.text,
      "confirm_password": _passwordController.text
    });

    setState(() {
      _isLoading = false;
    });

    if (response.isSuccess) {
      appShowSnackBar(
          msg: 'Reset password success',
          context: context,
          type: AppSnackBarType.success);
      // Chuyển về form đăng nhập
      setState(() {
        _currentForm = AuthFormType.login;
        _showOtpField = false;
      });
    } else {
      _showError(response.msg ?? 'Reset password failed');
    }
  }

  _showError(String message) {
    print("_showError: $message");
    appShowSnackBar(
      msg: message,
      context: context,
      type: AppSnackBarType.error,
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        WidgetAnimationStaggeredItem(
          index: 1,
          type: AnimationStaggeredType.bottomToTop,
          child: WidgetTextFieldPhone(
            initialValue: _phoneNumber?.phoneNumber,
            initialCountryCode: _phoneNumber?.isoCode ?? 'HU',
            focusNode: _phoneFocusNode,
            onPhoneNumberChanged: (phoneNumber) {
              setState(() {
                _phoneNumber = phoneNumber;
              });
            },
            onInputValidated: (isValid) {
              setState(() {
                _isValidPhoneNumber = isValid;
                if (isValid) {
                  _passwordFocusNode.requestFocus();
                }
              });
            },
            hint: "Input your phone".tr(),
            label: "Phone number".tr(),
          ),
        ),
        Gap(20.sw),
        WidgetAnimationStaggeredItem(
          index: 2,
          type: AnimationStaggeredType.bottomToTop,
          child: WidgetTextField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            hint: "Input your password".tr(),
            label: "Password".tr(),
            isPassword: true,
            onChanged: (value) {
              setState(() {});
            },
            onSubmitted: (_) {
              if (_isValidPhoneNumber && _passwordController.text.length > 4) {
                _login();
              }
            },
            actionWidget: GestureDetector(
              onTap: () {
                setState(() {
                  _currentForm = AuthFormType.forgotPassword;
                  _showOtpField = false;
                  _isLoading = false;
                  _showEnterPasswordField = false;
                });
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                child: Text(
                  "Forgot password?".tr(),
                  style: w300TextStyle(
                    fontSize: 14.sw,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline,
                    decorationColor: appColorText.withOpacity(0.35),
                  ),
                ),
              ),
            ),
          ),
        ),
        Gap(24),
        WidgetAnimationStaggeredItem(
          index: 3,
          type: AnimationStaggeredType.bottomToTop,
          child: WidgetAppButtonOK(
            loading: _isLoading,
            enable: _isValidPhoneNumber && _passwordController.text.length > 4,
            label: 'Sign in',
            onTap: _login,
          ),
        ),
        Gap(8.sw),
        TextButton(
          onPressed: _toggleFormType,
          child: Text(
            'Don\'t have an account? Sign up'.tr(),
            style: w300TextStyle(
              fontSize: 14.sw,
              decoration: TextDecoration.underline,
              decorationColor: appColorText.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      children: [
        WidgetAnimationStaggeredItem(
          index: 1,
          type: AnimationStaggeredType.bottomToTop,
          child: WidgetTextFieldPhone(
            initialValue: _phoneNumber?.phoneNumber,
            initialCountryCode: _phoneNumber?.isoCode ?? 'HU',
            focusNode: _phoneFocusNode,
            onPhoneNumberChanged: (phoneNumber) {
              setState(() {
                _showOtpField = false;
                _showEnterPasswordField = false;
                _phoneNumber = phoneNumber;
              });
            },
            onInputValidated: (isValid) {
              setState(() {
                _isValidPhoneNumber = isValid;
                if (isValid && _showEnterPasswordField) {
                  _passwordFocusNode.requestFocus();
                }
              });
            },
            hint: "Input your phone".tr(),
            label: "Phone number".tr(),
          ),
        ),
        if (_showOtpField) ...[
          Gap(20),
          WidgetAnimationStaggeredItem(
            index: 2,
            type: AnimationStaggeredType.bottomToTop,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Code'.tr(),
                  style: w500TextStyle(fontSize: 14.sw),
                ),
                Gap(2),
                Text(
                  'We sent a verification code to your phone number'.tr(),
                  style: w300TextStyle(fontSize: 12.sw),
                ),
                Gap(12),
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  textStyle: w600TextStyle(fontSize: 24.sw),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 46,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    activeColor: appColorPrimary,
                    inactiveColor: appColorText.withOpacity(0.25),
                    selectedColor: appColorPrimary,
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  enableActiveFill: true,
                  onCompleted: (v) {
                    _otpController.text = v;
                    setState(() {});
                  },
                  onChanged: (value) {
                    _otpController.text = value;
                    setState(() {});
                  },
                  beforeTextPaste: (text) {
                    // Kiểm tra nếu text chỉ chứa các số
                    return text?.contains(RegExp(r'^[0-9]+$')) ?? false;
                  },
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ] else if (_showEnterPasswordField) ...[
          Gap(20),
          WidgetAnimationStaggeredItem(
            index: 2,
            type: AnimationStaggeredType.bottomToTop,
            child: WidgetTextField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              hint: "Input new password".tr(),
              label: "New Password".tr(),
              isPassword: true,
              onSubmitted: (_) {
                _confirmPasswordFocusNode.requestFocus();
              },
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Gap(20),
          WidgetAnimationStaggeredItem(
            index: 3,
            type: AnimationStaggeredType.bottomToTop,
            child: WidgetTextField(
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocusNode,
              hint: "Re-input new password".tr(),
              label: "Confirm password".tr(),
              isPassword: true,
              onSubmitted: (_) {
                if (_passwordController.text.length > 4 &&
                    _confirmPasswordController.text ==
                        _passwordController.text) {
                  _register();
                }
              },
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
        ],
        Gap(24),
        WidgetAnimationStaggeredItem(
          index: 4,
          type: AnimationStaggeredType.bottomToTop,
          child: Column(
            children: [
              WidgetAppButtonOK(
                loading: _isLoading,
                enable: _showOtpField
                    ? _otpController.text.length == 6
                    : _showEnterPasswordField
                        ? _passwordController.text.length > 4 &&
                            _confirmPasswordController.text ==
                                _passwordController.text
                        : _isValidPhoneNumber,
                label: _showOtpField
                    ? 'Verify OTP'
                    : _showEnterPasswordField
                        ? 'Register'
                        : 'Send OTP',
                onTap: _showOtpField
                    ? _verifyOtp
                    : _showEnterPasswordField
                        ? _register
                        : _verifyPhoneNumber,
              ),
              Gap(8.sw),
              TextButton(
                onPressed: _toggleFormType,
                child: Text(
                  'Already have an account? Sign in'.tr(),
                  style: w300TextStyle(
                    fontSize: 14.sw,
                    decoration: TextDecoration.underline,
                    decorationColor: appColorText.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordForm() {
    return Column(
      children: [
        WidgetAnimationStaggeredItem(
          index: 1,
          type: AnimationStaggeredType.bottomToTop,
          child: WidgetTextFieldPhone(
            initialValue: _phoneNumber?.phoneNumber,
            initialCountryCode: _phoneNumber?.isoCode ?? 'HU',
            focusNode: _phoneFocusNode,
            onPhoneNumberChanged: (phoneNumber) {
              setState(() {
                _showOtpField = false;
                _showEnterPasswordField = false;
                _phoneNumber = phoneNumber;
              });
            },
            onInputValidated: (isValid) {
              setState(() {
                _isValidPhoneNumber = isValid;
                if (isValid && _showEnterPasswordField) {
                  _passwordFocusNode.requestFocus();
                }
              });
            },
            hint: "Input your phone".tr(),
            label: "Phone number".tr(),
          ),
        ),
        if (_showOtpField) ...[
          Gap(20),
          WidgetAnimationStaggeredItem(
            index: 2,
            type: AnimationStaggeredType.bottomToTop,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Code'.tr(),
                  style: w500TextStyle(fontSize: 14.sw),
                ),
                Gap(2),
                Text(
                  'We sent a verification code to your phone number'.tr(),
                  style: w300TextStyle(fontSize: 12.sw),
                ),
                Gap(12),
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  textStyle: w600TextStyle(fontSize: 24.sw),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 46,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    activeColor: appColorPrimary,
                    inactiveColor: appColorText.withOpacity(0.25),
                    selectedColor: appColorPrimary,
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  enableActiveFill: true,
                  onCompleted: (v) {
                    _otpController.text = v;
                    setState(() {});
                  },
                  onChanged: (value) {
                    _otpController.text = value;
                    setState(() {});
                  },
                  beforeTextPaste: (text) {
                    return text?.contains(RegExp(r'^[0-9]+$')) ?? false;
                  },
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ] else if (_showEnterPasswordField) ...[
          Gap(20),
          WidgetAnimationStaggeredItem(
            index: 2,
            type: AnimationStaggeredType.bottomToTop,
            child: WidgetTextField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              hint: "Input new password".tr(),
              label: "New Password".tr(),
              isPassword: true,
              onSubmitted: (_) {
                _confirmPasswordFocusNode.requestFocus();
              },
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Gap(20),
          WidgetAnimationStaggeredItem(
            index: 3,
            type: AnimationStaggeredType.bottomToTop,
            child: WidgetTextField(
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocusNode,
              hint: "Re-input new password".tr(),
              label: "Confirm password".tr(),
              isPassword: true,
              onSubmitted: (_) {
                if (_passwordController.text.length > 4 &&
                    _confirmPasswordController.text ==
                        _passwordController.text) {
                  _resetPassword();
                }
              },
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
        ],
        Gap(24),
        WidgetAnimationStaggeredItem(
          index: 4,
          type: AnimationStaggeredType.bottomToTop,
          child: Column(
            children: [
              WidgetAppButtonOK(
                loading: _isLoading,
                enable: _showOtpField
                    ? _otpController.text.length == 6
                    : _showEnterPasswordField
                        ? _passwordController.text.length > 4 &&
                            _confirmPasswordController.text ==
                                _passwordController.text
                        : _isValidPhoneNumber,
                label: _showOtpField
                    ? 'Verify OTP'
                    : _showEnterPasswordField
                        ? 'Reset Password'
                        : 'Send OTP',
                onTap: _showOtpField
                    ? _verifyOtp
                    : _showEnterPasswordField
                        ? _resetPassword
                        : _verifyPhoneNumber,
              ),
              Gap(8.sw),
              TextButton(
                onPressed: () {
                  setState(() {
                    _currentForm = AuthFormType.login;
                    _showOtpField = false;
                  });
                },
                child: Text(
                  'Back to Sign in'.tr(),
                  style: w300TextStyle(
                    fontSize: 14.sw,
                    decoration: TextDecoration.underline,
                    decorationColor: appColorText.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.sw),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                WidgetAnimationStaggeredItem(
                  index: 2,
                  type: AnimationStaggeredType.topToBottom,
                  child: Column(
                    children: [
                      GestureDetector(
                        onDoubleTap: () {
                          _login(phone: '+84969696969', password: '123456');
                        },
                        child: Hero(
                          tag: 'app_logo',
                          child: WidgetAppSVG(
                            assetsvg('ic_logo_white'),
                            width: 160.sw,
                            color: appColorPrimaryDark,
                          ),
                        ),
                      ),
                      Text(
                        _currentForm == AuthFormType.login
                            ? 'Welcome back'.tr()
                            : _currentForm == AuthFormType.register
                                ? 'Create an account'.tr()
                                : 'Forgot Password'.tr(),
                        style: w400TextStyle(fontSize: 24.sw),
                      ),
                    ],
                  ),
                ),
                Gap(40.sw),
                Builder(
                  key: ValueKey(_currentForm),
                  builder: (_) {
                    return _currentForm == AuthFormType.login
                        ? _buildLoginForm()
                        : _currentForm == AuthFormType.register
                            ? _buildRegisterForm()
                            : _buildForgotPasswordForm();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
