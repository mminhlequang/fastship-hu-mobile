import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/extensions/context_extension.dart';
import 'package:internal_core/setup/app_textstyles.dart';
import 'package:internal_core/widgets/widgets.dart';

class DetailOrderScreen extends StatefulWidget {
  const DetailOrderScreen({super.key});

  @override
  State<DetailOrderScreen> createState() => _DetailOrderScreenState();
}

class _DetailOrderScreenState extends State<DetailOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Detail order'.tr())),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.sw),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${'Expected delivery at'.tr()} 18:50',
                          style: w400TextStyle(),
                        ),
                      ],
                    ),
                  ),
                  AppDivider(height: 5.sw, thickness: 5.sw),
                ],
              ),
            ),
          ),
          const AppDivider(),
          Padding(
            padding:
                EdgeInsets.fromLTRB(16.sw, 10.sw, 16.sw, 10.sw + context.mediaQueryPadding.bottom),
            child: Row(
              children: [
                Expanded(
                  child: WidgetRippleButton(
                    onTap: () {
                      // Todo:
                    },
                    borderSide: BorderSide(color: appColorPrimary),
                    child: SizedBox(
                      height: 48.sw,
                      child: Center(
                        child: Text(
                          'Edit/Cancel order'.tr(),
                          style: w500TextStyle(fontSize: 16.sw, color: appColorPrimary),
                        ),
                      ),
                    ),
                  ),
                ),
                Gap(10.sw),
                Expanded(
                  child: WidgetRippleButton(
                    onTap: () {
                      // Todo:
                    },
                    color: appColorPrimary,
                    child: SizedBox(
                      height: 48.sw,
                      child: Center(
                        child: Text(
                          'Notify to driver'.tr(),
                          style: w500TextStyle(fontSize: 16.sw, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
