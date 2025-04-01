import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool pushNotifications = false;
  bool termsAndConditions = false;
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const StatusBar(),
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProfileSection(),
                          const SizedBox(height: 18),
                          _buildOtherSection(),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFCEC6C5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios, size: 24),
          ),
          const SizedBox(width: 12),
          Text(
            'Settings',
            style: GoogleFonts.fredoka(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF120F0F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile',
          style: TextStyle(
            color: const Color(0xFF878787),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.14,
          ),
        ),
        const SizedBox(height: 7),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFF1EFE9)),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            children: [
              _buildToggleOption(
                'Push Notification',
                pushNotifications,
                (value) => setState(() => pushNotifications = value),
              ),
              _buildToggleOption(
                'Terms and Conditions',
                termsAndConditions,
                (value) => setState(() => termsAndConditions = value),
              ),
              const SizedBox(height: 16),
              _buildLanguageSelector(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleOption(
      String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF101010),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF74CA45),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Language',
              style: TextStyle(
                color: Color(0xFF101010),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              selectedLanguage,
              style: const TextStyle(
                color: Color(0xFF101010),
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F8F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              LanguageOption(
                language: 'Hungarian',
                isSelected: selectedLanguage == 'Hungarian',
                onSelect: () => setState(() => selectedLanguage = 'Hungarian'),
              ),
              const SizedBox(height: 8),
              LanguageOption(
                language: 'English',
                isSelected: selectedLanguage == 'English',
                onSelect: () => setState(() => selectedLanguage = 'English'),
              ),
              const SizedBox(height: 8),
              LanguageOption(
                language: 'Spanish',
                isSelected: selectedLanguage == 'Spanish',
                onSelect: () => setState(() => selectedLanguage = 'Spanish'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOtherSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Other',
          style: TextStyle(
            color: const Color(0xFF878787),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.14,
          ),
        ),
        const SizedBox(height: 7),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFF1EFE9)),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            children: [
              _buildNavigationItem('About Ticketis'),
              _buildNavigationItem('Terms and Conditions'),
              _buildNavigationItem('Privacy Policy'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF101010),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 20,
            color: const Color(0xFF847D79),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Positioned(
      bottom: 34,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF74CA45),
          borderRadius: BorderRadius.circular(120),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(17, 10),
              blurRadius: 30,
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Save',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}

// StatusBar Component
class StatusBar extends StatelessWidget {
  const StatusBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '9:41',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          Row(
            children: [
              _buildSignalStrength(),
              const SizedBox(width: 8),
              _buildWifiIcon(),
              const SizedBox(width: 8),
              _buildBatteryIcon(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignalStrength() {
    return Row(
      children: List.generate(
        4,
        (index) => Container(
          width: 3,
          height: (index + 1) * 3,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildWifiIcon() {
    return const Icon(Icons.wifi, size: 20);
  }

  Widget _buildBatteryIcon() {
    return Row(
      children: [
        Container(
          width: 25,
          height: 12,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        Container(
          width: 2,
          height: 4,
          color: Colors.black,
          margin: const EdgeInsets.only(left: 1),
        ),
      ],
    );
  }
}

// LanguageOption Component
class LanguageOption extends StatelessWidget {
  final String language;
  final bool isSelected;
  final VoidCallback onSelect;

  const LanguageOption({
    Key? key,
    required this.language,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFDEDEDE)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE3E3E3)),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              language,
              style: const TextStyle(
                color: Color(0xFF333333),
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF74CA45)
                      : const Color(0xFFBDBDBD),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF74CA45),
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
