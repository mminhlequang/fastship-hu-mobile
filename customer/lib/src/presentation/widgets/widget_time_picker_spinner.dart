import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:internal_core/internal_core.dart';

class ItemScrollPhysics extends ScrollPhysics {
  /// Creates physics for snapping to item.
  /// Based on PageScrollPhysics
  final double? itemHeight;
  final double targetPixelsLimit;

  const ItemScrollPhysics({
    super.parent,
    this.itemHeight,
    this.targetPixelsLimit = 3.0,
  }) : assert(itemHeight != null && itemHeight > 0);

  @override
  ItemScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ItemScrollPhysics(parent: buildParent(ancestor), itemHeight: itemHeight);
  }

  double _getItem(ScrollPosition position) {
    double maxScrollItem = (position.maxScrollExtent / itemHeight!).floorToDouble();
    return min(max(0, position.pixels / itemHeight!), maxScrollItem);
  }

  double _getPixels(ScrollPosition position, double item) {
    return item * itemHeight!;
  }

  double _getTargetPixels(ScrollPosition position, Tolerance tolerance, double velocity) {
    double item = _getItem(position);
    if (velocity < -tolerance.velocity) {
      item -= targetPixelsLimit;
    } else if (velocity > tolerance.velocity) {
      item += targetPixelsLimit;
    }
    return _getPixels(position, item.roundToDouble());
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a item boundary.
//    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
//        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent))
//      return super.createBallisticSimulation(position, velocity);
    Tolerance tolerance = this.tolerance;
    final double target = _getTargetPixels(position as ScrollPosition, tolerance, velocity);
    if (target != position.pixels) {
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    }
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}

typedef SelectedIndexCallback = void Function(int);
typedef TimePickerCallback = void Function(DateTime);

class TimePickerSpinner extends StatefulWidget {
  final DateTime? time;
  final int minutesInterval;
  final int secondsInterval;
  final bool is24HourMode;
  final bool isShowSeconds;
  final TextStyle? highlightedTextStyle;
  final TextStyle? normalTextStyle;
  final double? itemHeight;
  final double? itemWidth;
  final AlignmentGeometry? alignment;
  final double? spacing;
  final bool isForce2Digits;
  final TimePickerCallback? onTimeChange;

  const TimePickerSpinner({
    super.key,
    this.time,
    this.minutesInterval = 1,
    this.secondsInterval = 1,
    this.is24HourMode = true,
    this.isShowSeconds = false,
    this.highlightedTextStyle,
    this.normalTextStyle,
    this.itemHeight,
    this.itemWidth,
    this.alignment,
    this.spacing,
    this.isForce2Digits = false,
    this.onTimeChange,
  });

  @override
  State<TimePickerSpinner> createState() => _TimePickerSpinnerState();
}

class _TimePickerSpinnerState extends State<TimePickerSpinner> {
  ScrollController hourController = ScrollController();
  ScrollController minuteController = ScrollController();
  ScrollController secondController = ScrollController();
  ScrollController apController = ScrollController();
  int currentSelectedHourIndex = -1;
  int currentSelectedMinuteIndex = -1;
  int currentSelectedSecondIndex = -1;
  int currentSelectedAPIndex = -1;
  DateTime? currentTime;
  bool isHourScrolling = false;
  bool isMinuteScrolling = false;
  bool isSecondsScrolling = false;
  bool isAPScrolling = false;

  /// default settings
  TextStyle defaultHighlightTextStyle = const TextStyle(fontSize: 32, color: Colors.black);
  TextStyle defaultNormalTextStyle = const TextStyle(fontSize: 32, color: Colors.black54);
  double defaultItemHeight = 60;
  double defaultItemWidth = 45;
  double defaultSpacing = 20;
  AlignmentGeometry defaultAlignment = Alignment.centerRight;

  /// getter

  TextStyle? _getHighlightedTextStyle() {
    return widget.highlightedTextStyle ?? defaultHighlightTextStyle;
  }

  TextStyle? _getNormalTextStyle() {
    return widget.normalTextStyle ?? defaultNormalTextStyle;
  }

  int _getHourCount() {
    return widget.is24HourMode ? 24 : 12;
  }

  int _getMinuteCount() {
    return (60 / widget.minutesInterval).floor();
  }

  int _getSecondCount() {
    return (60 / widget.secondsInterval).floor();
  }

  double? _getItemHeight() {
    return widget.itemHeight ?? defaultItemHeight;
  }

  double? _getItemWidth() {
    return widget.itemWidth ?? defaultItemWidth;
  }

  double? _getSpacing() {
    return widget.spacing ?? defaultSpacing;
  }

  AlignmentGeometry? _getAlignment() {
    return widget.alignment ?? defaultAlignment;
  }

  bool isLoop(int value) {
    return value > 10;
  }

  DateTime getDateTime() {
    int hour = currentSelectedHourIndex - _getHourCount();
    if (!widget.is24HourMode && currentSelectedAPIndex == 2) hour += 12;
    int minute =
        (currentSelectedMinuteIndex - (isLoop(_getMinuteCount()) ? _getMinuteCount() : 1)) *
            widget.minutesInterval;
    int second =
        (currentSelectedSecondIndex - (isLoop(_getSecondCount()) ? _getSecondCount() : 1)) *
            widget.secondsInterval;
    return DateTime(currentTime!.year, currentTime!.month, currentTime!.day, hour, minute, second);
  }

  @override
  void initState() {
    currentTime = widget.time ?? DateTime.now();

    currentSelectedHourIndex =
        (currentTime!.hour % (widget.is24HourMode ? 24 : 12)) + _getHourCount();
    hourController =
        ScrollController(initialScrollOffset: (currentSelectedHourIndex - 1) * _getItemHeight()!);

    currentSelectedMinuteIndex = (currentTime!.minute / widget.minutesInterval).floor() +
        (isLoop(_getMinuteCount()) ? _getMinuteCount() : 1);
    minuteController =
        ScrollController(initialScrollOffset: (currentSelectedMinuteIndex - 1) * _getItemHeight()!);

    currentSelectedSecondIndex = (currentTime!.second / widget.secondsInterval).floor() +
        (isLoop(_getSecondCount()) ? _getSecondCount() : 1);
    secondController =
        ScrollController(initialScrollOffset: (currentSelectedSecondIndex - 1) * _getItemHeight()!);

    currentSelectedAPIndex = currentTime!.hour >= 12 ? 2 : 1;
    apController =
        ScrollController(initialScrollOffset: (currentSelectedAPIndex - 1) * _getItemHeight()!);

    super.initState();

    if (widget.onTimeChange != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => widget.onTimeChange!(getDateTime()));
    }
  }

  int oldMinutes = 0;
  int oldHours = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> contents = [
      Expanded(
        child: SizedBox(
          width: context.width,
          height: _getItemHeight()! * 3,
          child: spinner(
            hourController,
            _getHourCount(),
            currentSelectedHourIndex,
            isHourScrolling,
            1,
            (index) {
              currentSelectedHourIndex = index;
              isHourScrolling = true;
              int value = ((index % _getHourCount()) * 1).toInt();
              if (!widget.is24HourMode && value == 0) {
                value = 12;
              }
              if (oldHours != value) {
                oldHours = value;
                HapticFeedback.lightImpact();
              }
            },
            () => isHourScrolling = false,
            Alignment.centerRight,
          ),
        ),
      ),
      spacer(),
      Expanded(
        child: SizedBox(
          width: _getItemWidth(),
          height: _getItemHeight()! * 3,
          child: spinner(
            minuteController,
            _getMinuteCount(),
            currentSelectedMinuteIndex,
            isMinuteScrolling,
            widget.minutesInterval,
            (index) {
              currentSelectedMinuteIndex = index;
              isMinuteScrolling = true;
              int value = ((index % _getMinuteCount()) * widget.minutesInterval).toInt();
              if (oldMinutes != value) {
                oldMinutes = value;
                HapticFeedback.lightImpact();
              }
            },
            () => isMinuteScrolling = false,
            Alignment.centerLeft,
          ),
        ),
      ),
    ];

    //Not yet check UI
    if (widget.isShowSeconds) {
      contents.add(spacer());
      contents.add(SizedBox(
        width: _getItemWidth(),
        height: _getItemHeight()! * 3,
        child: spinner(
          secondController,
          _getSecondCount(),
          currentSelectedSecondIndex,
          isSecondsScrolling,
          widget.secondsInterval,
          (index) {
            currentSelectedSecondIndex = index;
            isSecondsScrolling = true;
          },
          () => isSecondsScrolling = false,
        ),
      ));
    }

    if (!widget.is24HourMode) {
      contents.add(spacer());
      contents.add(SizedBox(
        width: _getItemWidth()! * 1.2,
        height: _getItemHeight()! * 3,
        child: apSpinner(),
      ));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: contents,
    );
  }

  Widget spacer() {
    return SizedBox(
      width: _getSpacing(),
      height: _getItemHeight()! * 3,
    );
  }

  Widget spinner(
    ScrollController controller,
    int max,
    int selectedIndex,
    bool isScrolling,
    int interval,
    SelectedIndexCallback onUpdateSelectedIndex,
    VoidCallback onScrollEnd, [
    Alignment? alignment,
  ]) {
    /// wrapping the spinner with stack and add container above it when it's scrolling
    /// this thing is to prevent an error causing by some weird stuff like this
    /// flutter: Another exception was thrown: 'package:flutter/src/widgets/scrollable.dart': Failed assertion: line 469 pos 12: '_hold == null || _drag == null': is not true.
    /// maybe later we can find out why this error is happening
    Widget spinner = NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is UserScrollNotification) {
          if (scrollNotification.direction.toString() == "ScrollDirection.idle") {
            if (isLoop(max)) {
              int segment = (selectedIndex / max).floor();
              if (segment == 0) {
                onUpdateSelectedIndex(selectedIndex + max);
                controller.jumpTo(controller.offset + (max * _getItemHeight()!));
              } else if (segment == 2) {
                onUpdateSelectedIndex(selectedIndex - max);
                controller.jumpTo(controller.offset - (max * _getItemHeight()!));
              }
            }
            setState(() {
              onScrollEnd();
              if (widget.onTimeChange != null) {
                widget.onTimeChange!(getDateTime());
              }
            });
          }
        } else if (scrollNotification is ScrollUpdateNotification) {
          setState(() {
            onUpdateSelectedIndex((controller.offset / _getItemHeight()!).round() + 1);
          });
        }
        return true;
      },
      child: ListView.builder(
        controller: controller,
        itemCount: isLoop(max) ? max * 3 : max + 2,
        physics: ItemScrollPhysics(itemHeight: _getItemHeight()),
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          bool isSelected = selectedIndex == index;
          String text = '';

          if (isLoop(max)) {
            text = ((index % max) * interval).toString();
          } else if (index != 0 && index != max + 1) {
            text = (((index - 1) % max) * interval).toString();
          }
          if (!widget.is24HourMode && controller == hourController && text == '0') {
            text = '12';
          }
          if (widget.isForce2Digits && text != '') {
            text = text.padLeft(2, '0');
          }

          return Container(
            height: _getItemHeight(),
            alignment: alignment ?? _getAlignment(),
            child: Text(
              text,
              style: isSelected ? _getHighlightedTextStyle() : _getNormalTextStyle(),
            ),
          );
        },
      ),
    );

    return Stack(
      children: <Widget>[
        Positioned.fill(child: spinner),
        isScrolling
            ? Positioned.fill(
                child: Container(
                color: Colors.black.withValues(alpha: 0),
              ))
            : Container()
      ],
    );
  }

  Widget apSpinner() {
    Widget spinner = NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is UserScrollNotification) {
          if (scrollNotification.direction.toString() == "ScrollDirection.idle") {
            isAPScrolling = false;
            if (widget.onTimeChange != null) {
              widget.onTimeChange!(getDateTime());
            }
          }
        } else if (scrollNotification is ScrollUpdateNotification) {
          setState(() {
            currentSelectedAPIndex = (apController.offset / _getItemHeight()!).round() + 1;
            isAPScrolling = true;
          });
        }
        return true;
      },
      child: ListView.builder(
        itemBuilder: (context, index) {
          String text = index == 1 ? 'AM' : (index == 2 ? 'PM' : '');
          return Container(
            height: _getItemHeight(),
            alignment: Alignment.center,
            child: Text(
              text,
              style: currentSelectedAPIndex == index
                  ? _getHighlightedTextStyle()
                  : _getNormalTextStyle(),
            ),
          );
        },
        controller: apController,
        itemCount: 4,
        physics: ItemScrollPhysics(
          itemHeight: _getItemHeight(),
          targetPixelsLimit: 1,
        ),
      ),
    );

    return Stack(
      children: <Widget>[
        Positioned.fill(child: spinner),
        isAPScrolling ? Positioned.fill(child: Container()) : Container()
      ],
    );
  }
}
