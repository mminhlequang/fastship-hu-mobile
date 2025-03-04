import 'package:flutter/material.dart';
import 'horizontal_stepper_item.dart';
import 'horizontal_stepper_divider.dart';
import 'stepper_data.dart';
import 'stepper_style.dart';


class HorizontalSteppers extends StatelessWidget {
  const HorizontalSteppers({
    Key? key,
    required this.labels,
    required this.currentStep,
    required this.stepBarStyle,
  }): super(key: key);

  final List<StepperData> labels;
  final int currentStep;
  final StepperStyle stepBarStyle;
  get _totalSteps => labels.length;

  @override
  Widget build(BuildContext context) {
    assert(1 < _totalSteps && _totalSteps < 6 && currentStep <= _totalSteps + 1, 'Invalid steppers');
    return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: _buildListDividers()
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildListStepWidgets(),
          ),
        ],
    );
  }

  _buildListDividers() {
    List<Widget> dividers = [];
    labels.asMap().forEach((index, model) {
      dividers.add(
          ProgressStepHorizontalDivider(
              step: index + 1,
              currentStep: currentStep,
              totalSteps: _totalSteps,
              stepBarStyle: stepBarStyle,
              labels: labels,
          )
      );
    });
    return dividers;
  }

  _buildListStepWidgets() {
    List<Widget> stepWidgets = [];
    labels.asMap().forEach((index, model) {
      stepWidgets.add(HorizontalStepperItem(
        step: index + 1,
        currentStep: currentStep,
        stepData: model,
        totalSteps: _totalSteps,
        stepBarStyle: stepBarStyle,
      ));
    });
    return stepWidgets;
  }
}
