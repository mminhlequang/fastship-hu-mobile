import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';
import 'package:gap/gap.dart';
import 'package:app/src/presentation/widgets/widget_textfield.dart';
import 'package:app/src/constants/app_colors.dart';

import 'widget_form_profile_1.dart';

class WidgetFormProfile extends StatefulWidget {
  const WidgetFormProfile({super.key});

  @override
  State<WidgetFormProfile> createState() => _WidgetFormProfileState();
}

class _WidgetFormProfileState extends State<WidgetFormProfile> {
  //1. personal information
  //2. images: id card, driver license, vehicle registration, vehicle inspection
  //3. emergency contact
  //4. payment method

  int step = 0;
  String get nameStep => switch (step) {
        0 => 'Personal Information',
        1 => 'Images',
        2 => 'Emergency Contact',
        3 => 'Payment Method',
        _ => 'Unknown'
      };

  Widget _buildStepper() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          16.sw, 4.sw + context.mediaQueryPadding.top, 16.sw, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  appHaptic();
                  context.pop();
                },
                icon: WidgetAppSVG(
                  'chevron-left',
                  width: 24.sw,
                ),
              ),
              Gap(12.sw),
              Expanded(
                child: Row(
                  spacing: 6.sw,
                  children: List.generate(4, (index) {
                    return Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: index == step
                              ? appColorPrimary
                              : AppColors.instance.grey5,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        height: 5.sw,
                      ),
                    );
                  }),
                ),
              ),
              Gap(12.sw),
              Opacity(
                opacity: 0,
                child: IconButton(
                  onPressed: null,
                  icon: WidgetAppSVG(
                    'chevron-left',
                    width: 24.sw,
                  ),
                ),
              ),
            ],
          ),
          Gap(4.sw),
          Text(
            nameStep,
            style: w500TextStyle(fontSize: 20.sw),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20.sw, 12.sw, 20.sw, 8.sw + context.mediaQueryPadding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: appColorText.withOpacity(0.1),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: appColorText.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: WidgetAppButtonCancel(
              onTap: () {
                appHaptic();
                if (step > 0) {
                  setState(() {
                    step--;
                  });
                } else {
                  context.pop();
                }
              },
              label: "Back",
              height: 48.sw,
            ),
          ),
          Gap(16.sw),
          Expanded(
            child: WidgetAppButtonOK(
              onTap: () {
                appHaptic();
                setState(() {
                  step++;
                });
              },
              label: "Continue",
              height: 48.sw,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepper(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 20.sw, vertical: 24.sw),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: switch (step) {
                    0 => WidgetFormProfile1(onChanged: (data) {}),
                    1 => WidgetFormProfile1(onChanged: (data) {}),
                    2 => WidgetFormProfile1(onChanged: (data) {}),
                    3 => WidgetFormProfile1(onChanged: (data) {}),
                    _ => SizedBox.shrink(),
                  },
                ),
              ),
            ),
          ),
          _buildBottomNavigation(),
        ],
      ),
    );
  }
}
