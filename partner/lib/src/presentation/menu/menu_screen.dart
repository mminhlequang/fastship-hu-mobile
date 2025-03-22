import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/setup/app_textstyles.dart';
import 'package:internal_core/widgets/widgets.dart';

class CategoryModel {
  final String name;
  final List<String> dishes;

  const CategoryModel({required this.name, required this.dishes});
}

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _currentTab = 0;
  List<CategoryModel> categories = [
    CategoryModel(
      name: 'Drink A',
      dishes: List.generate(5, (index) => 'Vanilla Latte Milk'),
    ),
    CategoryModel(
      name: 'Drink B',
      dishes: List.generate(2, (index) => 'Vanilla Latte Milk'),
    ),
    CategoryModel(
      name: 'Topping',
      dishes: List.generate(4, (index) => 'Vanilla Latte Milk'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Menu'.tr()),
        actions: [
          IconButton(
            onPressed: () => appContext.push(_currentTab == 0 ? '/add-category' : '/add-topping'),
            icon: WidgetAppSVG('ic_add_circle'),
          ),
          Gap(4.sw),
        ],
      ),
      body: WidgetAppTabBar(
        tabController: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        tabs: ['Menu'.tr(), 'Topping'.tr()],
        children: [_menu, _topping],
        onTap: (index) {
          setState(() {
            _currentTab = index;
          });
        },
      ),
    );
  }

  Widget get _menu {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.sw, 16.sw, 16.sw, 4.sw),
      itemCount: categories.length,
      separatorBuilder: (context, index) => Gap(4.sw),
      itemBuilder: (context, index) {
        final category = categories[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${category.name} (${category.dishes.length})',
                  style: w500TextStyle(fontSize: 16.sw),
                ),
                GestureDetector(
                  onTap: () => appContext.push('/add-category', extra: category),
                  child: Icon(
                    CupertinoIcons.arrow_right,
                    size: 20.sw,
                    color: appColorText,
                  ),
                ),
              ],
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: category.dishes.length,
              separatorBuilder: (context, index) => const AppDivider(),
              itemBuilder: (context, index) {
                String dish = category.dishes[index];
                return WidgetRippleButton(
                  onTap: () => appContext.push('/add-dish', extra: dish),
                  radius: 0,
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
                                dish,
                                style: w400TextStyle(height: 1),
                              ),
                              Gap(3.sw),
                              Text(
                                'Espresso, Vanilla Syrup, Fresh Mink, Fresh Milk',
                                style: w400TextStyle(fontSize: 10.sw, color: grey1, height: 1),
                              ),
                              Gap(4.sw),
                              Text(
                                '\$10',
                                style: w400TextStyle(color: darkGreen),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget get _topping {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.sw),
      itemCount: 10,
      separatorBuilder: (context, index) => const AppDivider(),
      itemBuilder: (context, index) {
        return WidgetRippleButton(
          onTap: () => appContext.push('/add-topping', extra: 'Konjac Jelly'),
          radius: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.sw),
            child: Row(
              children: [
                WidgetAppImage(
                  imageUrl:
                      'https://bizweb.dktcdn.net/100/421/036/files/pudding-la-gi-cach-lam-pudding-ngon-don-gian9.jpg?v=1617095326547',
                  width: 48.sw,
                  height: 48.sw,
                ),
                Gap(8.sw),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Konjac Jelly',
                        style: w400TextStyle(height: 1),
                      ),
                      Gap(3.sw),
                      Text(
                        '\$10',
                        style: w400TextStyle(color: darkGreen),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
