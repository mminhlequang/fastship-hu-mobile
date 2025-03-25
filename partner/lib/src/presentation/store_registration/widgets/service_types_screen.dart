import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/setup/app_textstyles.dart';
import 'package:internal_core/widgets/widgets.dart';

class ServiceTypesScreen extends StatefulWidget {
  const ServiceTypesScreen({super.key});

  @override
  State<ServiceTypesScreen> createState() => _ServiceTypesScreenState();
}

class _ServiceTypesScreenState extends State<ServiceTypesScreen> {
  List<int> selectedTypes = [];
  List<String> allTypes = [
    'Restaurant'.tr(),
    'Cafe/Dessert'.tr(),
    'Eatery'.tr(),
    'Bar/Pub'.tr(),
    'Bakery'.tr(),
    'Snacks/Sidewalk'.tr(),
    'Luxury'.tr(),
    'Online shop'.tr(),
    'Office lunch'.tr(),
    'Buffet'.tr(),
    'Beer club'.tr(),
    'Party on site'.tr(),
    'Vegetarian'.tr(),
    'Food court'.tr(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Service types'.tr()),
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
          Expanded(
            child: ListView.separated(
              itemCount: allTypes.length,
              separatorBuilder: (context, index) => AppDivider(
                padding: EdgeInsets.symmetric(horizontal: 16.sw),
              ),
              itemBuilder: (context, index) {
                bool isSelected = selectedTypes.contains(index);

                return WidgetRippleButton(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedTypes.removeWhere((e) => e == index);
                      } else {
                        selectedTypes.add(index);
                      }
                    });
                  },
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 11.sw),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          allTypes[index],
                          style: w400TextStyle(),
                        ),
                        WidgetAppSVG(isSelected ? 'check-box' : 'uncheck-box'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
