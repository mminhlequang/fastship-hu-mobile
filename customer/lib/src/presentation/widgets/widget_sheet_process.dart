import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:easy_localization/easy_localization.dart'; 
import 'package:internal_core/internal_core.dart'; 

enum SheetProcessStatus {
  loading,
  success,
  error,
}

class WidgetBottomSheetProcess extends StatefulWidget {
  final ValueNotifier<SheetProcessStatus> processer;
  final VoidCallback onTryAgain;
  const WidgetBottomSheetProcess(
      {super.key, required this.processer, required this.onTryAgain});

  @override
  State<WidgetBottomSheetProcess> createState() =>
      _WidgetBottomSheetProcessState();
}

class _WidgetBottomSheetProcessState extends State<WidgetBottomSheetProcess> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.sw),
          topRight: Radius.circular(24.sw),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20.sw, 32.sw, 20.sw,
          48.sw + MediaQuery.of(context).viewInsets.bottom),
      child: ValueListenableBuilder(
        valueListenable: widget.processer,
        builder: (context, value, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: switch (value) {
              SheetProcessStatus.loading => [
                  // WidgetAppSVG(
                  //   'ic_loading', //TODO: replace
                  //   width: 72.sw,
                  // ),
                  Gap(32.sw),
                  Text(
                    "Processing...",
                    style: w500TextStyle(fontSize: 24.sw),
                  ),
                  Gap(16.sw),
                  Text(
                    "Your profile is being processed.\nPlease wait while we upload your information"
                        .tr(),
                    style: w300TextStyle(fontSize: 14.sw, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  Gap(40.sw),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(appColorPrimary),
                  ),
                ],
              SheetProcessStatus.success => [
                  WidgetAppSVG(
                    'ic_done',
                    width: 72.sw,
                  ),
                  Gap(32.sw),
                  Text(
                    "Congrats!",
                    style: w500TextStyle(fontSize: 24.sw),
                  ),
                  Gap(16.sw),
                  Text(
                    "Profile added successfully.\nThe FastShip team has received your application and will contact you soon"
                        .tr(),
                    style: w300TextStyle(fontSize: 14.sw, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  Gap(40.sw),
                  WidgetButtonConfirm(
                    text: "Done",
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ],
              SheetProcessStatus.error => [
                  // WidgetAppSVG(
                  //   'ic_error', //TODO: replace
                  //   width: 72.sw,
                  // ),
                  Gap(32.sw),
                  Text(
                    "Error!",
                    style: w500TextStyle(fontSize: 24.sw),
                  ),
                  Gap(16.sw),
                  Text(
                    "Your profile is not complete yet.\nPlease make sure to fill in all required information to proceed"
                        .tr(),
                    style: w300TextStyle(fontSize: 14.sw, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  Gap(40.sw),
                  Row(
                    spacing: 16.sw,
                    children: [
                      Expanded(
                        child: WidgetButtonCancel(
                          text: "Back",
                          onPressed: () {
                            appHaptic();
                            Navigator.pop(context, false);
                          },
                        ),
                      ),
                      Expanded(
                        child: WidgetButtonConfirm(
                          text: "Try again",
                          onPressed: () {
                            appHaptic();
                            widget.onTryAgain();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              _ => [],
            },
          );
        },
      ),
    );
  }
}
