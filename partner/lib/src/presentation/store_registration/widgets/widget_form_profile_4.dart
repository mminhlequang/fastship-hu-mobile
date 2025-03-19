import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/widgets/widget_app_divider.dart';
import 'package:app/src/presentation/widgets/widget_app_upload_image.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/extensions/context_extension.dart';
import 'package:internal_core/setup/app_textstyles.dart';
import 'package:internal_core/widgets/widgets.dart';

class WidgetFormProfile4 extends StatefulWidget {
  const WidgetFormProfile4({super.key});

  @override
  State<WidgetFormProfile4> createState() => _WidgetFormProfile4State();
}

class _WidgetFormProfile4State extends State<WidgetFormProfile4> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppUploadImage(
              title: 'Avatar'.tr(),
              padding: EdgeInsets.symmetric(horizontal: 16.sw),
              subTitle: Padding(
                padding: EdgeInsets.only(bottom: 8.sw),
                child: Text(
                  '550x550px',
                  style: w400TextStyle(fontSize: 12.sw, color: grey1),
                ),
              ),
              onPickImage: (image) {
                // Todo:
              },
            ),
            Gap(24.sw),
            AppUploadImage(
              title: 'Cover image'.tr(),
              width: context.width,
              padding: EdgeInsets.symmetric(horizontal: 16.sw),
              subTitle: Padding(
                padding: EdgeInsets.only(bottom: 8.sw),
                child: Text(
                  '960x550px',
                  style: w400TextStyle(fontSize: 12.sw, color: grey1),
                ),
              ),
              onPickImage: (image) {
                // Todo:
              },
            ),
            Gap(24.sw),
            AppUploadImage(
              title: 'Facade image'.tr(),
              padding: EdgeInsets.symmetric(horizontal: 16.sw),
              subTitle: Padding(
                padding: EdgeInsets.only(bottom: 8.sw),
                child: Text(
                  '550x550px',
                  style: w400TextStyle(fontSize: 12.sw, color: grey1),
                ),
              ),
              onPickImage: (image) {
                // Todo:
              },
            ),
            Gap(16.sw),
            Container(height: 8.sw, color: appColorBackground),
            WidgetRippleButton(
              onTap: () => appContext.push('/provide-info/opening-time'),
              color: Colors.white,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Opening time'.tr(),
                      style: w400TextStyle(),
                    ),
                    WidgetAppSVG('chevron-right'),
                  ],
                ),
              ),
            ),
            AppDivider(padding: EdgeInsets.symmetric(horizontal: 16.sw)),
            WidgetRippleButton(
              onTap: () {
                // Todo:
              },
              color: Colors.white,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Type of service'.tr(),
                      style: w400TextStyle(),
                    ),
                    WidgetAppSVG('chevron-right'),
                  ],
                ),
              ),
            ),
            AppDivider(padding: EdgeInsets.symmetric(horizontal: 16.sw)),
            WidgetRippleButton(
              onTap: () {
                // Todo:
              },
              color: Colors.white,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cuisine'.tr(),
                      style: w400TextStyle(),
                    ),
                    WidgetAppSVG('chevron-right'),
                  ],
                ),
              ),
            ),
            AppDivider(padding: EdgeInsets.symmetric(horizontal: 16.sw)),
            WidgetRippleButton(
              onTap: () {
                // Todo:
              },
              color: Colors.white,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Featured products'.tr(),
                      style: w400TextStyle(),
                    ),
                    WidgetAppSVG('chevron-right'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
