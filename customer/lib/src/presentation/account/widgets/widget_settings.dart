import 'package:app/src/presentation/widgets/widget_appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';
import 'package:app/src/constants/constants.dart';

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
                WidgetAppBar(
                  title: 'Settings'.tr(),
                ),
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
            color: appColorBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios, size: 24, color: appColorText),
          ),
          const SizedBox(width: 12),
          Text(
            'Settings',
            style: w500TextStyle(
              fontSize: 22,
              color: appColorText,
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
          style: w400TextStyle(
            color: appColorText2,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 7),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: appColorBorder),
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
            style: w400TextStyle(
              color: appColorText,
              fontSize: 16,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: appColorPrimary,
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
            Text(
              'Language',
              style: w400TextStyle(
                color: appColorText,
                fontSize: 16,
              ),
            ),
            Text(
              selectedLanguage,
              style: w400TextStyle(
                color: appColorText,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: appColorBackground,
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
          style: w400TextStyle(
            color: appColorText2,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 7),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: appColorBorder),
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
            style: w400TextStyle(
              color: appColorText,
              fontSize: 16,
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: appColorText,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: TextButton(
          onPressed: () {
            // Handle save action
          },
          style: TextButton.styleFrom(
            backgroundColor: appColorPrimary,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(120),
            ),
          ),
          child: Text(
            'Save',
            style: w500TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}

 

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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? appColorPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              language,
              style: w400TextStyle(
                color: isSelected ? Colors.white : appColorText,
                fontSize: 16,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check,
                color: Colors.white,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}
