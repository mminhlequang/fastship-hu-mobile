import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/widgets/widget_app_divider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/setup/app_textstyles.dart';

class WidgetOpeningTime extends StatefulWidget {
  final List? initialData;
  const WidgetOpeningTime({super.key, this.initialData});

  @override
  State<WidgetOpeningTime> createState() => _WidgetOpeningTimeState();
}

class _WidgetOpeningTimeState extends State<WidgetOpeningTime> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Opening time'.tr(),
          style: w500TextStyle(fontSize: 20.sw, height: 1.2),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: appColorText),
        actions: [
          TextButton(
            onPressed: () {
              // Todo:
            },
            child: Text(
              'Save'.tr(),
              style: w400TextStyle(fontSize: 16.sw, color: darkGreen),
            ),
          ),
          Gap(4.sw),
        ],
      ),
      body: Column(
        children: [
          const AppDivider(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.sw),
              child: const WidgetOpeningTime(),
            ),
          ),
        ],
      ),
    );
  }
}
