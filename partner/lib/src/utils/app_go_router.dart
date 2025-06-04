import 'package:network_resources/models/opening_time_model.dart';
import 'package:network_resources/product/model/product.dart';
import 'package:network_resources/store/models/models.dart';
import 'package:network_resources/topping/models/models.dart';
import 'package:app/src/presentation/order_detail/detail_order_screen.dart';
import 'package:app/src/presentation/help_center/help_center_screen.dart';
import 'package:app/src/presentation/menu/menu_screen.dart';
import 'package:app/src/presentation/menu/widgets/widget_add_topping_group.dart';
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
import 'package:app/src/presentation/store_settings/store_settings_screen.dart';
import 'package:app/src/presentation/store_settings/widgets/information_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../presentation/auth/auth_screen.dart';
import '../presentation/menu/widgets/widget_add_dish_variation.dart';
import '../presentation/menu/widgets/widget_link_topping_group.dart';
import '../presentation/navigation/navigation_screen.dart';
import '../presentation/preference_settings/perference_settings_screen.dart';
import '../presentation/ratings/ratings_screen.dart';
import '../presentation/report/report_screen.dart';
import '../presentation/socket_shell/socket_shell_wrapper.dart';
import '../presentation/store_registration/cubit/store_registration_cubit.dart';
import '../presentation/store_registration/widgets/widget_store_category.dart';
import '../presentation/wallet/wallet_screen.dart';
import '../presentation/wallet_banks_card_add/banks_card_add_screen.dart';
import '../presentation/wallet_banks_cards/banks_cards_screen.dart';
import '../presentation/wallet_transactions/wallet_transactions.dart';
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
          pageBuilder:
              _defaultPageBuilder((state) => const StoreRegistrationScreen()),
        ),
        GoRoute(
          path: '/provide-info',
          pageBuilder:
              _defaultPageBuilder((state) => const ProvideInfoScreen()),
        ),
        GoRoute(
          path: '/opening-time',
          pageBuilder: _defaultPageBuilder((state) => OpeningTimeScreen(
                initialData: state.extra as List<OpeningTimeModel>?,
              )),
        ),
        GoRoute(
          path: '/business-type',
          pageBuilder: _defaultPageBuilder((state) => WidgetBusinessType(
                initialData: state.extra as List<int>?,
              )),
        ),
        GoRoute(
          path: '/store-category',
          pageBuilder: _defaultPageBuilder((state) => WidgetStoreCategory(
                initialData: state.extra as List<int>?,
              )),
        ),
      ],
    ),
    ShellRoute(
      parentNavigatorKey: appNavigatorKey,
      pageBuilder: (context, state, child) {
        return NoTransitionPage(
          child: SocketShellWrapper(
            child: child,
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/merchant-onboarding',
          pageBuilder:
              _defaultPageBuilder((state) => const MerchantOnboardingScreen()),
        ),
        GoRoute(
          path: '/navigation',
          pageBuilder: _defaultPageBuilder((state) => const NavigationScreen()),
        ),
        GoRoute(
          path: '/menu',
          pageBuilder: _defaultPageBuilder((state) => const MenuScreen()),
        ),
        GoRoute(
          path: '/add-topping-group',
          pageBuilder: _defaultPageBuilder((state) => WidgetAddToppingGroup(
                model: state.extra as MenuModel?,
              )),
        ),
        GoRoute(
          path: '/add-dish',
          pageBuilder: _defaultPageBuilder(
              (state) => WidgetAddDish(params: state.extra as AddDishParams)),
        ),
        GoRoute(
          path: '/add-topping',
          pageBuilder: _defaultPageBuilder((state) =>
              WidgetAddTopping(topping: state.extra as ToppingModel?)),
        ),
        GoRoute(
          path: '/add-variation',
          pageBuilder: _defaultPageBuilder((state) =>
              WidgetAddVariation(variation: state.extra as VariationModel?)),
        ),
        GoRoute(
          path: '/link-topping-group',
          pageBuilder: _defaultPageBuilder((state) => WidgetLinkToppingGroup(
                initList: state.extra as List<int>?,
              )),
        ),
        GoRoute(
          path: '/add-option',
          pageBuilder: _defaultPageBuilder((state) => const WidgetAddOption()),
        ),
        GoRoute(
          path: '/detail-order',
          pageBuilder: _defaultPageBuilder(
              (state) => DetailOrderScreen(id: state.extra as int)),
        ),
        GoRoute(
          path: '/ratings',
          pageBuilder: _defaultPageBuilder((state) => const RatingsScreen()),
        ),
        GoRoute(
          path: '/my-profile',
          pageBuilder: _defaultPageBuilder((state) => const MyProfileScreen()),
        ),
        GoRoute(
          path: '/store-settings',
          pageBuilder:
              _defaultPageBuilder((state) => const StoreSettingsScreen()),
          routes: [
            GoRoute(
              name: 'information',
              path: 'information',
              pageBuilder:
                  _defaultPageBuilder((state) => const InformationScreen()),
            ),
          ],
        ),
        GoRoute(
          path: '/order-settings',
          pageBuilder:
              _defaultPageBuilder((state) => const OrderSettingsScreen()),
        ),
        GoRoute(
          path: '/preference-settings',
          pageBuilder:
              _defaultPageBuilder((state) => const PreferenceSettingsScreen()),
        ),
        GoRoute(
          path: '/help-center',
          pageBuilder: _defaultPageBuilder((state) => const HelpCenterScreen()),
        ),
        GoRoute(
          path: '/report',
          pageBuilder: _defaultPageBuilder((state) => const ReportScreen()),
        ),
        GoRoute(
          path: '/my-wallet',
          pageBuilder: _defaultPageBuilder((state) => const WalletScreen()),
          routes: [
            GoRoute(
              path: '/transactions',
              pageBuilder:
                  _defaultPageBuilder((state) => const TransactionsScreen()),
            ),
            GoRoute(
              path: '/banks-cards',
              pageBuilder: _defaultPageBuilder(
                (state) => BanksCardsScreen(isSelector: state.extra == true),
              ),
            ),
            GoRoute(
              path: '/banks-cards/add-card',
              pageBuilder: _defaultPageBuilder(
                (state) => BanksCardAddScreen(
                  params: state.extra as Map<String, dynamic>,
                ),
              ),
            ),
          ],
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
