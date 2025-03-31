import 'package:app/src/presentation/restaurant_detail/restaurant_detail_screen.dart';
import 'package:app/src/presentation/splash/splash_screen.dart';
import 'package:app/src/presentation/checkout/checkout_screen.dart';
import 'package:app/src/presentation/checkout/cubit/checkout_cubit.dart';
import 'package:app/src/presentation/cart/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../presentation/navigation/navigation_screen.dart';
import '../presentation/notifications/notifications_screen.dart';
import '../presentation/socket_shell/socket_shell_wrapper.dart';
import '../presentation/socket_shell/widgets/location_permission_wraper.dart';
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
      path: '/',
      builder: (context, state) => const SplashScreen(),
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
        // Thêm route cho trang checkout
        // GoRoute(
        //   path: '/checkout',
        //   builder: (context, state) {
        //     // Đăng ký CheckoutCubit nếu chưa đăng ký
        //     if (!getIt.isRegistered<CheckoutCubit>()) {
        //       getIt.registerSingleton<CheckoutCubit>(
        //         CheckoutCubit(cartCubit: getIt<CartCubit>()),
        //       );
        //     }
        //     return const CheckoutScreen();
        //   },
        // ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) {
            return const NotificationsScreen();
          },
        ),
      ],
    ),
    
  ],
);
