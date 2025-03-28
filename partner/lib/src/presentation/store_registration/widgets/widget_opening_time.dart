import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/network_resources/models/opening_time_model.dart';
import 'package:app/src/presentation/widgets/widget_app_divider.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';
import 'package:internal_core/setup/app_textstyles.dart';

class OpeningTimeScreen extends StatefulWidget {
  final List<OpeningTimeModel>? initialData;
  const OpeningTimeScreen({super.key, this.initialData});

  @override
  State<OpeningTimeScreen> createState() => _OpeningTimeScreenState();
}

class _OpeningTimeScreenState extends State<OpeningTimeScreen> {
  late List<OpeningTimeModel>? openingTimes = widget.initialData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(openingTimes),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          'Opening hours'.tr(),
          style: w500TextStyle(fontSize: 20.sw, height: 1.2),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: appColorText),
        actions: [
          TextButton(
            onPressed: () {
              appHaptic();
              context.pop(openingTimes);
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
              child: WidgetOpeningTime(
                initialData: widget.initialData,
                onChanged: (value) {
                  setState(() {
                    openingTimes = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
