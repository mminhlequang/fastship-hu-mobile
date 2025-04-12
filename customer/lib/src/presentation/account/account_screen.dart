import 'package:app/src/base/auth/auth_cubit.dart';
import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widget_dialog_confirm.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';

import '../widgets/widget_appbar.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
    // Khởi tạo dữ liệu khi cần
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          WidgetAppBar(
            showBackButton: false,
            title: 'Profile Settings'.tr(),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProfileSection(),
                  _buildMenuSection(),
                  _buildSupportSection(),
                  _buildLogoutButton(),
                  SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Stack(
      children: [
        Container(
          height: 140,
          decoration: BoxDecoration(
            color: appColorPrimaryOrange,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
          child: Column(
            children: [
              Row(
                children: [
                  WidgetAvatar(
                    imageUrl: AppPrefs.instance.user?.avatar ?? '',
                    radius1: 64 / 2,
                    radius2: 64 / 2 - 2,
                    radius3: 64 / 2 - 2,
                    borderColor: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  AppPrefs.instance.user?.name ?? '',
                                  style: w500TextStyle(
                                    fontSize: 22.sw,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppPrefs.instance.user?.phone ?? '',
                              style: w400TextStyle(
                                fontSize: 14.sw,
                                color: const Color(0xFFF1EFE9),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 24, height: 24),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoItem('Point', '10000 Point', 'icon74'),
                    WidgetInkWellTransparent(
                      onTap: () {
                        appHaptic();
                        context.push('/vouchers');
                      },
                      child: _buildInfoItem(
                        'Voucher'.tr(),
                        '400+ voucher',
                        'icon73',
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String title, String value, String imageUrl) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4F4),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: WidgetAppSVG(
              imageUrl,
              width: 28,
              height: 28,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: w500TextStyle(
                fontSize: 16.sw,
                color: const Color(0xFF120F0F),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: w400TextStyle(
                fontSize: 14.sw,
                color: appColorPrimaryOrange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuSection() {
    return Container(
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1EFE9)),
      ),
      child: Column(
        spacing: 8.sw,
        children: [
          _buildMenuItem('Personal Data', 'icon70', () {
            appContext.push("/personal-data");
          }),
          _buildMenuItem('My Favorite', 'icon65', () {
            appContext.push("/my-favorite");
          }),
          _buildMenuItem('Settings', 'icon71', () {
            appContext.push("/settings");
          }),
          // _buildMenuItem('Security', 'icon72', () {
          //   appContext.push("/security");
          // }),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 24),
          child: Text(
            'Support'.tr(),
            style: w400TextStyle(
              fontSize: 14.sw,
              color: const Color(0xFF878787),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 7, left: 16, right: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF1EFE9)),
          ),
          child: Column(
            spacing: 8.sw,
            children: [
              _buildMenuItem('Help Center', 'icon67', () {
                appContext.push("/help-center");
              }),
              _buildMenuItem('Request Account Deletion', 'icon70', () async {
                final r = await appOpenDialog(WidgetDialogConfirm(
                  title: "Request Account Deletion".tr(),
                  message: "Are you sure you want to delete your account?".tr(),
                ));
                if (r) {
                  // authCubit.logout();
                  // appContext.pushReplacement("/auth");
                }
              }),
              // _buildMenuItem('Add another account', 'icon70'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(String title, String imageUrl, [VoidCallback? onTap]) {
    return WidgetInkWellTransparent(
      enableInkWell: false,
      onTap: () {
        appHaptic();
        if (onTap != null) {
          onTap();
        }
      },
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F4),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: WidgetAppSVG(
                imageUrl,
                width: 24,
                height: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: w400TextStyle(
                fontSize: 16.sw,
                color: const Color(0xFF3C3836),
              ),
            ),
          ),
          SizedBox(
            width: 20,
            height: 20,
            child: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: const Color(0xFF3C3836),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: TextButton(
        onPressed: () async {
          appHaptic();
          final r = await appOpenDialog(WidgetDialogConfirm(
            title: "Log out".tr(),
            message: "Are you sure you want to log out?".tr(),
          ));
          if (r) {
            authCubit.logout();
            appContext.pushReplacement("/auth");
          }
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(120),
            side: BorderSide(color: appColorPrimaryOrange),
          ),
          backgroundColor: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WidgetAppSVG(
              'icon69',
              color: appColorPrimaryOrange,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 10),
            Text(
              'Log out'.tr(),
              style: w400TextStyle(
                fontSize: 18.sw,
                color: appColorPrimaryOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
