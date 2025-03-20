import 'package:flutter/material.dart';
import 'vertical_steppers.dart';
import 'horizontal_steppers.dart';
import 'stepper_data.dart';
import 'stepper_style.dart';

enum StepperDirection { horizontal, vertical }

//ignore: must_be_immutable
class Steppers extends StatelessWidget {
  Steppers({
    Key? key,
    required this.labels,
    required this.currentStep,
    this.stepBarStyle,
    this.direction = StepperDirection.horizontal,
  }) : super(key: key);

  final List<StepperData> labels;
  final int currentStep;
  StepperStyle? stepBarStyle;
  final StepperDirection direction;

  get _totalSteps => labels.length;

  get _stepBarStyle => stepBarStyle ??= StepperStyle();

  @override
  Widget build(BuildContext context) {
    assert(1 < _totalSteps && _totalSteps < 6 && currentStep <= _totalSteps + 1, 'Invalid progress steps');
    return direction == StepperDirection.horizontal
        ? HorizontalSteppers(
            labels: labels,
            currentStep: currentStep,
            stepBarStyle: _stepBarStyle,
          )
        : VerticalSteppers(
            labels: labels,
            currentStep: currentStep,
            stepBarStyle: _stepBarStyle,
          );
  }
}
