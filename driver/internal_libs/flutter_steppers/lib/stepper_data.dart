import 'package:flutter/material.dart';

class StepperData {
  StepperData({
    this.id = "",
    this.label,
    this.description,
    this.child,
    this.state = StepperState.normal,
  });

  String id;
  String? label;
  String? description;
  StepperState state;
  Widget? child;
}

enum StepperState { normal, loading, error, success }
