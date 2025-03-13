import 'package:app/src/constants/constants.dart';
import 'package:app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';

import 'widgets/widget_wallet.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 244.sw + context.mediaQueryPadding.top,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(assetpng('setting_backgorund')),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.sw),
            child: SafeArea(
              bottom: false,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Column(
                    children: [
                      Gap(context.mediaQueryPadding.top),
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
                                      fontSize: 18.sw, color: Colors.white),
                                ),
                                Gap(4.sw),
                                Text(
                                  AppPrefs.instance.user?.phone ?? '',
                                  style: w300TextStyle(
                                      fontSize: 16.sw, color: Colors.white),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Spacer(),
                      WidgetWallet(
                        onTap: () {
                          appHaptic();
                          context.push('/wallet');
                        },
                      ),
                      Gap(20.sw),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.sw),
                    child: GestureDetector(
                      onTap: () {
                        appHaptic();
                        context.pop();
                      },
                      child: Icon(
                        Icons.close_rounded,
                        size: 28.sw,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ColoredBox(
              color: AppColors.instance.grey6,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildButton('Statistics', 'wallet', () {
                      appHaptic();
                      context.push('/statistics');
                    }),
                    _divider(),
                    _buildButton('Help Center', 'wallet', () {
                      appHaptic();
                      context.push('/help-center');
                    }),
                    _divider(),
                    _buildButton('My Wallet', 'wallet', () {
                      appHaptic();
                      context.push('/wallet');
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1.sw,
      color: hexColor('F2F2F2'),
    );
  }

  Widget _buildButton(String title, String icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16.sw, horizontal: 20.sw),
        child: Row(
          children: [
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 24.sw,
              color: AppColors.instance.grey4,
            ),
            Gap(8.sw),
            Expanded(
              child: Text(
                title,
                style: w400TextStyle(fontSize: 16.sw, color: appColorText),
              ),
            ),
            Gap(8.sw),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20.sw,
              color: AppColors.instance.grey4,
            ),
          ],
        ),
      ),
    );
  }
}
