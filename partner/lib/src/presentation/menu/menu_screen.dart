import 'package:app/src/base/auth/auth_cubit.dart';
import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/network_resources/product/model/product.dart';
import 'package:app/src/network_resources/store/models/menu.dart';
import 'package:app/src/network_resources/store/repo.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/setup/app_textstyles.dart';
import 'package:internal_core/setup/app_utils.dart';
import 'package:internal_core/widgets/widgets.dart';
import 'package:internal_network/network_resources/resources.dart';

import 'widgets/widget_add_dish.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _currentTab = 0;
  List<MenuModel> menus = [];
  List<MenuModel> toppingGroups = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchData();
  }

  void _fetchData() async {
    setState(() => isLoading = true);

    if (_currentTab == 0) {
      // Fetch menu data
      final menuResponse = await StoreRepo().getStoreMenus({
        "store_id": authCubit.storeId,
        "type": 1,
      });
      if (menuResponse.isSuccess) {
        menus = menuResponse.data;
      }
    } else {
      // Fetch topping data
      final toppingResponse = await StoreRepo().getStoreMenus({
        "store_id": authCubit.storeId,
        "type": 2,
      });
      if (toppingResponse.isSuccess) {
        toppingGroups = toppingResponse.data;
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
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
            onPressed: () async {
              if (_currentTab == 0) {
                final r = await appContext.push('/store-category',
                    extra: authCubit.state.store?.categories
                            ?.map((e) => e.id!)
                            .toList() ??
                        []);
                if (r is List<int>) {
                  await StoreRepo().updateStore(
                      {"id": authCubit.storeId!, "category_ids": r}).then((v) {
                    if (v.isSuccess) {
                      appShowSnackBar(
                        context: context,
                        msg: "Store categories updated successfully!".tr(),
                        type: AppSnackBarType.success,
                      );
                      authCubit.refreshStore();
                    } else {
                      appShowSnackBar(
                          context: context,
                          msg:
                              "Failed to update store info, please try again later!"
                                  .tr());
                    }
                  });
                  _fetchData();
                }
              } else {
                await appContext.push('/add-topping-group');
              }
              _fetchData();
            },
            icon: _currentTab == 0
                ? Icon(Icons.category_sharp, color: Colors.white)
                : WidgetAppSVG('ic_add_circle'),
          ),
          Gap(4.sw),
        ],
      ),
      body: WidgetAppTabBar(
        tabController: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        tabs: ['Menu'.tr(), 'Topping group'.tr()],
        children: [_menu, _topping],
        onTap: (index) {
          _currentTab = index;
          _fetchData();
          setState(() {});
        },
      ),
    );
  }

  Widget get _menu {
    if (isLoading) {
      return ListView.separated(
        padding: EdgeInsets.fromLTRB(16.sw, 16.sw, 16.sw, 4.sw),
        itemCount: 3,
        separatorBuilder: (_, __) => Gap(4.sw),
        itemBuilder: (_, __) => const MenuShimmer(),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.sw, 16.sw, 16.sw, 4.sw),
      itemCount: menus.length,
      separatorBuilder: (context, index) => Gap(4.sw),
      itemBuilder: (context, index) {
        final menu = menus[index];
        onAddDish() async {
          appHaptic();
          final r = await appContext.push('/add-dish',
              extra: AddDishParams(
                categoryIds: [menu.id!],
              ));
          if (r is ProductModel) {
            menu.products!.add(r);
            setState(() {});
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WidgetInkWellTransparent(
              enableInkWell: false,
              onTap: onAddDish,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${menu.name} (${menu.products?.length ?? 0})',
                    style: w500TextStyle(fontSize: 16.sw),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, size: 16.sw),
                ],
              ),
            ),
            if (menu.products?.isNotEmpty == true) ...[
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: menu.products!.length,
                separatorBuilder: (_, __) => const AppDivider(),
                itemBuilder: (context, productIndex) {
                  final product = menu.products![productIndex];
                  return WidgetRippleButton(
                    onTap: () async {
                      final r = await appContext.push('/add-dish',
                          extra: AddDishParams(
                            model: product,
                            categoryIds: [menu.id!],
                          ));
                      if (r is ProductModel) {
                        menu.products![productIndex] = r;
                        setState(() {});
                      }
                    },
                    radius: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.sw),
                      child: Row(
                        children: [
                          WidgetAppImage(
                            imageUrl: product.image ?? '',
                            width: 52.sw,
                            height: 52.sw,
                            radius: 4,
                          ),
                          Gap(8.sw),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name ?? '',
                                  style: w400TextStyle(),
                                ),
                                Gap(2.sw),
                                if (product.description != null) ...[
                                  Text(
                                    product.description!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: w400TextStyle(
                                      fontSize: 10.sw,
                                      color: grey1,
                                    ),
                                  ),
                                  Gap(2.sw),
                                ],
                                Text(
                                  '\$${product.price ?? 0}',
                                  style: w400TextStyle(color: darkGreen),
                                ),
                              ],
                            ),
                          ),
                          Gap(8.sw),
                          AdvancedSwitch(
                            controller: ValueNotifier<bool>(true),
                            initialValue: true,
                            height: 28.sw,
                            width: 48.sw,
                            activeColor: appColorPrimary,
                            inactiveColor: hexColor('#E2E2EF'),
                            onChanged: (value) {
                              appHaptic();
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ] else
              Center(
                child: GestureDetector(
                  onTap: onAddDish,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.sw),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const WidgetAppSVG('empty_store'),
                        Gap(16.sw),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No have any product'.tr(),
                              style: w400TextStyle(fontSize: 15.sw),
                            ),
                            Gap(4.sw),
                            Text(
                              'Let\'s create your first\nproduct for this category'
                                  .tr(),
                              style:
                                  w400TextStyle(fontSize: 12.sw, color: grey1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget get _topping {
    if (isLoading) {
      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.sw),
        itemCount: 5,
        separatorBuilder: (_, __) => const AppDivider(),
        itemBuilder: (_, __) => const ToppingShimmer(),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.sw),
      itemCount: toppingGroups.length,
      separatorBuilder: (_, __) => const AppDivider(),
      itemBuilder: (context, index) {
        final m = toppingGroups[index];
        String text = m.toppings?.map((e) => e.name).join(', ') ?? '';
        return WidgetRippleButton(
          onTap: () async {
            await appContext.push('/add-topping-group', extra: m);
            _fetchData();
          },
          radius: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.sw),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.name ?? '',
                        style: w400TextStyle(fontSize: 16.sw),
                      ),
                      Gap(2.sw),
                      Text(
                        text,
                        style: w400TextStyle(color: grey1),
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

// Thêm các widget Shimmer
class MenuShimmer extends StatelessWidget {
  const MenuShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 20.sw,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Gap(8.sw),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          separatorBuilder: (_, __) => const AppDivider(),
          itemBuilder: (_, __) => Padding(
            padding: EdgeInsets.symmetric(vertical: 12.sw),
            child: Row(
              children: [
                Container(
                  width: 48.sw,
                  height: 48.sw,
                  color: Colors.grey[300],
                ),
                Gap(8.sw),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120.sw,
                        height: 16.sw,
                        color: Colors.grey[300],
                      ),
                      Gap(4.sw),
                      Container(
                        width: 80.sw,
                        height: 14.sw,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ToppingShimmer extends StatelessWidget {
  const ToppingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.sw),
      child: Row(
        children: [
          Container(
            width: 48.sw,
            height: 48.sw,
            color: Colors.grey[300],
          ),
          Gap(8.sw),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100.sw,
                  height: 16.sw,
                  color: Colors.grey[300],
                ),
                Gap(4.sw),
                Container(
                  width: 60.sw,
                  height: 14.sw,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
