import 'package:flutter/material.dart';
import 'colors.dart';

class StepperStyle {
  StepperStyle({
    this.activeColor = StepperColors.blue500,
    this.activeBorderColor = StepperColors.blue200,
    this.inactiveColor = StepperColors.grey300s,
    this.inactiveLabelTextColor = StepperColors.grey400s,
    this.activeDescriptionTextColor = StepperColors.grey500s,
    this.inactiveDescriptionTextColor = StepperColors.grey400s,
    this.maxLineLabel = 2,
    this.iconSize = 24.0,
  });

  Color activeColor;
  Color activeBorderColor;
  Color inactiveColor;
  Color inactiveLabelTextColor;
  Color activeDescriptionTextColor;
  Color inactiveDescriptionTextColor;
  int maxLineLabel;
  double iconSize;
}