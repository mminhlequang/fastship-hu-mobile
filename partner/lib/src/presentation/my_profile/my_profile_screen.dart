import 'package:app/src/constants/constants.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';

import '../widgets/widgets.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My profile'.tr())),
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
              '${AppPrefs.instance.user?.name}'.toUpperCase(),
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
              '${AppPrefs.instance.user?.phone}',
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
              'PARTNER-${AppPrefs.instance.user?.id}'.toUpperCase(),
              style: w400TextStyle(fontSize: 16.sw),
            ),
          ],
        ),
      ),
    );
  }
}
