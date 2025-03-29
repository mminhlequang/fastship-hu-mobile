import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class InputDesignStyles {
  static const TextStyle titleStyle = TextStyle(
    fontFamily: 'Fredoka',
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Colors.black,
    height: 1.4,
  );

  static const TextStyle descriptionStyle = TextStyle(
    fontFamily: 'Fredoka',
    fontSize: 16,
    color: Color(0xFF7A838C),
    height: 22 / 16, // Converting line-height to Flutter's height
    letterSpacing: 0.16,
  );

  static const TextStyle buttonStyle = TextStyle(
    fontFamily: 'Fredoka',
    fontSize: 18,
    letterSpacing: 0.36,
    height: 1.2,
  );

  static const double maxWidth = 393;
  static const double horizontalPadding = 16;
  static const double verticalPadding = 16;
  static const double bottomPadding = 34;
  static const double spacing = 12;
  static const double buttonSpacing = 16;
  static const double borderRadius = 16;
  static const double buttonBorderRadius = 26;
  static const double mapBorderRadius = 12;
}
class InputDesign extends StatelessWidget {
  const InputDesign({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 393),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 34),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(
                  'https://cdn.builder.io/api/v1/image/assets/TEMP/67495db62892fedf434c42c317f6b432968a2845?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                  width: 64,
                  height: 64 / 9.01, // Maintaining aspect ratio
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Use current location',
                              style: InputDesignStyles.titleStyle,
                            ),
                          ),
                          Image.network(
                            'https://cdn.builder.io/api/v1/image/assets/TEMP/296893192c4c2277569642de9a891171c4deeba2?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Confirming your location helps us determine availability and delivery fees',
                        style: InputDesignStyles.descriptionStyle,
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          'https://cdn.builder.io/api/v1/image/assets/TEMP/1bae94b2ec8d9a286b18e0aa934b5a340099c1e9?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                          width: 361,
                          height: 361 / 1.97, // Maintaining aspect ratio
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildButton(
                            text: 'Cancel',
                            isOutlined: true,
                            onPressed: () {
                              // Handle cancel action
                            },
                          ),
                          const SizedBox(width: 16),
                          _buildButton(
                            text: 'Submit',
                            isOutlined: false,
                            onPressed: () {
                              // Handle submit action
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required bool isOutlined,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 172,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 57,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
            side: isOutlined
                ? const BorderSide(color: Color(0xFFDEDEDE))
                : BorderSide.none,
          ),
          backgroundColor: isOutlined ? Colors.white : const Color(0xFF74CA45),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: isOutlined ? Colors.black : Colors.white,
            letterSpacing: 0.36,
            fontFeatures: isOutlined
                ? [
                    const FontFeature.disable('liga'),
                    const FontFeature.disable('clig'),
                  ]
                : null,
          ),
        ),
      ),
    );
  }
}
