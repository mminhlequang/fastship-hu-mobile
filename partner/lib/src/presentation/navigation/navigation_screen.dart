import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/home/home_screen.dart';
import 'package:app/src/presentation/navigation/cubit/navigation_cubit.dart';
import 'package:app/src/presentation/navigation/widgets/custom_bottom_bar.dart';
import 'package:app/src/presentation/notification/notification_screen.dart';
import 'package:app/src/presentation/orders/orders_screen.dart';
import 'package:app/src/presentation/profile/profile_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      bloc: navigationCubit,
      builder: (context, state) {
        int currentIndex = state.currentIndex;
        String title = switch (currentIndex) {
          0 => 'Bánh cuốn Hồng Liên',
          1 => 'Notification'.tr(),
          2 => 'Orders'.tr(),
          _ => 'Profile'.tr(),
        };

        return Scaffold(
          appBar: AppBar(title: Text(title), titleSpacing: 16.sw),
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
