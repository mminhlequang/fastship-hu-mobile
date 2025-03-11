import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/extensions/context_extension.dart';
import 'package:internal_core/setup/app_utils.dart';
import 'package:internal_core/widgets/widget_animation_staggered_item.dart';
import 'package:internal_core/widgets/widget_app_svg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

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
