import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home/home_screen.dart';
import '../food/food_screen.dart';
import '../cart/cart_screen.dart';
import '../orders/orders_screen.dart';
import '../account/account_screen.dart';
import 'cubit/navigation_cubit.dart';
import 'widgets/custom_bottom_bar.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      bloc: navigationCubit,
      builder: (context, state) {
        return Scaffold(
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildScreen(state.currentIndex),
          ),
          bottomNavigationBar: CustomBottomBar(
            currentIndex: navigationCubit.state.currentIndex,
            onTap: (index) => navigationCubit.changeIndex(index),
          ),
        );
      },
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return HomeScreen(key: ValueKey('home'));
      case 1:
        return FoodScreen(key: ValueKey('food'));
      case 2:
        return CartScreen(key: ValueKey('cart'));
      case 3:
        return OrdersScreen(key: ValueKey('orders'));
      case 4:
        return AccountScreen(key: ValueKey('account'));
      default:
        return HomeScreen(key: ValueKey('home'));
    }
  }
}
