import 'package:app/src/presentation/login/login_screen.dart';
import 'package:app/src/presentation/otp/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      // builder: (context, state) => BlocProvider(
      //   create: (context) => HomeCubit(),
      //   child: const HomeScreen(),
      // ),
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: 'otp',
      path: '/otp',
      builder: (context, state) => OtpScreen(args: state.extra as OtpArgs),
    ),
  ],
);
