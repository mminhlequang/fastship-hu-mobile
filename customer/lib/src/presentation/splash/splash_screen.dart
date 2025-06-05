import 'package:app/src/base/bloc.dart';
import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    authCubit.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColorPrimary,
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(0, -.3),
              child: WidgetAnimationStaggeredItem(
                index: 2,
                type: AnimationStaggeredType.topToBottom,
                child: Hero(
                  tag: 'app_logo',
                  child: WidgetAppSVG(
                    assetsvg('ic_logo_white'),
                    width: appContext.width * .54,
                  ),
                ),
              ),
            ),
            const Align(
              alignment: Alignment(0, .85),
              child: CupertinoActivityIndicator(
                color: Colors.white,
                radius: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
