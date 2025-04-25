import 'package:app/src/base/cubit/location_cubit.dart';
import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widget_appbar.dart';
import 'package:app/src/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/network_resources.dart';
import 'package:network_resources/product/model/product.dart';
import 'package:network_resources/product/repo.dart';
import 'package:network_resources/store/models/models.dart';
import 'package:network_resources/store/repo.dart';

import '../home/widgets/widget_dialog_filters.dart';
import '../home/widgets/widget_dish_card.dart';
import '../home/widgets/widget_restaurant_card.dart';
import '../restaurants/restaurants_screen.dart';
import '../widgets/widget_search_field.dart';

class FilterResultsParams {
  String name;
  List<String> listChip;
  Map<String, dynamic> params;

  FilterResultsParams({
    required this.name,
    required this.listChip,
    required this.params,
  });
}

class FilterResultsScreen extends StatefulWidget {
  final FilterResultsParams params;
  const FilterResultsScreen({super.key, required this.params});

  @override
  State<FilterResultsScreen> createState() => _FilterResultsScreenState();
}

class _FilterResultsScreenState extends State<FilterResultsScreen> {
  bool isRestaurant = true;

  @override
  void initState() {
    super.initState();
    if (isRestaurant) {
      _fetchRestaurants();
    } else {
      _fetchFoods();
    }
  }

  List<StoreModel>? _restaurants;
  List<ProductModel>? _foods;
  void _fetchRestaurants() async {
    _restaurants = null;
    setState(() {});

    Map<String, dynamic> params = {
      "lat": locationCubit.latitude,
      "lng": locationCubit.longitude,
    };
    if (widget.params.params.isNotEmpty) {
      params.addAll(widget.params.params);
    }
    final response = await StoreRepo().getStores(params);
    if (response.isSuccess) {
      _restaurants = response.data;
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _fetchFoods() async {
    _foods = null;
    setState(() {});
    Map<String, dynamic> params = {
      "lat": locationCubit.latitude,
      "lng": locationCubit.longitude,
    };
    if (widget.params.params.isNotEmpty) {
      params.addAll(widget.params.params);
    }
    final response = await ProductRepo().getProducts(params);
    if (response.isSuccess) {
      _foods = response.data;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColorBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WidgetAppBar(
            title: Row(
              children: [
                Expanded(child: WidgetSearchField(onTap: () {})),
                WidgetInkWellTransparent(
                  onTap: () {
                    appHaptic();
                    // appOpenDialog(WidgetDialogFilters());
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                    child: WidgetAppSVG('icon26', width: 24.sw, height: 24.sw),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.params.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: w600TextStyle(fontSize: 20.sw),
                        ),
                      ),
                      SizedBox(width: 24),
                      GestureDetector(
                        onTap: () {
                          appHaptic();
                          context.pop();
                          appOpenDialog(WidgetDialogFilters(
                            isRestaurant: isRestaurant,
                            initialParams: widget.params.params,
                          ));
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: hexColor('#EEEEEE')),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: WidgetAppSVG(
                              'icon30',
                              width: 24.sw,
                              height: 24.sw,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.params.listChip.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.params.listChip
                          .map((e) => _WidgetFilterChip(label: e))
                          .toList(),
                    ),
                  const SizedBox(height: 8),
                  WidgetFoodRestaurantTabbar(
                    isRestaurant: isRestaurant,
                    onTapRestaurant: () {
                      setState(() {
                        isRestaurant = true;
                      });
                      _fetchRestaurants();
                    },
                    onTapFood: () {
                      setState(() {
                        isRestaurant = false;
                      });
                      _fetchFoods();
                    },
                    padding: 16,
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: (isRestaurant)
                        ? _restaurants == null
                            ? ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: WidgetRestaurantCardShimmer(),
                                  );
                                },
                              )
                            : ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: _restaurants?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: WidgetRestaurantCard(
                                      store: _restaurants![index],
                                    ),
                                  );
                                },
                              )
                        : _foods == null
                            ? SingleChildScrollView(
                                child: Wrap(
                                  spacing: 16.sw,
                                  runSpacing: 20.sw,
                                  children: List.generate(
                                    8,
                                    (index) => SizedBox(
                                      width: context.width / 2 - 16 - 8.sw,
                                      child: WidgetDishCardShimmer(),
                                    ),
                                  ),
                                ),
                              )
                            : SingleChildScrollView(
                                child: Wrap(
                                  spacing: 16.sw,
                                  runSpacing: 20.sw,
                                  children: List.generate(
                                    _foods?.length ?? 0,
                                    (index) => WidgetDishCard(
                                      width: context.width / 2 - 16 - 8.sw,
                                      product: _foods![index],
                                    ),
                                  ),
                                ),
                              ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _WidgetFilterChip extends StatelessWidget {
  final String label;

  const _WidgetFilterChip({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: appColorPrimaryOrange,
        ),
      ),
      child: Text(
        label,
        style: w400TextStyle(
          color: appColorPrimaryOrange,
          fontSize: 14,
          height: 1.2,
        ),
      ),
    );
  }
}

class FoodItemCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double price;
  final double originalPrice;
  final double rating;
  final String distance;
  final String restaurantName;
  final String restaurantLogo;
  final double discount;

  const FoodItemCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.distance,
    required this.restaurantName,
    required this.restaurantLogo,
    required this.discount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 146,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 5,
              left: 5,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(123),
                ),
                child: Center(
                  child: Image.network(
                    'https://cdn.builder.io/api/v1/image/assets/TEMP/d79c26fb1d5dfd86c1ad48ea6283aa258b25b41c?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
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
                  color: const Color(0xFFF17228),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 14,
                      height: 14,
                    ),
                    Text(
                      currencyFormatted(discount) + ' off',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Fredoka',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: Image.network(
                    restaurantLogo,
                    width: 18,
                    height: 18,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  restaurantName,
                  style: TextStyle(
                    color: const Color(0xFF847D79),
                    fontFamily: 'Fredoka',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Color(0xFFFC8A06),
                  size: 14,
                ),
                const SizedBox(width: 3),
                Text(
                  rating.toString(),
                  style: TextStyle(
                    color: const Color(0xFFFC8A06),
                    fontFamily: 'Fredoka',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.06,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Fredoka',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: Color(0xFFA6A0A0),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  distance,
                  style: TextStyle(
                    color: const Color(0xFFA6A0A0),
                    fontFamily: 'Fredoka',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  currencyFormatted(originalPrice),
                  style: w400TextStyle(
                    color: const Color(0xFFA6A0A0),
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough,
                    
                  ),
                ),
                const SizedBox(width: 3),
                Text(
                  currencyFormatted(price),
                  style: w500TextStyle(
                    color: const Color(0xFFED653B),
                    fontSize: 12,
                     ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
