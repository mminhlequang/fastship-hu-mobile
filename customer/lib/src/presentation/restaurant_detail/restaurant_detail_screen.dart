import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/constants.dart';
import 'package:network_resources/network_resources.dart';
import 'package:network_resources/store/models/models.dart';
import 'package:network_resources/store/repo.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';
import 'package:internal_core/widgets/widget_ripple_button.dart';

import '../home/widgets/widget_dish_card.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final dynamic id;
  const RestaurantDetailScreen({super.key, required this.id});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  StoreModel? store;
  List<MenuModel>? menus;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    final response = await StoreRepo().getStoreDetail({"id": widget.id});
    if (response.isSuccess) {
      store = response.data;
      if (mounted) setState(() {});
    }
    final responseMenu =
        await StoreRepo().getStoreMenus({"store_id": widget.id, "type": 1});
    if (responseMenu.isSuccess) {
      menus = responseMenu.data;
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColorBackground,
      body: store == null ? _buildShimmerState() : _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.sw,
                children: [
                  if (menus != null) ...menus!.map((e) => _buildMenuItem(e)),
                  SizedBox(height: 12 + context.mediaQueryPadding.bottom),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(MenuModel menu) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          menu.name ?? '',
          style: w500TextStyle(
            fontSize: 20.sw,
            color: hexColor('#333333'),
          ),
        ),
        if (menu.description != null) ...[
          const SizedBox(height: 4),
          Text(
            menu.description ?? '',
            style: w400TextStyle(
              fontSize: 14.sw,
              color: hexColor('#847D79'),
            ),
          ),
        ],
        const SizedBox(height: 12),
        Wrap(
          spacing: 12.sw,
          runSpacing: 12.sw,
          children: [
            if (menu.products != null)
              ...menu.products!.map(
                (e) => WidgetDishCardInMenu(
                  width: context.width / 2 - 16 - 6.sw,
                  product: e,
                  store: store,
                ),
              ),
          ],
        )
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding:
          EdgeInsets.fromLTRB(12, 8 + context.mediaQueryPadding.top, 12, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WidgetInkWellTransparent(
                onTap: () {
                  appHaptic();
                  context.pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: WidgetAppSVG(
                    'icon40',
                    width: 24.sw,
                  ),
                ),
              ),
              Gap(4),
              Expanded(
                child: Text(
                  store?.name ?? '',
                  style: w600TextStyle(fontSize: 18.sw),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: WidgetAppSVG(
                  'icon1',
                  width: 24.sw,
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 24.sw),
                  child: WidgetAppImage(
                    height: 124.sw,
                    imageUrl: store?.bannerImages?.first.image ?? '',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    radius: 16.sw,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 24.sw,
                  height: 85,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.sw),
                        gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(.9),
                              Colors.black.withOpacity(.001),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter)),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  right: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WidgetGlassBackground(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.sw,
                          vertical: 6.sw,
                        ),
                        borderRadius: BorderRadius.circular(16.sw),
                        backgroundColor: Colors.black.withOpacity(0.1),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Colors.white,
                              size: 18.sw,
                            ),
                            Gap(4.sw),
                            Text(
                              store?.rating.toString() ?? '',
                              style: w500TextStyle(
                                  fontSize: 16.sw, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      WidgetGlassBackground(
                          borderRadius: BorderRadius.circular(16.sw),
                          backgroundColor: Colors.black.withOpacity(0.1),
                          child: WidgetAppSVG(
                            'icon12',
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 8.sw,
                  right: 8.sw,
                  height: 75.sw,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.sw),
                            border: Border.all(
                                width: 2.sw,
                                color: hexColor('#F2F0F0').withOpacity(.6))),
                        child: WidgetAppImage(
                          imageUrl: store?.avatarImage ?? '',
                          width: 75.sw,
                          height: 75.sw,
                          radius: 16.sw,
                        ),
                      ),
                      Gap(8.sw),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            store?.name ?? '',
                            style: w600TextStyle(
                                fontSize: 20.sw, color: Colors.white),
                          ),
                          Gap(4.sw),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Opening Hours:',
                                    style: w400TextStyle(
                                        fontSize: 14.sw,
                                        color: hexColor('#CEC6C5'))),
                                TextSpan(
                                    text:
                                        'Today: ${store?.operatingHours?.firstWhere((e) => e.day == DateTime.now().weekday).startTime} - ${store?.operatingHours?.firstWhere((e) => e.day == DateTime.now().weekday).endTime}',
                                    style: w400TextStyle(
                                        fontSize: 14.sw, color: Colors.white)),
                              ],
                            ),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Text(
                                'Delivery: 25-30 mins',
                                style: w400TextStyle(fontSize: 14.sw),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 8.sw),
                                width: 1.sw,
                                height: 16.sw,
                                color: hexColor('#E6E6E6'),
                              ),
                              Text(
                                '30 mins',
                                style: w400TextStyle(
                                    fontSize: 14.sw,
                                    color: hexColor('#7A838C')),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 8.sw),
                                width: 1.sw,
                                height: 16.sw,
                                color: hexColor('#E6E6E6'),
                              ),
                              Text(
                                '0.1 Km',
                                style: w400TextStyle(fontSize: 14.sw),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),

          // Order information section
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE7E7E7)),
                        color: Colors.white,
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: w400TextStyle(
                            fontSize: 14.sw,
                            color: hexColor('#7A838C'),
                          ),
                          children: [
                            TextSpan(text: 'Min order: '),
                            TextSpan(
                              text: currencyFormatted(1000),
                              style: w400TextStyle(
                                  fontSize: 14.sw, color: Color(0xFF3C3836)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE7E7E7)),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          WidgetAppSVG(
                            'icon39',
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            currencyFormatted(2000),
                            style: w400TextStyle(
                                fontSize: 14.sw, color: Color(0xFF3C3836)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE7E7E7)),
                        color: Colors.white,
                      ),
                      child: Text(
                        'More',
                        style: w400TextStyle(
                          fontSize: 14.sw,
                          color: hexColor('#F17228'),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        appHaptic();
                      },
                      child: Container(
                        width: 38,
                        height: 38,
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: WidgetAppSVG(
                          'icon30',
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Gap(8),
                    GestureDetector(
                      onTap: () {
                        appHaptic();
                      },
                      child: Container(
                        width: 38,
                        height: 38,
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: const Color(0xFFF4F4F4),
                        ),
                        child: WidgetAppSVG(
                          'icon29',
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(
              12, 8 + context.mediaQueryPadding.top, 12, 14),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    WidgetAppShimmer(
                      width: 24.sw,
                      height: 24.sw,
                    ),
                    Row(
                      children: [
                        WidgetAppShimmer(
                          width: 44.sw,
                          height: 44.sw,
                        ),
                        SizedBox(width: 12.sw),
                        WidgetAppShimmer(
                          width: 44.sw,
                          height: 44.sw,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.sw),
              WidgetAppShimmer(
                width: double.infinity,
                height: 200.sw,
              ),
              SizedBox(height: 16.sw),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      WidgetAppShimmer(
                        width: 100.sw,
                        height: 36.sw,
                      ),
                      SizedBox(width: 4.sw),
                      WidgetAppShimmer(
                        width: 100.sw,
                        height: 36.sw,
                      ),
                      SizedBox(width: 4.sw),
                      WidgetAppShimmer(
                        width: 80.sw,
                        height: 36.sw,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      WidgetAppShimmer(
                        width: 38.sw,
                        height: 38.sw,
                      ),
                      SizedBox(width: 8.sw),
                      WidgetAppShimmer(
                        width: 38.sw,
                        height: 38.sw,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16.sw),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WidgetAppShimmer(
                width: 200.sw,
                height: 24.sw,
              ),
              SizedBox(height: 4.sw),
              WidgetAppShimmer(
                width: 250.sw,
                height: 16.sw,
              ),
              SizedBox(height: 15.sw),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    WidgetDishCardInMenuShimmer(),
                    SizedBox(width: 12.sw),
                    WidgetDishCardInMenuShimmer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
