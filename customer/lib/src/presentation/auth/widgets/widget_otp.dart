import 'dart:async';
import 'package:flutter/material.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({Key? key}) : super(key: key);

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 11),
              Text(
                '9:41',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 67),
              Text(
                'Verify phone number',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.375,
                    letterSpacing: 0.16,
                    color: Color(0xFF54535A),
                  ),
                  children: [
                    TextSpan(text: 'We send a text with a code to '),
                    TextSpan(
                      text: '+354 234567890',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF120F0F),
                      ),
                    ),
                    TextSpan(text: '.\n'),
                    TextSpan(
                      text:
                          'Please check your message and enter the code below.',
                      style: TextStyle(
                        color: Color(0xFF3C3836),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 27),
              PinInputField(
                controller: _pinController,
                onChanged: (value) {
                  // Handle PIN input
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CountdownTimer(
                    duration: const Duration(seconds: 15),
                    onFinished: () {
                      // Handle timer finished
                    },
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Code not received',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF7A838C),
                      letterSpacing: 0.28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 33),
              TextButton(
                onPressed: () {
                  // Handle didn't get code
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 19,
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(120),
                    side: BorderSide(
                      color: Color(0xFFCEC6C5),
                    ),
                  ),
                ),
                child: Text(
                  "I didn't get a code",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF3C3836),
                    fontWeight: FontWeight.w400,
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

class PinInputField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final int pinLength;

  const PinInputField({
    Key? key,
    required this.controller,
    this.onChanged,
    this.pinLength = 6,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        pinLength,
        (index) => Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFF1EFE9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              '*',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF686868),
                letterSpacing: 0.4,
              ),
            ),
          ),
        ),
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
 