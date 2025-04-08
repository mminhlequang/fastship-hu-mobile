import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';
import 'dart:async';

import 'package:network_resources/enums.dart';

class WidgetAnimatedStepper extends StatefulWidget {
  const WidgetAnimatedStepper({super.key, required this.status});

  final AppOrderProcessStatus status;

  @override
  State<WidgetAnimatedStepper> createState() => _WidgetAnimatedStepperState();
}

class _WidgetAnimatedStepperState extends State<WidgetAnimatedStepper> {
  final List<AppOrderProcessStatus> totalStep = [
    AppOrderProcessStatus.driverArrivedStore,
    AppOrderProcessStatus.driverPicked,
    AppOrderProcessStatus.driverArrivedDestination,
    AppOrderProcessStatus.completed,
  ];

  _buildStep(AppOrderProcessStatus status, isCompleted) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: CircleAvatar(
            radius: 12.sw,
            backgroundColor: isCompleted ? appColorPrimary : grey1,
            child: WidgetAppSVG(
              _getStepIcon(status),
              width: 18.sw,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          bottom: -17.sw,
          child: Text(
            _getStepText(status),
            style: w400TextStyle(
              fontSize: 11.sw,
              color: isCompleted ? appColorPrimary : grey1,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(totalStep.length, (index) {
        bool isCompleted = widget.status.index >= totalStep[index].index;
        return index == totalStep.length - 1
            ? _buildStep(totalStep[index], isCompleted)
            : Expanded(
                child: Row(
                  children: [
                    _buildStep(totalStep[index], isCompleted),
                    Expanded(
                      child: Container(
                        height: 3.sw,
                        color:
                            (widget.status.index >= totalStep[index + 1].index)
                                ? appColorPrimary
                                : hexColor('#E0E0E0'),
                      ),
                    ),
                  ],
                ),
              );
      }),
    );
  }

  String _getStepText(AppOrderProcessStatus status) {
    switch (status) {
      case AppOrderProcessStatus.driverArrivedStore:
        return 'I\'m at store'.tr();
      case AppOrderProcessStatus.driverPicked:
        return 'Picked'.tr();
      case AppOrderProcessStatus.driverArrivedDestination:
        return 'I\'m at destination'.tr();
      case AppOrderProcessStatus.completed:
        return 'Completed'.tr();
      default:
        return '';
    }
  }

  String _getStepIcon(AppOrderProcessStatus status) {
    switch (status) {
      case AppOrderProcessStatus.driverArrivedStore:
        return assetsvg('icon4');
      case AppOrderProcessStatus.driverPicked:
        return assetsvg('icon3');
      case AppOrderProcessStatus.driverArrivedDestination:
        return assetsvg('icon2');
      default:
        return assetsvg('icon1');
    }
  }
}
