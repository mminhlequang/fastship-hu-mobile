import 'package:app/src/constants/constants.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';

import '../perference_settings_screen.dart';

class WidgetPreferenceLangSelector extends StatefulWidget {
  const WidgetPreferenceLangSelector({super.key});

  @override
  State<WidgetPreferenceLangSelector> createState() =>
      _WidgetPreferenceLangSelectorState();
}

class _WidgetPreferenceLangSelectorState
    extends State<WidgetPreferenceLangSelector> {
  String get languageCode => AppPrefs.instance.languageCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language'.tr()),
      ),
      backgroundColor: hexColor('F4F4F6'),
      body: ListView.separated(
        itemBuilder: (_, index) {
          return WidgetInkWellTransparent(
            onTap: () {
              appHaptic();
              setState(() {
                AppPrefs.instance.languageCode =
                    appSupportedLocales[index].languageCode;
                setLocale(languageCode);
              });
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 14.sw),
              child: Row(
                children: [
                  WidgetAppSVG(
                    appSupportedLocales[index].languageCode == languageCode
                        ? 'radio-check'
                        : 'radio-uncheck',
                    width: 24.sw,
                  ),
                  Gap(16.sw),
                  WidgetAppFlag.languageCode(
                    languageCode: appSupportedLocales[index].languageCode,
                    radius: 6,
                    height: 24.sw,
                  ),
                  Gap(20.sw),
                  Expanded(
                    child: Text(
                      getLanguageName(appSupportedLocales[index].languageCode),
                      style: w500TextStyle(fontSize: 16.sw),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) {
          return Container(
            height: 1,
            color: hexColor('F2F2F2'),
          );
        },
        itemCount: appSupportedLocales.length,
      ),
    );
  }
}

class WidgetPreferenceCurrencySelector extends StatefulWidget {
  const WidgetPreferenceCurrencySelector({super.key});

  @override
  State<WidgetPreferenceCurrencySelector> createState() =>
      _WidgetPreferenceCurrencySelectorState();
}

class _WidgetPreferenceCurrencySelectorState
    extends State<WidgetPreferenceCurrencySelector> {
  String get currency => AppPrefs.instance.currency;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency'.tr()),
      ),
      backgroundColor: hexColor('F4F4F6'),
      body: Column(
        children: [
          WidgetInkWellTransparent(
            onTap: () {
              appHaptic();
              // setState(() {
              //   AppPrefs.instance.languageCode =
              //       appSupportedLocales[index].languageCode;
              //   setLocale(languageCode);
              // });
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 14.sw),
              child: Row(
                children: [
                  WidgetAppSVG(
                    currency == 'HUF' ? 'radio-check' : 'radio-uncheck',
                    width: 24.sw,
                  ),
                  Gap(20.sw),
                  Expanded(
                    child: Text(
                      "Forint Hungary (HUF)",
                      style: w500TextStyle(fontSize: 16.sw),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            color: hexColor('F2F2F2'),
          ),
          WidgetInkWellTransparent(
            onTap: () {
              appHaptic();
              // setState(() {
              //   AppPrefs.instance.currency = 'USD';
              // });
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 14.sw),
              child: Row(
                children: [
                  WidgetAppSVG(
                    currency == 'USD' ? 'radio-check' : 'radio-uncheck',
                    width: 24.sw,
                  ),
                  Gap(20.sw),
                  Expanded(
                    child: Text(
                      "Dollar (USD)",
                      style: w500TextStyle(fontSize: 16.sw),
                    ),
                  ),
                ],
              ),
            ),
          ).opacity(.4),
        ],
      ),
    );
  }
}

class WidgetPreferenceDateTimeSelector extends StatefulWidget {
  const WidgetPreferenceDateTimeSelector({super.key});

  @override
  State<WidgetPreferenceDateTimeSelector> createState() =>
      _WidgetPreferenceDateTimeSelectorState();
}

class _WidgetPreferenceDateTimeSelectorState
    extends State<WidgetPreferenceDateTimeSelector> {
  List<String> dateFormats = [
    'dd.MM.yyyy'.tr(),
    'MM.dd.yyyy'.tr(),
    'yyyy.MM.dd'.tr(),
    'dd/MM/yyyy'.tr(),
    'MM/dd/yyyy'.tr(),
    'yyyy/MM/dd'.tr(),
  ];

  List<String> timeFormats = [
    'hh:mm'.tr(),
    'hh:mm a'.tr(),
    'HH:mm'.tr(),
    'HH:mm a'.tr(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date and Time format'.tr()),
      ),
      backgroundColor: hexColor('F4F4F6'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 14.sw),
            child: Text(
              'Date format'.tr(),
              style: w400TextStyle(fontSize: 16.sw, color: appColorTextLabel),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.only(),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              return WidgetInkWellTransparent(
                onTap: () {
                  appHaptic();
                  setState(() {
                    AppPrefs.instance.dateFormat = dateFormats[index];
                    WidgetsFlutterBinding.ensureInitialized()
                        .performReassemble();
                  });
                },
                child: Container(
                  color: Colors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.sw, vertical: 14.sw),
                  child: Row(
                    children: [
                      WidgetAppSVG(
                        AppPrefs.instance.dateFormat == dateFormats[index]
                            ? 'radio-check'
                            : 'radio-uncheck',
                        width: 24.sw,
                      ),
                      Gap(20.sw),
                      Expanded(
                        child: Text(
                          dateFormats[index],
                          style: w500TextStyle(fontSize: 16.sw),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) {
              return Container(
                height: 1,
                color: hexColor('F2F2F2'),
              );
            },
            itemCount: dateFormats.length,
          ),
          Gap(12.sw),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 14.sw),
            child: Text(
              'Time format'.tr(),
              style: w400TextStyle(fontSize: 16.sw, color: appColorTextLabel),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.only(),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              return WidgetInkWellTransparent(
                onTap: () {
                  appHaptic();
                  setState(() {
                    AppPrefs.instance.timeFormat = timeFormats[index];
                    WidgetsFlutterBinding.ensureInitialized()
                        .performReassemble();
                  });
                },
                child: Container(
                  color: Colors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.sw, vertical: 14.sw),
                  child: Row(
                    children: [
                      WidgetAppSVG(
                        AppPrefs.instance.timeFormat == timeFormats[index]
                            ? 'radio-check'
                            : 'radio-uncheck',
                        width: 24.sw,
                      ),
                      Gap(20.sw),
                      Expanded(
                        child: Text(
                          timeFormats[index],
                          style: w500TextStyle(fontSize: 16.sw),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) {
              return Container(
                height: 1,
                color: hexColor('F2F2F2'),
              );
            },
            itemCount: timeFormats.length,
          )
        ],
      ),
    );
  }
}

class _DateTimeFormatItem {
  String label;
  String value;

  _DateTimeFormatItem({required this.label, required this.value});
}
