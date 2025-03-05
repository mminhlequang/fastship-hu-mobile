import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';
import 'package:progress_bar_steppers/steppers.dart';

class DriverRegisterScreen extends StatefulWidget {
  const DriverRegisterScreen({super.key});

  @override
  State<DriverRegisterScreen> createState() => _DriverRegisterScreenState();
}

class _DriverRegisterScreenState extends State<DriverRegisterScreen> {
  int get currentStep => AppPrefs.instance.user?.profile?.stepId ?? 1;
  late int totalSteps = stepsData.length;
  List<StepperData> get stepsData => [
        StepperData(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.instance.grey8,
              borderRadius: BorderRadius.circular(10.sw),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.sw, vertical: 12.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create profile'.tr(),
                  style: w500TextStyle(fontSize: 16.sw),
                ),
                Gap(8.sw),
                Divider(
                  color: AppColors.instance.grey5,
                  height: 1.sw,
                ),
                Gap(8.sw),
                Text(
                  'Required documents'.tr(),
                  style: w500TextStyle(fontSize: 14.sw),
                ),
                Gap(4.sw),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRequirementItem(
                        'Personal information (ID, address, contact details)'),
                    Gap(8.sw),
                    _buildRequirementItem('National ID card or passport'),
                    Gap(8.sw),
                    _buildRequirementItem(
                        'EU driving license (category B or higher)'),
                    Gap(8.sw),
                    _buildRequirementItem('Tax identification number'),
                    Gap(8.sw),
                    _buildRequirementItem('Vehicle registration certificate'),
                  ],
                ),
                Gap(12.sw),
                if (currentStep == 1)
                  WidgetAppButtonOK(
                    label: "Send profile".tr(),
                    height: 44.sw,
                    onTap: () async {
                      appHaptic();
                      await context.push('/driver-register/profile');
                      setState(() {});
                    },
                  ),
              ],
            ),
          ),
        ),
        StepperData(
          child: _buildContainerWrapper(
            'Profile Review'.tr(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Our team will verify your information and documents'.tr(),
                  style: w400TextStyle(fontSize: 14.sw),
                ),
                Gap(12.sw),
                Text(
                  'Verification process'.tr(),
                  style: w500TextStyle(fontSize: 14.sw),
                ),
                Gap(4.sw),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRequirementItem('Document authenticity check'),
                    Gap(8.sw),
                    _buildRequirementItem('Background verification'),
                    Gap(8.sw),
                    _buildRequirementItem('Criminal record check'),
                    Gap(8.sw),
                    _buildRequirementItem('Driving history review'),
                  ],
                ),
              ],
            ),
          ),
        ),
        StepperData(
          child: _buildContainerWrapper(
            'Interview & Contract'.tr(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Visit our headquarters for interview and contract signing'
                      .tr(),
                  style: w400TextStyle(fontSize: 14.sw),
                ),
                Gap(12.sw),
                Text(
                  'Interview process'.tr(),
                  style: w500TextStyle(fontSize: 14.sw),
                ),
                Gap(4.sw),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRequirementItem('Professional experience assessment'),
                    Gap(8.sw),
                    _buildRequirementItem('Customer service evaluation'),
                    Gap(8.sw),
                    _buildRequirementItem('Safety protocols understanding'),
                    Gap(8.sw),
                    _buildRequirementItem(
                        'Contract terms discussion and signing'),
                  ],
                ),
              ],
            ),
          ),
        ),
        StepperData(
          child: _buildContainerWrapper(
            'Training'.tr(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete service standards and procedures training'.tr(),
                  style: w400TextStyle(fontSize: 14.sw),
                ),
                Gap(12.sw),
                Text(
                  'Training modules'.tr(),
                  style: w500TextStyle(fontSize: 14.sw),
                ),
                Gap(4.sw),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRequirementItem('Platform usage guidelines'),
                    Gap(8.sw),
                    _buildRequirementItem('Customer service standards'),
                    Gap(8.sw),
                    _buildRequirementItem('Safety protocols'),
                    Gap(8.sw),
                    _buildRequirementItem('Emergency procedures'),
                  ],
                ),
              ],
            ),
          ),
        ),
        StepperData(
          child: _buildContainerWrapper(
            'Completed'.tr(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Congratulations! You have completed all requirements and can now start your partnership with Fastship'
                      .tr(),
                  style: w400TextStyle(fontSize: 14.sw),
                ),
                Gap(12.sw),
                Text(
                  'Your journey begins'.tr(),
                  style: w500TextStyle(fontSize: 14.sw),
                ),
                Gap(4.sw),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRequirementItem(
                        'Your account is now fully activated'),
                    Gap(8.sw),
                    _buildRequirementItem(
                        'Payment system is ready for earnings'),
                    Gap(8.sw),
                    _buildRequirementItem('Vehicle has passed all inspections'),
                    Gap(8.sw),
                    _buildRequirementItem(
                        'You are now an official Fastship partner'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: appColorPrimary,
              boxShadow: [
                BoxShadow(
                  color: appColorPrimary.withOpacity(0.25),
                  blurRadius: 10,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.sw, vertical: 16.sw),
            child: SafeArea(
                top: true,
                bottom: false,
                child: Row(
                  children: [
                    Text(
                      'Driver Register',
                      style:
                          w500TextStyle(fontSize: 20.sw, color: Colors.white),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        appHaptic();
                        context.push('/help-center');
                      },
                      child: Row(
                        children: [
                          Text(
                            'Need help'.tr(),
                            style: w400TextStyle(
                                fontSize: 16.sw, color: Colors.white),
                          ),
                          Gap(2.sw),
                          Icon(
                            Icons.help_center,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/png/bg_register.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.sw, vertical: 24.sw),
                  child: Steppers(
                    direction: StepperDirection.vertical,
                    labels: stepsData,
                    currentStep: currentStep,
                    stepBarStyle: StepperStyle(
                      activeColor: appColorPrimary,
                      inactiveColor: appColorPrimary.withOpacity(0.35),
                      activeBorderColor: appColorPrimary.withOpacity(0.5),
                      maxLineLabel: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

_buildRequirementItem(String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(top: 4.sw),
        child: CircleAvatar(
          radius: 3,
          backgroundColor: AppColors.instance.text,
        ),
      ),
      Gap(8.sw),
      Expanded(
        child: Text(
          text.tr(),
          style: w400TextStyle(fontSize: 14.sw),
        ),
      ),
    ],
  );
}

_buildContainerWrapper(String title, Widget child) {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.instance.grey8,
      borderRadius: BorderRadius.circular(10.sw),
    ),
    padding: EdgeInsets.symmetric(horizontal: 12.sw, vertical: 12.sw),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: w500TextStyle(fontSize: 16.sw),
        ),
        Gap(8.sw),
        Divider(
          color: AppColors.instance.grey5,
          height: 1.sw,
        ),
        Gap(8.sw),
        child,
      ],
    ),
  );
}
