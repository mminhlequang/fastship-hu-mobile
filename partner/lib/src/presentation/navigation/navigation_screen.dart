import 'package:app/src/presentation/home/home_screen.dart';
import 'package:app/src/presentation/navigation/cubit/navigation_cubit.dart';
import 'package:app/src/presentation/navigation/widgets/custom_bottom_bar.dart';
import 'package:app/src/presentation/notification/notification_screen.dart';
import 'package:app/src/presentation/orders/orders_screen.dart';
import 'package:app/src/presentation/profile/profile_screen.dart';
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
        return Scaffold(
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _screens[state.currentIndex],
          ),
          bottomNavigationBar: CustomBottomBar(
            currentIndex: navigationCubit.state.currentIndex,
            onTap: (index) => navigationCubit.changeIndex(index),
          ),
        );
      },
    );
  }
}
