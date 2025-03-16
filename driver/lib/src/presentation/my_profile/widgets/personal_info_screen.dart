import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';

import '../../../constants/constants.dart';
import '../../widgets/widget_app_divider.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Personal Information'.tr())),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.sw),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FULL NAME'.tr(),
              style: w400TextStyle(fontSize: 12.sw, color: grey9),
            ),
            Gap(4.sw),
            Text(
              'John Doe',
              style: w400TextStyle(fontSize: 16.sw),
            ),
            Gap(12.sw),
            const AppDivider(),
            Gap(12.sw),
            Text(
              'PHONE NUMBER'.tr(),
              style: w400TextStyle(fontSize: 12.sw, color: grey9),
            ),
            Gap(4.sw),
            Text(
              '(332) 454-9224',
              style: w400TextStyle(fontSize: 16.sw),
            ),
            Gap(12.sw),
            const AppDivider(),
            Gap(12.sw),
            Text(
              'ID'.tr(),
              style: w400TextStyle(fontSize: 12.sw, color: grey9),
            ),
            Gap(4.sw),
            Text(
              '98765432234',
              style: w400TextStyle(fontSize: 16.sw),
            ),
          ],
        ),
      ),
    );
  }
}
