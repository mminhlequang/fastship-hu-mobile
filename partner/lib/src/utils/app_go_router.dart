import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:app/src/presentation/home/cubit/home_cubit.dart';

import '../presentation/home/home_screen.dart';
import '../presentation/page1/bloc/page1_bloc.dart';
import '../presentation/page1/page1_screen.dart';
import '../presentation/page2/page2_screen.dart';
import 'app_get.dart';

GlobalKey<NavigatorState> get appNavigatorKey =>
    findInstance<GlobalKey<NavigatorState>>();
bool get isAppContextReady => appNavigatorKey.currentContext != null;
BuildContext get appContext => appNavigatorKey.currentContext!;

// GoRouter configuration
final goRouter = GoRouter(
  navigatorKey: appNavigatorKey,
  routes: [
    GoRoute(
      name: '/',
      path: '/',

      /// Example register new [bloc] using at [homescreen]
      builder: (context, state) => BlocProvider(
        create: (context) => HomeCubit(),
        child: const HomeScreen(),
      ),
      routes: [
        GoRoute(
          name: 'page1',
          path: 'page1',

          /// Example register new [bloc] using at [Page1Screen]
          builder: (context, state) => BlocProvider(
            create: (context) => Page1Bloc(),
            child: const Page1Screen(),
          ),
        ),
        GoRoute(
          name: 'page2',
          path: 'page2',
          builder: (context, state) => const Page2Screen(),
        ),
      ],
    ),
  ],
);
