import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widget_bottom_sheet_base.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter_datetime_picker_plus/src/datetime_picker_theme.dart'
    as picker_theme;
import 'package:internal_core/internal_core.dart';

import 'widget_time_picker_spinner.dart';
import 'widgets.dart';


class WidgetDateTimePicker extends StatefulWidget {
  final picker.BasePickerModel pickerModel;
  final picker.DateChangedCallback? onChanged;
  final picker.DateChangedCallback? onConfirm;
  final picker.DateCancelledCallback? onCancel;
  final picker.LocaleType locale;
  final picker_theme.DatePickerTheme theme;

  WidgetDateTimePicker({
    Key? key,
    required this.pickerModel,
    this.onChanged,
    this.onConfirm,
    this.onCancel,
    this.locale = picker.LocaleType.en,
    this.theme = const picker_theme.DatePickerTheme(),
  }) : super(key: key);

  @override
  _WidgetDateTimePickerState createState() => _WidgetDateTimePickerState();
}

class _WidgetDateTimePickerState extends State<WidgetDateTimePicker> {
  late FixedExtentScrollController leftScrollCtrl,
      middleScrollCtrl,
      rightScrollCtrl;

  @override
  void initState() {
    super.initState();
    refreshScrollOffset();
  }

  void refreshScrollOffset() {
    leftScrollCtrl = FixedExtentScrollController(
        initialItem: widget.pickerModel.currentLeftIndex());
    middleScrollCtrl = FixedExtentScrollController(
        initialItem: widget.pickerModel.currentMiddleIndex());
    rightScrollCtrl = FixedExtentScrollController(
        initialItem: widget.pickerModel.currentRightIndex());
  }

  @override
  Widget build(BuildContext context) {
    return WidgetAppBaseSheet(
      title: "Please choose date time".tr(),
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
            appContext.pop(widget.pickerModel.finalTime()!);
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
      child: Container(
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: appColorElement,
          borderRadius: BorderRadius.circular(16),
        ),
        child: _renderPickerView(),
      ),
    );
    // return Container(
    //   color: widget.theme.backgroundColor,
    //   child: Column(
    //     children: <Widget>[
    //       if (widget.theme.titleHeight > 0) _renderTitleActionsView(),
    //       _renderPickerView(),
    //     ],
    //   ),
    // );
  }

  Widget _renderPickerView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _renderColumnView(
          widget.pickerModel.leftStringAtIndex,
          leftScrollCtrl,
          widget.pickerModel.layoutProportions()[0],
          (index) {
            widget.pickerModel.setLeftIndex(index);
          },
        ),
        Text(
          widget.pickerModel.leftDivider(),
          style: w400TextStyle(color: appColorTextLabel),
        ),
        _renderColumnView(
          widget.pickerModel.middleStringAtIndex,
          middleScrollCtrl,
          widget.pickerModel.layoutProportions()[1],
          (index) {
            widget.pickerModel.setMiddleIndex(index);
          },
        ),
        Text(
          widget.pickerModel.rightDivider(),
          style: w400TextStyle(color: appColorTextLabel),
        ),
        _renderColumnView(
          widget.pickerModel.rightStringAtIndex,
          rightScrollCtrl,
          widget.pickerModel.layoutProportions()[2],
          (index) {
            widget.pickerModel.setRightIndex(index);
          },
        ),
      ],
    );
  }

  Widget _renderColumnView(
    picker.StringAtIndexCallBack stringAtIndexCB,
    ScrollController scrollController,
    int layoutProportion,
    ValueChanged<int> selectedChangedWhenScrolling,
  ) {
    return Expanded(
      flex: layoutProportion,
      child: Container(
        padding: EdgeInsets.all(8.0),
        height: widget.theme.containerHeight,
        // decoration: BoxDecoration(color: widget.theme.backgroundColor),
        child: CupertinoPicker.builder(
          // backgroundColor: widget.theme.backgroundColor,
          backgroundColor: Colors.transparent,
          scrollController: scrollController as FixedExtentScrollController,
          itemExtent: widget.theme.itemHeight,
          onSelectedItemChanged: (int index) {
            selectedChangedWhenScrolling(index);
          },
          useMagnifier: true,
          itemBuilder: (BuildContext context, int index) {
            final content = stringAtIndexCB(index);
            if (content == null) {
              return null;
            }
            return Container(
              height: widget.theme.itemHeight,
              alignment: Alignment.center,
              child: Text(
                content,
                style: w400TextStyle(color: appColorTextLabel),
                textAlign: TextAlign.start,
              ),
            );
          },
        ),
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
    return WidgetAppBaseSheet(
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
      child: Container(
        margin: EdgeInsets.all(12),
        height: 200,
        decoration: BoxDecoration(
          color: appColorElement,
          borderRadius: BorderRadius.circular(16),
        ),
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
  _WidgetTimePickerState createState() => _WidgetTimePickerState();
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
          decoration: BoxDecoration(
            color: appColorBackground,
          ),
        ),
        TimePickerSpinner(
          is24HourMode: true,
          isShowSeconds: false,
          time: widget.initialSelectedDate,
          normalTextStyle:
              w500TextStyle(color: appColorText.withOpacity(.65), fontSize: 16),
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
