import 'package:app/src/presentation/create_store/create_store_screen.dart';
import 'package:app/src/presentation/detail_order/detail_order_screen.dart';
import 'package:app/src/presentation/help_center/help_center_screen.dart';
import 'package:app/src/presentation/menu/menu_screen.dart';
import 'package:app/src/presentation/menu/widgets/widget_add_category.dart';
import 'package:app/src/presentation/menu/widgets/widget_add_dish.dart';
import 'package:app/src/presentation/menu/widgets/widget_add_option.dart';
import 'package:app/src/presentation/menu/widgets/widget_add_topping.dart';
import 'package:app/src/presentation/merchant_onboarding/merchant_onboarding_screen.dart';
import 'package:app/src/presentation/my_profile/my_profile_screen.dart';
import 'package:app/src/presentation/order_settings/order_settings_screen.dart';
import 'package:app/src/presentation/splash/splash_screen.dart';
import 'package:app/src/presentation/store_registration/export.dart';
import 'package:app/src/presentation/store_registration/widgets/widget_opening_time.dart';
import 'package:app/src/presentation/store_registration/widgets/widget_business_type.dart';
import 'package:app/src/presentation/store_registration/widgets/opening_hours_screen.dart';
import 'package:app/src/presentation/store_registration/widgets/service_types_screen.dart';
import 'package:app/src/presentation/store_settings/store_settings_screen.dart';
import 'package:app/src/presentation/store_settings/widgets/information_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../presentation/auth/auth_screen.dart';
import '../presentation/navigation/navigation_screen.dart';
import '../presentation/socket_shell/socket_shell_wrapper.dart';
import '../presentation/socket_shell/widgets/location_permission_wraper.dart';
import '../presentation/store_registration/cubit/store_registration_cubit.dart';
import 'app_get.dart';

GlobalKey<NavigatorState> get appNavigatorKey => findInstance<GlobalKey<NavigatorState>>();
bool get isAppContextReady => appNavigatorKey.currentContext != null;
BuildContext get appContext => appNavigatorKey.currentContext!;

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
    ShellRoute(
      parentNavigatorKey: appNavigatorKey,
      pageBuilder: (context, state, child) {
        return NoTransitionPage(
          child: BlocProvider(
            create: (context) => StoreRegistrationCubit(),
            child: child,
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/store-registration',
          builder: (context, state) => const StoreRegistrationScreen(),
        ),
        GoRoute(
          path: '/provide-info',
          builder: (context, state) => const ProvideInfoScreen(),
        ),
        GoRoute(
          path: '/opening-time',
          builder: (context, state) =>   WidgetOpeningTime(
            initialData: state.extra as List?,
          ),
        ),
        GoRoute(
          path: '/business-type',
          builder: (context, state) => WidgetBusinessType(
            initialData: state.extra as List<int>?,
          ),
 
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
          builder: (context, state) => WidgetAddCategory(category: state.extra as CategoryModel?),
        ),
        GoRoute(
          path: '/add-dish',
          builder: (context, state) => WidgetAddDish(dish: state.extra as String?),
        ),
        GoRoute(
          path: '/add-topping',
          builder: (context, state) => WidgetAddTopping(topping: state.extra as String?),
        ),
        GoRoute(
          path: '/add-option',
          builder: (context, state) => const WidgetAddOption(),
        ),
        GoRoute(
          path: '/detail-order',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const DetailOrderScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        ),
        GoRoute(
          path: '/my-profile',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const MyProfileScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        ),
        GoRoute(
          path: '/store-settings',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const StoreSettingsScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
          routes: [
            GoRoute(
              name: 'information',
              path: 'information',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const InformationScreen(),
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
          ],
        ),
        GoRoute(
          path: '/order-settings',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const OrderSettingsScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        ),
        GoRoute(
          path: '/help-center',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const HelpCenterScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        ),
        GoRoute(
          path: '/opening-hours',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const OpeningHoursScreen(),
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
      ],
    ),
  ],
);
