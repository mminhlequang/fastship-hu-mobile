import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home/home_screen.dart';
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
            child: state.currentIndex == 0 ? HomeScreen() : SizedBox(),
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
