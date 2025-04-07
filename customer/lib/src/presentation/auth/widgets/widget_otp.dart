import 'dart:async';
import 'package:app/src/base/bloc.dart';
import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widget_loading_wrapper.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:network_resources/auth/repo.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneVerificationScreen extends StatefulWidget {
  final PhoneNumber phoneNumber;
  const PhoneVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState
    extends BaseLoadingState<PhoneVerificationScreen> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();

  DateTime? _dateTimeSendOTP;

  @override
  void initState() {
    super.initState();
    _sendOTP();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  String? verificationId;
  Future<void> _sendOTP() async {
    _pinController.clear();
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber.phoneNumber!,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          setLoading(false);
          appShowSnackBar(msg: e.toString());
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId = verificationId;
          _dateTimeSendOTP = DateTime.now().add(const Duration(seconds: 60));
          setState(() {});
          _pinFocusNode.requestFocus();
          appShowSnackBar(
              msg: "Sent OTP code to ${widget.phoneNumber.phoneNumber}",
              type: AppSnackBarType.notitfication);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      setLoading(false);
    } catch (e) {
      setLoading(false);
      appShowSnackBar(msg: e.toString(), type: AppSnackBarType.error);
    }
  }

  Future<void> _verifyOTP() async {
    if (_pinController.text.length != 6) {
      appShowSnackBar(
          msg: 'Please enter a valid 6-digit code'.tr(),
          type: AppSnackBarType.error);
      return;
    }

    try {
      setLoading(true);
      var userCredential = await FirebaseAuth.instance.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: verificationId!,
          smsCode: _pinController.text,
        ),
      );
      final response = await AuthRepo().loginPhoneOtp({
        'id_token': await userCredential.user!.getIdToken(),
        'phone': widget.phoneNumber.phoneNumber,
        'type': 1,
      });

      setLoading(false);

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
        setLoading(false);
        // Xử lý lỗi
        appShowSnackBar(
            msg: response.msg ?? 'Register failed, please try again!',
            type: AppSnackBarType.error);
      }
    } catch (e) {
      setLoading(false);
      appShowSnackBar(msg: e.toString(), type: AppSnackBarType.error);
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12 + MediaQuery.of(context).padding.top),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            appHaptic();
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                WidgetAppSVG('icon40', width: 24, height: 24),
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Verify phone number'.tr(),
                      style: w600TextStyle(
                        fontSize: 32,
                        color: Colors.black,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: w400TextStyle(
                          fontSize: 16,
                          height: 1.375,
                          color: Color(0xFF54535A),
                        ),
                        children: [
                          TextSpan(text: 'We send a text with a code to '.tr()),
                          TextSpan(
                            text: widget.phoneNumber.phoneNumber,
                            style: w500TextStyle(),
                          ),
                          TextSpan(text: '.\n'),
                          TextSpan(
                            text:
                                'Please check your message and enter the code below.'
                                    .tr(),
                            style: w400TextStyle(
                              color: Color(0xFF3C3836),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 27),
                    PinCodeTextField(
                      focusNode: _pinFocusNode,
                      appContext: context,
                      length: 6,
                      controller: _pinController,
                      keyboardType: TextInputType.number,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        activeColor: appColorPrimary.withOpacity(0.65),
                        inactiveColor: appColorElement,
                        selectedColor: appColorPrimary,
                        borderRadius: BorderRadius.circular(12),
                        fieldHeight: 52.sw,
                        fieldWidth: 52.sw,
                        activeFillColor: const Color(0xFFF1EFE9),
                        inactiveFillColor: const Color(0xFFF1EFE9),
                        selectedFillColor: const Color(0xFFF1EFE9),
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: null,
                      onCompleted: (v) {
                        _verifyOTP();
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                      beforeTextPaste: (text) {
                        return true;
                      },
                      textStyle: w600TextStyle(
                        fontSize: 22,
                        color: Color(0xFF686868),
                      ),
                      showCursor: false,
                      cursorColor: Colors.transparent,
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: WidgetTimer(builder: () {
                        int seconds = (_dateTimeSendOTP
                                ?.difference(DateTime.now())
                                .inSeconds ??
                            0);
                        return TextButton(
                          onPressed: seconds < 0
                              ? () {
                                  setLoading(true);
                                  _sendOTP();
                                }
                              : null,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: 12.sw,
                              horizontal: 40.sw,
                            ),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(120),
                              side: BorderSide(
                                color: seconds > 0
                                    ? Color(0xFFCEC6C5)
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: w400TextStyle(
                                    fontSize: 18,
                                    color: seconds < 0
                                        ? appColorText
                                        : Colors.grey,
                                  ),
                                  text: _dateTimeSendOTP == null
                                      ? "We sending a code".tr()
                                      : seconds > 0
                                          ? "You can resend a code in ".tr()
                                          : "Resend a code".tr(),
                                  children: seconds > 0
                                      ? [
                                          TextSpan(
                                            text: "${seconds}s",
                                            style:
                                                w600TextStyle(fontSize: 18.sw),
                                          ),
                                        ]
                                      : null,
                                ),
                              ),
                              if (_dateTimeSendOTP == null)
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.grey[100],
                                      color: appColorPrimaryOrange,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // ValueListenableBuilder(
          //     valueListenable: _pinController,
          //     builder: (context, value, child) {
          //       if (value.text.length != 6) return SizedBox();
          //       return Container(
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           boxShadow: [
          //             BoxShadow(
          //               color: Colors.grey.withOpacity(0.5),
          //               spreadRadius: 2,
          //               blurRadius: 5,
          //             ),
          //           ],
          //         ),
          //         padding: EdgeInsets.fromLTRB(
          //             20, 12, 20, 4 + MediaQuery.of(context).padding.bottom),
          //         child: WidgetButtonConfirm(
          //           onPressed: _isLoading ? null : _verifyOTP,
          //           text: 'Verify'.tr(),
          //           isLoading: _isLoading,
          //         ),
          //       );
          //     }),
        ],
      ),
    );
  }
}

class CountdownTimer extends StatefulWidget {
  final Duration duration;
  final VoidCallback? onFinished;

  const CountdownTimer({
    Key? key,
    required this.duration,
    this.onFinished,
  }) : super(key: key);

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.duration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
        } else {
          _timer.cancel();
          widget.onFinished?.call();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'https://cdn.builder.io/api/v1/image/assets/TEMP/29975271409cc4155be6a8c27f96d684cbfe9f69?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
          width: 20,
          height: 20,
        ),
        const SizedBox(width: 4),
        Text(
          '${_remainingTime.inSeconds}s',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF7A838C),
            letterSpacing: 0.28,
          ),
        ),
      ],
    );
  }
}

// Theme constants
class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFFF9F8F6),
      fontFamily: 'Fredoka',
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w500,
          height: 1.4,
          color: Colors.black,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.375,
          letterSpacing: 0.16,
          color: Color(0xFF54535A),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Color(0xFF7A838C),
          letterSpacing: 0.28,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF3C3836),
        surface: Color(0xFFF1EFE9),
        onSurface: Color(0xFF686868),
      ),
    );
  }
}
