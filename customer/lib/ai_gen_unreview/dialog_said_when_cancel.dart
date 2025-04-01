import 'package:flutter/material.dart';

// Color constants
class AppColors {
  static const Color primary = Color(0xFFF17228);
  static const Color secondary = Color(0xFF847D79);
  static const Color buttonGreen = Color(0xFF74CA45);
  static const Color white = Color(0xFFFFFFFF);
  static const Color shadow = Color(0x1A000000);
}

// Text styles
class AppTextStyles {
  static const TextStyle heading = TextStyle(
    color: AppColors.primary,
    fontSize: 24,
    fontFamily: 'Fredoka',
    fontWeight: FontWeight.w500,
    height: 1.21, // line-height: 29px / 24px
  );

  static const TextStyle body = TextStyle(
    color: AppColors.secondary,
    fontSize: 18,
    fontFamily: 'Fredoka',
    fontWeight: FontWeight.w400,
    height: 1.39, // line-height: 25px / 18px
    letterSpacing: 0.18,
  );

  static const TextStyle button = TextStyle(
    color: AppColors.white,
    fontSize: 18,
    fontFamily: 'Fredoka',
    fontWeight: FontWeight.w400,
    height: 1.11,
  );
}

class CancellationScreen extends StatelessWidget {
  const CancellationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 50,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(
                    'https://cdn.builder.io/api/v1/image/assets/TEMP/94835ba694656dd0bdbfdb35ef04ff9b1ebdf773?placeholderIfAbsent=true',
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'We\'re so sad about your cancellation',
                    style: AppTextStyles.heading,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'We will continue to improve our service & satisfy you on the next order.',
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        // Handle button press
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.buttonGreen,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(120),
                        ),
                      ),
                      child: const Text(
                        'Done',
                        style: AppTextStyles.button,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}