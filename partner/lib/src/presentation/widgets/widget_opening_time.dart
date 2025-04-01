import 'package:app/src/constants/constants.dart';
import 'package:network_resources/models/opening_time_model.dart';
import 'package:app/src/utils/app_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/setup/app_textstyles.dart';
import 'package:internal_core/setup/app_utils.dart';
import 'package:internal_core/widgets/widget_ripple_button.dart';
import 'package:intl/intl.dart';

class WidgetOpeningTime extends StatefulWidget {
  final List<OpeningTimeModel>? initialData;
  final Function(List<OpeningTimeModel>)? onChanged;
  const WidgetOpeningTime({super.key, this.initialData, this.onChanged});

  @override
  State<WidgetOpeningTime> createState() => _WidgetOpeningTimeState();
}

class _WidgetOpeningTimeState extends State<WidgetOpeningTime> {
  late List<OpeningTimeModel> openingTimes;
  final _monday = ValueNotifier<bool>(true);
  final _tuesday = ValueNotifier<bool>(true);
  final _wednesday = ValueNotifier<bool>(true);
  final _thursday = ValueNotifier<bool>(true);
  final _friday = ValueNotifier<bool>(true);
  final _saturday = ValueNotifier<bool>(true);
  final _sunday = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    openingTimes =
        widget.initialData ?? OpeningTimeModel.getDefaultOpeningTimes();
    _initializeValueNotifiers();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onChanged?.call(openingTimes);
    });
  }

  void _initializeValueNotifiers() {
    _monday.value = openingTimes[0].isOpen;
    _tuesday.value = openingTimes[1].isOpen;
    _wednesday.value = openingTimes[2].isOpen;
    _thursday.value = openingTimes[3].isOpen;
    _friday.value = openingTimes[4].isOpen;
    _saturday.value = openingTimes[5].isOpen;
    _sunday.value = openingTimes[6].isOpen;
  }

  void updateOpeningTime(int index, String field, dynamic value) {
    setState(() {
      switch (field) {
        case 'isOpen':
          openingTimes[index].isOpen = value;
          break;
        case 'openTime':
          openingTimes[index].openTime = value;
          break;
        case 'closeTime':
          openingTimes[index].closeTime = value;
          break;
      }
    });
    widget.onChanged?.call(openingTimes);
  }

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
    return Column(
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
    );
  }

  Widget _oneDay(String day, ValueNotifier<bool> notifier) {
    final index = openingTimes.indexWhere((element) => element.day == day);
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
                    updateOpeningTime(index, 'isOpen', value);
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
                                  string2DateTime(openingTimes[index].openTime,
                                      format: 'HH:mm'),
                                  (date) {
                                    final timeString =
                                        DateFormat('HH:mm').format(date);
                                    updateOpeningTime(
                                        index, 'openTime', timeString);
                                  },
                                );
                              },
                              radius: 4.sw,
                              color: appColorBackground,
                              child: SizedBox(
                                height: 25.sw,
                                child: Center(
                                  child: Text(
                                    openingTimes[index].openTime + 'AM'.tr(),
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
                                  string2DateTime(openingTimes[index].closeTime,
                                      format: 'HH:mm'),
                                  (date) {
                                    final timeString =
                                        DateFormat('HH:mm').format(date);
                                    updateOpeningTime(
                                        index, 'closeTime', timeString);
                                  },
                                );
                              },
                              radius: 4.sw,
                              color: appColorBackground,
                              child: SizedBox(
                                height: 25.sw,
                                child: Center(
                                  child: Text(
                                    openingTimes[index].closeTime + 'PM'.tr(),
                                    style: w400TextStyle(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.sw, vertical: 4.sw),
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
