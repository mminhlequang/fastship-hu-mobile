import 'dart:io';
import 'package:app/firebase_options.dart';
import 'package:app/src/constants/constants.dart';

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:network_resources/network_resources.dart';
import 'package:toastification/toastification.dart';

import 'internal_setup.dart';
import 'src/base/bloc.dart';
import 'src/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = stripeMerchantIdentifier;
  Stripe.urlScheme = stripeUrlScheme;

  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    if (Platform.isAndroid)
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.top]),
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]),
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

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: ToastificationWrapper(
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
            colorScheme: ColorScheme.fromSeed(
              seedColor: appColorPrimary,
              brightness: AppPrefs.instance.isDarkTheme
                  ? Brightness.dark
                  : Brightness.light,
            ),
          ),
          themeMode:
              AppPrefs.instance.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          builder: (context, child) {
            return GestureDetector(
              onDoubleTap: kDebugMode
                  ? () {
                      AppPrefs.instance.getNormalToken().then((value) {
                        print(value);
                      });
                    }
                  : null,
              child: KeyboardDismissOnTap(
                child: child!,
              ),
            );
          },
        ),
      ),
    );
  }
}
