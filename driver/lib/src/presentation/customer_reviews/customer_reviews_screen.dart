import 'package:app/src/constants/constants.dart';
import 'package:network_resources/rating/models/models.dart';
import 'package:network_resources/rating/repo.dart';
import 'package:app/src/presentation/widgets/widget_app_divider.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';

class CustomerReviewsScreen extends StatefulWidget {
  const CustomerReviewsScreen({super.key});

  @override
  State<CustomerReviewsScreen> createState() => _CustomerReviewsScreenState();
}

class _CustomerReviewsScreenState extends State<CustomerReviewsScreen> {
  bool _isLoading = true;
  List<RatingModel> _reviews = [];
  double _averageRating = 0;
  int _totalReviews = 0;
  double _last7DaysRating = 0;
  int _last7DaysReviews = 0;
  String _selectedTimeFilter = '7 days ago';
  int? _selectedStarFilter;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final response = await RatingRepo().getDriverRatings({
        'driver_id': AppPrefs.instance.user?.id,
        // 'time': _selectedTimeFilter,
        // 'star': _selectedStarFilter,
      });

      if (response.isSuccess) {
        final reviews = response.data as List<RatingModel>;
        setState(() {
          _reviews = reviews;
          _calculateStats(reviews);
          _isLoading = false;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load reviews'.tr()),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something went wrong'.tr()),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _calculateStats(List<RatingModel> reviews) {
    if (reviews.isEmpty) return;

    // Calculate average rating
    final totalStars =
        reviews.fold(0, (sum, review) => sum + (review.star ?? 0));
    _averageRating = totalStars / reviews.length;

    // Calculate last 7 days stats
    final now = DateTime.now();
    final last7DaysReviews = reviews.where((review) {
      final reviewDate = DateTime.tryParse(review.createdAt ?? '');
      if (reviewDate == null) return false;
      return now.difference(reviewDate).inDays <= 7;
    }).toList();

    if (last7DaysReviews.isNotEmpty) {
      final last7DaysTotalStars =
          last7DaysReviews.fold(0, (sum, review) => sum + (review.star ?? 0));
      _last7DaysRating = last7DaysTotalStars / last7DaysReviews.length;
      _last7DaysReviews = last7DaysReviews.length;
    }

    _totalReviews = reviews.length;
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Customer's Reviews".tr())),
      body: _isLoading
          ? _buildShimmer()
          : Column(
              children: [
                _buildOverview(),
                Gap(8.sw),
                _buildFilter(),
                Expanded(
                  child: _buildReviews(),
                ),
              ],
            ),
    );
  }

  Widget _buildShimmer() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildShimmerOverview(),
          Gap(8.sw),
          _buildShimmerFilter(),
          _buildShimmerReviews(),
        ],
      ),
    );
  }

  Widget _buildShimmerOverview() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 12.sw, bottom: 8.sw),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                WidgetAppShimmer(
                  width: 60.sw,
                  height: 24.sw,
                ),
                Gap(2.sw),
                WidgetAppShimmer(
                  width: 100.sw,
                  height: 20.sw,
                ),
                Gap(2.sw),
                WidgetAppShimmer(
                  width: 80.sw,
                  height: 12.sw,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                WidgetAppShimmer(
                  width: 60.sw,
                  height: 24.sw,
                ),
                Gap(2.sw),
                WidgetAppShimmer(
                  width: 100.sw,
                  height: 20.sw,
                ),
                Gap(2.sw),
                WidgetAppShimmer(
                  width: 80.sw,
                  height: 12.sw,
                ),
                Gap(2.sw),
                WidgetAppShimmer(
                  width: 100.sw,
                  height: 12.sw,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerFilter() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
      child: Row(
        children: [
          Expanded(
            child: WidgetAppShimmer(
              height: 32.sw,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Gap(10.sw),
          Expanded(
            child: WidgetAppShimmer(
              height: 32.sw,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerReviews() {
    return Column(
      children: List.generate(
        3,
        (index) => Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16.sw),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      WidgetAppShimmer(
                        width: 34.sw,
                        height: 34.sw,
                        borderRadius: BorderRadius.circular(17.sw),
                      ),
                      Gap(6.sw),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                WidgetAppShimmer(
                                  width: 80.sw,
                                  height: 12.sw,
                                ),
                                const Spacer(),
                                WidgetAppShimmer(
                                  width: 60.sw,
                                  height: 16.sw,
                                ),
                              ],
                            ),
                            Gap(2.sw),
                            Row(
                              children: [
                                WidgetAppShimmer(
                                  width: 100.sw,
                                  height: 12.sw,
                                ),
                                const Spacer(),
                                WidgetAppShimmer(
                                  width: 120.sw,
                                  height: 12.sw,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gap(8.sw),
                  Row(
                    children: [
                      Gap(40.sw),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WidgetAppShimmer(
                              width: 80.sw,
                              height: 24.sw,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            Gap(8.sw),
                            WidgetAppShimmer(
                              width: double.infinity,
                              height: 36.sw,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: Colors.white,
            ),
            Container(
              height: 40.sw,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverview() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 12.sw, bottom: 8.sw),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      _averageRating.toStringAsFixed(1),
                      style: w600TextStyle(fontSize: 24.sw),
                    ),
                    Gap(2.sw),
                    RatingBarIndicator(
                      rating: _averageRating,
                      itemBuilder: (context, index) => WidgetAppSVG('ic_star'),
                      itemCount: 5,
                      itemSize: 20.sw,
                      direction: Axis.horizontal,
                      unratedColor: grey7,
                      itemPadding: EdgeInsets.zero,
                    ),
                    Gap(2.sw),
                    Text(
                      '$_totalReviews ${'reviews'.tr()}',
                      style: w400TextStyle(
                        fontSize: 12.sw,
                        color: hexColor('#4F4F4F'),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      _last7DaysRating.toStringAsFixed(1),
                      style: w600TextStyle(fontSize: 24.sw),
                    ),
                    Gap(2.sw),
                    RatingBarIndicator(
                      rating: _last7DaysRating,
                      itemBuilder: (context, index) => WidgetAppSVG('ic_star'),
                      itemCount: 5,
                      itemSize: 20.sw,
                      direction: Axis.horizontal,
                      unratedColor: grey7,
                      itemPadding: EdgeInsets.zero,
                    ),
                    Gap(2.sw),
                    Text(
                      '$_last7DaysReviews ${'reviews'.tr()}',
                      style: w400TextStyle(
                        fontSize: 12.sw,
                        color: hexColor('#4F4F4F'),
                      ),
                    ),
                    Gap(2.sw),
                    Text(
                      '${'Last'.tr()} 7 ${'days'.tr()}',
                      style: w400TextStyle(
                        fontSize: 12.sw,
                        color: hexColor('#4F4F4F'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 18.sw,
          bottom: 12.sw,
          child: Container(width: 1, color: hexColor('#EAEAEA')),
        ),
      ],
    );
  }

  Widget _buildFilter() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
      child: Row(
        children: [
          Expanded(
            child: WidgetOverlayActions(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.sw, vertical: 1.sw),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(color: grey9),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _selectedTimeFilter.tr(),
                      style: w400TextStyle(
                        fontSize: 12.sw,
                        color: hexColor('#4F4F4F'),
                      ),
                    ),
                    WidgetAppSVG('arrow_drop_down'),
                  ],
                ),
              ),
              builder: (child, size, childPosition, pointerPosition,
                  animationValue, hide) {
                return Positioned(
                  top: childPosition.dy + size.height,
                  left: childPosition.dx,
                  width: size.width,
                  child: Transform.scale(
                    scaleY: animationValue,
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(2)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 16,
                            offset: const Offset(1, 4),
                          ),
                        ],
                      ),
                      child: ListView(
                        children: [
                          _buildTimeFilterItem('7 days ago'),
                          _buildTimeFilterItem('30 days ago'),
                          _buildTimeFilterItem('All time'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Gap(10.sw),
          Expanded(
            child: WidgetOverlayActions(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.sw, vertical: 1.sw),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(color: grey9),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _selectedStarFilter != null
                          ? '$_selectedStarFilter Star'.tr()
                          : 'All Stars'.tr(),
                      style: w400TextStyle(
                        fontSize: 12.sw,
                        color: hexColor('#4F4F4F'),
                      ),
                    ),
                    Gap(1.sw),
                    WidgetAppSVG('ic_star', width: 16.sw),
                    Transform.translate(
                      offset: const Offset(-2, 0),
                      child: WidgetAppSVG('arrow_drop_down'),
                    ),
                  ],
                ),
              ),
              builder: (child, size, childPosition, pointerPosition,
                  animationValue, hide) {
                return Positioned(
                  top: childPosition.dy + size.height,
                  left: childPosition.dx,
                  width: size.width,
                  child: Transform.scale(
                    scaleY: animationValue,
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.sw, vertical: 8.sw),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(2)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 16,
                            offset: const Offset(1, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildStarFilterItem(null),
                          ...List.generate(
                            5,
                            (index) => _buildStarFilterItem(5 - index),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFilterItem(String time) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTimeFilter = time;
        });
        _refreshData();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.sw),
        child: Text(
          time.tr(),
          style: w400TextStyle(
            fontSize: 12.sw,
            color: hexColor('#4F4F4F'),
          ),
        ),
      ),
    );
  }

  Widget _buildStarFilterItem(int? star) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedStarFilter = star;
        });
        _refreshData();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.sw),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              star != null ? '$star Star'.tr() : 'All Stars'.tr(),
              style: w400TextStyle(
                fontSize: 12.sw,
                color: hexColor('#4F4F4F'),
              ),
            ),
            if (star != null) ...[
              Gap(2.sw),
              RatingBarIndicator(
                rating: star * 1.0,
                itemBuilder: (context, index) => WidgetAppSVG('ic_star'),
                itemCount: star,
                itemSize: 16.sw,
                direction: Axis.horizontal,
                unratedColor: grey7,
                itemPadding: EdgeInsets.zero,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReviews() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView.separated(
        itemCount: _reviews.length,
        separatorBuilder: (context, index) => Gap(5.sw),
        itemBuilder: (context, index) {
          final review = _reviews[index];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(
                    16.sw, index == 0 ? 0 : 12.sw, 16.sw, 12.sw),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        WidgetAppImage(
                          imageUrl: review.images?.firstOrNull ?? '',
                          height: 34.sw,
                          width: 34.sw,
                          radius: 99,
                        ),
                        Gap(6.sw),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'User${review.id}',
                                    style: w600TextStyle(fontSize: 12.sw),
                                  ),
                                  const Spacer(),
                                  RatingBarIndicator(
                                    rating: review.star?.toDouble() ?? 0,
                                    itemBuilder: (context, index) =>
                                        WidgetAppSVG('ic_star'),
                                    itemCount: 5,
                                    itemSize: 16.sw,
                                    direction: Axis.horizontal,
                                    unratedColor: grey7,
                                    itemPadding: EdgeInsets.zero,
                                  ),
                                  Gap(4.sw),
                                  Text(
                                    '${review.star}',
                                    style: w400TextStyle(
                                      fontSize: 12.sw,
                                      color: grey1,
                                    ),
                                  ),
                                ],
                              ),
                              Gap(2.sw),
                              Row(
                                children: [
                                  Text(
                                    '#${review.orderId}',
                                    style: w400TextStyle(
                                        fontSize: 12.sw, color: grey1),
                                  ),
                                  const Spacer(),
                                  Text(
                                    review.createdAt ?? '',
                                    style: w400TextStyle(
                                        fontSize: 12.sw, color: grey1),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Gap(8.sw),
                    Row(
                      children: [
                        Gap(40.sw),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (review.content != null)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.sw, vertical: 2.sw),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(99),
                                    border: Border.all(color: grey9),
                                  ),
                                  child: Text(
                                    review.content!,
                                    style: w400TextStyle(
                                      fontSize: 12.sw,
                                      color: hexColor('#4F4F4F'),
                                    ),
                                  ),
                                ),
                              Gap(8.sw),
                              Text(
                                review.text ?? '',
                                style: w400TextStyle(
                                  fontSize: 12.sw,
                                  color: hexColor('#4F4F4F'),
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
              AppDivider(color: appColorBackground),
              WidgetRippleButton(
                onTap: () {
                  // Todo: view order
                },
                radius: 0,
                child: Padding(
                  padding: EdgeInsets.only(top: 6.sw, bottom: 8.sw),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 2.sw),
                        child: WidgetAppSVG('ic_eye'),
                      ),
                      Gap(4.sw),
                      Text(
                        'View order'.tr(),
                        style: w400TextStyle(
                          fontSize: 12.sw,
                          color: hexColor('#4F4F4F'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
