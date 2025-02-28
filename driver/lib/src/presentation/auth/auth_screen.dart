import 'package:app/src/presentation/auth/otp_screen.dart';
import 'package:app/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pin_code_fields/pin_code_fields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

enum AuthFormType { login, register }

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();
  final _otpTextEditingController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _showOtpField = false;
  String? _verificationId;
  AuthFormType _currentForm = AuthFormType.login;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    _otpTextEditingController.dispose();
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

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final phoneNumber = _phoneController.text.trim();
    final password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('https://zennail23.com/api/v1/login'),
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
          'X-CSRF-TOKEN': '',
        },
        body: jsonEncode({
          'phone': phoneNumber,
          'password': password,
          'type': 1,
        }),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        // Xử lý đăng nhập thành công
        final data = jsonDecode(response.body);
        // TODO: Lưu token và thông tin người dùng

        // Chuyển hướng đến màn hình chính
        // appContext.go('/home');
        _showMessage('Đăng nhập thành công');
      } else {
        // Xử lý lỗi
        final data = jsonDecode(response.body);
        _showError(data['message'] ?? 'Đăng nhập thất bại');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Lỗi kết nối: $e');
    }
  }

  Future<void> _verifyPhoneNumber() async {
    setState(() {
      _isLoading = true;
    });
    final phoneNumber = _phoneController.text.trim();
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        print(
            'Phone number automatically verified and signed in: ${_auth.currentUser?.phoneNumber}');
        _proceedWithRegistration(_auth.currentUser!.uid);
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _isLoading = false;
        });
        if (e.code == 'invalid-phone-number') {
          _showError('Số điện thoại không hợp lệ.');
        } else if (e.code == 'missing-client-identifier') {
          _showError('Thiếu mã định danh của khách hàng.');
        } else if (e.code == 'too-many-requests') {
          _showError('Quá nhiều yêu cầu. Vui lòng thử lại sau.');
        } else {
          _showError('Xác thực thất bại: ${e.message}');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _isLoading = false;
          _showOtpField = true;
          _verificationId = verificationId;
        });
        _showMessage('Mã OTP đã được gửi đến số điện thoại của bạn');
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
        throw Exception('Mã xác thực không hợp lệ hoặc đã hết hạn');
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: _otpController.text.trim(),
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final idToken = await userCredential.user!.getIdToken();

      _proceedWithRegistration(idToken!);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Xác thực OTP thất bại: $e');
    }
  }

  Future<void> _proceedWithRegistration(String idToken) async {
    final phoneNumber = _phoneController.text.trim();
    print("_proceedWithRegistration: $phoneNumber");
    print("_proceedWithRegistration: $idToken");

    try {
      final response = await http.post(
        Uri.parse('https://zennail23.com/api/v1/register'),
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
          'X-CSRF-TOKEN': '',
        },
        body: jsonEncode({
          'id_token': idToken,
          'name': phoneNumber,
          'phone': phoneNumber,
          'password':
              '123456', // Mặc định hoặc có thể thêm trường nhập mật khẩu
          'type': 1,
        }),
      );

      print("_proceedWithRegistration: ${response.body}");

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        // Xử lý đăng ký thành công
        _showMessage('Đăng ký thành công');
        // Chuyển về form đăng nhập
        setState(() {
          _currentForm = AuthFormType.login;
          _showOtpField = false;
        });
      } else {
        // Xử lý lỗi
        final data = jsonDecode(response.body);
        _showError(data['message'] ?? 'Đăng ký thất bại');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Lỗi kết nối: $e');
    }
  }

  _showError(String message) {
    print("_showError: $message");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Số điện thoại',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
          ),
        ),
        Gap(16),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Mật khẩu',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock),
          ),
        ),
        Gap(20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _login,
            child:
                _isLoading ? CupertinoActivityIndicator() : Text('Đăng nhập'),
          ),
        ),
        Gap(16),
        TextButton(
          onPressed: _toggleFormType,
          child: Text('Chưa có tài khoản? Đăng ký ngay'),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      children: [
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Số điện thoại',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
          ),
        ),
        if (_showOtpField) ...[
          Gap(16),
          Column(
            children: [
              Text(
                'Nhập mã xác thực',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(8),
              PinCodeTextField(
                appContext: context,
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                  activeColor: Theme.of(context).primaryColor,
                  inactiveColor: Colors.grey.shade300,
                  selectedColor: Theme.of(context).primaryColor,
                ),
                animationDuration: Duration(milliseconds: 300),
                enableActiveFill: true,
                controller: _otpTextEditingController,
                onCompleted: (v) {
                  _otpController.text = v;
                },
                onChanged: (value) {
                  _otpController.text = value;
                },
                beforeTextPaste: (text) {
                  // Kiểm tra nếu text chỉ chứa các số
                  return text?.contains(RegExp(r'^[0-9]+$')) ?? false;
                },
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ],
        Gap(20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading
                ? null
                : (_showOtpField ? _verifyOtp : _verifyPhoneNumber),
            child: _isLoading
                ? CupertinoActivityIndicator()
                : Text(_showOtpField ? 'Xác nhận OTP' : 'Gửi mã OTP'),
          ),
        ),
        Gap(16),
        TextButton(
          onPressed: _toggleFormType,
          child: Text('Đã có tài khoản? Đăng nhập ngay'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FlutterLogo(size: 100),
              const Gap(40),
              Text(
                _currentForm == AuthFormType.login ? 'Đăng nhập' : 'Đăng ký',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Gap(24),
              _currentForm == AuthFormType.login
                  ? _buildLoginForm()
                  : _buildRegisterForm(),
            ],
          ),
        ),
      ),
    );
  }
}
