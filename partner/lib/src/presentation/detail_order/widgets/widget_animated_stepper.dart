import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
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
      children: List.generate(4, (index) {
        bool isCompleted = widget.currentStep >= index;
        bool isInProgress = widget.currentStep > index && widget.currentStep < index + 1;

        return index == 3
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.sw),
                child: WidgetAppSVG(
                  _getStepIcon(index),
                  width: 16.sw,
                  color: isCompleted ? appColorPrimary : grey9,
                ),
              )
            : Expanded(
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.sw),
                      child: WidgetAppSVG(
                        _getStepIcon(index),
                        width: 16.sw,
                        color: isCompleted ? appColorPrimary : grey9,
                      ),
                    ),
                    Expanded(
                      child: !isInProgress
                          ? Container(
                              height: 3.sw,
                              decoration: BoxDecoration(
                                color: isCompleted ? appColorPrimary : appColorBackground,
                                borderRadius: BorderRadius.circular(99),
                              ),
                            )
                          : LinearProgressIndicator(
                              value: progress,
                              backgroundColor: appColorBackground,
                              valueColor: AlwaysStoppedAnimation<Color>(appColorPrimary),
                              borderRadius: BorderRadius.circular(99),
                              minHeight: 3.sw,
                            ),
                    ),
                  ],
                ),
              );
      }),
    );
  }

  String _getStepIcon(int index) {
    switch (index) {
      case 0:
        return assetsvg('ic_order_confirmed');
      case 1:
        return assetsvg('ic_preparing');
      case 2:
        return assetsvg('ic_shipping');
      default:
        return assetsvg('ic_delivered');
    }
  }
}
