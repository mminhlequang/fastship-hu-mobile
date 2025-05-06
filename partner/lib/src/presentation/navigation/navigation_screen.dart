import 'package:app/src/base/bloc.dart';
import 'package:app/src/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/constants/constants.dart';
import 'package:network_resources/auth/repo.dart';
import 'package:app/src/presentation/home/home_screen.dart';
import 'package:app/src/presentation/navigation/cubit/navigation_cubit.dart';
import 'package:app/src/presentation/navigation/widgets/custom_bottom_bar.dart';
import 'package:app/src/presentation/notifications/notifications_screen.dart';
import 'package:app/src/presentation/orders/orders_screen.dart';
import 'package:app/src/presentation/profile/profile_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';
import 'package:permission_handler/permission_handler.dart';

import '../notifications/cubit/notification_cubit.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final List<Widget> _screens = const [
    HomeScreen(),
    NotificationScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    notificationCubit.fetchNotifications();
    _checkNotificationPermission().then((_) async {
      AuthRepo().updateDeviceToken(
          {'device_token': await FirebaseMessaging.instance.getToken()});
    });
  }

  Future<void> _checkNotificationPermission() async {
    final status = await Permission.notification.status;

    if (status.isGranted) {
      return;
    }

    final bool? userResponse = await _showPermissionExplanationDialog();

    if (userResponse == true) {
      await Permission.notification.request();
    }
  }

  Future<bool?> _showPermissionExplanationDialog() async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 300),
      ),
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: 24.sw + context.mediaQueryPadding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 375 / 255,
                child: SizedBox(
                  width: context.width,
                  child: Image.asset(
                    assetpng('bg_noti_permission'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Gap(24.sw),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sw),
                child: Text(
                  'Don’t miss anything'.tr(),
                  style: w700TextStyle(fontSize: 20.sw),
                ),
              ),
              Gap(8.sw),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sw),
                child: Text(
                  'You will receive push notification from Fast Ship like News and Balance alert.'
                      .tr(),
                  style: w400TextStyle(fontSize: 16.sw),
                  textAlign: TextAlign.center,
                ),
              ),
              Gap(32.sw),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sw),
                child: WidgetRippleButton(
                  onTap: () => Navigator.pop(context, true),
                  color: appColorPrimary,
                  child: SizedBox(
                    height: 48.sw,
                    child: Center(
                      child: Text(
                        'Turn on Notification'.tr(),
                        style: w500TextStyle(
                          fontSize: 16.sw,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Gap(8.sw),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sw),
                child: WidgetRippleButton(
                  onTap: () => Navigator.pop(context, false),
                  borderSide: BorderSide(color: appColorPrimary),
                  child: SizedBox(
                    height: 48.sw,
                    child: Center(
                      child: Text(
                        'Not now'.tr(),
                        style: w500TextStyle(
                          fontSize: 16.sw,
                          color: appColorPrimary,
                        ),
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      bloc: navigationCubit,
      builder: (context, state) {
        int currentIndex = state.currentIndex;
        String storeName = authCubit.state.store?.name ?? 'Unnamed Store';
        String title = switch (currentIndex) {
          0 => storeName,
          1 => '$storeName\'s ${'Notification'.tr()}',
          2 => '$storeName\'s ${'Orders'.tr()}',
          _ => '$storeName\'s ${'Profile'.tr()}',
        };

        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: GestureDetector(
              onTap: () => clearAllRouters('/merchant-onboarding'),
              child: Text(title),
            ),
            titleSpacing: 16.sw,
            actionsPadding: EdgeInsets.only(right: 8.sw),
            actions: [
              IconButton(
                onPressed: () => clearAllRouters('/merchant-onboarding'),
                icon: Icon(
                  Icons.store_mall_directory_rounded,
                  size: 28.sw,
                  color: Colors.white,
                ),
              )
            ],
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _screens[currentIndex],
          ),
          bottomNavigationBar: CustomBottomBar(
            currentIndex: currentIndex,
            onTap: (index) => navigationCubit.changeIndex(index),
          ),
        );
      },
    );
  }
}
