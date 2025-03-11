import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../store/store_screen.dart';
import '../orders/orders_screen.dart';
import '../reviews/reviews_screen.dart';
import '../notifications/notifications_screen.dart';
import '../wallet/wallet_screen.dart';
import 'cubit/navigation_cubit.dart';
import 'widgets/custom_bottom_bar.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final List<Widget> _screens = [
    const StoreScreen(),
    const OrdersScreen(),
    const ReviewsScreen(),
    const NotificationsScreen(),
    const WalletScreen(),
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
