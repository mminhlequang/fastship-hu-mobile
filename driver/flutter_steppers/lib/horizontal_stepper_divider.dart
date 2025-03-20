import 'package:flutter/material.dart';
import 'colors.dart';
import 'stepper_data.dart';
import 'stepper_style.dart';

class ProgressStepHorizontalDivider extends StatelessWidget {
  const ProgressStepHorizontalDivider({
    Key? key,
    required this.step,
    required this.currentStep,
    required this.totalSteps,
    required this.stepBarStyle,
    required this.labels,
  }): super(key: key);

  final int step;
  final int currentStep;
  final int totalSteps;
  final StepperStyle stepBarStyle;
  final List<StepperData> labels;

  bool _isCurrentStep(int step) => currentStep >= step;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          _buildSeparatorLine(step,
              color: _leftDividerColor
          ),
          const SizedBox(
            width: 32,
          ),
          _buildSeparatorLine(step,
              color: _rightDividerColor
          ),
        ],
      ),
    );
  }

  Widget _buildSeparatorLine(int step, {required Color color}) => Expanded(
    child: Container(
      color: color,
      height: 1,
    ),
  );

  get _leftDividerColor {
    if(step == 1)  return StepperColors.transparent;
    if(labels[step-1].state == StepperState.error) return StepperColors.red500;
    if(_isCurrentStep(step)) return stepBarStyle.activeColor;
    return stepBarStyle.inactiveColor;
  }

  get _rightDividerColor {
    if(step == totalSteps)  return StepperColors.transparent;
    if(labels[step].state == StepperState.error)  return StepperColors.red500;
    if(_isCurrentStep(step+1)) return stepBarStyle.activeColor;
    return stepBarStyle.inactiveColor;
  }
}