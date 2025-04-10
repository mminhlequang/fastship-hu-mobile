import 'package:flutter/cupertino.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:app/src/constants/constants.dart';
import 'package:internal_core/internal_core.dart';

import 'widget_app_bottomsheet.dart';
import 'widget_time_picker_spinner.dart';
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
  final DateTime? minimumDate;
  final DateTime? maximumDate;

  const WidgetDateTimePicker({
    super.key,
    required this.type,
    this.initialDateTime,
    this.onConfirm,
    this.onCancel,
    this.title,
    this.minimumDate,
    this.maximumDate,
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

    // Đảm bảo ngày được chọn nằm trong khoảng cho phép
    if (widget.minimumDate != null &&
        _selectedDateTime.isBefore(widget.minimumDate!)) {
      _selectedDateTime = widget.minimumDate!;
    }
    if (widget.maximumDate != null &&
        _selectedDateTime.isAfter(widget.maximumDate!)) {
      _selectedDateTime = widget.maximumDate!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WidgetAppBottomSheet(
      title: widget.title ?? 'Please select date time'.tr(),
      enableSafeArea: true,
      showCloseButton: false,
      actions: [
        WidgetInkWellTransparent(
          onTap: () {
            appHaptic();
            widget.onCancel?.call();
            appContext.pop();
          },
          enableInkWell: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
        minimumDate: widget.minimumDate,
        maximumDate: widget.maximumDate,
        onDateTimeChanged: (DateTime newDateTime) {
          _selectedDateTime = newDateTime;
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
        minimumDate: widget.minimumDate,
        maximumDate: widget.maximumDate,
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
        minimumDate: widget.minimumDate,
        maximumDate: widget.maximumDate,
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
  final DateTime? minimumDate;
  final DateTime? maximumDate;

  const WidgetBottomPickTime({
    super.key,
    required this.title,
    this.description,
    this.time,
    this.minimumDate,
    this.maximumDate,
  });

  @override
  State<WidgetBottomPickTime> createState() => _WidgetBottomPickTimeState();
}

class _WidgetBottomPickTimeState extends State<WidgetBottomPickTime> {
  late DateTime _time;

  @override
  void initState() {
    super.initState();
    _time = widget.time ?? DateTime.now();

    // Đảm bảo thời gian được chọn nằm trong khoảng cho phép
    if (widget.minimumDate != null && _time.isBefore(widget.minimumDate!)) {
      _time = widget.minimumDate!;
    }
    if (widget.maximumDate != null && _time.isAfter(widget.maximumDate!)) {
      _time = widget.maximumDate!;
    }
  }

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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Text(
              'Cancel'.tr(),
              style: w400TextStyle(color: appColorText),
            ),
          ),
        ),
        WidgetInkWellTransparent(
          onTap: () => appContext.pop(DateTime(
            _time.year,
            _time.month,
            _time.day,
            _time.hour,
            _time.minute,
          )),
          enableInkWell: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Text(
              'Save'.tr(),
              style: w400TextStyle(color: appColorPrimary),
            ),
          ),
        ),
      ],
      child: SizedBox(
        height: 130.sw,
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

  const WidgetTimePicker({
    super.key,
    required this.onTimeChange,
    this.initialSelectedDate,
  });

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
          height: 36.sw,
          color: appColorBackground,
          margin: EdgeInsets.symmetric(horizontal: 16.sw),
          child: Center(
            child: Text(
              ':',
              style: w500TextStyle(fontSize: 16.sw),
            ),
          ),
        ),
        TimePickerSpinner(
          is24HourMode: true,
          isShowSeconds: false,
          time: widget.initialSelectedDate,
          normalTextStyle: w400TextStyle(fontSize: 15.sw, color: appColorText),
          highlightedTextStyle: w500TextStyle(fontSize: 16.sw),
          spacing: 37.sw,
          itemHeight: 36.sw,
          isForce2Digits: true,
          onTimeChange: widget.onTimeChange,
        ),
      ],
    );
  }
}
