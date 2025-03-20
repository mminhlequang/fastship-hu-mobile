import 'package:flutter/material.dart';
import 'colors.dart';
import 'stepper_icon.dart';
import 'stepper_data.dart';
import 'stepper_style.dart';
import 'style.dart';

class VerticalSteppers extends StatelessWidget {
  const VerticalSteppers({
    Key? key,
    required this.labels,
    required this.currentStep,
    required this.stepBarStyle,
  }) : super(key: key);

  final List<StepperData> labels;
  final int currentStep;
  final StepperStyle stepBarStyle;

  get _totalSteps => labels.length;

  @override
  Widget build(BuildContext context) {
    assert(1 < _totalSteps && _totalSteps < 6 && currentStep <= _totalSteps + 1,
        'Invalid progress steps');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildListStepWidgets(),
    );
  }

  _buildListStepWidgets() {
    List<Widget> widgets = [];
    labels.asMap().forEach((index, stepData) {
      widgets.add(_buildProgressItemWidget(
        step: index + 1,
        stepData: stepData,
      ));
    });
    return widgets;
  }

  _buildProgressItemWidget({required StepperData stepData, required int step}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: (step == currentStep &&
                          stepData.state != StepperState.error)
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
              _buildSeparatorLine(step, stepData),
            ],
          ),
          _buildStepContentWidget(step, stepData),
        ],
      ),
    );
  }

  Widget _buildSeparatorLine(int step, StepperData stepData) {
    if (step == _totalSteps) {
      return const SizedBox.shrink();
    }
    return Expanded(
      child: Container(
        width: 1,
        color: _dividerColor(step, stepData),
      ),
    );
  }

  _isEmpty(String? text) => text == null || text.isEmpty;

  _dividerColor(int step, StepperData stepData) {
    if (step == _totalSteps &&
        stepData.child == null &&
        _isEmpty(stepData.description)) {
      return StepperColors.transparent;
    }
    if (step < _totalSteps && labels[step].state == StepperState.error)
      return StepperColors.red500;
    return currentStep > step
        ? stepBarStyle.activeColor
        : stepBarStyle.inactiveColor;
  }

  _buildStepContentWidget(int step, StepperData stepData) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 3, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_isEmpty(stepData.label))
              Text(
                stepData.label!,
                style: StepperStyles.t16SB
                    .copyWith(color: _labelColor(step, stepData)),
              ),
            if (!_isEmpty(stepData.description))
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  stepData.description!,
                  maxLines: stepBarStyle.maxLineLabel,
                  overflow: TextOverflow.ellipsis,
                  style: StepperStyles.t14R
                      .copyWith(color: _descriptionColor(step, stepData)),
                ),
              ),
            stepData.child ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  _labelColor(int step, StepperData stepData) {
    if (stepData.state == StepperState.error) return StepperColors.red500;
    return currentStep >= step
        ? stepBarStyle.activeColor
        : stepBarStyle.inactiveColor;
  }

  _descriptionColor(int step, StepperData stepData) {
    if (stepData.state == StepperState.error)
      return stepBarStyle.inactiveDescriptionTextColor;
    return currentStep >= step
        ? stepBarStyle.activeDescriptionTextColor
        : stepBarStyle.inactiveDescriptionTextColor;
  }
}
