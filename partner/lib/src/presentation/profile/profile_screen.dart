import 'package:app/src/base/bloc.dart';
import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/network_resources.dart';
import 'package:url_launcher/url_launcher.dart';

enum ProfileItem {
  myProfile,
  storeSettings,
  // orderSettings,
  helpCenter,
  settings,
  deleteAccount,
  logout;

  String get title => switch (this) {
        myProfile => 'My profile'.tr(),
        storeSettings => 'Store settings'.tr(),
        // orderSettings => 'Order settings'.tr(),
        helpCenter => 'Help center'.tr(),
        settings => 'Preference Settings'.tr(),
        deleteAccount => 'Delete account'.tr(),
        logout => 'Log out'.tr(),
      };

  String get icon => switch (this) {
        myProfile => assetsvg('ic_my_profile'),
        storeSettings => assetsvg('ic_store_2'),
        // orderSettings => assetsvg('ic_order_settings'),
        helpCenter => assetsvg('ic_support'),
        settings => assetsvg('ic_settings'),
        deleteAccount => assetsvg('ic_delete_acc'),
        logout => assetsvg('ic_logout'),
      };

  String? get route => switch (this) {
        myProfile => '/my-profile',
        storeSettings => '/store-settings',
        // orderSettings => '/order-settings',
        settings => '/preference-settings',
        helpCenter => '/help-center',
        _ => null,
      };
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) {
        return WidgetConfirmDialog(
          title: 'Delete account'.tr(),
          subTitle: 'Are you sure you want to delete your account?'.tr(),
          onConfirm: () {
            launchUrl(Uri.parse(privacyPolicyUrl));
            authCubit.logout();
          },
        );
      },
    );
  }

  void _logout() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.separated(
        itemCount: ProfileItem.values.length,
        separatorBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sw),
          child: AppDivider(color: grey8),
        ),
        itemBuilder: (context, index) {
          if (index == ProfileItem.values.length) {
            return Container(height: 100.sw);
          }
          final item = ProfileItem.values[index];
          return WidgetRippleButton(
            onTap: () {
              switch (item) {
                // case ProfileItem.deleteAccount:
                //   _deleteAccount();
                //   break;
                case ProfileItem.logout:
                  _logout();
                  break;
                default:
                  appContext.push(item.route!);
              }
            },
            radius: 0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.sw, 16.sw, 12.sw, 16.sw),
              child: Row(
                children: [
                  WidgetAppSVG(item.icon, width: 24.sw),
                  Gap(8.sw),
                  Expanded(
                    child: Text(
                      item.title,
                      style: w400TextStyle(fontSize: 16.sw),
                    ),
                  ),
                  if (item.route != null)
                    WidgetAppSVG('chevron-right', color: grey9),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
