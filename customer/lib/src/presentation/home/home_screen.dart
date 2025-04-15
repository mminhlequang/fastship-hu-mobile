import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';
import 'package:internal_core/widgets/widgets.dart';
import 'package:network_resources/banners/models/models.dart';
import 'package:network_resources/banners/repo.dart';
import 'package:network_resources/category/model/category.dart';
import 'package:network_resources/category/repo.dart';
import 'package:network_resources/news/models/models.dart';
import 'package:network_resources/news/repo.dart';
import 'package:network_resources/product/model/product.dart';
import 'package:network_resources/product/repo.dart';
import 'package:network_resources/store/models/models.dart';
import 'package:network_resources/store/repo.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:app/src/base/bloc.dart';
import 'package:app/src/base/cubit/location_cubit.dart';
import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/navigation/cubit/navigation_cubit.dart';
import 'package:app/src/presentation/widgets/widget_search_field.dart';
import 'package:app/src/utils/utils.dart';

import '../cart/cubit/cart_cubit.dart';
import '../notifications/cubit/notification_cubit.dart';
import 'widgets/widget_category_card.dart';
import 'widgets/widget_dialog_filters.dart';
import 'widgets/widget_dish_card.dart';
import 'widgets/widget_news_card.dart';
import 'widgets/widget_restaurant_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<CategoryModel?> _categoryNotifier =
      ValueNotifier<CategoryModel?>(null);

  @override
  void dispose() {
    _categoryNotifier.dispose();
    super.dispose();
  }

  Widget _categoryNotifierBuilder(
      {required Widget Function(String? categoryIds, CategoryModel? category)
          builder}) {
    return ValueListenableBuilder(
      valueListenable: _categoryNotifier,
      builder: (context, value, child) {
        List<int> categoryIds = [];
        if (value != null) {
          List<int> tempCategoryIds = [];
          tempCategoryIds.add(value.id!);

          // Thêm tất cả child id vào list
          if (value.children != null && value.children!.isNotEmpty) {
            for (var child in value.children!) {
              if (child.id != null) {
                tempCategoryIds.add(child.id!);
              }
            }
          }

          categoryIds = tempCategoryIds;
        }
        return builder(
            categoryIds.isEmpty ? null : categoryIds.join(','), value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColorBackground,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.sw),
        children: [
          SizedBox(
            height: 12.sw + context.mediaQueryPadding.top,
          ),
          const _LocationHeader(),
          const SizedBox(height: 17),
          WidgetSearchField(onTap: () {}),
          const SizedBox(height: 17),
          const _PromoBanner(),
          const SizedBox(height: 24),
          _CategorySection(
            categoryNotifier: _categoryNotifier,
          ),
          const SizedBox(height: 24),
          _categoryNotifierBuilder(
            builder: (categoryIds, category) => _FastestDeliverySection(
              key: Key('fastest_delivery_section_$categoryIds'),
              categoryIds: categoryIds,
            ),
          ),
          const SizedBox(height: 32),
          _categoryNotifierBuilder(
            builder: (categoryIds, category) => _RestaurantDiscountSection(
              key: Key('restaurant_discount_section_$categoryIds'),
              categoryIds: categoryIds,
              category: category,
            ),
          ),
          const SizedBox(height: 32),
          _categoryNotifierBuilder(
            builder: (categoryIds, category) => _BestSellerSection(
              key: Key('best_seller_section_$categoryIds'),
              categoryIds: categoryIds,
            ),
          ),
          const SizedBox(height: 32),
          _categoryNotifierBuilder(
            builder: (categoryIds, category) => _RestaurantHighRating(
              key: Key('restaurant_high_rating_section_$categoryIds'),
              categoryIds: categoryIds,
            ),
          ),
          const SizedBox(height: 32),
          _categoryNotifierBuilder(
            builder: (categoryIds, category) => _RecommendedSection(
              key: Key('recommended_section_$categoryIds'),
              categoryIds: categoryIds,
            ),
          ),
          const SizedBox(height: 32),
          const _PartnerSection(),
          const SizedBox(height: 32),
          const _NewsSection(),
          SizedBox(height: 140 + context.mediaQueryPadding.bottom),
        ],
      ),
    );
  }
}

List<BannerModel>? _banners;

class _PromoBanner extends StatefulWidget {
  const _PromoBanner({super.key});

  @override
  State<_PromoBanner> createState() => __PromoBannerState();
}

class __PromoBannerState extends State<_PromoBanner> {
  @override
  void initState() {
    super.initState();
    _fetchBanners();
  }

  void _fetchBanners() async {
    final response = await BannersRepo()
        .getBanners({"country_code": locationCubit.countryCode});
    if (response.isSuccess) {
      _banners = response.data;
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 146.sw,
        clipBehavior: Clip.none,
        viewportFraction: 0.8,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        enlargeCenterPage: true,
      ),
      items: List.generate(
        _banners == null ? 3 : _banners!.length,
        (index) => _banners == null
            ? _buildShimmerBanner()
            : GestureDetector(
                onTap: () {
                  appHaptic();
                  if (_banners![index].externalLink != null &&
                      _banners![index].externalLink!.isNotEmpty) {
                    launchUrl(Uri.parse(_banners![index].externalLink!));
                  } else {
                    //TODO: check logic
                  }
                },
                child: WidgetAppImage(
                  imageUrl: _banners![index].image ?? '',
                  width: double.infinity,
                  height: 146.sw,
                  fit: BoxFit.fill,
                  radius: 12.sw,
                ),
              ),
      ),
    );
  }

  Widget _buildShimmerBanner() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 146.sw,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

List<CategoryModel>? appProductCategories;
int? _categoryIdSelected;

class _CategorySection extends StatefulWidget {
  final ValueNotifier<CategoryModel?> categoryNotifier;
  const _CategorySection({super.key, required this.categoryNotifier});

  @override
  State<_CategorySection> createState() => __CategorySectionState();
}

class __CategorySectionState extends State<_CategorySection> {
  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  void _fetchCategories() async {
    final response = await CategoryRepo().getCategories({});
    if (response.isSuccess) {
      appProductCategories = response.data;
      if (appProductCategories != null && appProductCategories!.isNotEmpty) {
        widget.categoryNotifier.value = appProductCategories!.firstWhere(
          (category) => category.id == _categoryIdSelected,
          orElse: () => appProductCategories!.first,
        );
        _categoryIdSelected = widget.categoryNotifier.value?.id;
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Popular Categories'.tr(),
              style: w400TextStyle(fontSize: 20.sw),
            ),
            GestureDetector(
              onTap: () {
                appHaptic();
                appOpenDialog(WidgetDialogFilters());
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
        const SizedBox(height: 16),
        ValueListenableBuilder(
            valueListenable: widget.categoryNotifier,
            builder: (context, value, child) {
              return SingleChildScrollView(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: appProductCategories == null
                      ? List.generate(
                          5,
                          (index) => const WidgetCategoryCardShimmer(),
                        )
                      : appProductCategories!.map((category) {
                          return WidgetCategoryCard(
                            title: category.name ?? '',
                            imageUrl: category.image ?? '',
                            isSelected: value?.id == category.id,
                            onTap: () {
                              appHaptic();
                              widget.categoryNotifier.value = category;
                              _categoryIdSelected = category.id;
                            },
                          );
                        }).toList(),
                ),
              );
            }),
      ],
    );
  }
}

List<ProductModel>? _fastestDeliveryProducts;

class _FastestDeliverySection extends StatefulWidget {
  final String? categoryIds;
  const _FastestDeliverySection({super.key, this.categoryIds});

  @override
  State<_FastestDeliverySection> createState() =>
      __FastestDeliverySectionState();
}

class __FastestDeliverySectionState extends State<_FastestDeliverySection> {
  @override
  void initState() {
    super.initState();
    if (widget.categoryIds != null) _fetchFastestDeliveryProducts();
  }

  void _fetchFastestDeliveryProducts() async {
    final response = await ProductRepo().getProducts({
      if (widget.categoryIds != null) "category_ids": widget.categoryIds,
    });
    if (response.isSuccess) {
      _fastestDeliveryProducts = response.data;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _WidgetTitle(
          title: 'Fastest Delivery'.tr(),
          onTap: () {},
        ),
        SingleChildScrollView(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 12.sw,
            children: _fastestDeliveryProducts == null
                ? List.generate(
                    5,
                    (index) => const WidgetDishCardShimmer(),
                  ).toList()
                : _fastestDeliveryProducts!.map((product) {
                    return WidgetDishCard(product: product);
                  }).toList(),
          ),
        ),
      ],
    );
  }
}

List<StoreModel>? _restaurantHighRating;

class _RestaurantHighRating extends StatefulWidget {
  final String? categoryIds;
  const _RestaurantHighRating({super.key, this.categoryIds});

  @override
  State<_RestaurantHighRating> createState() => __RestaurantHighRatingState();
}

class __RestaurantHighRatingState extends State<_RestaurantHighRating> {
  @override
  void initState() {
    super.initState();
    if (widget.categoryIds != null) _fetchRestaurantHighRating();
  }

  void _fetchRestaurantHighRating() async {
    final response = await StoreRepo().getStores({
      if (widget.categoryIds != null) "category_ids": widget.categoryIds,
    });
    if (response.isSuccess) {
      _restaurantHighRating = response.data;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _WidgetTitle(
          title: 'High Rated Restaurants'.tr(),
          onTap: () {},
        ),
        ..._restaurantHighRating == null
            ? List.generate(
                3,
                (index) => const WidgetRestaurantCardShimmer(),
              ).toList()
            : _restaurantHighRating!.map((store) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.sw),
                  child: WidgetRestaurantCard(store: store),
                );
              }).toList()
      ],
    );
  }
}

List<StoreModel>? _restaurantDiscounts;

class _RestaurantDiscountSection extends StatefulWidget {
  final String? categoryIds;
  final CategoryModel? category;
  const _RestaurantDiscountSection(
      {super.key, this.categoryIds, this.category});

  @override
  State<_RestaurantDiscountSection> createState() =>
      __RestaurantDiscountSectionState();
}

class __RestaurantDiscountSectionState
    extends State<_RestaurantDiscountSection> {
  late CategoryModel? _subCategorySelected =
      widget.category?.children?.isNotEmpty == true
          ? widget.category?.children?.first
          : null;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) _fetchRestaurantDiscounts();
  }

  void _fetchRestaurantDiscounts() async {
    final response = await StoreRepo().getStores({
      if (widget.category != null)
        "category_ids": [
          widget.category?.id,
          if (_subCategorySelected != null) _subCategorySelected?.id
        ].join(','),
    });
    if (response.isSuccess) {
      _restaurantDiscounts = response.data;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _WidgetTitle(
          title: 'Discount Guaranteed! 👌'.tr(),
          onTap: () {},
        ),
        if (widget.category != null &&
            widget.category!.children != null &&
            widget.category!.children!.isNotEmpty) ...[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              spacing: 10.sw,
              children: widget.category!.children!.map((category) {
                return _buildFilterChip(category);
              }).toList(),
            ),
          ),
          const SizedBox(height: 24)
        ],
        CarouselSlider(
          options: CarouselOptions(
            height: 210.sw,
            viewportFraction: 0.68,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enlargeCenterPage: true,
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
          ),
          items: _restaurantDiscounts == null
              ? List.generate(
                  3,
                  (index) => WidgetRestaurantDiscountCardShimmer(),
                )
              : _restaurantDiscounts!.map((store) {
                  return WidgetRestaurantDiscountCard(store: store);
                }).toList(),
        ),
      ],
    );
  }

  Widget _buildFilterChip(CategoryModel category) {
    bool isSelected = _subCategorySelected?.id == category.id;
    return GestureDetector(
      onTap: () {
        appHaptic();
        setState(() {
          _subCategorySelected = category;
        });
        _fetchRestaurantDiscounts();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? appColorPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFFF1F1F1),
          ),
        ),
        child: Text(
          category.name ?? '',
          style: w400TextStyle(
            fontSize: 14.sw,
            color: isSelected ? Colors.white : const Color(0xFF57585D),
          ),
        ),
      ),
    );
  }
}

List<ProductModel>? _recommendedProducts;

class _RecommendedSection extends StatefulWidget {
  final String? categoryIds;
  const _RecommendedSection({super.key, this.categoryIds});

  @override
  State<_RecommendedSection> createState() => __RecommendedSectionState();
}

class __RecommendedSectionState extends State<_RecommendedSection> {
  @override
  void initState() {
    super.initState();
    if (widget.categoryIds != null) _fetchRecommendedProducts();
  }

  void _fetchRecommendedProducts() async {
    final response = await ProductRepo().getProducts({
      "is_popular": 1,
      if (widget.categoryIds != null) "category_ids": widget.categoryIds,
    });
    if (response.isSuccess) {
      _recommendedProducts = response.data;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _WidgetTitle(
          title: 'Recommended For You !'.tr(),
          onTap: () {},
        ),
        SingleChildScrollView(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 12.sw,
            children: _recommendedProducts == null
                ? List.generate(
                    5,
                    (index) => const WidgetDishCardShimmer(),
                  ).toList()
                : _recommendedProducts!.map((product) {
                    return WidgetDishCard(product: product);
                  }).toList(),
          ),
        ),
      ],
    );
  }
}

List<ProductModel>? _bestSellerProducts;

class _BestSellerSection extends StatefulWidget {
  final String? categoryIds;
  const _BestSellerSection({super.key, this.categoryIds});

  @override
  State<_BestSellerSection> createState() => __BestSellerSectionState();
}

class __BestSellerSectionState extends State<_BestSellerSection> {
  @override
  void initState() {
    super.initState();
    if (widget.categoryIds != null) _fetchBestSellerProducts();
  }

  void _fetchBestSellerProducts() async {
    final response = await ProductRepo().getProducts({
      "is_topseller": 1,
      if (widget.categoryIds != null) "category_ids": widget.categoryIds,
    });
    if (response.isSuccess) {
      _bestSellerProducts = response.data;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _WidgetTitle(
          title: 'Best seller'.tr(),
          onTap: () {},
        ),
        SingleChildScrollView(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 12.sw,
            children: _bestSellerProducts == null
                ? List.generate(
                    5,
                    (index) => const WidgetDishCardShimmer(),
                  )
                : _bestSellerProducts!.map((product) {
                    return WidgetDishCard(product: product);
                  }).toList(),
          ),
        ),
      ],
    );
  }
}

List<NewsModel>? _news;

class _NewsSection extends StatefulWidget {
  const _NewsSection({super.key});

  @override
  State<_NewsSection> createState() => __NewsSectionState();
}

class __NewsSectionState extends State<_NewsSection> {
  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  void _fetchNews() async {
    final response =
        await NewsRepo().getNews({"country_code": locationCubit.countryCode});
    if (response.isSuccess) {
      _news = response.data;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'News'.tr(),
              style: w400TextStyle(fontSize: 20.sw),
            ),
            Text(
              'View all'.tr(),
              style: w400TextStyle(
                fontSize: 14.sw,
                color: appColorPrimary,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          child: _news == null
              ? Row(
                  children: [
                    _buildShimmerNewsCard(),
                    const SizedBox(width: 12),
                    _buildShimmerNewsCard(),
                  ],
                )
              : Row(
                  children: _news!.map((news) {
                    return Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          appHaptic();
                          launchUrl(Uri.parse(news.link ?? ''));
                        },
                        child: WidgetNewsCard(
                          imageUrl: news.image ?? '',
                          date: news.createdAt ?? '',
                          title: news.name ?? '',
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildShimmerNewsCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 280,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _PartnerSection extends StatelessWidget {
  const _PartnerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Let's be partners now!".tr(),
          style: w400TextStyle(fontSize: 20.sw),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildPartnerCard(
              'Signup as a\nbusiness'.tr(),
              'Partner\nwith us'.tr(),
              'icon7',
              'https://www.google.com', //TODO: change to external link
            ),
            const SizedBox(width: 12),
            _buildPartnerCard(
              'Signup as a\nrider'.tr(),
              'Ride\nwith us'.tr(),
              'icon4',
              'https://www.google.com', //TODO: change to external link
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPartnerCard(
      String subtitle, String title, String icon, String externalLink) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          appHaptic();
          launchUrl(Uri.parse(externalLink));
        },
        child: Container(
          padding: EdgeInsets.all(12.sw),
          decoration: BoxDecoration(
            color: hexColor('#F1EFE9'),
            borderRadius: BorderRadius.circular(12.sw),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle,
                style: w400TextStyle(
                  fontSize: 14.sw,
                  color: hexColor('#636363'),
                ),
              ),
              SizedBox(height: 4.sw),
              Text(
                title,
                style: w500TextStyle(fontSize: 20.sw),
              ),
              SizedBox(height: 16.sw),
              Center(
                child: WidgetAppSVG(
                  icon,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 16.sw),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Get Started'.tr(),
                    style: w400TextStyle(
                      color: hexColor('#F17228'),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  WidgetAppSVG(
                    'icon36',
                    width: 24,
                    height: 24,
                    color: hexColor('#F17228'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationHeader extends StatelessWidget {
  const _LocationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocBuilder<AuthCubit, AuthState>(
            bloc: authCubit,
            builder: (context, state) {
              if (state.stateType != AuthStateType.logged) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: EdgeInsets.only(right: 8.sw),
                child: WidgetAvatar(
                  imageUrl: state.user?.avatar ?? "",
                  radius1: 48.sw / 2,
                  radius2: 48.sw / 2 - 1.5,
                  radius3: 48.sw / 2 - 1.5,
                  borderColor: appColorBorder,
                ),
              );
            }),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Deliver to'.tr(),
                style:
                    w400TextStyle(fontSize: 14.sw, color: hexColor('#757575')),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  WidgetAppSVG(
                    'icon23',
                    width: 18.sw,
                    height: 18.sw,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 4),
                  BlocBuilder<LocationCubit, LocationState>(
                      bloc: locationCubit,
                      builder: (context, state) {
                        return ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 200.sw),
                          child: Text(
                            state.addressDetail?.title ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: w400TextStyle(
                              fontSize: 14.sw,
                            ),
                          ),
                        );
                      }),
                  const SizedBox(width: 4),
                  WidgetAppSVG(
                    'icon3',
                    width: 18.sw,
                    height: 18.sw,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            appHaptic();
            navigationCubit.changeIndex(2);
          },
          child: Container(
            width: 44.sw,
            height: 44.sw,
            child: Center(
              child: BlocBuilder<CartCubit, CartState>(
                  bloc: cartCubit,
                  buildWhen: (previous, current) =>
                      previous.totalItems != current.totalItems,
                  builder: (context, state) {
                    return Stack(
                      children: [
                        WidgetAppSVG(
                          'icon2',
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                        ),
                        if (state.totalItems > 0)
                          Positioned(
                            right: 0,
                            child: Container(
                              width: 9,
                              height: 9,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 1.2, color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            appHaptic();
            context.push('/notifications');
          },
          child: BlocBuilder<NotificationCubit, NotificationState>(
              bloc: notificationCubit,
              buildWhen: (previous, current) =>
                  previous.unreadCount != current.unreadCount,
              builder: (context, state) {
                return Container(
                  width: 44.sw,
                  height: 44.sw,
                  child: Center(
                    child: Stack(
                      children: [
                        WidgetAppSVG(
                          'icon11',
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                        ),
                        if (state.unreadCount > 0)
                          Positioned(
                            right: 0,
                            child: Container(
                              width: 9,
                              height: 9,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 1.2, color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}

class _WidgetTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  const _WidgetTitle({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return WidgetInkWellTransparent(
      onTap: onTap,
      enableInkWell: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: w400TextStyle(fontSize: 20.sw),
                ),
              ),
              WidgetAppSVG(
                'icon28',
                width: 24.sw,
                height: 24.sw,
                fit: BoxFit.contain,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
