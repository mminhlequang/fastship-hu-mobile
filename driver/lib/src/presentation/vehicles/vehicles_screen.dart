import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';

import '../widgets/widgets.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vehicles'.tr())),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.sw),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TYPE'.tr(),
              style: w400TextStyle(fontSize: 12.sw, color: grey9),
            ),
            Gap(4.sw),
            Text(
              'Scooter',
              style: w400TextStyle(fontSize: 16.sw),
            ),
            Gap(12.sw),
            const AppDivider(),
            Gap(12.sw),
            Text(
              'LICENSE/IDP'.tr(),
              style: w400TextStyle(fontSize: 12.sw, color: grey9),
            ),
            Gap(4.sw),
            Text(
              '1245678942',
              style: w400TextStyle(fontSize: 16.sw),
            ),
            Gap(12.sw),
            const AppDivider(),
            Gap(12.sw),
            Text(
              'LICENSE PLATE'.tr(),
              style: w400TextStyle(fontSize: 12.sw, color: grey9),
            ),
            Gap(4.sw),
            Text(
              '54U3-9279',
              style: w400TextStyle(fontSize: 16.sw),
            ),
          ],
        ),
      ),
    );
  }
}
