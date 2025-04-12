import 'package:app/src/presentation/wallet_banks_card_add/banks_card_add_screen.dart';
import 'package:app/src/presentation/auth/auth_screen.dart';
import 'package:app/src/presentation/wallet_banks_cards/banks_cards_screen.dart';
import 'package:app/src/presentation/change_password/change_password_screen.dart';
import 'package:app/src/presentation/chat/chat_screen.dart';
import 'package:app/src/presentation/ratings/ratings_screen.dart';
import 'package:app/src/presentation/my_profile/my_profile_screen.dart';
import 'package:app/src/presentation/my_profile/widgets/personal_info_screen.dart';
import 'package:app/src/presentation/order_detail/order_detail_screen.dart';
import 'package:app/src/presentation/report_order/report_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:network_resources/order/models/models.dart';

import '../presentation/driver_register/driver_register_screen.dart';
import '../presentation/driver_register/widgets/widget_form_profile.dart';
import '../presentation/help_center/help_center_screen.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/notifications/notifications_screen.dart';
import '../presentation/settings/settings_screen.dart';
import '../presentation/socket_shell/socket_shell_wraper.dart';
import '../presentation/socket_shell/widgets/permissions_wraper.dart';
import '../presentation/splash/splash_screen.dart';
import '../presentation/statistics/statistics_screen.dart';
import '../presentation/vehicles/vehicles_screen.dart';
import '../presentation/wallet/wallet_screen.dart';
import '../presentation/wallet_transactions/wallet_transactions.dart';
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
      pageBuilder: _defaultPageBuilder((state) => const SplashScreen()),
    ),
    GoRoute(
      path: '/auth',
      pageBuilder: _defaultPageBuilder((state) => const LoginScreen()),
    ),
    GoRoute(
      path: '/driver-register',
      pageBuilder: _defaultPageBuilder((state) => const DriverRegisterScreen()),
    ),
    GoRoute(
      path: '/driver-register/profile',
      pageBuilder: _defaultPageBuilder((state) => const WidgetFormProfile()),
    ),
    ShellRoute(
      parentNavigatorKey: appNavigatorKey,
      pageBuilder: (context, state, child) {
        return NoTransitionPage(
          child: PermissionsWrapper(
            child: SocketShellWrapper(
              child: child,
            ),
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: _defaultPageBuilder((state) => const HomeScreen()),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: _defaultPageBuilder((state) => const SettingsScreen()),
        ),
        GoRoute(
          path: '/statistics',
          pageBuilder: _defaultPageBuilder((state) => const StatisticsScreen()),
        ),
        GoRoute(
          path: '/help-center',
          pageBuilder: _defaultPageBuilder((state) => const HelpCenterScreen()),
        ),
        GoRoute(
          path: '/notifications',
          pageBuilder:
              _defaultPageBuilder((state) => const NotificationsScreen()),
        ),
        GoRoute(
          path: '/order-detail',
          pageBuilder: _defaultPageBuilder((state) => OrderDetailScreen(
                order: state.extra as OrderModel,
              )),
        ),
        GoRoute(
          path: '/order-detail/chat',
          pageBuilder: _defaultPageBuilder((state) => const ChatScreen()),
        ),
        GoRoute(
          path: '/order-detail/report-order',
          pageBuilder:
              _defaultPageBuilder((state) => const ReportOrderScreen()),
        ),
        GoRoute(
          path: '/vehicles',
          pageBuilder: _defaultPageBuilder((state) => const VehiclesScreen()),
        ),
        GoRoute(
          path: '/ratings',
          pageBuilder: _defaultPageBuilder((state) => const RatingsScreen()),
        ),
        GoRoute(
          path: '/my-profile',
          pageBuilder: _defaultPageBuilder((state) => const MyProfileScreen()),
          routes: [
            GoRoute(
              name: 'personal-info',
              path: 'personal-info',
              pageBuilder:
                  _defaultPageBuilder((state) => const PersonalInfoScreen()),
            ),
          ],
        ),
        GoRoute(
          path: '/change-password',
          pageBuilder:
              _defaultPageBuilder((state) => const ChangePasswordScreen()),
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
