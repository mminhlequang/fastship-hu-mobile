import 'package:app/src/presentation/create_store/create_store_screen.dart';
import 'package:app/src/presentation/detail_order/detail_order_screen.dart';
import 'package:app/src/presentation/menu/menu_screen.dart';
import 'package:app/src/presentation/menu/widgets/widget_add_category.dart';
import 'package:app/src/presentation/menu/widgets/widget_add_dish.dart';
import 'package:app/src/presentation/menu/widgets/widget_add_option.dart';
import 'package:app/src/presentation/menu/widgets/widget_add_topping.dart';
import 'package:app/src/presentation/merchant_onboarding/merchant_onboarding_screen.dart';
import 'package:app/src/presentation/splash/splash_screen.dart';
import 'package:app/src/presentation/store_registration/export.dart';
import 'package:app/src/presentation/store_registration/widgets/widget_opening_time.dart';
import 'package:app/src/presentation/store_registration/widgets/widget_service_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../presentation/auth/auth_screen.dart';
import '../presentation/navigation/navigation_screen.dart';
import '../presentation/socket_shell/socket_shell_wrapper.dart';
import '../presentation/socket_shell/widgets/location_permission_wraper.dart';
import '../presentation/store_registration/cubit/store_registration_cubit.dart';
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
    GoRoute(
      path: '/auth',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/store-registration',
      builder: (context, state) => BlocProvider(
        create: (context) => StoreRegistrationCubit(),
        child: const StoreRegistrationScreen(),
      ),
      routes: [
        GoRoute(
          path: '/provide-info',
          builder: (context, state) => const ProvideInfoScreen(),
        ),
        GoRoute(
          path: '/provide-info/opening-time',
          builder: (context, state) => const WidgetOpeningTime(),
        ),
        GoRoute(
          path: '/provide-info/service-type',
          builder: (context, state) => const WidgetServiceType(),
        ),
        GoRoute(
          path: '/merchant-onboarding',
          builder: (context, state) => const MerchantOnboardingScreen(),
        ),
        GoRoute(
          path: '/create-store',
          builder: (context, state) => const CreateStoreScreen(),
        ),
      ],
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
          path: '/menu',
          builder: (context, state) => const MenuScreen(),
        ),
        GoRoute(
          path: '/add-category',
          builder: (context, state) =>
              WidgetAddCategory(category: state.extra as CategoryModel?),
        ),
        GoRoute(
          path: '/add-dish',
          builder: (context, state) =>
              WidgetAddDish(dish: state.extra as String?),
        ),
        GoRoute(
          path: '/add-topping',
          builder: (context, state) =>
              WidgetAddTopping(topping: state.extra as String?),
        ),
        GoRoute(
          path: '/add-option',
          builder: (context, state) => const WidgetAddOption(),
        ),
        GoRoute(
          path: '/detail-order',
          builder: (context, state) => const DetailOrderScreen(),
        ),
      ],
    ),
  ],
);
