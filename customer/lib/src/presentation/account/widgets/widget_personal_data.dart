import 'package:app/src/presentation/widgets/widget_app_dropdown.dart';
import 'package:app/src/presentation/widgets/widget_appbar.dart';
import 'package:app/src/presentation/widgets/widget_button.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';
import 'package:app/src/constants/constants.dart';
import 'package:network_resources/auth/repo.dart';

class PersonalDataScreen extends StatefulWidget {
  const PersonalDataScreen({super.key});

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  DateTime? _birthdayController;
  bool _isLoading = false;
  bool _isChanged = false;
  int? _selectedGender;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    final user = AppPrefs.instance.user;
    if (user != null) {
      _nameController.text = user.name ?? '';
      if (user.birthday != null) {
        _birthdayController =
            string2DateTime(user.birthday!, format: 'yyyy-MM-dd');
      }
      _emailController.text = user.email ?? '';
      _selectedGender = user.sex;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await AuthRepo().updateProfile({
        'name': _nameController.text,
        'birthday': _birthdayController?.formatDate(formatType: 'yyyy-MM-dd'),
        'sex': _selectedGender,
        'email': _emailController.text,
      });

      if (response.isSuccess) {
        AppPrefs.instance.user = response.data;
        WidgetsFlutterBinding.ensureInitialized().performReassemble();
        appShowSnackBar(
          msg: 'Profile updated successfully'.tr(),
          type: AppSnackBarType.success,
        );
        Navigator.pop(context);
      } else {
        appShowSnackBar(
          msg: response.msg ?? 'Failed to update profile'.tr(),
          type: AppSnackBarType.error,
        );
      }
    } catch (e) {
      appShowSnackBar(
        msg: 'An error occurred',
        type: AppSnackBarType.error,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColorBackground,
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
          if (_isChanged) _buildSaveButton(),
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
          _buildFormField(
            'Full Name'.tr(),
            _nameController,
            keyboardType: TextInputType.name,
            hintText: 'Enter your name'.tr(),
            onChanged: (value) {
              setState(() {
                _isChanged = true;
              });
            },
          ),
          const SizedBox(height: 12),
          SizedBox(
            key: Key(_birthdayController?.formatDate() ?? '_birthday'),
            child: _buildFormField(
              'Date of birth'.tr(),
              TextEditingController(
                  text: _birthdayController?.formatDate() ?? ''),
              hintText: 'DD/MM/YYYY',
              readOnly: true,
              onTap: () {
                appOpenDateTimePicker(
                  _birthdayController ??
                      DateTime(DateTime.now().year - 18, 1, 1),
                  (date) {
                    _birthdayController = date;
                    _isChanged = true;
                    setState(() {});
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          _buildGenderField(),
          const SizedBox(height: 12),
          _buildFormField(
            'Phone'.tr(),
            TextEditingController(text: AppPrefs.instance.user?.phone ?? ''),
            readOnly: true,
          ),
          const SizedBox(height: 12),
          _buildFormField(
            'Email'.tr(),
            _emailController,
            keyboardType: TextInputType.emailAddress,
            hintText: 'Enter your email'.tr(),
            onChanged: (value) {
              setState(() {
                _isChanged = true;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    String? hintText,
    bool readOnly = false,
    VoidCallback? onTap,
    Function(String)? onChanged,
  }) {
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
                child: TextField(
                  keyboardType: keyboardType,
                  controller: controller,
                  readOnly: readOnly,
                  onTap: onTap,
                  style: w400TextStyle(
                    color: appColorText,
                    fontSize: 16,
                  ),
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: w300TextStyle(
                      color: appColorText2,
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.keyboard_arrow_down,
                  color: appColorText,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender'.tr(),
          style: w400TextStyle(
            color: appColorText2,
            fontSize: 14,
            height: 1.43,
          ),
        ),
        const SizedBox(height: 8),
        AppDropdown(
          items: ['Male', 'Female'],
          indexSelected: _selectedGender == null ? null : _selectedGender! - 1,
          hintText: 'Select gender'.tr(),
          onChanged: (value) {
            _isChanged = true;
            _selectedGender = value + 1;
            setState(() {});
          },
          itemAsString: (item) => item,
          isAutoHeight: true,
          child: Container(
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
                    _selectedGender == 1
                        ? 'Male'.tr()
                        : _selectedGender == 2
                            ? 'Female'.tr()
                            : 'Select gender'.tr(),
                    style: w400TextStyle(
                      color: appColorText,
                      fontStyle: _selectedGender == null
                          ? FontStyle.italic
                          : FontStyle.normal,
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: appColorText,
                ),
              ],
            ),
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
        onPressed: _updateProfile,
        isLoading: _isLoading,
        text: 'Save'.tr(),
      ),
    );
  }
}
