import 'dart:io';

import 'package:app/firebase_options.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_portal/flutter_portal.dart';

import 'internal_setup.dart';
import 'src/base/bloc.dart';
import 'src/constants/constants.dart';
import 'src/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey = !kDebugMode && false
      ? "pk_live_51FdoD5FOB1XEXlZFImtB8bzWGoYDGYA6aZn5v2a9QrBQsdDmbxze6RExqKymtuT19uNY5pqZ1vth13WwSdNmQs0Z00ywRf7YmF"
      : 'pk_test_51QwQfYGbnQCWi1BqsVDBmUNXwsA6ye6daczJ5E7j8zgGTjuVAWjLluexegaACZTaHP14XUtrGxDLHwxWzMksUVod00p0ZXsyPd';
  Stripe.merchantIdentifier = !kDebugMode && false
      ? 'merchant.flutter.stripe'
      : 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';

  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    if (!kIsWeb) ...[
      if (Platform.isAndroid)
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: [SystemUiOverlay.top]),
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]),
    ],
    AppPrefs.instance.initialize(),
    initEasyLocalization(),
  ]);
  bloc.Bloc.observer = AppBlocObserver();

  internalSetup();
  getItSetup();

  if (kDebugMode || true) {
    runApp(wrapEasyLocalization(child: const _App()));
  } else {
    // await SentryFlutter.init((options) {
    //   options.dsn =
    //       'https://7c5653105e38011b42c99c079a1f0815@o4505117818814464.ingest.sentry.io/4506229022851072';
    //   options.tracesSampleRate = 1.0;
    //   options.environment = kDebugMode ? 'debug' : 'preprod';
    // }, appRunner: () => runApp(wrapEasyLocalization(child: const _App())));
  }
}

class _App extends StatefulWidget {
  const _App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<_App> {
  @override
  void initState() {
    super.initState();
    authCubit.load();
  }

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: MaterialApp.router(
        routerConfig: goRouter,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: (AppPrefs.instance.isDarkTheme
                ? ThemeData.dark()
                : ThemeData.light())
            .copyWith(
          scaffoldBackgroundColor: appColorBackground,
        ),
        themeMode:
            AppPrefs.instance.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }
}
