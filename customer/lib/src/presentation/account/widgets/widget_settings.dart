import 'package:app/src/presentation/widgets/widget_app_bottomsheet.dart';
import 'package:app/src/presentation/widgets/widget_appbar.dart';
import 'package:app/src/utils/app_easy_localization.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';
import 'package:app/src/constants/constants.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:language_code/language_code.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool pushNotifications = false;
  bool termsAndConditions = false;
  String get languageCode => AppPrefs.instance.languageCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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
                    _buildToggleOption(
                      'Push Notification',
                      pushNotifications,
                      (value) => setState(() => pushNotifications = value),
                    ),
                    // _buildToggleOption(
                    //   'Terms and Conditions',
                    //   termsAndConditions,
                    //   (value) => setState(() => termsAndConditions = value),
                    // ),
                    _buildLanguageSelector(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
          FlutterSwitch(
            width: 46.0,
            height: 24.0,
            value: value,
            onToggle: onChanged,
            activeColor: appColorPrimary,
            inactiveColor: Colors.grey[300]!,
            toggleSize: 22.0,
            padding: 2.0,
            activeToggleColor: Colors.white,
            inactiveToggleColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return WidgetInkWellTransparent(
      onTap: () {
        appHaptic();
        appOpenBottomSheet(_WidgetLanguageSelector());
      },
      enableInkWell: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Language'.tr(),
              style: w400TextStyle(
                color: appColorText,
                fontSize: 16,
              ),
            ),
            Spacer(),
            WidgetAppFlag.languageCode(
              languageCode: languageCode,
              height: 16,
              radius: 2,
            ),
            const SizedBox(width: 12),
            Text(
              getLanguageName(languageCode),
              style: w400TextStyle(
                color: appColorText,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String getLanguageName(String languageCode) {
  return LanguageCodes.fromCode(languageCode).name;
}

class _WidgetLanguageSelector extends StatelessWidget {
  const _WidgetLanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetAppBottomSheet(
      title: "Select Language".tr(),
      child: Column(
        children: [
          const SizedBox(height: 12),
          ...appSupportedLocales.map(
            (e) => WidgetInkWellTransparent(
              onTap: () {
                appHaptic();
                setLocale(e.languageCode);
                context.pop();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    WidgetAppFlag.languageCode(
                      languageCode: e.languageCode,
                      height: 16,
                      radius: 2,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        getLanguageName(e.languageCode),
                        style: w400TextStyle(
                          color:
                              AppPrefs.instance.languageCode == e.languageCode
                                  ? appColorText
                                  : appColorText2,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (AppPrefs.instance.languageCode == e.languageCode)
                      Icon(
                        Icons.check,
                        color: appColorPrimary,
                        size: 20,
                      )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: context.mediaQueryPadding.bottom + 12,
          ),
        ],
      ),
    );
  }
}
