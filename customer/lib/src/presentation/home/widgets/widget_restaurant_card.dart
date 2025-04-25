import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/home/widgets/widget_dish_card.dart';
import 'package:network_resources/network_resources.dart';
import 'package:network_resources/store/models/store.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/store/repo.dart';

class WidgetRestaurantCard extends StatefulWidget {
  final StoreModel store;
  final VoidCallback? onTap;

  const WidgetRestaurantCard({
    super.key,
    required this.store,
    this.onTap,
  });

  @override
  State<WidgetRestaurantCard> createState() => _WidgetRestaurantCardState();
}

class _WidgetRestaurantCardState extends State<WidgetRestaurantCard> {
  Future<void> toggleFavorite() async {
    widget.store.isFavorite = widget.store.isFavorite == 1 ? 0 : 1;
    setState(() {});
    appHaptic();

    final result = await StoreRepo().favoriteStore(widget.store.id ?? 0);
    if (result.isSuccess) {
      setState(() {});
    } else {
      widget.store.isFavorite = widget.store.isFavorite == 1 ? 0 : 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ??
          () {
            appHaptic();
            context.push('/restaurant-detail/${widget.store.id}');
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
            Stack(
              children: [
                WidgetAppImage(
                  imageUrl: widget.store.avatarImage ?? '',
                  width: 105.sw,
                  height: 105.sw,
                  fit: BoxFit.cover,
                  radius: 8.sw,
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: WidgetFavoriteState(
                    isFavorite: widget.store.isFavorite == 1,
                    onTap: toggleFavorite,
                  ),
                ),
              ],
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.store.name ?? '',
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
                  Text(
                    widget.store.categories?.map((e) => e.name).join(', ') ??
                        '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: w400TextStyle(
                      fontSize: 14.sw,
                      color: Color(0xFF847D79),
                    ),
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
                      // Container(
                      //   height: 28.sw,
                      //   padding: EdgeInsets.symmetric(horizontal: 10),
                      //   decoration: BoxDecoration(
                      //     color: Color(0xFFF17228),
                      //     border: Border.all(color: Color(0xFFF17228)),
                      //     borderRadius: BorderRadius.circular(12),
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       WidgetAppSVG('icon34', width: 14, height: 14),
                      //       SizedBox(width: 2),
                      //       Text(
                      //         "20%",
                      //         style: w400TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 14.sw,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(width: 12),
                      Container(
                        height: 28.sw,
                        padding: EdgeInsets.symmetric(horizontal: 10),
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
                              '15m',
                              style: w400TextStyle(
                                color: Color(0xFFFFAB17),
                                fontSize: 14.sw,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          WidgetAppSVG(
                            'icon33',
                            width: 14.sw,
                            height: 14.sw,
                          ),
                          SizedBox(width: 3),
                          Text(
                            widget.store.rating.toString(),
                            style: w500TextStyle(
                              fontSize: 12.sw,
                              color: Color(0xFFFC8A06),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 8.sw),
                      Row(
                        children: [
                          WidgetAppSVG.network(
                            'https://cdn.builder.io/api/v1/image/assets/TEMP/e2823b525107b0083e65551c21cd6bf62a92eae8?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                            width: 20,
                            height: 20,
                          ),
                          SizedBox(width: 4),
                          Text(
                            currencyFormatted(8000),
                            style: w400TextStyle(
                              fontSize: 14.sw,
                            ),
                          ),
                        ],
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
  final StoreModel store;
  final VoidCallback? onTap;

  const WidgetRestaurantDiscountCard({
    super.key,
    required this.store,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            appHaptic();
            context.push('/restaurant-detail/${store.id}');
          },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: WidgetAppImage(
                    imageUrl: store.avatarImage ?? '',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    radius: 12.sw,
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
                      '40% off',
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
          SizedBox(height: 8.sw),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                store.name ?? '',
                style: w600TextStyle(
                  fontSize: 16.sw,
                ),
              ),
              Row(
                children: [
                  Text(
                    store.rating.toString(),
                    style: w500TextStyle(fontSize: 14.sw),
                  ),
                  SizedBox(width: 2.sw),
                  WidgetAppSVG('icon33', width: 14.sw, height: 14.sw),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Widget hiển thị loading state cho thẻ nhà hàng
class WidgetRestaurantCardShimmer extends StatelessWidget {
  const WidgetRestaurantCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetAppShimmer(
            width: 105.sw,
            height: 105.sw,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetAppShimmer(
                  width: 150.sw,
                  height: 20.sw,
                ),
                SizedBox(height: 9),
                WidgetAppShimmer(
                  width: double.infinity,
                  height: 16.sw,
                ),
                SizedBox(height: 9),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.white,
                ),
                SizedBox(height: 9),
                Row(
                  children: [
                    WidgetAppShimmer(
                      width: 60.sw,
                      height: 30.sw,
                    ),
                    SizedBox(width: 12),
                    WidgetAppShimmer(
                      width: 80.sw,
                      height: 30.sw,
                    ),
                    Spacer(),
                    WidgetAppShimmer(
                      width: 40.sw,
                      height: 16.sw,
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
}

/// Widget hiển thị loading state cho thẻ giảm giá nhà hàng
class WidgetRestaurantDiscountCardShimmer extends StatelessWidget {
  const WidgetRestaurantDiscountCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              WidgetAppShimmer(
                width: double.infinity,
                height: double.infinity,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: WidgetAppShimmer(
                  width: 60.sw,
                  height: 24.sw,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.sw),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            WidgetAppShimmer(
              width: 120.sw,
              height: 20.sw,
            ),
            WidgetAppShimmer(
              width: 60.sw,
              height: 16.sw,
            ),
          ],
        ),
      ],
    );
  }
}
