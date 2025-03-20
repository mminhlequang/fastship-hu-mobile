import 'package:flutter/cupertino.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:app/src/constants/constants.dart';
import 'package:internal_core/extensions/context_extension.dart';
import 'package:internal_core/internal_core.dart';
import 'package:internal_core/setup/app_textstyles.dart';
import 'package:internal_core/setup/app_utils.dart';

import 'widgets.dart';

enum DateTimePickerType {
  date,
  time,
  dateTime,
}

class WidgetDateTimePicker extends StatefulWidget {
  final DateTimePickerType type;
  final DateTime? initialDateTime;
  final Function(DateTime)? onConfirm;
  final Function()? onCancel;
  final String? title;

  const WidgetDateTimePicker({
    super.key,
    required this.type,
    this.initialDateTime,
    this.onConfirm,
    this.onCancel,
    this.title,
  });

  @override
  State<WidgetDateTimePicker> createState() => _WidgetDateTimePickerState();
}

class _WidgetDateTimePickerState extends State<WidgetDateTimePicker> {
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDateTime ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetAppBottomSheet(
      title: widget.title ?? 'Please select date time'.tr(),
      enableSafeArea: true,
      actions: [
        WidgetInkWellTransparent(
          onTap: () {
            appHaptic();
            widget.onCancel?.call();
            appContext.pop();
          },
          enableInkWell: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: Text(
              'Cancel'.tr(),
              style: w400TextStyle(color: appColorText),
            ),
          ),
        ),
        WidgetInkWellTransparent(
          onTap: () {
            appHaptic();
            widget.onConfirm?.call(_selectedDateTime);
            appContext.pop(_selectedDateTime);
          },
          enableInkWell: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: Text(
              'Save'.tr(),
              style: w400TextStyle(color: appColorPrimary),
            ),
          ),
        ),
        Gap(4),
      ],
      child: _buildPickerContent(),
    );
  }

  Widget _buildPickerContent() {
    switch (widget.type) {
      case DateTimePickerType.date:
        return _buildDatePicker();
      case DateTimePickerType.time:
        return _buildTimePicker();
      case DateTimePickerType.dateTime:
        return _buildDateTimePicker();
    }
  }

  Widget _buildDatePicker() {
    return SizedBox(
      height: 200,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        initialDateTime: _selectedDateTime,
        onDateTimeChanged: (DateTime newDateTime) {
          setState(() {
            _selectedDateTime = newDateTime;
          });
        },
      ),
    );
  }

  Widget _buildTimePicker() {
    return SizedBox(
      height: 200,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.time,
        initialDateTime: _selectedDateTime,
        onDateTimeChanged: (DateTime newDateTime) {
          setState(() {
            _selectedDateTime = newDateTime;
          });
        },
      ),
    );
  }

  Widget _buildDateTimePicker() {
    return SizedBox(
      height: 200,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.dateAndTime,
        initialDateTime: _selectedDateTime,
        onDateTimeChanged: (DateTime newDateTime) {
          setState(() {
            _selectedDateTime = newDateTime;
          });
        },
      ),
    );
  }
}

class WidgetBottomPickTime extends StatefulWidget {
  final String title;
  final String? description;
  final DateTime? time;

  const WidgetBottomPickTime({
    super.key,
    required this.title,
    this.description,
    this.time,
  });

  @override
  State<WidgetBottomPickTime> createState() => _WidgetBottomPickTimeState();
}

class _WidgetBottomPickTimeState extends State<WidgetBottomPickTime> {
  late DateTime _time = widget.time ?? DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WidgetAppBottomSheet(
      title: widget.title,
      enableSafeArea: true,
      actions: [
        WidgetInkWellTransparent(
          onTap: () {
            appHaptic();
            appContext.pop();
          },
          enableInkWell: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: Text(
              'Cancel'.tr(),
              style: w400TextStyle(color: appColorPrimaryRed),
            ),
          ),
        ),
        WidgetInkWellTransparent(
          onTap: () {
            appHaptic();
            appContext.pop(DateTime(
                _time.year, _time.month, _time.day, _time.hour, _time.minute));
          },
          enableInkWell: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: Text(
              'Save'.tr(),
              style: w400TextStyle(color: appColorPrimary),
            ),
          ),
        ),
        Gap(4)
      ],
      child: SizedBox(
        height: 180.sw,
        child: WidgetTimePicker(
          onTimeChange: (DateTime time) {
            setState(() {
              _time = time;
            });
          },
          initialSelectedDate: _time,
        ),
      ),
    );
  }
}

class WidgetTimePicker extends StatefulWidget {
  final Function(DateTime) onTimeChange;
  final DateTime? initialSelectedDate;
  const WidgetTimePicker(
      {super.key, required this.onTimeChange, this.initialSelectedDate});

  @override
  State<WidgetTimePicker> createState() => _WidgetTimePickerState();
}

class _WidgetTimePickerState extends State<WidgetTimePicker> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: appContext.width,
          height: 46,
          color: appColorBackground,
        ),
        TimePickerSpinner(
          is24HourMode: true,
          isShowSeconds: false,
          time: widget.initialSelectedDate,
          normalTextStyle: w500TextStyle(
              color: appColorText.withValues(alpha: .65), fontSize: 16),
          highlightedTextStyle:
              w500TextStyle(color: appColorText, fontSize: 18),
          spacing: 24,
          itemHeight: 55,
          isForce2Digits: true,
          onTimeChange: widget.onTimeChange,
        ),
      ],
    );
  }
}
