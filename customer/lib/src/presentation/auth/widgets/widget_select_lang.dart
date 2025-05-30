import 'package:app/src/constants/constants.dart';
import 'package:flutter/material.dart';

class LanguageOptionWidget extends StatelessWidget {
  final String imagePath;
  final String languageName;

  const LanguageOptionWidget({
    Key? key,
    required this.imagePath,
    required this.languageName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFDEDEDE),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                imagePath,
                width: 30,
                height: 20,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              languageName,
              style: const TextStyle(
                color: Color(0xFF333333),
                fontSize: 16,
                fontFamily: 'Fredoka',
                letterSpacing: 0.16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 23, top: 11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, right: 92),
                      child: Image.network(
                        'https://cdn.builder.io/api/v1/image/assets/TEMP/48ff652631706326e11641fa8d8d0051aec05d1a?placeholderIfAbsent=true',
                        width: 163,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 45),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const Text(
                          'Select language',
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Fredoka',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: const [
                            LanguageOptionWidget(
                              imagePath:
                                  'https://cdn.builder.io/api/v1/image/assets/TEMP/88e1595250804c3dfa3ee91acf5eecdd8b075e0f?placeholderIfAbsent=true',
                              languageName: 'Hungarian',
                            ),
                            SizedBox(width: 8),
                            LanguageOptionWidget(
                              imagePath:
                                  'https://cdn.builder.io/api/v1/image/assets/TEMP/51556ff503467eb7e33c61a85b375477097d4c33?placeholderIfAbsent=true',
                              languageName: 'English',
                            ),
                            SizedBox(width: 8),
                            LanguageOptionWidget(
                              imagePath:
                                  'https://cdn.builder.io/api/v1/image/assets/TEMP/a82c49c93f7f7728c888561885f91be9f26d8a0a?placeholderIfAbsent=true',
                              languageName: 'Spanish',
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          '* You can change language later from menu bar',
                          style: TextStyle(
                            color: Color(0xFF54535A),
                            fontSize: 14,
                            fontFamily: 'Fredoka',
                            letterSpacing: 0.14,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 34),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    // Handle next button press
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: appColorPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Fredoka',
                      letterSpacing: 0.36,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
