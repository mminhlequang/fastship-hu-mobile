import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/slider_button.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLate = false; // Muộn giao hàng
  bool isCanceled = false; // Đơn hàng bị huỷ
  int step = 1;
  int? selectedReason;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String get stepText => switch (step) {
        1 => 'Đã đến điểm lấy'.tr(),
        2 => 'Đã lấy đơn'.tr(),
        3 => 'Đã giao'.tr(),
        _ => 'Cập nhật hình ảnh'.tr(),
      };

  Future<void> _onPhoneCall() async {
    var url = Uri.parse('tel:+36 9830268966');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('Could not launch $url');
    }
  }

  _onChat() {
    appContext.push('/order-detail/chat');
  }

  List<String> reasons = [
    'Người nhận hẹn giao lại sau',
    'Không liên hệ được người nhận',
    'Người nhận muốn huỷ đơn/ thay đổi địa chỉ',
    'Bận việc cá nhân',
    'Kẹt xe',
    'Khác',
  ];

  _onRefuse() {
    setState(() {
      selectedReason = null;
    });
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 300),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.sw, 4.sw, 6.sw, 4.sw),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Refusal reason'.tr(),
                        style: w600TextStyle(fontSize: 16.sw, color: grey1),
                      ),
                      const CloseButton(),
                    ],
                  ),
                ),
                const AppDivider(),
                ...List.generate(
                  reasons.length,
                  (index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.sw),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 0.sw),
                            child: RadioListTile(
                              title: Text(
                                reasons[index],
                                style: w400TextStyle(fontSize: 16.sw),
                              ),
                              dense: true,
                              activeColor: appColorPrimary,
                              visualDensity: VisualDensity(horizontal: -4),
                              contentPadding: EdgeInsets.zero,
                              value: index,
                              groupValue: selectedReason,
                              onChanged: (value) {
                                setState(() {
                                  selectedReason = value;
                                });
                              },
                            ),
                          ),
                          if (index != reasons.length - 1) const AppDivider(),
                        ],
                      ),
                    );
                  },
                ),
                const AppDivider(),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.sw, 16.sw, 16.sw,
                      16.sw + context.mediaQueryPadding.bottom),
                  child: WidgetRippleButton(
                    onTap: selectedReason == null
                        ? null
                        : () {
                            // Todo:
                          },
                    color: selectedReason == null ? grey8 : appColorPrimary,
                    child: SizedBox(
                      height: 48.sw,
                      child: Center(
                        child: Text(
                          'Confirm'.tr(),
                          style: w500TextStyle(
                            fontSize: 16.sw,
                            color:
                                selectedReason == null ? grey1 : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Order Details'.tr())),
      body: Column(
        children: [
          Expanded(
            child: WidgetAppTabBar(
              tabController: _tabController,
              tabs: ['Merchant'.tr(), 'Customer'.tr()],
              children: [
                _buildMerchant(),
                _buildCustomer(),
              ],
            ),
          ),
          AppDivider(color: appColorBackground),
          IgnorePointer(
            ignoring: isCanceled,
            child: Opacity(
              opacity: isCanceled ? .5 : 1,
              child: SizedBox(
                height: 61.sw,
                child: Row(
                  children: [
                    Expanded(
                      child: WidgetRippleButton(
                        onTap: _onPhoneCall,
                        radius: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            WidgetAppSVG('ic_calling'),
                            Gap(6.sw),
                            Text(
                              'Điện thoại'.tr(),
                              style:
                                  w400TextStyle(fontSize: 12.sw, color: grey1),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(width: 1.sw, color: appColorBackground),
                    Expanded(
                      child: WidgetRippleButton(
                        onTap: _onChat,
                        radius: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                WidgetAppSVG('ic_message'),
                                Positioned(
                                  top: -4.sw,
                                  right: -6.sw,
                                  child: Container(
                                    height: 16.sw,
                                    width: 16.sw,
                                    decoration: BoxDecoration(
                                      color: appColorPrimary,
                                      border: Border.all(color: Colors.white),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '2',
                                        style: w400TextStyle(
                                          fontSize: 10.sw,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Gap(6.sw),
                            Text(
                              'Chat'.tr(),
                              style:
                                  w400TextStyle(fontSize: 12.sw, color: grey1),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(width: 1.sw, color: appColorBackground),
                    Expanded(
                      child: WidgetRippleButton(
                        onTap: _onRefuse,
                        radius: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            WidgetAppSVG('ic_close'),
                            Gap(6.sw),
                            Text(
                              'Từ chối'.tr(),
                              style:
                                  w400TextStyle(fontSize: 12.sw, color: grey1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AppDivider(color: appColorBackground),
          IgnorePointer(
            ignoring: isCanceled,
            child: Container(
              width: context.width,
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(16.sw, 10.sw, 16.sw,
                  16.sw + MediaQuery.paddingOf(context).bottom),
              child: SliderButton(
                action: () async {
                  setState(() {
                    if (step < 4) {
                      step++;
                    } else {
                      appContext.push('/order-detail/report-order');
                    }
                  });
                  return false;
                },
                label: Text(
                  stepText,
                  style: w500TextStyle(fontSize: 18.sw, color: Colors.white),
                ),
                icon: Center(
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: isCanceled ? grey9 : appColorPrimary,
                    size: 24.sw,
                  ),
                ),
                height: 48.sw,
                buttonSize: 40.sw,
                width: context.width,
                radius: 8.sw,
                alignLabel: Alignment.center,
                buttonColor: Colors.white,
                backgroundColor: isCanceled ? grey9 : appColorPrimary,
                highlightedColor: appColorPrimary,
                baseColor: Colors.white,
                shimmer: !isCanceled,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMerchant() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.sw),
                  child: Row(
                    children: [
                      Expanded(
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
                          ],
                        ),
                      ),
                      Gap(12.sw),
                      WidgetRippleButton(
                        onTap: () {
                          // Todo:
                        },
                        radius: 99,
                        borderSide: BorderSide(color: hexColor('#E3E3E3')),
                        child: SizedBox(
                          height: 32.sw,
                          width: 32.sw,
                          child: Center(
                            child: WidgetAppSVG('ic_direction'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const AppDivider(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.sw),
                  child: Text.rich(
                    TextSpan(
                      text: '${'Pay'.tr()}: ',
                      style: w400TextStyle(color: grey1),
                      children: [
                        TextSpan(
                          text: '\$0',
                          style: w400TextStyle(color: darkGreen),
                        ),
                      ],
                    ),
                  ),
                ),
                const AppDivider(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.sw),
                  child: Text(
                    '${'Status'.tr()}: Order received',
                    style: w400TextStyle(color: grey1),
                  ),
                ),
              ],
            ),
          ),
          if (!isCanceled) ...[
            AppDivider(
                height: 5.sw, thickness: 5.sw, color: appColorBackground),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 7.sw),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WidgetAppSVG('ic_timer'),
                  Gap(4.sw),
                  Text.rich(
                    isLate
                        ? TextSpan(
                            text: 'Late'.tr(),
                            style: w400TextStyle(),
                            children: [
                              TextSpan(
                                text: ' 44 minutes',
                                style: w400TextStyle(color: appColorError),
                              ),
                            ],
                          )
                        : TextSpan(
                            text: '44 minutes',
                            style: w400TextStyle(color: darkGreen),
                            children: [
                              TextSpan(
                                text: ' ${'left to deliver'.tr()}',
                                style: w400TextStyle(color: appColorText),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
            AppDivider(height: 5.sw, thickness: 5.sw, color: appColorBackground)
          ] else
            Container(
              color: appColorBackground,
              padding: EdgeInsets.symmetric(vertical: 8.sw),
              child: Center(
                child: Text(
                  'Order canceled'.tr(),
                  style: w400TextStyle(),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
            child: Row(
              children: [
                WidgetAppSVG('ic_shop'),
                Gap(8.sw),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quán ghi chú',
                        style: w400TextStyle(),
                      ),
                      Gap(2.sw),
                      Text(
                        'Đơn hàng đã được chuẩn bị',
                        style: w400TextStyle(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AppDivider(height: 5.sw, thickness: 5.sw, color: appColorBackground),
          Padding(
            padding: EdgeInsets.fromLTRB(16.sw, 8.sw, 16.sw, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Details'.tr(),
                  style: w600TextStyle(),
                ),
                Gap(4.sw),
                Text(
                  '${'Quantity'.tr()}: 3',
                  style: w400TextStyle(),
                ),
                Gap(8.sw),
                ...List.generate(
                  2,
                  (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.sw),
                          child: Text(
                            'CATEGORY ${index + 1}',
                            style: w600TextStyle(fontSize: 12.sw),
                          ),
                        ),
                        ...List.generate(2, (index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Gap(8.sw),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Text(
                                      '0${index + 1}. PRODUCT ${index + 1}',
                                      style: w400TextStyle(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                        '1',
                                        style: w400TextStyle(color: darkGreen),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '\$15',
                                        style: w400TextStyle(),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Gap(2.sw),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Size M. Less ice',
                                      style: w400TextStyle(
                                        fontSize: 12.sw,
                                        color: grey1,
                                      ),
                                    ),
                                  ),
                                  if (index == 1)
                                    Text(
                                      '\$12',
                                      style: w400TextStyle(
                                        fontSize: 12.sw,
                                        color: grey1,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    )
                                ],
                              ),
                              Gap(8.sw),
                              if (index != 1) const AppDivider(),
                            ],
                          );
                        })
                      ],
                    );
                  },
                )
              ],
            ),
          ),
          AppDivider(height: 5.sw, thickness: 5.sw, color: appColorBackground),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hoá đơn quán'.tr(),
                  style: w600TextStyle(),
                ),
                Gap(4.sw),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tổng đơn quán'.tr(),
                      style: w400TextStyle(color: grey1),
                    ),
                    Text(
                      '\$0',
                      style: w400TextStyle(color: grey1),
                    ),
                  ],
                ),
                Gap(4.sw),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quán giảm giá'.tr(),
                      style: w400TextStyle(color: grey1),
                    ),
                    Text(
                      '\$0',
                      style: w400TextStyle(color: grey1),
                    ),
                  ],
                ),
                Gap(4.sw),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quán phụ thu'.tr(),
                      style: w400TextStyle(color: grey1),
                    ),
                    Text(
                      '\$0',
                      style: w400TextStyle(color: grey1),
                    ),
                  ],
                ),
                Gap(4.sw),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trả quán'.tr(),
                      style: w400TextStyle(),
                    ),
                    Text(
                      '\$0',
                      style: w400TextStyle(color: darkGreen),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppDivider(height: 5.sw, thickness: 5.sw, color: appColorBackground),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hoá đơn khách'.tr(),
                  style: w600TextStyle(),
                ),
                Gap(4.sw),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Thu tiền'.tr(),
                      style: w400TextStyle(color: grey1),
                    ),
                    Text(
                      '\$0',
                      style: w400TextStyle(color: darkGreen),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppDivider(height: 5.sw, thickness: 5.sw, color: appColorBackground),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tài xế nhận được'.tr(),
                  style: w600TextStyle(),
                ),
                Gap(4.sw),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Phí ship'.tr(),
                      style: w400TextStyle(color: grey1),
                    ),
                    Text(
                      '\$5',
                      style: w400TextStyle(color: darkGreen),
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

  Widget _buildCustomer() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.sw),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hai Dang',
                              style: w400TextStyle(),
                            ),
                            Gap(2.sw),
                            Text(
                              '41 Quang Trung, Ward 3, Go Vap District',
                              style: w400TextStyle(color: grey1),
                            ),
                          ],
                        ),
                      ),
                      Gap(12.sw),
                      WidgetRippleButton(
                        onTap: () {
                          // Todo:
                        },
                        radius: 99,
                        borderSide: BorderSide(color: hexColor('#E3E3E3')),
                        child: SizedBox(
                          height: 32.sw,
                          width: 32.sw,
                          child: Center(
                            child: WidgetAppSVG('ic_direction'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const AppDivider(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.sw),
                  child: Text.rich(
                    TextSpan(
                      text: '${'Thu'.tr()}: ',
                      style: w400TextStyle(color: grey1),
                      children: [
                        TextSpan(
                          text: '\$15',
                          style: w400TextStyle(color: darkGreen),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          isCanceled
              ? Container(
                  color: appColorBackground,
                  padding: EdgeInsets.symmetric(vertical: 8.sw),
                  child: Center(
                    child: Text(
                      'Order canceled'.tr(),
                      style: w400TextStyle(),
                    ),
                  ),
                )
              : AppDivider(
                  height: 5.sw, thickness: 5.sw, color: appColorBackground),
          Padding(
            padding: EdgeInsets.fromLTRB(16.sw, 8.sw, 16.sw, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Details'.tr(),
                  style: w600TextStyle(),
                ),
                ...List.generate(4, (index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(8.sw),
                      Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Text(
                              '0${index + 1}. PRODUCT ${index + 1}',
                              style: w400TextStyle(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                '1',
                                style: w400TextStyle(color: darkGreen),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '\$15',
                                style: w400TextStyle(),
                              ),
                            ),
                          )
                        ],
                      ),
                      Gap(2.sw),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Size M. Less ice',
                              style: w400TextStyle(
                                fontSize: 12.sw,
                                color: grey1,
                              ),
                            ),
                          ),
                          if (index == 1)
                            Text(
                              '\$12',
                              style: w400TextStyle(
                                fontSize: 12.sw,
                                color: grey1,
                                decoration: TextDecoration.lineThrough,
                              ),
                            )
                        ],
                      ),
                      Gap(8.sw),
                      if (index != 3) const AppDivider(),
                    ],
                  );
                }),
              ],
            ),
          ),
          AppDivider(height: 5.sw, thickness: 5.sw, color: appColorBackground),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hoá đơn quán'.tr(),
                  style: w600TextStyle(),
                ),
                Gap(4.sw),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tổng đơn quán'.tr(),
                      style: w400TextStyle(color: grey1),
                    ),
                    Text(
                      '\$0',
                      style: w400TextStyle(color: grey1),
                    ),
                  ],
                ),
                Gap(4.sw),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quán giảm giá'.tr(),
                      style: w400TextStyle(color: grey1),
                    ),
                    Text(
                      '\$0',
                      style: w400TextStyle(color: grey1),
                    ),
                  ],
                ),
                Gap(4.sw),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quán phụ thu'.tr(),
                      style: w400TextStyle(color: grey1),
                    ),
                    Text(
                      '\$0',
                      style: w400TextStyle(color: grey1),
                    ),
                  ],
                ),
                Gap(4.sw),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trả quán'.tr(),
                      style: w400TextStyle(),
                    ),
                    Text(
                      '\$0',
                      style: w400TextStyle(color: darkGreen),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppDivider(height: 5.sw, thickness: 5.sw, color: appColorBackground),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hoá đơn khách'.tr(),
                  style: w600TextStyle(),
                ),
                Gap(4.sw),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Thu tiền'.tr(),
                      style: w400TextStyle(color: grey1),
                    ),
                    Text(
                      '\$0',
                      style: w400TextStyle(color: darkGreen),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppDivider(height: 5.sw, thickness: 5.sw, color: appColorBackground),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tài xế nhận được'.tr(),
                  style: w600TextStyle(),
                ),
                Gap(4.sw),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Phí ship'.tr(),
                      style: w400TextStyle(color: grey1),
                    ),
                    Text(
                      '\$5',
                      style: w400TextStyle(color: darkGreen),
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
