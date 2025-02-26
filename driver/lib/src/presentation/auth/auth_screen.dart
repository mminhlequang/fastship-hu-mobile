import 'package:app/src/presentation/auth/otp_screen.dart';
import 'package:app/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
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
        });
        appContext.pushNamed(
          'otp',
          extra: OtpArgs(
            verificationId: verificationId,
            phoneNumber: phoneNumber,
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('Timeout: Mã OTP hết hạn.');
      },
    );
  }

  _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FlutterLogo(size: 100),
              const Gap(40),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              Gap(20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _verifyPhoneNumber,
                  child: _isLoading
                      ? CupertinoActivityIndicator()
                      : Text('Sign In'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
