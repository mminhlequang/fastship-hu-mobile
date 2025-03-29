import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildStatusBar(),
              _buildImageGrid(),
              _buildHeaderText(),
              _buildCountryPhoneSection(),
              _buildSocialLoginSection(),
              _buildTermsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '9:41',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
              color: Colors.black,
              fontFamily: GoogleFonts.fredoka().fontFamily,
            ),
          ),
          Row(
            children: [
              // Signal Icon
              _buildSignalIcon(),
              const SizedBox(width: 10),
              // Battery Icon
              _buildBatteryIcon(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              _buildGridImage(
                  'https://cdn.builder.io/api/v1/image/assets/TEMP/39684c089be5dac8dcfa95f471919edf34a91039',
                  172),
              _buildGridImage(
                  'https://cdn.builder.io/api/v1/image/assets/TEMP/211b69a6d6f4767f60dbb6c04b27cd0235a595d1',
                  182),
              _buildGridImage(
                  'https://cdn.builder.io/api/v1/image/assets/TEMP/01cfdf06543ef096b77989231a0dd4b45c84b0ea',
                  172),
              _buildGridImage(
                  'https://cdn.builder.io/api/v1/image/assets/TEMP/b512552d279b049f054655c77ef53206f743a51c',
                  172),
              _buildGridImage(
                  'https://cdn.builder.io/api/v1/image/assets/TEMP/5a9f99af11b847e195fd62d2838e93c53c08c157',
                  182),
              _buildGridImage(
                  'https://cdn.builder.io/api/v1/image/assets/TEMP/502af263e8143bab221efc4c4b69db2ae9afbdb2',
                  172),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 89,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 139,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridImage(String url, double height) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Image.network(
          url,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          Text(
            'Your Favorite Food Delivery Partner',
            style: TextStyle(
              fontSize: 33,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0E0D0A),
              height: 1.2,
              fontFamily: GoogleFonts.fredoka().fontFamily,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'We are the fastest and most popular delivery service across the city.',
            style: TextStyle(
              fontSize: 18,
              color: const Color(0xFF847D79),
              height: 1.4,
              fontFamily: GoogleFonts.fredoka().fontFamily,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCountryPhoneSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Country',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFFB6AFAE),
                    letterSpacing: 0.14,
                    fontFamily: GoogleFonts.fredoka().fontFamily,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hungary',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xFFF17228),
                          fontFamily: GoogleFonts.fredoka().fontFamily,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: const Color(0xFFF17228),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Number phone',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFFB6AFAE),
                    letterSpacing: 0.14,
                    fontFamily: GoogleFonts.fredoka().fontFamily,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFF1EFE9)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '+ 43',
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color(0xFF120F0F),
                      letterSpacing: 0.16,
                      fontFamily: GoogleFonts.fredoka().fontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLoginSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Divider(color: const Color(0xFFF8F1F0))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Or',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFFB6AFAE),
                    fontFamily: GoogleFonts.fredoka().fontFamily,
                  ),
                ),
              ),
              Expanded(child: Divider(color: const Color(0xFFF8F1F0))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSocialButton(
                  'Google',
                  Icons.g_mobiledata,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSocialButton(
                  'Apple',
                  Icons.apple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Continue as a guest',
            style: TextStyle(
              fontSize: 18,
              color: const Color(0xFF538D33),
              decoration: TextDecoration.underline,
              decorationColor: const Color(0xFF538D33),
              fontFamily: GoogleFonts.fredoka().fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFF1EFE9)),
        borderRadius: BorderRadius.circular(62),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: const Color(0xFF303030),
              fontFamily: GoogleFonts.fredoka().fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFFF17228),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: GoogleFonts.fredoka().fontFamily,
                ),
                children: const [
                  TextSpan(
                    text: 'You must accept the ',
                    style: TextStyle(color: Color(0xFF847D79)),
                  ),
                  TextSpan(
                    text: 'terms and conditions',
                    style: TextStyle(color: Color(0xFFF17228)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignalIcon() {
    return Row(
      children: List.generate(
        4,
        (index) => Container(
          margin: const EdgeInsets.only(right: 2),
          width: 3,
          height: (index + 1) * 3.0,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildBatteryIcon() {
    return Container(
      width: 25,
      height: 12,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(2),
            width: 18,
            color: Colors.black,
          ),
          Container(
            width: 2,
            height: 8,
            margin: const EdgeInsets.only(left: 1),
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
