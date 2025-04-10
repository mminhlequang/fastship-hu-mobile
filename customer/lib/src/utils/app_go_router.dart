import 'package:app/src/presentation/restaurant_detail/restaurant_detail_screen.dart';
import 'package:app/src/presentation/splash/splash_screen.dart';
import 'package:app/src/presentation/checkout/checkout_tracking_screen.dart';
import 'package:app/src/presentation/checkout/cubit/checkout_cubit.dart';
import 'package:app/src/presentation/cart/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:network_resources/voucher/models/models.dart';

import '../presentation/account/widgets/widget_help_center.dart';
import '../presentation/account/widgets/widget_my_favorite.dart';
import '../presentation/account/widgets/widget_personal_data.dart';
import '../presentation/account/widgets/widget_settings.dart';
import '../presentation/auth/auth_screen.dart';
import '../presentation/checkout/widgets/widget_cancel_order.dart';
import '../presentation/navigation/navigation_screen.dart';
import '../presentation/notifications/notifications_screen.dart';
import '../presentation/socket_shell/socket_shell_wrapper.dart';
import '../presentation/socket_shell/widgets/location_permission_wraper.dart';
import '../presentation/vouchers/vouchers_screen.dart';
import '../presentation/vouchers/widgets/voucher_detail_screen.dart';
import 'app_get.dart';

GlobalKey<NavigatorState> get appNavigatorKey =>
    findInstance<GlobalKey<NavigatorState>>();
bool get isAppContextReady => appNavigatorKey.currentContext != null;
BuildContext get appContext => appNavigatorKey.currentContext!;

clearAllRouters([String? router]) {
  try {
    while (appContext.canPop() == true) {
      appContext.pop();
    }
  } catch (_) {}
  if (router != null) {
    appContext.pushReplacement(router);
  }
}

pushWidget(
    {required child,
    String? routeName,
    bool opaque = true,
    bool replacement = false}) {
  if (replacement) {
    return Navigator.of(appContext).pushReplacement(PageRouteBuilder(
      opaque: opaque,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
      settings: RouteSettings(name: routeName),
    ));
  } else {
    return Navigator.of(appContext).push(PageRouteBuilder(
      opaque: opaque,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
      settings: RouteSettings(name: routeName),
    ));
  }
}

// GoRouter configuration
final goRouter = GoRouter(
  navigatorKey: appNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
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
        GoRoute(
          path: '/restaurant-detail/:id',
          builder: (context, state) => RestaurantDetailScreen(
            id: state.pathParameters['id'] ?? '',
          ),
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) {
            return const NotificationsScreen();
          },
        ),
        GoRoute(
          path: '/help-center',
          builder: (context, state) => const HelpCenterScreen(),
        ),
        GoRoute(
          path: '/my-favorite',
          builder: (context, state) => const MyFavoriteScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/personal-data',
          builder: (context, state) => const PersonalDataScreen(),
        ),
        GoRoute(
          path: '/checkout-tracking',
          builder: (context, state) => const CheckoutTrackingScreen(),
        ),
        GoRoute(
          path: '/cancel-order',
          builder: (context, state) => const CancelOrderScreen(),
        ),
        GoRoute(
          path: '/vouchers',
          builder: (context, state) =>   VouchersScreen(storeId: state.extra as int?),
        ),
        GoRoute(
          path: '/vouchers-detail',
          builder: (context, state) =>
              VoucherDetailScreen(voucher: state.extra as VoucherModel),
        ),
      ],
    ),
  ],
);
