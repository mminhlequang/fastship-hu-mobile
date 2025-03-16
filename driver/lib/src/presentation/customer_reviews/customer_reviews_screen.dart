import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widget_app_divider.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customer’s Reviews'.tr())),
      body: Column(
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
                      '4.8',
                      style: w600TextStyle(fontSize: 24.sw),
                    ),
                    Gap(2.sw),
                    RatingBarIndicator(
                      rating: 4.8,
                      itemBuilder: (context, index) => WidgetAppSVG('ic_star'),
                      itemCount: 5,
                      itemSize: 20.sw,
                      direction: Axis.horizontal,
                      unratedColor: grey7,
                      itemPadding: EdgeInsets.zero,
                    ),
                    Gap(2.sw),
                    Text(
                      '50 ${'reviews'.tr()}',
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
                      '4.8',
                      style: w600TextStyle(fontSize: 24.sw),
                    ),
                    Gap(2.sw),
                    RatingBarIndicator(
                      rating: 4.8,
                      itemBuilder: (context, index) => WidgetAppSVG('ic_star'),
                      itemCount: 5,
                      itemSize: 20.sw,
                      direction: Axis.horizontal,
                      unratedColor: grey7,
                      itemPadding: EdgeInsets.zero,
                    ),
                    Gap(2.sw),
                    Text(
                      '3 ${'reviews'.tr()}',
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
                      '7 days ago'.tr(),
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
                      '5 Star'.tr(),
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
                        children: List.generate(
                          5,
                          (index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 6.sw),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${5 - index} Star'.tr(),
                                    style: w400TextStyle(
                                      fontSize: 12.sw,
                                      color: hexColor('#4F4F4F'),
                                    ),
                                  ),
                                  Gap(2.sw),
                                  RatingBarIndicator(
                                    rating: (5 - index) * 1.0,
                                    itemBuilder: (context, index) =>
                                        WidgetAppSVG('ic_star'),
                                    itemCount: 5 - index,
                                    itemSize: 16.sw,
                                    direction: Axis.horizontal,
                                    unratedColor: grey7,
                                    itemPadding: EdgeInsets.zero,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
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

  Widget _buildReviews() {
    return RefreshIndicator(
      onRefresh: () async {
        // Todo: refresh list
      },
      child: ListView.separated(
        itemCount: 5,
        separatorBuilder: (context, index) => Gap(5.sw),
        itemBuilder: (context, index) {
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
                          imageUrl:
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShkkazTAUNIxKrUcCEMB-7LFeClEFjRaoxAw&s',
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
                                    'User12345',
                                    style: w600TextStyle(fontSize: 12.sw),
                                  ),
                                  const Spacer(),
                                  RatingBarIndicator(
                                    rating: 4,
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
                                    '4.0',
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
                                    '#2345987654',
                                    style: w400TextStyle(
                                        fontSize: 12.sw, color: grey1),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '24/02/2025 12:30',
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
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.sw, vertical: 2.sw),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(99),
                                  border: Border.all(color: grey9),
                                ),
                                child: Text(
                                  'Friendly',
                                  style: w400TextStyle(
                                    fontSize: 12.sw,
                                    color: hexColor('#4F4F4F'),
                                  ),
                                ),
                              ),
                              Gap(8.sw),
                              Text(
                                'Khach comment Lorem ipsum dolor sit amet consec tetur. Duis vel libero sed rutrum.',
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
