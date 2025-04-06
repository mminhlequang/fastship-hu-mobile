import 'package:app/src/presentation/widgets/widget_appbar.dart';
import 'package:app/src/presentation/widgets/widget_button.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';
import 'package:app/src/constants/constants.dart';

class PersonalDataScreen extends StatelessWidget {
  const PersonalDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          WidgetAppBar(
            title: 'Personal Data'.tr(),
            showBackButton: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileSection(),
                  _buildFormFields(),
                  const SizedBox(height: 80), // Space for bottom button
                ],
              ),
            ),
          ),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildOrangeBackground() {
    return Container(
      height: 139,
      decoration: BoxDecoration(
        color: appColorPrimaryOrange,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        _buildOrangeBackground(),
        Padding(
          padding: const EdgeInsets.only(top: 45),
          child: Column(
            children: [
              WidgetAvatar(
                imageUrl: AppPrefs.instance.user?.avatar ?? '',
                radius1: 149 / 2,
                radius2: 149 / 2 - 2,
                radius3: 149 / 2 - 2,
                borderColor: Colors.white,
              ),
            ],
          ),
        ),
        Positioned(
          right: 16,
          top: 91,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFF4F4F4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.camera_alt,
              color: appColorText2,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildFormField('Full Name', 'Frances Swann'),
          const SizedBox(height: 12),
          _buildFormField('Date of birth', '19/06/1999'),
          const SizedBox(height: 12),
          _buildFormField(
            'Gender',
            'Male',
            suffix: Icon(
              Icons.keyboard_arrow_down,
              color: appColorText,
            ),
          ),
          const SizedBox(height: 12),
          _buildFormField('Phone', '+1 325-433-7656'),
          const SizedBox(height: 12),
          _buildFormField('Email', 'albertstevano@gmail.com'),
        ],
      ),
    );
  }

  Widget _buildFormField(String label, String value, {Widget? suffix}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: w400TextStyle(
            color: appColorText2,
            fontSize: 14,
            height: 1.43,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: appColorBorder),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: w400TextStyle(
                    color: appColorText,
                    fontSize: 16,
                  ),
                ),
              ),
              if (suffix != null) suffix,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 16, 16, 12 + appContext.mediaQuery.padding.bottom),
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
      alignment: Alignment.bottomCenter,
      child: WidgetButtonConfirm(
          onPressed: () {
            // Save action
          },
          text: 'Save'.tr()),
    );
  }
}
