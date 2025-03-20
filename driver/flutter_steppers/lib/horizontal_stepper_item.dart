import 'package:flutter/material.dart';
import 'style.dart';
import 'colors.dart';
import 'stepper_icon.dart';
import 'stepper_data.dart';
import 'stepper_style.dart';

class HorizontalStepperItem extends StatelessWidget {
  const HorizontalStepperItem({
    Key? key,
    required this.step,
    required this.currentStep,
    required this.totalSteps,
    required this.stepData,
    required this.stepBarStyle,
    Map<String, Object>? trackingParam,
    String? identity,
    TargetPlatform? platformOverride,
  }): super(key: key);

  final int step;
  final int currentStep;
  final int totalSteps;
  final StepperData stepData;
  final StepperStyle stepBarStyle;

  bool _isCurrentStep(int step) => currentStep >= step;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: (step == currentStep && stepData.state != StepperState.error)
                  ? stepBarStyle.activeBorderColor
                  : StepperColors.transparent,
              shape: BoxShape.circle,
            ),
            child: StepperIcon(
              step: step,
              currentStep: currentStep,
              stepBarStyle: stepBarStyle,
              stepData: stepData,
            ),
          ),
          _buildStepDescriptionWidget(step, stepData.label),
        ],
      ),
    );
  }

  Widget _buildStepDescriptionWidget(int step, String? label) =>
      Text(
        label ?? '',
        textAlign: TextAlign.center,
        maxLines: stepBarStyle.maxLineLabel,
        overflow: TextOverflow.ellipsis,
        style: StepperStyles.t14SB.copyWith(color: _getTextColor),
      );

  get _getTextColor {
    if (stepData.state == StepperState.error) return StepperColors.red500;
    if (_isCurrentStep(step)) return stepBarStyle.activeColor;
    return stepBarStyle.inactiveLabelTextColor;
  }
}
