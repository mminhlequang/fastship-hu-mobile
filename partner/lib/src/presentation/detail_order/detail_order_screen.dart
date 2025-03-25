import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/detail_order/widgets/widget_animated_stepper.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/app_utils.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';

class DetailOrderScreen extends StatefulWidget {
  const DetailOrderScreen({super.key});

  @override
  State<DetailOrderScreen> createState() => _DetailOrderScreenState();
}

class _DetailOrderScreenState extends State<DetailOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Detail order'.tr())),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    child: WidgetAnimatedStepper(currentStep: 1.5),
                  ),
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
                  AppDivider(
                    color: grey8,
                    padding: EdgeInsets.all(16.sw),
                  ),
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
