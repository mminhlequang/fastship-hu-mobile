import 'package:app/src/constants/constants.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';

class WidgetRestaurantCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String logoUrl;
  final String category;
  final double rating;
  final double deliveryFee;
  final String? discount;
  final String deliveryTime;

  const WidgetRestaurantCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.logoUrl,
    required this.category,
    required this.rating,
    required this.deliveryFee,
    this.discount,
    required this.deliveryTime,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Sử dụng hàm từ utils
        appHaptic();
        // appOpenBottomSheet(const WidgetRestaurantMenu());
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFFF9F8F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 105,
                height: 105,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      WidgetAvatar.withoutBorder(
                        radius: 11.5,
                        imageUrl: logoUrl,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: w500TextStyle(
                            fontSize: 18.sw,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 9),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Salads",
                            style: w400TextStyle(
                              fontSize: 14.sw,
                              color: Color(0xFF847D79),
                            ),
                          ),
                          SizedBox(width: 12),
                          Container(
                            width: 1,
                            height: 16,
                            color: Color(0xFFF1EFE9),
                          ),
                          SizedBox(width: 12),
                          Row(
                            children: [
                              WidgetAppSVG(
                                'icon33',
                                width: 14.sw,
                                height: 14.sw,
                              ),
                              SizedBox(width: 3),
                              Text(
                                rating.toString(),
                                style: w500TextStyle(
                                  fontSize: 12.sw,
                                  color: Color(0xFFFC8A06),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          WidgetAppSVG.network(
                            'https://cdn.builder.io/api/v1/image/assets/TEMP/e2823b525107b0083e65551c21cd6bf62a92eae8?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                            width: 20,
                            height: 20,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '\$${deliveryFee.toStringAsFixed(2)}',
                            style: w400TextStyle(
                              fontSize: 14.sw,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 9),
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
                  SizedBox(height: 9),
                  Row(
                    children: [
                      // if (discount != null)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Color(0xFFF17228),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            WidgetAppSVG('icon34', width: 14, height: 14),
                            SizedBox(width: 2),
                            Text(
                              "20%",
                              style: w400TextStyle(
                                color: Colors.white,
                                fontSize: 14.sw,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFFFAB17)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            WidgetAppSVG('icon35',
                                color: Color(0xFFFFAB17),
                                width: 16,
                                height: 16),
                            SizedBox(width: 2),
                            Text(
                              deliveryTime,
                              style: w400TextStyle(
                                color: Color(0xFFFFAB17),
                                fontSize: 14.sw,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget hiển thị thẻ giảm giá nhà hàng
/// Được sử dụng để hiển thị các ưu đãi đặc biệt từ nhà hàng
class WidgetRestaurantDiscountCard extends StatelessWidget {
  final String imageUrl;
  final String discount;
  final String rating;
  final String? title;

  const WidgetRestaurantDiscountCard({
    Key? key,
    required this.imageUrl,
    required this.discount,
    required this.rating,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.sw, vertical: 6.sw),
                  decoration: BoxDecoration(
                    color: appColorPrimary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    discount,
                    style: w400TextStyle(
                      fontSize: 12.sw,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (title != null) ...[
          SizedBox(height: 8.sw),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title!,
                style: w600TextStyle(
                  fontSize: 16.sw,
                ),
              ),
              Row(
                children: [
                  Text(
                    rating,
                    style: w500TextStyle(
                      fontSize: 14.sw,
                      color: hexColor('#F17228'),
                    ),
                  ),
                  SizedBox(width: 2.sw),
                  Icon(
                    Icons.star,
                    color: hexColor('#F17228'),
                    size: 16.sw,
                  ),
                ],
              ),
            ],
          ),
        ],
      ],
    );
  }
}
