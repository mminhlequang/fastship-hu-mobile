import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

// Color Constants
class AppColors {
  static const Color primary = Color(0xFF538D33);
  static const Color background = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF3C3836);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color divider = Color(0xFFCEC6C5);
  static const Color tileBackground = Color(0xFFF9F8F6);
}

// Contact Option Tile Widget
class ContactOptionTile extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;

  const ContactOptionTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.tileBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset(
                icon,
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.fredoka(
                fontSize: 16,
                color: AppColors.text,
                letterSpacing: 0.16,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Main Help Center Screen
class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(86),
        child: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          flexibleSpace: Column(
            children: [
              const SizedBox(height: 44), // Status bar height
              SizedBox(
                height: 42,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: SvgPicture.asset(
                          'assets/icons/back_icon.svg',
                          width: 24,
                          height: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Help Center',
                        style: GoogleFonts.fredoka(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF120F0F),
                        ),
                      ),
                      const Spacer(),
                      SvgPicture.asset(
                        'assets/icons/more_circle.svg',
                        width: 28,
                        height: 28,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 1,
            color: AppColors.divider,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'FAQ',
                            style: GoogleFonts.fredoka(
                              fontSize: 18,
                              color: AppColors.textLight,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 2,
                            color: const Color(0xFFEEEEEE),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Contact us',
                            style: GoogleFonts.fredoka(
                              fontSize: 18,
                              color: AppColors.textLight,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 2,
                            color: const Color(0xFFEEEEEE),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Column(
                  children: [
                    ContactOptionTile(
                      icon: 'assets/icons/customer_service.svg',
                      title: 'Customer Service',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    ContactOptionTile(
                      icon: 'assets/icons/whatsapp.svg',
                      title: 'WhatsApp',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    ContactOptionTile(
                      icon: 'assets/icons/website.svg',
                      title: 'Website',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    ContactOptionTile(
                      icon: 'assets/icons/facebook.svg',
                      title: 'Facebook',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    ContactOptionTile(
                      icon: 'assets/icons/twitter.svg',
                      title: 'Twitter',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    ContactOptionTile(
                      icon: 'assets/icons/instagram.svg',
                      title: 'Instagram',
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
