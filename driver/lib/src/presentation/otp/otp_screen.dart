import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpArgs {
  final String verificationId;
  final String phoneNumber;

  const OtpArgs({required this.verificationId, required this.phoneNumber});
}

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.args});

  final OtpArgs args;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isResendButtonEnabled = false;
  Timer? _timer;
  int _secondsRemaining = 60;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _isResendButtonEnabled = true;
          timer.cancel();
        }
      });
    });
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    final credential = PhoneAuthProvider.credential(
      verificationId: widget.args.verificationId,
      smsCode: otp,
    );

    try {
      await _auth.signInWithCredential(credential);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng nhập thành công!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mã OTP không chính xác.')),
      );
    }
  }

  void _resendOtp() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.args.phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể gửi lại mã OTP.')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _secondsRemaining = 60;
          _isResendButtonEnabled = false;
        });
        _startResendTimer();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nhập mã OTP')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PinCodeTextField(
              appContext: context,
              length: 6,
              controller: _otpController,
              keyboardType: TextInputType.number,
              onChanged: (value) {},
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _verifyOtp,
                child: Text('Xác nhận'),
              ),
            ),
            TextButton(
              onPressed: _isResendButtonEnabled ? _resendOtp : null,
              child: Text(_isResendButtonEnabled
                  ? 'Gửi lại'
                  : 'Gửi lại sau $_secondsRemaining giây'),
            ),
          ],
        ),
      ),
    );
  }
}
