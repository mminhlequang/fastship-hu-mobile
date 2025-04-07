import 'dart:ui';

import 'package:app/src/base/bloc.dart';
import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';

import 'widgets/widget_wallet.dart';

enum SettingsItem {
  myProfile,
  status,
  incomeStatistics,
  customerReviews,
  changePassword,
  // vehicles,
  helpCenter,
  // deleteAccount,
  logout;

  String get title => switch (this) {
        myProfile => 'My profile'.tr(),
        status => 'Auto active online status'.tr(),
        incomeStatistics => 'Income statistics'.tr(),
        customerReviews => 'Customer’s reviews'.tr(),
        changePassword => 'Change password'.tr(),
        // vehicles => 'Vehicles'.tr(),
        helpCenter => 'Help center'.tr(),
        // deleteAccount => 'Delete account'.tr(),
        logout => 'Log out'.tr(),
      };

  String get icon => switch (this) {
        myProfile => assetsvg('ic_my_profile'),
        status => assetsvg('ic_status'),
        incomeStatistics => assetsvg('ic_income_statistics'),
        customerReviews => assetsvg('ic_review'),
        changePassword => assetsvg('ic_lock'),
        // vehicles => assetsvg('ic_vehicle'),
        helpCenter => assetsvg('ic_support'),
        // deleteAccount => assetsvg('ic_delete_acc'),
        logout => assetsvg('ic_logout'),
      };

  String? get route => switch (this) {
        myProfile => '/my-profile',
        incomeStatistics => '/statistics',
        customerReviews => '/customer-reviews',
        changePassword => '/change-password',
        // vehicles => '/vehicles',
        helpCenter => '/help-center',
        _ => null,
      };
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _autoActiveOnlineStatusController =
      ValueNotifier<bool>(AppPrefs.instance.autoActiveOnlineStatus);
  final _notificationController = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _autoActiveOnlineStatusController.dispose();
    _notificationController.dispose();
    super.dispose();
  }

  _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) {
        return WidgetConfirmDialog(
          title: 'Delete account'.tr(),
          subTitle: 'Are you sure you want to delete your account?'.tr(),
          onConfirm: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext dialogContext) {
                Future.delayed(
                  const Duration(seconds: 2),
                  () {
                    if (mounted) {
                      Navigator.of(dialogContext).pop();
                      authCubit.logout();
                    }
                  },
                );
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Center(
                    child: Material(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        width: appContext.width - 112.sw,
                        padding: EdgeInsets.all(20.sw),
                        constraints: BoxConstraints(maxWidth: 264.sw),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const WidgetAppSVG('ic_check_circle'),
                            Gap(15.sw),
                            Text(
                              'Your account deletion request was successful! You will now be logged out.'
                                  .tr(),
                              style: w400TextStyle(color: grey1),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  _logout() {
    showDialog(
      context: context,
      builder: (context) {
        return WidgetConfirmDialog(
          title: 'Log out'.tr(),
          subTitle: 'Do you really want to log out?'.tr(),
          onConfirm: authCubit.logout,
        );
      },
    );
  }

  void onTap(SettingsItem item) {
    switch (item) {
      // case SettingsItem.deleteAccount:
      //   _deleteAccount();
      //   break;
      case SettingsItem.logout:
        _logout();
        break;
      default:
        appContext.push(item.route!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: [
                  Container(
                    height: 230.sw + context.mediaQueryPadding.top,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(assetpng('setting_background')),
                        fit: BoxFit.fill,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.sw),
                    child: SafeArea(
                      bottom: false,
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Gap(36.sw),
                              Row(
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      WidgetAppSVG(
                                        assetsvg('avatar_border'),
                                        width: 66.sw,
                                        height: 66.sw,
                                      ),
                                      WidgetAvatar.withoutBorder(
                                        imageUrl:
                                            AppPrefs.instance.user?.avatar,
                                        radius: 56.sw / 2,
                                        errorAsset: assetpng('defaultavatar'),
                                      )
                                    ],
                                  ),
                                  Gap(12.sw),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppPrefs.instance.user?.name ?? '',
                                          style: w500TextStyle(
                                            fontSize: 16.sw,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Gap(4.sw),
                                        Text(
                                          AppPrefs.instance.user?.phone ?? '',
                                          style: w400TextStyle(
                                            color: Colors.white
                                                .withValues(alpha: .6),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const Spacer(),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12.sw),
                            child: CloseButton(
                              color: Colors.white,
                              style: ButtonStyle(
                                iconSize: WidgetStateProperty.resolveWith(
                                    (_) => 28.sw),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 20.sw, color: Colors.white),
                ],
              ),
              Positioned(
                left: 16.sw,
                right: 16.sw,
                child: WidgetWallet(
                  onTap: () {
                    appHaptic();
                    context.push('/wallet');
                  },
                ),
              ),
            ],
          ),
          Gap(8.sw),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: SettingsItem.values.length + 1,
              separatorBuilder: (context, index) => const AppDivider(),
              itemBuilder: (context, index) {
                if (index == SettingsItem.values.length) {
                  return Container(height: 100.sw);
                }
                final item = SettingsItem.values[index];
                return WidgetRippleButton(
                  onTap: item == SettingsItem.status
                      ? null
                      : () {
                          onTap(item);
                        },
                  radius: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.sw, vertical: 14.sw),
                    child: Row(
                      children: [
                        WidgetAppSVG(item.icon),
                        Gap(8.sw),
                        Expanded(
                          child: Text(
                            item.title,
                            style: w400TextStyle(fontSize: 16.sw),
                          ),
                        ),
                        if (item.route != null) WidgetAppSVG('chevron_right'),
                        if (item == SettingsItem.status)
                          AdvancedSwitch(
                            controller: _autoActiveOnlineStatusController,
                            height: 22.sw,
                            width: 40.sw,
                            activeColor: appColorPrimary,
                            inactiveColor: hexColor('#E2E2EF'),
                            onChanged: (value) {
                              AppPrefs.instance.autoActiveOnlineStatus = value;
                            },
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
