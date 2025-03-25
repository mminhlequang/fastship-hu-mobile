import 'dart:async';

import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/detail_order/widgets/widget_animated_stepper.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/app_utils.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';

class DetailOrderScreen extends StatefulWidget {
  const DetailOrderScreen({super.key});

  @override
  State<DetailOrderScreen> createState() => _DetailOrderScreenState();
}

class _DetailOrderScreenState extends State<DetailOrderScreen> {
  double currentStep = -0.5;

  bool get isCompleted => currentStep >= 3.0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(
      const Duration(seconds: 5),
      (_) {
        if (mounted) {
          setState(() {
            currentStep += 0.5;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Order details'.tr())),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// status & stepper
                  if (!isCompleted) ...[
                    Gap(16.sw),
                    Padding(
                      padding: EdgeInsets.only(left: 16.sw),
                      child: Text(
                        '${'Expected delivery at'.tr()} 18:50',
                        style: w400TextStyle(fontSize: 12.sw, color: grey10),
                      ),
                    ),
                    Gap(4.sw),
                    Padding(
                      padding: EdgeInsets.only(left: 16.sw),
                      child: Text(
                        'New order'.tr(),
                        style: w600TextStyle(color: grey10),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.sw, vertical: 24.sw),
                      child: WidgetAnimatedStepper(currentStep: currentStep),
                    ),
                  ],

                  /// contact customer & driver
                  if (currentStep < 1) ...[
                    AppDivider(
                      color: grey8,
                      padding: EdgeInsets.symmetric(horizontal: 16.sw),
                    ),
                    Gap(14.sw),
                    Stack(
                      children: [
                        Container(
                          width: context.width,
                          padding: EdgeInsets.only(left: 30.sw, right: 16.sw),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gong Cha Bubble Tea',
                                style: w400TextStyle(),
                              ),
                              Gap(2.sw),
                              Text(
                                '41 Quang Trung, Ward 3, Go Vap District',
                                style: w400TextStyle(color: grey1),
                              ),
                              Gap(24.sw),
                              Text(
                                'Nguyen Hai Dang',
                                style: w400TextStyle(),
                              ),
                            ],
                          ),
                        ),
                        Positioned.fill(
                          top: 5.sw,
                          left: 16.sw,
                          bottom: 5.sw,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 2.5.sw,
                                  backgroundColor: appColorPrimary,
                                ),
                                Expanded(
                                  child: DottedLine(
                                    direction: Axis.vertical,
                                    lineThickness: 1,
                                    dashLength: 4,
                                    dashColor: appColorPrimary,
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 2.5.sw,
                                  backgroundColor: appColorPrimary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(2.sw),
                    Padding(
                      padding: EdgeInsets.only(left: 30.sw, right: 16.sw),
                      child: Text(
                        '41 Quang Trung, Ward 3, Go Vap District',
                        style: w400TextStyle(color: grey1),
                      ),
                    ),
                    Gap(16.sw),
                    AppDivider(
                      color: grey8,
                      padding: EdgeInsets.symmetric(horizontal: 16.sw),
                    ),
                  ] else ...[
                    if (!isCompleted) AppDivider(height: 5.sw, thickness: 5.sw),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
                      child: Row(
                        children: [
                          WidgetAppSVG('ic_user_circle', width: 24.sw),
                          Gap(8.sw),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'User_123',
                                  style: w600TextStyle(fontSize: 12.sw),
                                ),
                                Gap(4.sw),
                                Text(
                                  '+084912345678',
                                  style: w400TextStyle(fontSize: 12.sw, color: grey1),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => makePhoneCall('+84912345678'),
                            child: WidgetAppSVG('ic_call', width: 24.sw),
                          ),
                        ],
                      ),
                    ),
                    AppDivider(height: 5.sw, thickness: 5.sw),
                    WidgetInkWellTransparent(
                      onTap: () {
                        appOpenBottomSheet(
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 32.sw),
                            child: Row(
                              children: [
                                WidgetAppImage(
                                  imageUrl: 'https://mdbcdn.b-cdn.net/img/new/avatars/2.webp',
                                  height: 40.sw,
                                  width: 40.sw,
                                  radius: 20.sw,
                                ),
                                Gap(12.sw),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Nguyễn Văn A',
                                            style: w600TextStyle(fontSize: 16.sw),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 8.sw),
                                            child: CircleAvatar(
                                              radius: 2.sw,
                                              backgroundColor: appColorText,
                                            ),
                                          ),
                                          Text(
                                            '5.0',
                                            style: w400TextStyle(color: grey1),
                                          ),
                                          Gap(1.sw),
                                          WidgetAppSVG('ic_star', width: 16.sw),
                                        ],
                                      ),
                                      Gap(1.sw),
                                      Text(
                                        '75E-6GS',
                                        style: w400TextStyle(color: grey1),
                                      ),
                                    ],
                                  ),
                                ),
                                WidgetRippleButton(
                                  onTap: () {
                                    // Todo:
                                  },
                                  color: grey8,
                                  borderSide: BorderSide(color: hexColor('#E0E0E0')),
                                  child: SizedBox(
                                    height: 32.sw,
                                    width: 32.sw,
                                    child: Center(
                                      child: WidgetAppSVG('ic_chat', width: 20.sw),
                                    ),
                                  ),
                                ),
                                Gap(12.sw),
                                WidgetRippleButton(
                                  onTap: () {
                                    // Todo:
                                  },
                                  color: appColorPrimary,
                                  child: SizedBox(
                                    height: 32.sw,
                                    width: 32.sw,
                                    child: Center(
                                      child: WidgetAppSVG('ic_call_2', width: 20.sw),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      enableInkWell: false,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
                        child: Row(
                          children: [
                            WidgetAppSVG('ic_user_circle', width: 24.sw),
                            Gap(8.sw),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nguyễn Văn A',
                                    style: w600TextStyle(fontSize: 12.sw),
                                  ),
                                  Gap(4.sw),
                                  Text(
                                    '+084912345678',
                                    style: w400TextStyle(fontSize: 12.sw, color: grey1),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => makePhoneCall('+84912345678'),
                              child: WidgetAppSVG('ic_call', width: 24.sw),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppDivider(height: 5.sw, thickness: 5.sw),
                  ],

                  /// rating
                  if (isCompleted) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RatingBarIndicator(
                                rating: 4,
                                itemBuilder: (context, index) => WidgetAppSVG('ic_star'),
                                itemCount: 5,
                                itemSize: 16.sw,
                                direction: Axis.horizontal,
                                unratedColor: grey7,
                                itemPadding: EdgeInsets.zero,
                              ),
                              Text(
                                '24/02/2025 11:11',
                                style: w400TextStyle(fontSize: 12.sw, color: grey1),
                              ),
                            ],
                          ),
                          Gap(11.sw),
                          WidgetAppImage(
                            imageUrl:
                                'https://images.immediate.co.uk/production/volatile/sites/30/2020/08/flat-white-3402c4f.jpg',
                            height: 72.sw,
                            width: 72.sw,
                          ),
                          Gap(8.sw),
                          Text(
                            'Đóng gói chưa tốt',
                            style: w600TextStyle(fontSize: 12.sw),
                          ),
                          Gap(2.sw),
                          Text(
                            'Khach comment Lorem ipsum dolor sit amet consec tetur. Duis vel libero sed rutrum.',
                            style: w400TextStyle(fontSize: 12.sw, color: grey10),
                          ),
                        ],
                      ),
                    ),
                    const AppDivider(),
                    WidgetInkWellTransparent(
                      onTap: () {
                        // Todo:
                      },
                      enableInkWell: false,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.sw),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const WidgetAppSVG('ic_reply'),
                            Gap(2.sw),
                            Text(
                              'Feedback'.tr(),
                              style: w400TextStyle(fontSize: 12.sw, color: grey10),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppDivider(height: 5.sw, thickness: 5.sw),
                  ],
                  Gap(16.sw),
                  Padding(
                    padding: EdgeInsets.only(left: 16.sw),
                    child: Text(
                      'Order details'.tr(),
                      style: w600TextStyle(),
                    ),
                  ),
                  ListView.separated(
                    padding: EdgeInsets.fromLTRB(16.sw, 8.sw, 16.sw, 4.sw),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    separatorBuilder: (context, index) => AppDivider(color: grey8),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.sw),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    'Croissant 50gr',
                                    style: w400TextStyle(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      '1',
                                      style: w400TextStyle(),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      '\$15',
                                      style: w400TextStyle(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Gap(2.sw),
                            Text(
                              'Size M. Less ice',
                              style: w400TextStyle(fontSize: 12.sw, color: grey1),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  AppDivider(height: 5.sw, thickness: 5.sw),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total item price (original price)'.tr(),
                              style: w600TextStyle(),
                            ),
                            Text(
                              '\$35'.tr(),
                              style: w600TextStyle(),
                            ),
                          ],
                        ),
                        Gap(8.sw),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Discount'.tr(), // giảm giá
                              style: w400TextStyle(color: grey1),
                            ),
                            Text(
                              '\$3'.tr(),
                              style: w400TextStyle(color: grey1),
                            ),
                          ],
                        ),
                        Gap(4.sw),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rebate'.tr(), // chiết khấu
                              style: w400TextStyle(color: grey1),
                            ),
                            Text(
                              '\$2'.tr(),
                              style: w400TextStyle(color: grey1),
                            ),
                          ],
                        ),
                        Gap(16.sw),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${'Total amount received'.tr()} (3 ${'dishes'.tr()})',
                              style: w600TextStyle(),
                            ),
                            Text(
                              '\$30'.tr(),
                              style: w600TextStyle(color: darkGreen),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AppDivider(height: 5.sw, thickness: 5.sw),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order code'.tr(),
                              style: w400TextStyle(color: grey1),
                            ),
                            GestureDetector(
                              onTap: () => copyToClipboard('8765432345yu89'),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '8765432345yu89',
                                    style: w400TextStyle(color: blue1),
                                  ),
                                  Gap(4.sw),
                                  WidgetAppSVG('ic_copy', width: 16.sw, color: blue1),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Gap(4.sw),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order time'.tr(),
                              style: w400TextStyle(color: grey1),
                            ),
                            Text(
                              '15/03/2005, 15:21',
                              style: w400TextStyle(color: grey1),
                            ),
                          ],
                        ),
                        Gap(4.sw),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Distance'.tr(),
                              style: w400TextStyle(color: grey1),
                            ),
                            Text(
                              '1km',
                              style: w400TextStyle(color: grey1),
                            ),
                          ],
                        ),
                        Gap(4.sw),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Estimated pick up time'.tr(),
                              style: w400TextStyle(color: grey1),
                            ),
                            Text(
                              '15/03/2005, 15:43',
                              style: w400TextStyle(color: grey1),
                            ),
                          ],
                        ),
                        Gap(4.sw),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pick up time'.tr(),
                              style: w400TextStyle(color: grey1),
                            ),
                            Text(
                              '15/03/2005, 15:39',
                              style: w400TextStyle(color: grey1),
                            ),
                          ],
                        ),
                        Gap(4.sw),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delivery time'.tr(),
                              style: w400TextStyle(color: grey1),
                            ),
                            Text(
                              '15/03/2005, 15:52',
                              style: w400TextStyle(color: grey1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const AppDivider(),
          Padding(
            padding: EdgeInsets.fromLTRB(
              16.sw,
              10.sw,
              16.sw,
              10.sw + context.mediaQueryPadding.bottom,
            ),
            child: Row(
              children: [
                if (currentStep < 1) ...[
                  Expanded(
                    child: WidgetRippleButton(
                      onTap: () {
                        // Todo:
                      },
                      borderSide: BorderSide(color: appColorPrimary),
                      child: SizedBox(
                        height: 48.sw,
                        child: Center(
                          child: Text(
                            'Edit/Cancel order'.tr(),
                            style: w500TextStyle(fontSize: 16.sw, color: appColorPrimary),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gap(10.sw),
                ],
                Expanded(
                  child: WidgetRippleButton(
                    onTap: () {
                      // Todo:
                    },
                    color: appColorPrimary,
                    child: SizedBox(
                      height: 48.sw,
                      child: Center(
                        child: Text(
                          'Notify to driver'.tr(),
                          style: w500TextStyle(fontSize: 16.sw, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
