import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/setup/app_textstyles.dart';

class OpeningHoursScreen extends StatefulWidget {
  const OpeningHoursScreen({super.key});

  @override
  State<OpeningHoursScreen> createState() => _OpeningHoursScreenState();
}

class _OpeningHoursScreenState extends State<OpeningHoursScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Opening hours'.tr()),
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
      body: Column(
        children: [
          const AppDivider(),
          // Expanded(
          //   child: SingleChildScrollView(
          //     padding: EdgeInsets.all(16.sw),
          //     child: const WidgetOpeningTime(),
          //   ),
          // ),
        ],
      ),
    );
  }
}
