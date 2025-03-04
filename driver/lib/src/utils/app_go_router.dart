import 'package:app/src/presentation/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/driver_register/driver_register_screen.dart';
import '../presentation/driver_register/widgets/widget_form_profile.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/splash/splash_screen.dart';
import 'app_get.dart';

GlobalKey<NavigatorState> get appNavigatorKey =>
    findInstance<GlobalKey<NavigatorState>>();
bool get isAppContextReady => appNavigatorKey.currentContext != null;
BuildContext get appContext => appNavigatorKey.currentContext!;

// GoRouter configuration
final goRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: appNavigatorKey,
  routes: [
    GoRoute(
      path: '/', 
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/driver-register',
      builder: (context, state) => const DriverRegisterScreen(),
    ),
    GoRoute(
      path: '/driver-register/profile',
      builder: (context, state) => const WidgetFormProfile(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
