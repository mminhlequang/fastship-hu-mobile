import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Information'.tr()),
        actions: [
          TextButton(
            onPressed: () {
              // Todo:
            },
            child: Text(
              'Save'.tr(),
              style: w500TextStyle(fontSize: 16.sw, color: Colors.white),
            ),
          ),
          Gap(4.sw),
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NAME'.tr(),
              style: w400TextStyle(fontSize: 12.sw, color: hexColor('#B0B0B0')),
            ),
            Gap(4.sw),
            Text(
              'Bánh cuốn Hồng Liên -  Bánh cuốn nóng',
              style: w400TextStyle(fontSize: 16.sw),
            ),
            AppDivider(padding: EdgeInsets.symmetric(vertical: 12.sw)),
            Text(
              'ADDRESS'.tr(),
              style: w400TextStyle(fontSize: 12.sw, color: hexColor('#B0B0B0')),
            ),
            Gap(4.sw),
            Text(
              '41 Quang Trung, Ward 3, Go Vap District, HCMC',
              style: w400TextStyle(fontSize: 16.sw),
            ),
            AppDivider(padding: EdgeInsets.symmetric(vertical: 12.sw)),
            AppUploadImage(
              title: 'Avatar'.tr(),
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
            AppUploadImage(
              title: 'Cover image'.tr(),
              height: 110.sw,
              width: context.width,
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
            Gap(4.sw),
          ],
        ),
      ),
    );
  }
}
