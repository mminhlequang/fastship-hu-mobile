import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/navigation/cubit/navigation_cubit.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_core/internal_core.dart';

enum HomeItem {
  orders,
  menu,
  // banner,
  statistics,
  wallet,
  rating,
  support,
  settings;

  String get displayName => switch (this) {
        orders => 'Orders'.tr(),
        menu => 'Menu'.tr(),
        // banner => 'Banner'.tr(),
        statistics => 'Statistics'.tr(),
        wallet => 'Wallet'.tr(),
        rating => 'Rating'.tr(),
        support => 'Support'.tr(),
        settings => 'Settings'.tr(),
      };

  String get icon => switch (this) {
        orders => 'ic_home_order',
        menu => 'ic_home_menu',
        // banner => 'ic_home_banner',
        statistics => 'ic_home_statistics',
        wallet => 'ic_home_wallet',
        rating => 'ic_home_rating',
        support => 'ic_home_support',
        settings => 'ic_home_settings',
      };

  String get route => switch (this) {
        orders => '',
        menu => '/menu',
        // banner => '',
        statistics => '/report',
        wallet => '',
        rating => '',
        support => '/help-center',
        settings => '/store-settings',
      };

  Color get backgroundColor => switch (this) {
        orders => hexColor('#FFF2E5'),
        menu => hexColor('#E9FFF4'),
        // banner => hexColor('#F5EDFF'),
        statistics => hexColor('#FFEEEE'),
        wallet => hexColor('#F2FFF8'),
        rating => hexColor('#FFF7E5'),
        support => hexColor('#EDF7FF'),
        settings => hexColor('#F2F5FF'),
      };

  Color get borderColor => switch (this) {
        orders => hexColor('#FFE8D2'),
        menu => hexColor('#D5FAE7'),
        // banner => hexColor('#EDE3FB'),
        statistics => hexColor('#FFE4E4'),
        wallet => hexColor('#E5FAEE'),
        rating => hexColor('#FFF2D6'),
        support => hexColor('#DEF0FF'),
        settings => hexColor('#E4EAFC'),
      };
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> banners = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSS95xqc0vn-3EDxzvHeazJ7e21bC9w_LIp6g&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSS95xqc0vn-3EDxzvHeazJ7e21bC9w_LIp6g&s',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.sw),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return CarouselSlider.builder(
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 343 / 129,
                  viewportFraction: 1,
                  autoPlayAnimationDuration: const Duration(seconds: 1),
                  autoPlayCurve: Curves.easeInOut,
                  enlargeCenterPage: true,
                ),
                itemCount: banners.length,
                itemBuilder: (context, index, realIndex) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      WidgetAppImage(
                        imageUrl: banners[index],
                        radius: 8.sw,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        left: 16.sw,
                        bottom: 16.sw,
                        child: WidgetRippleButton(
                          onTap: () {
                            // Todo:
                          },
                          radius: 4.sw,
                          color: hexColor('#F5DA27'),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.sw, vertical: 4.sw),
                            child: Text(
                              'Try now'.tr(),
                              style: w600TextStyle(fontSize: 12.sw),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          Gap(16.sw),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 13.sw, vertical: 16.sw),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.sw),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Tính toán chiều rộng của mỗi item
                // 4 items + 3 khoảng trống = 7 phần
                final itemWidth = (constraints.maxWidth - (3 * 16.sw)) / 4;
                return Wrap(
                  spacing: 16.sw,
                  runSpacing: 16.sw,
                  children: HomeItem.values.map((item) {
                    bool isRating = item == HomeItem.rating;
                    return SizedBox(
                      width: itemWidth,
                      child: WidgetInkWellTransparent(
                        onTap: () {
                          appHaptic();
                          if (item == HomeItem.orders) {
                            navigationCubit.changeIndex(2);
                          } else if (item.route.isNotEmpty) {
                            appContext.push(item.route);
                          }
                        },
                        enableInkWell: false,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  height: 40.sw,
                                  width: 40.sw,
                                  decoration: BoxDecoration(
                                    color: item.backgroundColor,
                                    borderRadius: BorderRadius.circular(12.sw),
                                    border: Border.all(color: item.borderColor),
                                  ),
                                  child: Center(
                                    child: WidgetAppSVG(item.icon),
                                  ),
                                ),
                                if (isRating)
                                  Positioned(
                                    top: -3.sw,
                                    right: -5.sw,
                                    child: Container(
                                      height: 15.sw,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4.sw),
                                      decoration: BoxDecoration(
                                        color: hexColor('#FF8832'),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.white),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '10',
                                          style: GoogleFonts.roboto(
                                            fontSize: 10.sw,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Gap(4.sw),
                            Text(
                              item.displayName,
                              style: w400TextStyle(fontSize: 12.sw),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
