import 'package:app/src/base/cubit/location_cubit.dart';
import 'package:app/src/constants/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:network_resources/category/model/category.dart';
import 'package:network_resources/category/repo.dart';
import 'package:network_resources/product/model/product.dart';
import 'package:network_resources/product/repo.dart';
import 'package:network_resources/store/models/store.dart';
import 'package:network_resources/store/repo.dart';
import 'package:app/src/presentation/widgets/widget_search_field.dart';
import 'package:app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';
import '../home/widgets/widget_category_card.dart';
import '../home/widgets/widget_dialog_filters.dart';
import '../home/widgets/widget_dish_card.dart';
import '../home/widgets/widget_restaurant_card.dart';

List<CategoryModel>? _categories;

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({super.key});

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  bool isRestaurant = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  CategoryModel? _selectedCategory;
  CategoryModel? _selectedSubCategory;

  void _fetchCategories() async {
    final response = await CategoryRepo().getCategories({});
    if (response.isSuccess) {
      _categories = response.data;
      _selectedCategory = _categories?.first;
      if (_selectedCategory?.children?.isNotEmpty ?? false) {
        _selectedSubCategory = _selectedCategory?.children?.first;
      }

      if (isRestaurant) {
        _fetchRestaurants();
      } else {
        _fetchFoods();
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  List<StoreModel>? _restaurants;
  List<ProductModel>? _foods;
  void _fetchRestaurants() async {
    _restaurants = null;
    setState(() {});
    final response = await StoreRepo().getStores({
      "lat": locationCubit.latitude,
      "lng": locationCubit.longitude,
      "category_ids": [
        _selectedCategory?.id,
        if (_selectedSubCategory?.id != null) _selectedSubCategory?.id
      ].join(','),
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
    final response = await ProductRepo().getProducts({
      "lat": locationCubit.latitude,
      "lng": locationCubit.longitude,
      "category_ids": [
        _selectedCategory?.id,
        if (_selectedSubCategory?.id != null) _selectedSubCategory?.id
      ].join(','),
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: WidgetSearchField(onTap: () {}),
              ),
              SingleChildScrollView(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _categories == null
                      ? List.generate(
                          5,
                          (index) => const WidgetCategoryCardShimmer(),
                        )
                      : _categories!.map((category) {
                          return WidgetCategoryCard(
                            title: category.name ?? '',
                            imageUrl: category.image ?? '',
                            isSelected: _selectedCategory?.id == category.id,
                            onTap: () {
                              appHaptic();
                              setState(() {
                                _selectedCategory = category;
                                if (_selectedCategory?.children?.isNotEmpty ??
                                    false) {
                                  _selectedSubCategory =
                                      _selectedCategory?.children?.first;
                                }
                                if (isRestaurant) {
                                  _fetchRestaurants();
                                } else {
                                  _fetchFoods();
                                }
                              });
                            },
                          );
                        }).toList(),
                ),
              ),
              SizedBox(height: 24),
              _buildSubCatFilters(),
              SizedBox(height: 12),
              _buildList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubCatFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Wrap(
              spacing: 10.sw,
              runSpacing: 12.sw,
              children: _selectedCategory == null
                  ? List.generate(
                      3,
                      (index) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 80,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    )
                  : _selectedCategory?.children
                          ?.map((e) => _buildFilterChip(e,
                              isSelected: e.id == _selectedSubCategory?.id))
                          .toList() ??
                      [],
            ),
          ),
          GestureDetector(
            onTap: () {
              appHaptic();
              appOpenDialog(WidgetDialogFilters());
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFFEEE)),
              ),
              child: Center(
                child: WidgetAppSVG('icon30', width: 24, height: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(CategoryModel category, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        appHaptic();
        setState(() {
          _selectedSubCategory = category;
        });
        if (isRestaurant) {
          _fetchRestaurants();
        } else {
          _fetchFoods();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? appColorPrimary : Color(0xFFF9F8F6),
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: appColorPrimary) : null,
        ),
        child: Text(
          category.name ?? '',
          style: w400TextStyle(
            fontSize: 14.sw,
            color: isSelected ? Colors.white : appColorText,
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          if (isRestaurant)
            _restaurants == null
                ? ListView.builder(
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
    );
  }
}


class WidgetFoodRestaurantTabbar extends StatelessWidget {
 final bool isRestaurant;
 final VoidCallback onTapRestaurant;
 final VoidCallback onTapFood;
 final double padding;
 
  const WidgetFoodRestaurantTabbar({super.key, required this.isRestaurant, required this.onTapRestaurant, required this.onTapFood,   this.padding = 16});
 
 @override
  Widget build(BuildContext context) {
    return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: WidgetInkWellTransparent(
                      onTap: () {
                        appHaptic();
                        onTapRestaurant();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.sw),
                        child: Center(
                          child: Text(
                            'All restaurants'.tr(),
                            style: w400TextStyle(
                                fontSize: 18.sw,
                                color: isRestaurant
                                    ? appColorText
                                    : Color(0xFF847D79)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: WidgetInkWellTransparent(
                      onTap: () {
                        appHaptic();
                        onTapFood();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.sw),
                        child: Center(
                          child: Text(
                            'All foods'.tr(),
                            style: w400TextStyle(
                                fontSize: 18.sw,
                                color: !isRestaurant
                                    ? appColorText
                                    : Color(0xFF847D79)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                left: isRestaurant ? 0 : context.width / 2 - 16 + 12,
                child: Container(
                  width: context.width / 2 - padding - 12,
                  height: 2,
                  color: appColorText2,
                ),
              )
            ],
          );
  }
}