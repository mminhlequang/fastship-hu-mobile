import 'package:app/src/presentation/navigation/cubit/navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../base/bloc.dart';
import '../presentation/notifications/cubit/notification_cubit.dart';


final getIt = GetIt.instance;

/// Register which one need be install when app start and keep alive into end
/// other bloc/cubit must be register in [GoRouter]

void getItSetup() {
  getIt.registerSingleton<GlobalKey<NavigatorState>>(
      GlobalKey<NavigatorState>());
  getIt.registerSingleton<AuthCubit>(AuthCubit());
  getIt.registerSingleton<NavigationCubit>(NavigationCubit());
  getIt.registerSingleton<NotificationCubit>(NotificationCubit());
}
