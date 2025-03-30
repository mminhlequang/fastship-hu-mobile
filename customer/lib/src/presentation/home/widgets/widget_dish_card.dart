import 'package:app/src/constants/constants.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';

/// Widget hiển thị thẻ món ăn phiên bản 2
/// Được sử dụng để hiển thị thông tin chi tiết về món ăn với bố cục ngang
class WidgetDishCardV2 extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String restaurantName;
  final String deliveryTime;
  final String originalPrice;
  final String discountedPrice;
  final String discountPercentage;
  final String rating;
  final String reviewCount;
  final String deliveryFee;

  const WidgetDishCardV2({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.restaurantName,
    required this.deliveryTime,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercentage,
    required this.rating,
    required this.reviewCount,
    required this.deliveryFee,
  }) : super(key: key);

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
                              discountPercentage,
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
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: w600TextStyle(fontSize: 18.sw, height: 1.4),
                        ),
                      ),
                      SizedBox(height: 8.sw),
                      Row(
                        children: [
                          Text(
                            originalPrice,
                            style: w400TextStyle(
                              fontSize: 14.sw,
                              color: hexColor('#A6A0A0'),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          SizedBox(width: 3.sw),
                          Text(
                            discountedPrice,
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
                    imageUrl: imageUrl,
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
              CircleAvatar(
                radius: 18.sw,
                backgroundImage: NetworkImage(imageUrl),
              ),
              SizedBox(width: 8.sw),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurantName,
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
                          deliveryTime,
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
                    rating,
                    style: w400TextStyle(
                      fontSize: 12.sw,
                      color: hexColor('#F17228'),
                    ),
                  ),
                  Text(
                    ' ($reviewCount)',
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
    );
  }
}

class WidgetDishCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String rating;
  final String deliveryTime;
  final String originalPrice;
  final String discountedPrice;
  final String discountPercentage;
  final double? width;

  const WidgetDishCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.deliveryTime,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercentage,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ??  175.sw,
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: WidgetAppImage(
                    imageUrl: imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
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
                          '$discountPercentage off',
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
              Row(
                children: [
                  Image.network(
                    'https://cdn.builder.io/api/v1/image/assets/TEMP/473a7b3b713820da1587d9e18f45e3600a86de71?placeholderIfAbsent=true',
                    width: 18,
                    height: 18,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    name,
                    style: w400TextStyle(
                      fontSize: 12.sw,
                      color: hexColor('#848484'),
                    ),
                  ),
                ],
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
                    rating,
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
            name,
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
                    deliveryTime,
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
                    originalPrice,
                    style: w400TextStyle(
                      fontSize: 12.sw,
                      color: hexColor('#A6A0A0'),
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    discountedPrice,
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
    );
  }
}
