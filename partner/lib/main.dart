import 'dart:io';

import 'package:app/firebase_options.dart';
import 'package:app/src/constants/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/network_resources.dart';

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
          colorScheme: ColorScheme.fromSeed(seedColor: appColorPrimary),
          appBarTheme: AppBarTheme(
            backgroundColor: appColorPrimary,
            titleSpacing: 0,
            titleTextStyle: w500TextStyle(
              fontSize: 20.sw,
              color: Colors.white,
            ),
            iconTheme: IconThemeData(color: Colors.white),
            actionsIconTheme: IconThemeData(color: Colors.white),
          ),
          tabBarTheme: TabBarThemeData(
            dividerHeight: 1.sw,
            dividerColor: hexColor('#F1F4F6'),
            indicator: _TabIndicator(),
            labelColor: appColorText,
            labelStyle: w400TextStyle(fontSize: 16.sw),
            unselectedLabelColor: appColorText,
            unselectedLabelStyle: w400TextStyle(fontSize: 16.sw),
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
        themeMode:
            AppPrefs.instance.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
        builder: (context, child) {
          return kDebugMode
              ? GestureDetector(
                  onDoubleTap: () {
                    AppPrefs.instance.getNormalToken().then((value) {
                      print(value);
                    });
                  },
                  child: KeyboardDismissOnTap(
                    child: child!,
                  ),
                )
              : KeyboardDismissOnTap(
                  child: child!,
                );
        },
      ),
    );
  }
}

class _TabIndicator extends BoxDecoration {
  final BoxPainter _painter;

  _TabIndicator() : _painter = _TabIndicatorPainter();

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _TabIndicatorPainter extends BoxPainter {
  final Paint _paint;

  _TabIndicatorPainter()
      : _paint = Paint()
          ..color = darkGreen
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final double xPos = offset.dx + cfg.size!.width;
    final double yPos = offset.dy + cfg.size!.height;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        // Rect.fromLTRB(offset.dx, 0, xPos, 2),
        Rect.fromLTRB(offset.dx, yPos - 2, xPos, yPos),
        const Radius.circular(4),
      ),
      _paint,
    );
  }
}
