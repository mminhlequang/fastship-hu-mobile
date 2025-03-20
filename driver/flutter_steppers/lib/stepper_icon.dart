import 'package:flutter/material.dart';
import 'colors.dart';
import 'stepper_data.dart';
import 'stepper_style.dart';

class StepperIcon extends StatelessWidget {
  const StepperIcon({
    Key? key,
    required this.step,
    required this.currentStep,
    required this.stepBarStyle,
    required this.stepData,
  }) : super(key: key);

  final int currentStep;
  final int step;
  final StepperStyle stepBarStyle;
  final StepperData stepData;

  bool _isCurrentStep(int step) => currentStep >= step;

  bool _isPassedStep(int step) => currentStep <= step;

  @override
  Widget build(BuildContext context) {
    return stepData.state == StepperState.error
        ? _errorWidget
        : Container(
            alignment: Alignment.center,
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: _isCurrentStep(step) ? stepBarStyle.activeColor : stepBarStyle.inactiveColor,
              shape: BoxShape.circle,
            ),
            child: _isPassedStep(step)
                ? Text(
                    '$step',
                    style: const TextStyle(color: StepperColors.white500, fontSize: 12, fontWeight: FontWeight.bold),
                  )
                : const Icon(
                    Icons.done_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
          );
  }

  get _errorWidget => Container(
        alignment: Alignment.center,
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: StepperColors.red500,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.error,
          color: Colors.white,
          size: 16,
        ),
      );
}
