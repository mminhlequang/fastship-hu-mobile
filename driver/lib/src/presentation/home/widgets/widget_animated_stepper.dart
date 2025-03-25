import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';
import 'dart:async';

class WidgetAnimatedStepper extends StatefulWidget {
  const WidgetAnimatedStepper({super.key, required this.currentStep});

  final double currentStep;

  @override
  State<WidgetAnimatedStepper> createState() => _WidgetAnimatedStepperState();
}

class _WidgetAnimatedStepperState extends State<WidgetAnimatedStepper> {
  double progress = 0.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startProgressAnimation();
  }

  void _startProgressAnimation() {
    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        progress += 0.025;
        if (progress >= 1.0) {
          progress = 0.0;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(3, (index) {
        bool isCompleted = widget.currentStep >= index;
        bool isInProgress = widget.currentStep >= index && widget.currentStep < index + 1;

        return index == 2
            ? Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  WidgetAppSVG(
                    _getStepIcon(index, isCompleted: isCompleted),
                    width: 24.sw,
                  ),
                  Positioned(
                    bottom: -19.sw,
                    child: Text(
                      'Delivered'.tr(),
                      style: w400TextStyle(
                        fontSize: 12.sw,
                        color: isCompleted ? darkGreen : grey1,
                      ),
                    ),
                  ),
                ],
              )
            : Expanded(
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.bottomCenter,
                      children: [
                        WidgetAppSVG(
                          _getStepIcon(index, isCompleted: isCompleted),
                          width: 24.sw,
                        ),
                        Positioned(
                          bottom: -19.sw,
                          child: Text(
                            index == 0 ? 'Picked'.tr() : 'Delivery'.tr(),
                            style: w400TextStyle(
                              fontSize: 12.sw,
                              color: isCompleted ? darkGreen : grey1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: !isInProgress
                          ? Container(
                              height: 3.sw,
                              color: isCompleted ? darkGreen : hexColor('#E0E0E0'),
                            )
                          : LinearProgressIndicator(
                              value: progress,
                              backgroundColor: darkGreen.withValues(alpha: .15),
                              valueColor: AlwaysStoppedAnimation<Color>(darkGreen),
                              minHeight: 3.sw,
                            ),
                    ),
                  ],
                ),
              );
      }),
    );
  }

  String _getStepIcon(int index, {bool isCompleted = false}) {
    switch (index) {
      case 0:
        return assetsvg(isCompleted ? 'ic_picked_on' : 'ic_picked_off');
      case 1:
        return assetsvg(isCompleted ? 'ic_delivering_on' : 'ic_delivering_off');
      default:
        return assetsvg(isCompleted ? 'ic_delivered_on' : 'ic_delivered_off');
    }
  }
}
