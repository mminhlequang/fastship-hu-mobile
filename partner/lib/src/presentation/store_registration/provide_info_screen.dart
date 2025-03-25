import 'dart:convert';

import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/store_registration/cubit/store_registration_cubit.dart';
import 'package:app/src/presentation/store_registration/widgets/widget_bottomsheet.dart';
import 'package:app/src/presentation/store_registration/widgets/widget_form_profile_1.dart';
import 'package:app/src/presentation/store_registration/widgets/widget_form_profile_2.dart';
import 'package:app/src/presentation/store_registration/widgets/widget_form_profile_3.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/app_prefs.dart';
import 'package:app/src/utils/app_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internal_core/extensions/context_extension.dart';
import 'package:internal_core/extensions/date_extension.dart';
import 'package:internal_core/setup/app_textstyles.dart';
import 'package:internal_core/setup/app_utils.dart';
import 'package:internal_core/internal_core.dart';
import 'package:app/src/network_resources/auth/models/models.dart';

class ProvideInfoScreen extends StatelessWidget {
  const ProvideInfoScreen({super.key});

  List<String> get allSteps => [
        'Basic Information'.tr(),
        'Representative Information'.tr(),
        'Detail Information'.tr()
      ];

  Widget _buildStepper(BuildContext context, StoreRegistrationState state,
      StoreRegistrationCubit cubit) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: 8.sw,
        right: 24.sw,
        top: 4.sw + context.mediaQueryPadding.top,
        bottom: 20.sw,
      ),
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
                icon: WidgetAppSVG('chevron-left', width: 24.sw),
              ),
              Gap(12.sw),
              Expanded(
                child: Row(
                  spacing: 8.sw,
                  children: List.generate(
                    allSteps.length,
                    (index) {
                      return Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: index <= state.currentStep2 - 1
                                ? appColorPrimary
                                : grey7,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          height: 5.sw,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Gap(8.sw),
          Padding(
            padding: EdgeInsets.only(left: 8.sw),
            child: Text(
              allSteps[state.currentStep2 - 1],
              style: w500TextStyle(fontSize: 18.sw),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context,
      StoreRegistrationState state, StoreRegistrationCubit cubit) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16.sw, 10.sw, 16.sw, 10.sw + context.mediaQueryPadding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: appColorBackground)),
      ),
      child: Row(
        children: [
          Expanded(
            child: WidgetAppButtonCancel(
              onTap: () {
                appHaptic();
                if (state.currentStep2 > 1) {
                  cubit.previousStep2();
                } else {
                  context.pop();
                }
              },
              label: 'Back'.tr(),
              height: 48.sw,
            ),
          ),
          Gap(10.sw),
          Expanded(
            child: WidgetAppButtonOK(
              loading: state.isLoading,
              onTap: () {
                appHaptic();
                if (state.currentStep2 < 3) {
                  cubit.nextStep2();
                } else {
                  _processSubmit(context, cubit);
                }
              },
              enable: state.isEnableProvideInfoContinue,
              label: 'Continue'.tr(),
              height: 48.sw,
            ),
          ),
        ],
      ),
    );
  }

  void _processSubmit(BuildContext context, StoreRegistrationCubit cubit) {
    final _processor = ValueNotifier<String>('loading');

    appOpenBottomSheet(
      WidgetBottomSheetProcess(
        processer: _processor,
        onTryAgain: () {
          cubit.submitStoreRegistration();
        },
      ),
      isDismissible: false,
    ).then((r) {
      if (r == true) {
        AccountModel user = AppPrefs.instance.user!;
        user.profile!.stepId = 2;
        AppPrefs.instance.user = user;
        if (context.mounted) context.pop();
      }
    });

    cubit.submitStoreRegistration().then((success) {
      print('success: $success');
      if (success) {
        _processor.value = 'success';
      } else {
        _processor.value = 'error';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreRegistrationCubit, StoreRegistrationState>(
      builder: (context, state) {
        final cubit = context.read<StoreRegistrationCubit>();

        return GestureDetector(
          onTap: appHideKeyboard,
          child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepper(context, state, cubit),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: switch (state.currentStep2) {
                        1 => WidgetFormProfile1(
                            initialData: state.basicInfo,
                            onChanged: (data) {
                              cubit.updatePersonalInfo(data);
                            },
                          ),
                        2 => WidgetFormProfile2(
                            initialData: state.idCardImages,
                            onChanged: (data) {
                              cubit.updateIdCardImages(data);
                            },
                          ),
                        _ => WidgetFormProfile3(
                            initialData: state.detailInfos,
                            onChanged: (data) {
                              cubit.updateDetailInfo(data);
                            },
                          ),
                      },
                    ),
                  ),
                ),
                _buildBottomNavigation(context, state, cubit),
              ],
            ),
          ),
        );
      },
    );
  }
}
