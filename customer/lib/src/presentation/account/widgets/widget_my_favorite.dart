import 'package:app/src/base/cubit/location_cubit.dart';
import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/home/widgets/widget_dish_card.dart';
import 'package:app/src/presentation/home/widgets/widget_restaurant_card.dart';
import 'package:app/src/presentation/restaurants/restaurants_screen.dart';
import 'package:app/src/presentation/widgets/widget_appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/product/model/product.dart';
import 'package:network_resources/product/repo.dart';
import 'package:network_resources/store/models/models.dart';
import 'package:network_resources/store/repo.dart';

class MyFavoriteScreen extends StatefulWidget {
  const MyFavoriteScreen({super.key});

  @override
  State<MyFavoriteScreen> createState() => _MyFavoriteScreenState();
}

class _MyFavoriteScreenState extends State<MyFavoriteScreen> {
  bool isRestaurant = true;

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }

  List<StoreModel>? _restaurants;
  List<ProductModel>? _foods;
  void _fetchRestaurants() async {
    _restaurants = null;
    setState(() {});
    final response = await StoreRepo().getStores({
      "lat": locationCubit.latitude,
      "lng": locationCubit.longitude,
      "is_favorite": 1,
    });
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
    final response = await ProductRepo().getFavoriteProducts({
      "lat": locationCubit.latitude,
      "lng": locationCubit.longitude,
    });
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetAppBar(
            title: 'My Favorite'.tr(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sw),
            child: WidgetFoodRestaurantTabbar(
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
              padding: 16.sw,
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.sw),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    if (isRestaurant)
                      _restaurants == null
                          ? ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
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
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
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
                    else
                      _foods == null
                          ? Wrap(
                              spacing: 16.sw,
                              runSpacing: 20.sw,
                              children: List.generate(
                                8,
                                (index) => SizedBox(
                                  width: context.width / 2 - 16 - 8.sw,
                                  child: WidgetDishCardShimmer(),
                                ),
                              ),
                            )
                          : Wrap(
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
                    SizedBox(height: 110),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
