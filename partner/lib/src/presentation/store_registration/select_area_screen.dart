import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';

class SelectAreaScreen extends StatefulWidget {
  const SelectAreaScreen({super.key});

  @override
  State<SelectAreaScreen> createState() => _SelectAreaScreenState();
}

class _SelectAreaScreenState extends State<SelectAreaScreen> {
  List<String> areas = [
    'Bacs-Kiskun',
    'Borsod-abauj-zemplen',
    'Bacs-Kiskun',
    'Bacs-Kiskun',
    'Borsod-abauj-zemplen',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Select area'.tr())),
      body: ListView.separated(
        itemCount: areas.length,
        separatorBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sw),
          child: const AppDivider(),
        ),
        itemBuilder: (context, index) {
          return WidgetRippleButton(
            onTap: () {
              appContext.push('/store-registration');
            },
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
              child: Text(areas[index], style: w400TextStyle()),
            ),
          );
        },
      ),
    );
  }
}
