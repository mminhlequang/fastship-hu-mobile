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
  notifications,
  incomeStatistics,
  customerReviews,
  changePassword,
  vehicles,
  helpCenter,
  deleteAccount,
  logout;

  String get title => switch (this) {
        myProfile => 'My profile'.tr(),
        status => 'Status'.tr(),
        notifications => 'Notifications'.tr(),
        incomeStatistics => 'Income statistics'.tr(),
        customerReviews => 'Customer’s reviews'.tr(),
        changePassword => 'Change password'.tr(),
        vehicles => 'Vehicles'.tr(),
        helpCenter => 'Help center'.tr(),
        deleteAccount => 'Delete account'.tr(),
        logout => 'Log out'.tr(),
      };

  String get icon => switch (this) {
        myProfile => assetsvg('ic_my_profile'),
        status => assetsvg('ic_status'),
        notifications => assetsvg('ic_notification'),
        incomeStatistics => assetsvg('ic_income_statistics'),
        customerReviews => assetsvg('ic_review'),
        changePassword => assetsvg('ic_lock'),
        vehicles => assetsvg('ic_vehicle'),
        helpCenter => assetsvg('ic_support'),
        deleteAccount => assetsvg('ic_delete_acc'),
        logout => assetsvg('ic_logout'),
      };

  String? get route => switch (this) {
        myProfile => '',
        incomeStatistics => '/statistics',
        customerReviews => '',
        changePassword => '',
        vehicles => '',
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
  final _statusController = ValueNotifier<bool>(true);
  final _notificationController = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _statusController.dispose();
    _notificationController.dispose();
    super.dispose();
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
                        image: AssetImage(assetpng('setting_backgorund')),
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
                              Gap(context.mediaQueryPadding.top + 36.sw),
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
                                        imageUrl: AppPrefs.instance.user?.avatar,
                                        radius: 56.sw / 2,
                                        errorAsset: assetpng('defaultavatar'),
                                      )
                                    ],
                                  ),
                                  Gap(12.sw),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                            color: Colors.white.withValues(alpha: .6),
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
                                iconSize: WidgetStateProperty.resolveWith((_) => 28.sw),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 30.sw, color: Colors.white),
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
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: SettingsItem.values.length,
              separatorBuilder: (context, index) => const AppDivider(),
              itemBuilder: (context, index) {
                final item = SettingsItem.values[index];
                return WidgetRippleButton(
                  onTap: item == SettingsItem.status || item == SettingsItem.notifications
                      ? null
                      : () {
                          // Todo:
                        },
                  radius: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 14.sw),
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
                            controller: _statusController,
                            height: 22.sw,
                            width: 40.sw,
                            activeColor: appColorPrimary,
                            inactiveColor: hexColor('#E2E2EF'),
                          ),
                        if (item == SettingsItem.notifications)
                          AdvancedSwitch(
                            controller: _notificationController,
                            height: 22.sw,
                            width: 40.sw,
                            activeColor: appColorPrimary,
                            inactiveColor: hexColor('#E2E2EF'),
                          )
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
