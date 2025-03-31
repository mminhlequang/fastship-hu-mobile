import 'package:app/src/constants/constants.dart';
import 'package:app/src/network_resources/product/model/product.dart';
import 'package:app/src/presentation/home/widgets/widget_sheet_dish_detail.dart';
import 'package:app/src/utils/app_utils.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';

class WidgetDishCardInMenu extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final double? width;
  const WidgetDishCardInMenu({
    super.key,
    required this.product,
    this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            appHaptic();
            appOpenBottomSheet(WidgetSheetDishDetail(product: product));
          },
      child: Container(
        height: 220.sw,
        width: width ?? 175.sw,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFFF9F8F6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Positioned.fill(
                    child: WidgetAppImage(
                      imageUrl: product.image ?? '',
                      radius: 12.sw,
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 8.sw,
                    bottom: 8.sw,
                    child: Container(
                      width: 40.sw,
                      height: 40.sw,
                      decoration: BoxDecoration(
                        color: hexColor('#DEEFD3').withOpacity(.9),
                        borderRadius: BorderRadius.circular(8.sw),
                      ),
                      alignment: Alignment.center,
                      child: WidgetAppSVG(
                        'icon10',
                        width: 24.sw,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.name ?? '',
              style: w500TextStyle(fontSize: 16.sw),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  currencyFormatted(product.priceCompare?.toDouble()),
                  style: w400TextStyle(
                    fontSize: 16.sw,
                    color: hexColor('#A6A0A0'),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  currencyFormatted(product.price?.toDouble()),
                  style: w600TextStyle(
                    fontSize: 16.sw,
                    color: hexColor('#F17228'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget hiển thị thẻ món ăn phiên bản 2
/// Được sử dụng để hiển thị thông tin chi tiết về món ăn với bố cục ngang
class WidgetDishCardV2 extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const WidgetDishCardV2({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            appHaptic();
            appOpenBottomSheet(WidgetSheetDishDetail(product: product));
          },
      child: Container(
        height: 185.sw,
        width: 285.sw,
        padding: EdgeInsets.all(10.sw),
        decoration: BoxDecoration(
          color: hexColor('#F9F9FC'),
          borderRadius: BorderRadius.circular(12.sw),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.sw,
                            vertical: 5.sw,
                          ),
                          decoration: BoxDecoration(
                            color: hexColor('#F17228'),
                            borderRadius: BorderRadius.circular(12.sw),
                          ),
                          child: Row(
                            children: [
                              WidgetAppSVG(
                                'icon34',
                                width: 14.sw,
                                height: 14.sw,
                              ),
                              SizedBox(width: 2.sw),
                              Text(
                                "20% off",
                                style: w400TextStyle(
                                  fontSize: 12.sw,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 13.sw),
                        SizedBox(
                          width: 140.sw,
                          child: Text(
                            product.name ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: w600TextStyle(fontSize: 18.sw, height: 1.4),
                          ),
                        ),
                        SizedBox(height: 8.sw),
                        Row(
                          children: [
                            Text(
                              currencyFormatted(
                                  product.priceCompare?.toDouble()),
                              style: w400TextStyle(
                                fontSize: 14.sw,
                                color: hexColor('#A6A0A0'),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            SizedBox(width: 3.sw),
                            Text(
                              currencyFormatted(product.price?.toDouble()),
                              style: w500TextStyle(
                                fontSize: 14.sw,
                                color: hexColor('#F17228'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.sw),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.sw),
                    child: WidgetAppImage(
                      imageUrl: product.image ?? '',
                      width: 138.sw,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Gap(8.sw),
            DottedLine(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              lineLength: double.infinity,
              lineThickness: 1.0,
              dashLength: 4.0,
              dashColor: hexColor('#D1D1D1'),
              dashRadius: 0.0,
              dashGapLength: 4.0,
              dashGapColor: Colors.transparent,
              dashGapRadius: 0.0,
            ),
            Gap(8.sw),
            Row(
              children: [
                WidgetAvatar.withoutBorder(
                  imageUrl: product.store?.avatarImage ?? '',
                  radius: 18.sw / 2,
                ),
                SizedBox(width: 8.sw),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.store?.name ?? '',
                        style: w400TextStyle(fontSize: 12.sw),
                      ),
                      Row(
                        children: [
                          WidgetAppSVG(
                            'icon35',
                            width: 16.sw,
                            height: 16.sw,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: 4.sw),
                          Text(
                            "15-20m",
                            style: w400TextStyle(
                              fontSize: 12.sw,
                              color: hexColor('#A6A0A0'),
                            ),
                          ),

                          // SizedBox(width: 4.sw),
                          // Container(
                          //   width: 1,
                          //   height: 11.sw,
                          //   color: hexColor('#D0D0D0'),
                          // ),
                          // SizedBox(width: 4.sw),
                          // Row(
                          //   children: [
                          //     WidgetAppSVG(
                          //       'icon_delivery',
                          //       width: 18.sw,
                          //       height: 18.sw,
                          //     ),
                          //     SizedBox(width: 4.sw),
                          //     Text(
                          //       deliveryFee,
                          //       style: w400TextStyle(fontSize: 12.sw),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    WidgetAppSVG(
                      'icon33',
                      width: 14.sw,
                      height: 14.sw,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 3.sw),
                    Text(
                      product.rating.toString(),
                      style: w400TextStyle(
                        fontSize: 12.sw,
                        color: hexColor('#F17228'),
                      ),
                    ),
                    Text(
                      // ' (${product.ratingCount})',
                      " (100)",
                      style: w400TextStyle(
                        fontSize: 12.sw,
                        color: hexColor('#A6A0A0'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget hiển thị loading state cho thẻ món ăn phiên bản 2
class WidgetDishCardV2Shimmer extends StatelessWidget {
  const WidgetDishCardV2Shimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 185,
      width: 285.sw,
      padding: EdgeInsets.all(10.sw),
      decoration: BoxDecoration(
        color: hexColor('#F9F9FC'),
        borderRadius: BorderRadius.circular(12.sw),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WidgetAppShimmer(
                        width: 80.sw,
                        height: 24.sw,
                      ),
                      SizedBox(height: 13.sw),
                      WidgetAppShimmer(
                        width: 140.sw,
                        height: 24.sw,
                      ),
                      SizedBox(height: 8.sw),
                      Row(
                        children: [
                          WidgetAppShimmer(
                            width: 60.sw,
                            height: 16.sw,
                          ),
                          SizedBox(width: 3.sw),
                          WidgetAppShimmer(
                            width: 80.sw,
                            height: 16.sw,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.sw),
                WidgetAppShimmer(
                  width: 138.sw,
                  height: 138.sw,
                ),
              ],
            ),
          ),
          Gap(8.sw),
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.white,
          ),
          Gap(8.sw),
          Row(
            children: [
              WidgetAppShimmer(
                width: 18.sw,
                height: 18.sw,
              ),
              SizedBox(width: 8.sw),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetAppShimmer(
                      width: 100.sw,
                      height: 12.sw,
                    ),
                    SizedBox(height: 4.sw),
                    Row(
                      children: [
                        WidgetAppShimmer(
                          width: 16.sw,
                          height: 16.sw,
                        ),
                        SizedBox(width: 4.sw),
                        WidgetAppShimmer(
                          width: 60.sw,
                          height: 12.sw,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  WidgetAppShimmer(
                    width: 14.sw,
                    height: 14.sw,
                  ),
                  SizedBox(width: 3.sw),
                  WidgetAppShimmer(
                    width: 20.sw,
                    height: 12.sw,
                  ),
                  SizedBox(width: 2.sw),
                  WidgetAppShimmer(
                    width: 40.sw,
                    height: 12.sw,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WidgetDishCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final double? width;

  const WidgetDishCard({
    Key? key,
    required this.product,
    this.onTap,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            appHaptic();
            appOpenBottomSheet(WidgetSheetDishDetail(product: product));
          },
      child: Container(
        width: width ?? 175.sw,
        height: 220.sw,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.sw),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: WidgetAppImage(
                        imageUrl: product.image ?? '',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(123),
                      ),
                      child: Center(
                        child: WidgetAppSVG(
                          'icon12',
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    left: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: hexColor('#F17228'),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          WidgetAppSVG(
                            'icon34',
                            width: 14.sw,
                            height: 14.sw,
                          ),
                          SizedBox(width: 4.sw),
                          Text(
                            '20% off',
                            style: w400TextStyle(
                              fontSize: 12.sw,
                              height: 1,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      WidgetAvatar.withoutBorder(
                        imageUrl: product.store?.avatarImage ?? '',
                        radius: 18.sw / 2,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          product.store?.name ?? '',
                          maxLines: 1,
                          style: w400TextStyle(
                            fontSize: 12.sw,
                            color: hexColor('#848484'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    WidgetAppSVG(
                      'icon33',
                      width: 14.sw,
                      height: 14.sw,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      product.rating.toString(),
                      style: w400TextStyle(
                        fontSize: 12.sw,
                        color: hexColor('#FC8A06'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              product.name ?? '',
              style: w400TextStyle(fontSize: 16.sw),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    WidgetAppSVG(
                      'icon35',
                      width: 16.sw,
                      height: 16.sw,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "15-20m",
                      style: w400TextStyle(
                        fontSize: 12.sw,
                        color: hexColor('#A6A0A0'),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      currencyFormatted(product.priceCompare?.toDouble()),
                      style: w400TextStyle(
                        fontSize: 12.sw,
                        color: hexColor('#A6A0A0'),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      currencyFormatted(product.price?.toDouble()),
                      style: w500TextStyle(
                        fontSize: 12.sw,
                        color: hexColor('#F17228'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget hiển thị loading state cho thẻ món ăn
class WidgetDishCardShimmer extends StatelessWidget {
  const WidgetDishCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 175.sw,
      height: 220.sw,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.sw),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: WidgetAppShimmer(
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned(
                  top: 8.sw,
                  right: 8.sw,
                  child: WidgetAppShimmer(
                    width: 40.sw,
                    height: 24.sw,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.sw),
          WidgetAppShimmer(
            width: 120.sw,
            height: 16.sw,
          ),
          SizedBox(height: 4.sw),
          Row(
            children: [
              WidgetAppShimmer(
                width: 60.sw,
                height: 16.sw,
              ),
              SizedBox(width: 4.sw),
              WidgetAppShimmer(
                width: 80.sw,
                height: 16.sw,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WidgetDishCardInMenuShimmer extends StatelessWidget {
  final double? width;
  const WidgetDishCardInMenuShimmer({super.key, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 175.sw,
      padding: EdgeInsets.all(8.sw),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.sw),
        color: const Color(0xFFF9F8F6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetAppShimmer(
            width: 159.sw,
            height: 159.sw,
          ),
          SizedBox(height: 8.sw),
          WidgetAppShimmer(
            width: 120.sw,
            height: 20.sw,
          ),
          SizedBox(height: 4.sw),
          Row(
            children: [
              WidgetAppShimmer(
                width: 60.sw,
                height: 20.sw,
              ),
              SizedBox(width: 4.sw),
              WidgetAppShimmer(
                width: 80.sw,
                height: 20.sw,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
