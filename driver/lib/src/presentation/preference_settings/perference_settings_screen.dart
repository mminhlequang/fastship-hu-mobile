import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/preference_settings/widgets/widget_selector.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';
import 'package:language_code/language_code.dart';

class PreferenceSettingsScreen extends StatelessWidget {
  const PreferenceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      WidgetRippleButton(
        onTap: () {
          appHaptic();
          pushWidget(
            child: const WidgetPreferenceLangSelector(),
          );
        },
        radius: 0,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.sw, 14.sw, 12.sw, 14.sw),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Language".tr(),
                  style: w400TextStyle(fontSize: 16.sw),
                ),
              ),
              Text(
                getLanguageName(AppPrefs.instance.languageCode),
                style: w400TextStyle(fontSize: 16.sw, color: grey4),
              ),
              // WidgetAppSVG('chevron_right', color: grey4),
            ],
          ),
        ),
      ),
      WidgetRippleButton(
        onTap: () {
          appHaptic();
          pushWidget(
            child: const WidgetPreferenceCurrencySelector(),
          );
        },
        radius: 0,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.sw, 14.sw, 12.sw, 14.sw),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Currency".tr(),
                  style: w400TextStyle(fontSize: 16.sw),
                ),
              ),
              Text(
                  "${AppPrefs.instance.currency} (${AppPrefs.instance.currencySymbol})",
                  style: w400TextStyle(fontSize: 16.sw, color: grey4)),
              // WidgetAppSVG('chevron_right', color: grey4),
            ],
          ),
        ),
      ),
      WidgetRippleButton(
        onTap: () {
          appHaptic();
          pushWidget(
            child: const WidgetPreferenceDateTimeSelector(),
          );
        },
        radius: 0,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.sw, 14.sw, 12.sw, 14.sw),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "DateTime format".tr(),
                  style: w400TextStyle(fontSize: 16.sw),
                ),
              ),
              Text(DateTime.now().formatDateTime(),
                  style: w400TextStyle(fontSize: 16.sw, color: grey4)),
              // WidgetAppSVG('chevron_right', color: grey4),
            ],
          ),
        ),
      )
    ];
    return Scaffold(
      appBar: AppBar(title: Text('Preference settings'.tr())),
      backgroundColor: Colors.white,
      body: ListView.separated(
        itemCount: 3,
        separatorBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sw),
          child: AppDivider(color: grey8),
        ),
        itemBuilder: (context, index) {
          return items[index];
        },
      ),
    );
  }
}

String getLanguageName(String languageCode) {
  return LanguageCodes.fromCode(languageCode).name;
}
