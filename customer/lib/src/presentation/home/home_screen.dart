import 'package:app/src/constants/constants.dart';
import 'package:app/src/network_resources/category/model/category.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:app/src/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/presentation/home/cubit/home_cubit.dart';  

double get _horizontalPadding => 16.sw;

// Thêm lớp Shimmer tùy chỉnh
class _Shimmer extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;

  const _Shimmer({
    Key? key,
    required this.child,
    this.baseColor = const Color(0xFFEEEEEE),
    this.highlightColor = const Color(0xFFFAFAFA),
  }) : super(key: key);

  @override
  _ShimmerState createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutSine,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(_animation.value, 0.0),
              end: Alignment(2 + _animation.value, 0.0),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeCubit get homeCubit => context.read<HomeCubit>();

  @override
  void initState() {
    super.initState();
    // Load dữ liệu khi màn hình được khởi tạo
    homeCubit.fetchHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  homeCubit.refreshHomeData();
                },
                child: BlocBuilder<HomeCubit, HomeState>(
                  bloc: homeCubit,
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPromotionBanner(state.banners),
                          _buildPopularCategories(state.categories),
                          // _buildRestaurantsNearYou(state.shops),
                          // _buildDiscountGuaranteed(),
                          // _buildBestSeller(state.popularItems),
                          // _buildRecommendedForYou(),
                          // _buildPartnershipSection(),
                          // _buildNewsSection(),
                          const Gap(20),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget shimmer đơn giản cho container hình chữ nhật
  Widget _buildShimmerBox({
    double width = double.infinity,
    double height = 100,
    double borderRadius = 8.0,
  }) {
    return _Shimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  // Widget shimmer cho text
  Widget _buildShimmerText({
    double width = 100,
    double height = 12,
  }) {
    return _Shimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  // Shimmer cho banner promotion
  Widget _buildPromotionBannerShimmer() {
    return Container(
      height: 200,
      margin:
          EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 12),
      child: _buildShimmerBox(
        height: 200,
        borderRadius: 12,
      ),
    );
  }

  // Shimmer cho categories
  Widget _buildCategoriesShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 8),
          child: Row(
            children: [
              _buildShimmerText(width: 150, height: 20),
              const Spacer(),
              _buildShimmerBox(width: 40, height: 40, borderRadius: 20),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5, // 5 items giả
            itemBuilder: (context, index) {
              return Container(
                width: 90,
                margin: EdgeInsets.only(right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildShimmerBox(width: 50, height: 50, borderRadius: 25),
                    const Gap(4),
                    _buildShimmerText(width: 70, height: 12),
                    const Gap(2),
                    _buildShimmerText(width: 50, height: 10),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Shimmer cho restaurants
  Widget _buildRestaurantsShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: _horizontalPadding, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildShimmerText(width: 180, height: 18),
              _buildShimmerBox(width: 24, height: 24, borderRadius: 12),
            ],
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: 4, // 4 items giả
            itemBuilder: (context, index) {
              return Container(
                width: 140,
                margin: EdgeInsets.only(right: 16),
                child: _buildShimmerBox(height: 150, borderRadius: 8),
              );
            },
          ),
        ),
      ],
    );
  }

  // Shimmer cho best sellers
  Widget _buildBestSellerShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: _horizontalPadding, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildShimmerText(width: 120, height: 18),
              _buildShimmerText(width: 60, height: 14),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3, // 3 items giả
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: EdgeInsets.only(right: 16),
                child: _buildShimmerBox(height: 220, borderRadius: 8),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 100,
    );
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage('assets/images/avatar.png'),
              ),
              const Gap(8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deliver to',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Regent, London',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down, size: 16),
                    ],
                  ),
                ],
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.notifications_none_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.favorite_border_outlined),
                onPressed: () {},
              ),
            ],
          ),
          const Gap(12),
          Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(25),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'What are you craving?',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionBanner( banners) {
    // Hiển thị shimmer nếu banners là null
    if (banners == null) {
      return _buildPromotionBannerShimmer();
    }

    // Hiển thị thông báo nếu danh sách rỗng
    if (banners.isEmpty) {
      return SizedBox.shrink();
    }

    return SizedBox(
      height: 200,
    );

    return Container(
      height: 100,
      margin:
          EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 12),
      child: PageView.builder(
        itemCount: banners.length,
        itemBuilder: (context, index) {
          final banner = banners[index];
          return Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
              image: banner.image != null
                  ? DecorationImage(
                      image: NetworkImage(banner.image!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        banner.name ?? 'Special Offer',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (banner.description != null)
                        Text(
                          banner.description!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Order now',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Icon(Icons.arrow_forward, size: 12, color: Colors.green),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularCategories(List<CategoryModel>? categories) {
    // Hiển thị shimmer nếu categories là null
    if (categories == null) {
      return _buildCategoriesShimmer();
    } else if (categories.isEmpty) {
      return SizedBox.shrink();
    }

    Widget _buildCategoryItem({
      required int index,
      required CategoryModel category,
    }) {
      return Container(
        height: 124.sw,
        constraints: BoxConstraints(minWidth: 110.sw),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.sw),
          boxShadow: index != 0
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 32,
                    offset: Offset(0, 2),
                  ),
                ],
        ),
        padding: EdgeInsets.all(6.sw),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: WidgetAppImage(
                  imageUrl: category.image,
                  placeholderWidget: SizedBox(),
                ),
              ),
            ),
            Gap(4.sw),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 110.sw),
              child: Text(
                category.name ?? "",
                style: w500TextStyle(fontSize: 16.sw),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 110.sw),
              child: Text(
                category.description ?? '',
                style:
                    w400TextStyle(fontSize: 12.sw, color: hexColor('#F17228')),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: _WidgetTitle(
            title: 'Popular Categories',
            actions: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: appColorBorder),
                ),
                width: 48.sw,
                height: 48.sw,
                alignment: Alignment.center,
                child: WidgetAppSVG(
                  'Setting',
                  width: 24.sw,
                ),
              )
            ],
          ),
        ),
        Gap(24.sw),
        SizedBox(
          height: 124.sw,
          child: ListView.separated(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
            itemCount: categories.length,
            separatorBuilder: (context, index) => Gap(8.sw),
            itemBuilder: (context, index) {
              return _buildCategoryItem(
                index: index,
                category: categories[index],
              );
            },
          ),
        ),
      ],
    );
  }

  // Widget _buildRestaurantsNearYou(List<Shop>? shops) {
  //   // Hiển thị shimmer nếu shops là null
  //   if (shops == null) {
  //     return _buildRestaurantsShimmer();
  //   }

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: EdgeInsets.symmetric(
  //             horizontal: _horizontalPadding, vertical: 16),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               'Restaurants near you',
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             Icon(Icons.search),
  //           ],
  //         ),
  //       ),
  //       SizedBox(
  //         height: 150,
  //         child: shops.isEmpty
  //             ? Center(child: Text('Không có cửa hàng gần đây'))
  //             : ListView.builder(
  //                 scrollDirection: Axis.horizontal,
  //                 padding: EdgeInsets.symmetric(horizontal: 16),
  //                 itemCount: shops.length,
  //                 itemBuilder: (context, index) {
  //                   final shop = shops[index];
  //                   return _buildRestaurantCard(
  //                     shop.name,
  //                     shop.distance ?? '?km',
  //                     shop.id,
  //                     imageUrl: shop.image,
  //                   );
  //                 },
  //               ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildRestaurantCard(
    String name,
    String distance,
    String id, {
    String? imageUrl,
  }) {
    return GestureDetector(
      onTap: () {
        context.push('/restaurant-detail/$id');
      },
      child: Container(
        width: 140,
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                image: DecorationImage(
                  image: imageUrl != null
                      ? NetworkImage(imageUrl) as ImageProvider
                      : AssetImage('assets/images/restaurant_placeholder.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(2),
                  Text(
                    distance,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountGuaranteed() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: _horizontalPadding, vertical: 16),
          child: Row(
            children: [
              Text(
                'Discount Guaranteed! ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.thumb_up, color: Colors.amber, size: 20),
            ],
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildDiscountTag('Vegan'),
              _buildDiscountTag('Pizza & Fast food'),
              _buildDiscountTag('Sushi'),
            ],
          ),
        ),
        const Gap(12),
        GestureDetector(
          onTap: () {
            // Điều hướng đến trang chi tiết nhà hàng
            context.push('/restaurant-detail/rest1');
          },
          child: Container(
            height: 140,
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage('assets/images/chef_burger.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'TOP',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Text(
                    'Chef Burgers London',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(
                        '5',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountTag(String title) {
    return Container(
      margin: EdgeInsets.only(right: 12),
      padding:
          EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 8),
      decoration: BoxDecoration(
        color: title == 'Pizza & Fast food' ? Colors.green : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: title == 'Pizza & Fast food'
              ? Colors.green
              : Colors.grey.shade300,
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: title == 'Pizza & Fast food' ? Colors.white : Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Widget _buildBestSeller(List<Food>? popularItems) {
  //   // Hiển thị shimmer nếu popularItems là null
  //   if (popularItems == null) {
  //     return _buildBestSellerShimmer();
  //   }

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: EdgeInsets.symmetric(
  //             horizontal: _horizontalPadding, vertical: 16),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               'Best Sellers',
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             Text(
  //               'See all',
  //               style: TextStyle(
  //                 color: Colors.blue,
  //                 fontSize: 14,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       SizedBox(
  //         height: 220,
  //         child: popularItems.isEmpty
  //             ? Center(child: Text('Không có món ăn nổi bật'))
  //             : ListView.builder(
  //                 scrollDirection: Axis.horizontal,
  //                 padding: EdgeInsets.symmetric(horizontal: 16),
  //                 itemCount: popularItems.length,
  //                 itemBuilder: (context, index) {
  //                   final food = popularItems[index];
  //                   return _buildFoodCard(
  //                     food.name,
  //                     food.price ?? 0,
  //                     food.discountPrice,
  //                     food.id,
  //                     rating: food.rating ?? 0,
  //                     reviewCount: food.reviewCount ?? 0,
  //                     imageUrl: food.image,
  //                   );
  //                 },
  //               ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildFoodCard(
    String name,
    double price,
    double? discountPrice,
    String id, {
    double rating = 0,
    int reviewCount = 0,
    String? imageUrl,
  }) {
    return GestureDetector(
      onTap: () {
        context.push('/food-detail/$id');
      },
      child: Container(
        width: 160,
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    image: DecorationImage(
                      image: imageUrl != null
                          ? NetworkImage(imageUrl) as ImageProvider
                          : AssetImage('assets/images/food_placeholder.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (discountPrice != null && discountPrice < price)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${((price - discountPrice) / price * 100).toInt()}% OFF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      Text(
                        '$rating',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        ' ($reviewCount)',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      if (discountPrice != null && discountPrice < price) ...[
                        Text(
                          '₫${discountPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.green,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          '₫${price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ] else
                        Text(
                          '₫${price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
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

  Widget _buildRecommendedForYou() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: _horizontalPadding, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recommended For You!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('View all'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildRecommendedCard('Vegetarian Noodles', 20, 'food3'),
              _buildRecommendedCard('Pizza Hut - Lumintui', 20, 'food4'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedCard(String name, int discount, String id) {
    return GestureDetector(
      onTap: () {
        // Điều hướng đến trang chi tiết món ăn
        context.push('/food-detail/$id');
      },
      child: Container(
        width: 160,
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: AssetImage('assets/images/noodles.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '-$discount%',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      Text(
                        'Olive Outdoor',
                        style: TextStyle(fontSize: 10),
                      ),
                      Spacer(),
                      Text(
                        '1.1km',
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      Text(
                        ' 4.5 (1.1k)',
                        style: TextStyle(fontSize: 10),
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

  Widget _buildPartnershipSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: _horizontalPadding, vertical: 16),
          child: Text(
            'Let\'s be partners now!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _buildPartnerCard(
                  title: 'Partner with us',
                  buttonText: 'Get Started',
                  icon: Icons.store,
                ),
              ),
              const Gap(16),
              Expanded(
                child: _buildPartnerCard(
                  title: 'Ride with us',
                  buttonText: 'Get Started',
                  icon: Icons.delivery_dining,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPartnerCard({
    required String title,
    required String buttonText,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Sign up as a business',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
          const Gap(8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const Gap(16),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 24),
              ),
              Spacer(),
              Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
          const Gap(16),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(
              buttonText,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: _horizontalPadding, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'News',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('View all'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildNewsCard('Blueberry pancake'),
              _buildNewsCard('Blueberry'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNewsCard(String title) {
    return Container(
      width: 180,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.asset(
              'assets/images/pancake.png',
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Lorem ipsum dolor sit amet consectetur...',
                  style: TextStyle(fontSize: 8, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WidgetTitle extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  const _WidgetTitle({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: w500TextStyle(fontSize: 24.sw),
          ),
        ),
        if (actions != null) ...actions!,
      ],
    );
  }
}
