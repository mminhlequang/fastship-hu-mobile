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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(totalStep.length, (index) {
        bool isCompleted = widget.status.index >= totalStep[index].index;
        return index == totalStep.length - 1
            ? Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  WidgetAppSVG(
                    _getStepIcon(totalStep[index]),
                    width: 24.sw,
                    color: isCompleted ? darkGreen : grey1,
                  ),
                  Positioned(
                    bottom: -19.sw,
                    child: Text(
                      'Delivered'.tr(),
                      style: w400TextStyle(
                        fontSize: 12.sw,
                        color: isCompleted ? darkGreen : grey1,
                      ),
                    ),
                  ),
                ],
              )
            : Expanded(
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.bottomCenter,
                      children: [
                        WidgetAppSVG(
                          _getStepIcon(totalStep[index]),
                          width: 24.sw,
                          color: isCompleted ? darkGreen : grey1,
                        ),
                        Positioned(
                          bottom: -19.sw,
                          child: Text(
                            _getStepText(totalStep[index]),
                            style: w400TextStyle(
                              fontSize: 12.sw,
                              color: isCompleted ? darkGreen : grey1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        height: 3.sw,
                        color:
                            (widget.status.index >= totalStep[index + 1].index)
                                ? darkGreen
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

  String _getStepIcon(
    AppOrderProcessStatus status,
  ) {
    switch (status) {
      case AppOrderProcessStatus.driverArrivedStore:
        return assetsvg('ic_picked_on'); //TODO: change icon
      case AppOrderProcessStatus.driverPicked:
        return assetsvg('ic_picked_on');
      case AppOrderProcessStatus.driverArrivedDestination:
        return assetsvg('ic_delivering_on');
      default:
        return assetsvg('ic_delivered_on');
    }
  }
}
