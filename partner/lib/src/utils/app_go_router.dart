import 'package:app/src/presentation/create_store/create_store_screen.dart';
import 'package:app/src/presentation/merchant_onboarding/merchant_onboarding_screen.dart';
import 'package:app/src/presentation/splash/splash_screen.dart';
import 'package:app/src/presentation/store_registration/export.dart';
import 'package:app/src/presentation/store_registration/widgets/widget_opening_time.dart';
import 'package:app/src/presentation/store_registration/widgets/widget_service_type.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/navigation/navigation_screen.dart';
import '../presentation/socket_shell/socket_shell_wrapper.dart';
import '../presentation/socket_shell/widgets/location_permission_wraper.dart';
import 'app_get.dart';

GlobalKey<NavigatorState> get appNavigatorKey => findInstance<GlobalKey<NavigatorState>>();
bool get isAppContextReady => appNavigatorKey.currentContext != null;
BuildContext get appContext => appNavigatorKey.currentContext!;

// GoRouter configuration
final goRouter = GoRouter(
  navigatorKey: appNavigatorKey,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/activity-area',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ActivityAreaScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ),
    GoRoute(
      path: '/select-area',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SelectAreaScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ),
    GoRoute(
      path: '/store-registration',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const StoreRegistrationScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ),
    GoRoute(
      path: '/provide-info',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ProvideInfoScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ),
    GoRoute(
      path: '/provide-info/opening-time',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const WidgetOpeningTime(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ),
    GoRoute(
      path: '/provide-info/service-type',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const WidgetServiceType(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ),
    GoRoute(
      path: '/merchant-onboarding',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const MerchantOnboardingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ),
    GoRoute(
      path: '/create-store',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const CreateStoreScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ),
    ShellRoute(
      parentNavigatorKey: appNavigatorKey,
      pageBuilder: (context, state, child) {
        return NoTransitionPage(
          child: LocationPermissionWrapper(
            child: SocketShellWrapper(
              child: child,
            ),
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/navigation',
          builder: (context, state) => const NavigationScreen(),
        ),
      ],
    ),
  ],
);
