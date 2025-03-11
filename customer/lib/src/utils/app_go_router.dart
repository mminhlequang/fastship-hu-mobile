import 'package:app/src/presentation/food_detail/food_detail_screen.dart';
import 'package:app/src/presentation/food_detail/cubit/food_detail_cubit.dart';
import 'package:app/src/presentation/restaurant_detail/restaurant_detail_screen.dart';
import 'package:app/src/presentation/restaurant_detail/cubit/restaurant_detail_cubit.dart';
import 'package:app/src/presentation/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/navigation/navigation_screen.dart';
import '../presentation/socket_shell/socket_shell_wrapper.dart';
import '../presentation/socket_shell/widgets/location_permission_wraper.dart';
import 'app_get.dart';
import 'app_get_it.dart';

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
      ],
    ),
    // Thêm routes mới cho trang chi tiết món ăn và nhà hàng
    GoRoute(
      path: '/food-detail/:id',
      builder: (context, state) {
        // Đăng ký FoodDetailCubit
        getIt.registerFactory(() => FoodDetailCubit());
        return FoodDetailScreen(
          foodId: state.pathParameters['id'] ?? '',
        );
      },
    ),
    GoRoute(
      path: '/restaurant-detail/:id',
      builder: (context, state) {
        // Đăng ký RestaurantDetailCubit
        getIt.registerFactory(() => RestaurantDetailCubit());
        return RestaurantDetailScreen(
          restaurantId: state.pathParameters['id'] ?? '',
        );
      },
    ),
  ],
);
