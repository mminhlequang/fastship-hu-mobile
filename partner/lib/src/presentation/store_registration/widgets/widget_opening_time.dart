import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/widgets/widget_app_divider.dart';
import 'package:app/src/utils/app_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/setup/app_textstyles.dart';
import 'package:internal_core/setup/app_utils.dart';
import 'package:internal_core/widgets/widgets.dart';

class WidgetOpeningTime extends StatefulWidget {
  const WidgetOpeningTime({super.key});

  @override
  State<WidgetOpeningTime> createState() => _WidgetOpeningTimeState();
}

class _WidgetOpeningTimeState extends State<WidgetOpeningTime> {
  final _monday = ValueNotifier<bool>(false);
  final _tuesday = ValueNotifier<bool>(true);
  final _wednesday = ValueNotifier<bool>(true);
  final _thursday = ValueNotifier<bool>(true);
  final _friday = ValueNotifier<bool>(true);
  final _saturday = ValueNotifier<bool>(true);
  final _sunday = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _monday.dispose();
    _tuesday.dispose();
    _wednesday.dispose();
    _thursday.dispose();
    _friday.dispose();
    _saturday.dispose();
    _sunday.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Opening time'.tr(),
          style: w500TextStyle(fontSize: 20.sw, height: 1.2),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: appColorText),
        actions: [
          TextButton(
            onPressed: () {
              // Todo:
            },
            child: Text(
              'Save'.tr(),
              style: w400TextStyle(fontSize: 16.sw, color: darkGreen),
            ),
          ),
          Gap(4.sw),
        ],
      ),
      body: Column(
        children: [
          const AppDivider(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.sw),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'Opening hours'.tr(),
                      style: w600TextStyle(),
                      children: [
                        TextSpan(
                          text: '*',
                          style: w600TextStyle(color: appColorError),
                        )
                      ],
                    ),
                  ),
                  Gap(16.sw),
                  _oneDay('Monday'.tr(), _monday),
                  _oneDay('Tuesday'.tr(), _tuesday),
                  _oneDay('Wednesday'.tr(), _wednesday),
                  _oneDay('Thursday'.tr(), _thursday),
                  _oneDay('Friday'.tr(), _friday),
                  _oneDay('Saturday'.tr(), _saturday),
                  _oneDay('Sunday'.tr(), _sunday),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _oneDay(String day, ValueNotifier<bool> notifier) {
    return Padding(
      padding: EdgeInsets.only(bottom: 13.sw),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                AdvancedSwitch(
                  controller: notifier,
                  initialValue: notifier.value,
                  height: 22.sw,
                  width: 40.sw,
                  activeColor: appColorPrimary,
                  inactiveColor: hexColor('#E2E2EF'),
                  onChanged: (value) {
                    notifier.value = value;
                  },
                ),
                Gap(9.sw),
                Expanded(
                  child: Text(
                    day,
                    style: w400TextStyle(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<bool>(
              valueListenable: notifier,
              builder: (context, value, child) {
                return value
                    ? Row(
                        children: [
                          Expanded(
                            child: WidgetRippleButton(
                              onTap: () {
                                appOpenTimePicker(
                                  DateTime.now(),
                                  (date) {
                                    // Todo:
                                  },
                                );
                              },
                              radius: 4.sw,
                              color: appColorBackground,
                              child: SizedBox(
                                height: 25.sw,
                                child: Center(
                                  child: Text(
                                    '5:00AM'.tr(),
                                    style: w400TextStyle(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 1,
                            width: 6,
                            margin: EdgeInsets.symmetric(horizontal: 9.sw),
                            color: appColorText,
                          ),
                          Expanded(
                            child: WidgetRippleButton(
                              onTap: () {
                                appOpenTimePicker(
                                  DateTime.now(),
                                  (date) {
                                    // Todo:
                                  },
                                );
                              },
                              radius: 4.sw,
                              color: appColorBackground,
                              child: SizedBox(
                                height: 25.sw,
                                child: Center(
                                  child: Text(
                                    '23:00PM'.tr(),
                                    style: w400TextStyle(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.sw, vertical: 4.sw),
                        decoration: BoxDecoration(
                          color: appColorBackground,
                          borderRadius: BorderRadius.circular(4.sw),
                        ),
                        child: Text(
                          'Close'.tr(),
                          style: w400TextStyle(color: hexColor('#8A8C91')),
                        ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
