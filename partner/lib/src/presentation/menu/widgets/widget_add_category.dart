import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/menu/menu_screen.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';

class WidgetAddCategory extends StatefulWidget {
  const WidgetAddCategory({super.key, this.category});

  final CategoryModel? category;

  @override
  State<WidgetAddCategory> createState() => _WidgetAddCategoryState();
}

class _WidgetAddCategoryState extends State<WidgetAddCategory> {
  CategoryModel? get _category => widget.category;
  String? _selectedCategory;
  bool enableSave = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_category != null ? _category!.name : 'Add category'.tr())),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(16.sw),
                    child: AppDropdown(
                      items: List.generate(3, (index) => 'Category ${index + 1}'),
                      selectedItem: _selectedCategory,
                      title: 'Name'.tr(),
                      hintText: 'Choose category'.tr(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                  ),
                  Gap(5.sw),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16.sw),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(16.sw),
                        Text(
                          'DISH'.tr(),
                          style: w400TextStyle(fontSize: 12.sw, color: hexColor('#B0B0B0')),
                        ),
                        Gap(11.sw),
                        const AppDivider(),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          separatorBuilder: (context, index) => const AppDivider(),
                          itemBuilder: (context, index) {
                            return Slidable(
                              endActionPane: ActionPane(
                                motion: const StretchMotion(),
                                extentRatio: .16,
                                children: [
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                      outlinedButtonTheme: const OutlinedButtonThemeData(
                                        style: ButtonStyle(
                                          iconColor: WidgetStatePropertyAll(Colors.white),
                                        ),
                                      ),
                                    ),
                                    child: SlidableAction(
                                      onPressed: (_) {
                                        // Todo: delete
                                      },
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: CupertinoIcons.delete,
                                    ),
                                  ),
                                ],
                              ),
                              child: WidgetInkWellTransparent(
                                onTap: () =>
                                    appContext.push('/add-dish', extra: 'Vanilla Latte Milk'),
                                enableInkWell: false,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12.sw),
                                  child: Row(
                                    children: [
                                      WidgetAppImage(
                                        imageUrl:
                                            'https://images.immediate.co.uk/production/volatile/sites/30/2020/08/flat-white-3402c4f.jpg',
                                        width: 48.sw,
                                        height: 48.sw,
                                      ),
                                      Gap(8.sw),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Vanilla Latte Milk',
                                              style: w400TextStyle(height: 1),
                                            ),
                                            Gap(3.sw),
                                            Text(
                                              'Espresso, Vanilla Syrup, Fresh Mink, Fresh Milk',
                                              style: w400TextStyle(
                                                  fontSize: 10.sw, color: grey1, height: 1),
                                            ),
                                            Gap(4.sw),
                                            Text(
                                              '\$10',
                                              style: w400TextStyle(color: darkGreen),
                                            ),
                                          ],
                                        ),
                                      ),
                                      AdvancedSwitch(
                                        controller: ValueNotifier<bool>(true),
                                        initialValue: true,
                                        height: 22.sw,
                                        width: 40.sw,
                                        activeColor: appColorPrimary,
                                        inactiveColor: hexColor('#E2E2EF'),
                                        onChanged: (value) {
                                          // Todo:
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const AppDivider(),
                        WidgetInkWellTransparent(
                          onTap: () => appContext.push('/add-dish'),
                          enableInkWell: false,
                          child: SizedBox(
                            height: 34.sw,
                            width: context.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                WidgetAppSVG('ic_add'),
                                Gap(4.sw),
                                Text(
                                  'Add dish'.tr(),
                                  style: w400TextStyle(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(5.sw),
                  WidgetRippleButton(
                    onTap: () => appContext.push('/add-option'),
                    radius: 0,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16.sw, 12.sw, 12.sw, 12.sw),
                      child: Row(
                        children: [
                          Text(
                            'Options'.tr(),
                            style: w400TextStyle(),
                          ),
                          const Spacer(),
                          Text(
                            'Optional, max 9 toppings',
                            style: w400TextStyle(fontSize: 12.sw, color: grey1),
                          ),
                          Gap(4.sw),
                          const WidgetAppSVG('chevron-right'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding:
                EdgeInsets.fromLTRB(16.sw, 10.sw, 16.sw, 10.sw + context.mediaQueryPadding.bottom),
            child: _category == null
                ? WidgetRippleButton(
                    onTap: () {
                      // Todo:
                      appContext.pop();
                    },
                    enable: enableSave,
                    color: appColorPrimary,
                    child: SizedBox(
                      height: 48.sw,
                      child: Center(
                        child: Text(
                          'Save'.tr(),
                          style: w500TextStyle(
                            fontSize: 16.sw,
                            color: enableSave ? Colors.white : grey1,
                          ),
                        ),
                      ),
                    ),
                  )
                : Row(
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
                                'Delete'.tr(),
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
                            appContext.pop();
                          },
                          color: appColorPrimary,
                          child: SizedBox(
                            height: 48.sw,
                            child: Center(
                              child: Text(
                                'Save'.tr(),
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
