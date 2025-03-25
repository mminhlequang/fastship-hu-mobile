import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/store_registration/cubit/store_registration_cubit.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/extensions/extensions.dart';
import 'package:internal_core/setup/app_textstyles.dart';
import 'package:internal_core/widgets/widgets.dart';

class StoreRegistrationScreen extends StatelessWidget {
  const StoreRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreRegistrationCubit, StoreRegistrationState>(
      builder: (context, state) {
        final cubit = context.read<StoreRegistrationCubit>();
        Widget child = switch (state.currentStep1) {
          1 => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select service type'.tr(),
                  style: w600TextStyle(fontSize: 16.sw),
                ),
                Gap(13.sw),
                ...List.generate(
                  2,
                  (index) {
                    return WidgetInkWellTransparent(
                      onTap: () {
                        cubit.updateSelectedService(index);
                      },
                      enableInkWell: false,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 13.sw),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                WidgetAppSVG(
                                  index == state.selectedService
                                      ? 'radio-check'
                                      : 'radio-uncheck',
                                  width: 24.sw,
                                ),
                                Gap(8.sw),
                                Expanded(
                                  child: Text(
                                    index == 0
                                        ? 'Food delivery (For restaurants, cafes, etc.)'
                                            .tr()
                                        : 'Supermarket and grocery delivery'
                                            .tr(),
                                    style: w600TextStyle(),
                                  ),
                                ),
                              ],
                            ),
                            Gap(4.sw),
                            Padding(
                              padding: EdgeInsets.only(left: 32.sw),
                              child: Text(
                                index == 0
                                    ? 'The main dishes of the shop are prepared food and drinks.'
                                        .tr()
                                    : 'The main dishes of the shop are prepared food and drinks.'
                                        .tr(),
                                style: w400TextStyle(color: grey1),
                              ),
                            ),
                            if (index == 0) ...[
                              Gap(12.sw),
                              Padding(
                                padding: EdgeInsets.only(left: 32.sw),
                                child: const AppDivider(),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 32.sw,
                                  top: 12.sw,
                                  bottom: 12.sw,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Do you sell alcoholic beverages?'.tr(),
                                        style: w400TextStyle(),
                                      ),
                                    ),
                                    Gap(20.sw),
                                    WidgetInkWellTransparent(
                                      onTap: () {
                                        cubit.updateHasAlcohol(true);
                                      },
                                      enableInkWell: false,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          WidgetAppSVG(state.hasAlcohol == true
                                              ? 'radio-check'
                                              : 'radio-uncheck'),
                                          Gap(8.sw),
                                          Text(
                                            'Yes'.tr(),
                                            style: w400TextStyle(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Gap(24.sw),
                                    WidgetInkWellTransparent(
                                      onTap: () {
                                        cubit.updateHasAlcohol(false);
                                      },
                                      enableInkWell: false,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          WidgetAppSVG(state.hasAlcohol == false
                                              ? 'radio-check'
                                              : 'radio-uncheck'),
                                          Gap(8.sw),
                                          Text(
                                            'No'.tr(),
                                            style: w400TextStyle(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 32.sw),
                                child: const AppDivider(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          2 => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Related documents'.tr(),
                  style: w600TextStyle(fontSize: 16.sw),
                ),
                Gap(16.sw),
                Text(
                  'Related document information'.tr(),
                  style: w600TextStyle(),
                ),
                Gap(8.sw),
                Row(
                  children: [
                    CircleAvatar(radius: 2, backgroundColor: appColorText),
                    Gap(8.sw),
                    Expanded(
                      child: Text(
                        'ID/Passport'.tr(),
                        style: w400TextStyle(),
                      ),
                    ),
                  ],
                ),
                Gap(4.sw),
                Row(
                  children: [
                    CircleAvatar(radius: 2, backgroundColor: appColorText),
                    Gap(8.sw),
                    Expanded(
                      child: Text(
                        'Business registration certificate'.tr(),
                        style: w400TextStyle(),
                      ),
                    ),
                  ],
                ),
                Gap(4.sw),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 7.sw),
                      child: CircleAvatar(
                          radius: 2, backgroundColor: appColorText),
                    ),
                    Gap(8.sw),
                    Expanded(
                      child: Text(
                        'Menu/Product List photos, cover photo, profile photo, individual dish photos and store front'
                            .tr(),
                        style: w400TextStyle(),
                      ),
                    ),
                  ],
                ),
                Gap(4.sw),
                Row(
                  children: [
                    CircleAvatar(radius: 2, backgroundColor: appColorText),
                    Gap(8.sw),
                    Expanded(
                      child: Text(
                        'Bank account information'.tr(),
                        style: w400TextStyle(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          _ => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Please read the terms and conditions'.tr(),
                  style: w600TextStyle(fontSize: 16.sw),
                ),
                Gap(16.sw),
                Container(height: 192.sw, color: Colors.grey),
                Gap(16.sw),
                WidgetInkWellTransparent(
                  onTap: () {
                    cubit.updateAcceptTerms(!state.acceptTerms);
                  },
                  enableInkWell: false,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WidgetAppSVG(
                        state.acceptTerms ? 'check-box' : 'uncheck-box',
                        width: 20.sw,
                      ),
                      Gap(4.sw),
                      Expanded(
                        child: Text(
                          'I confirm that I have read all the terms and conditions stated above.'
                              .tr(),
                          style: w400TextStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        };

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Store registration'.tr()),
            leading: BackButton(
              onPressed: () {
                if (state.currentStep1 > 1) {
                  cubit.previousStep1();
                } else {
                  appContext.pop();
                }
              },
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.sw),
                  child: child,
                ),
              ),
              const AppDivider(),
              Padding(
                padding: EdgeInsets.fromLTRB(16.sw, 10.sw, 16.sw,
                    10.sw + context.mediaQueryPadding.bottom),
                child: WidgetRippleButton(
                  onTap: () {
                    if (state.currentStep1 < state.totalStep1) {
                      cubit.nextStep1();
                    } else {
                      appContext.push('/provide-info');
                    }
                  },
                  radius: 10.sw,
                  enable: state.currentStep1 != state.totalStep1 ||
                      state.acceptTerms,
                  color: appColorPrimary,
                  child: SizedBox(
                    height: 48.sw,
                    child: Center(
                      child: Text(
                        'Continue'.tr(),
                        style:
                            w500TextStyle(fontSize: 16.sw, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
