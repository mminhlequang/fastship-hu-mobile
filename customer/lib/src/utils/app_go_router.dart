import 'package:app/src/presentation/restaurant_detail/restaurant_detail_screen.dart';
import 'package:app/src/presentation/splash/splash_screen.dart';
import 'package:app/src/presentation/checkout/checkout_tracking_screen.dart';
import 'package:app/src/presentation/checkout/cubit/checkout_cubit.dart';
import 'package:app/src/presentation/cart/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:network_resources/cart/models/models.dart';
import 'package:network_resources/order/models/models.dart';
import 'package:network_resources/voucher/models/models.dart';

import '../presentation/account/widgets/widget_help_center.dart';
import '../presentation/account/widgets/widget_my_favorite.dart';
import '../presentation/account/widgets/widget_personal_data.dart';
import '../presentation/account/widgets/widget_settings.dart';
import '../presentation/auth/auth_screen.dart';
import '../presentation/cart/widgets/widget_preview_order.dart';
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
      pageBuilder: _defaultPageBuilder((state) => const SplashScreen()),
    ),
    GoRoute(
      path: '/auth',
      pageBuilder: _defaultPageBuilder((state) => const AuthScreen()),
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
          pageBuilder: _defaultPageBuilder((state) => const NavigationScreen()),
        ),
        GoRoute(
          path: '/restaurant-detail/:id',
          pageBuilder: _defaultPageBuilder((state) => RestaurantDetailScreen(
                id: state.pathParameters['id'] ?? '',
              )),
        ),
        GoRoute(
          path: '/notifications',
          pageBuilder:
              _defaultPageBuilder((state) => const NotificationsScreen()),
        ),
        GoRoute(
          path: '/help-center',
          pageBuilder: _defaultPageBuilder((state) => const HelpCenterScreen()),
        ),
        GoRoute(
          path: '/my-favorite',
          pageBuilder: _defaultPageBuilder((state) => const MyFavoriteScreen()),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: _defaultPageBuilder((state) => const SettingsScreen()),
        ),
        GoRoute(
          path: '/personal-data',
          pageBuilder:
              _defaultPageBuilder((state) => const PersonalDataScreen()),
        ),
        GoRoute(
          path: '/checkout-tracking',
          pageBuilder:
              _defaultPageBuilder((state) =>   CheckoutTrackingScreen(
                order: state.extra is OrderModel ? state.extra as OrderModel : null,
              )),
        ),
        GoRoute(
          path: '/cancel-order',
          pageBuilder:
              _defaultPageBuilder((state) => const CancelOrderScreen()),
        ),
        GoRoute(
          path: '/preview-order',
          pageBuilder: _defaultPageBuilder((state) => WidgetPreviewOrder(
                cart: state.extra as CartModel,
              )),
        ),
        GoRoute(
          path: '/vouchers',
          pageBuilder: _defaultPageBuilder(
              (state) => VouchersScreen(storeId: state.extra as int?)),
        ),
        GoRoute(
          path: '/vouchers-detail',
          pageBuilder: _defaultPageBuilder((state) =>
              VoucherDetailScreen(voucher: state.extra as VoucherModel)),
        ),
      ],
    ),
  ],
);

Page<dynamic> Function(BuildContext, GoRouterState) _defaultPageBuilder<T>(
        Widget Function(GoRouterState) builder) =>
    (BuildContext context, GoRouterState state) {
      return _buildPageWithDefaultTransition<T>(
        context: context,
        state: state,
        name: state.name,
        child: builder(state),
      );
    };

CustomTransitionPage _buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  required String? name,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    name: name,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}
