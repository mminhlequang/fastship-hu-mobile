import 'dart:async';

import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/home/widgets/widget_animated_stepper.dart';
import 'package:app/src/presentation/socket_shell/controllers/socket_controller.dart';
import 'package:app/src/presentation/widgets/slider_button.dart';
import 'package:app/src/presentation/widgets/widget_app_divider.dart';
import 'package:app/src/utils/app_utils.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/enums.dart';
import 'package:network_resources/order/models/models.dart';

class WidgetOrderStates extends StatefulWidget {
  final AppOrderProcessStatus processStatus;
  final OrderModel? order;

  const WidgetOrderStates({
    super.key,
    required this.processStatus,
    this.order,
  });

  @override
  State<WidgetOrderStates> createState() => _WidgetOrderStatesState();
}

class _WidgetOrderStatesState extends State<WidgetOrderStates> {
  @override
  void initState() {
    super.initState();
  }

  final List<AppOrderProcessStatus> totalStep = [
    AppOrderProcessStatus.driverAccepted,
    AppOrderProcessStatus.driverArrivedStore,
    AppOrderProcessStatus.driverPicked,
    AppOrderProcessStatus.driverArrivedDestination,
    AppOrderProcessStatus.completed,
  ];

  /// Lấy trạng thái tiếp theo dựa trên trạng thái hiện tại
  AppOrderProcessStatus get _nextStatus {
    final index = totalStep.indexOf(widget.processStatus);
    if (index + 1 < totalStep.length) {
      return totalStep[index + 1];
    }
    return AppOrderProcessStatus.pending;
  }

  /// Xử lý khi trạng thái thay đổi
  void _handleStatusChange(AppOrderProcessStatus newStatus) {
    socketController.updateOrderStatus(newStatus);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('Debug socket: Trạng thái đơn hàng: ${widget.processStatus}');
    bool isWaitingToConfirm =
        widget.processStatus == AppOrderProcessStatus.findDriver;

    return WidgetTimer(builder: () {
      int seconds = socketController.responseTimeout != null &&
              socketController.timestampOrderReceived != null
          ? socketController.responseTimeout! -
              DateTime.now()
                  .difference(socketController.timestampOrderReceived!)
                  .inSeconds
          : 0;
      if (seconds < 0 &&
          widget.processStatus == AppOrderProcessStatus.findDriver) {
        return const SizedBox();
      }
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.sw)),
        ),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                16.sw, 16.sw, 16.sw, 16.sw + context.mediaQueryPadding.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isWaitingToConfirm) ...[
                  _buildOrderHeader(),
                ] else ...[
                  _buildStatusHeader(context),
                  Gap(24.sw),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.sw),
                    child: WidgetAnimatedStepper(
                      status: widget.processStatus,
                    ),
                  ),
                  Gap(33.sw),
                ],
                const AppDivider(),
                Gap(16.sw),
                _buildOrderRouteInfo(context),
                Gap(20.sw),
                isWaitingToConfirm
                    ? WidgetRippleButton(
                        onTap: () {
                          appHaptic();
                          socketController.acceptOrder();
                        },
                        color: appColorPrimary,
                        child: SizedBox(
                          height: 48.sw,
                          child: Center(
                            child: Text(
                              '${'Accept order'.tr()} ($seconds s)',
                              style: w500TextStyle(
                                  fontSize: 16.sw, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    : SliderButton(
                        key: Key(_nextStatus.name),
                        action: () async {
                          _handleStatusChange(_nextStatus);
                          return false;
                        },
                        label: Text(
                          _nextStatus.titleDisplay,
                          style: w500TextStyle(
                              fontSize: 18.sw, color: Colors.white),
                        ),
                        icon: Center(
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: appColorPrimary,
                            size: 24.sw,
                          ),
                        ),
                        height: 48.sw,
                        buttonSize: 40.sw,
                        width: MediaQuery.of(context).size.width,
                        radius: 99,
                        alignLabel: Alignment.center,
                        buttonColor: Colors.white,
                        backgroundColor: appColorPrimary,
                        highlightedColor: appColorPrimary,
                        baseColor: Colors.white,
                        shimmer: false,
                      ),
              ],
            ),
          ),
        ),
      );
    });
  }

  /// Widget hiển thị thông tin thu nhập của đơn hàng
  Widget _buildOrderHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Earning'.tr(),
          style: w400TextStyle(color: grey1),
        ),
        Gap(2.sw),
        Text(
          currencyFormatted(widget.order!.shipFee! * .70),
          style: w600TextStyle(fontSize: 20.sw, color: darkGreen),
        ),
        Gap(12.sw),
      ],
    );
  }

  /// Widget hiển thị header của trạng thái đơn hàng
  Widget _buildStatusHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Detail Status'.tr(),
          style: w600TextStyle(fontSize: 16.sw),
        ),
        GestureDetector(
          onTap: () {
            appHaptic();
            context.push('/order-detail', extra: widget.order);
          },
          child: Text(
            'View more'.tr(),
            style: w400TextStyle(
              color: grey1,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  /// Widget hiển thị thông tin lộ trình đơn hàng
  Widget _buildOrderRouteInfo(BuildContext context) {
    final restaurantName = widget.order?.store?.name ?? 'Unknown';
    final restaurantAddress = widget.order?.store?.address ?? 'Unknown';
    final restaurantDistance = '1,2km';

    final customerName = widget.order?.customer?.name ?? 'Unknown';
    final customerAddress = widget.order?.address ?? 'Unknown';
    final customerDistance = widget.order?.shipDistance ?? 0;

    return Stack(
      children: [
        Container(
          width: context.width,
          padding: EdgeInsets.only(left: 24.sw),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                restaurantName,
                style: w500TextStyle(fontSize: 16.sw),
              ),
              Gap(2.sw),
              Text(
                restaurantAddress,
                style: w400TextStyle(color: grey1),
              ),
              Gap(4.sw),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.sw, vertical: 2.sw),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: grey9),
                ),
                child: Text(
                  restaurantDistance,
                  style: w400TextStyle(fontSize: 12.sw),
                ),
              ),
              Gap(16.sw),
              Text(
                customerName,
                style: w500TextStyle(fontSize: 16.sw),
              ),
              Gap(2.sw),
              Text(
                customerAddress,
                style: w400TextStyle(color: grey1),
              ),
              Gap(4.sw),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.sw, vertical: 2.sw),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: grey9),
                ),
                child: Text(
                  distanceFormatted(customerDistance),
                  style: w400TextStyle(fontSize: 12.sw),
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          top: 6.sw,
          left: 6.sw,
          bottom: 5.sw,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                CircleAvatar(radius: 4.sw, backgroundColor: appColorText),
                Expanded(
                  child: DottedLine(
                    direction: Axis.vertical,
                    lineThickness: 1,
                    dashLength: 4,
                    dashColor: grey1,
                  ),
                ),
                CircleAvatar(radius: 4.sw, backgroundColor: appColorText),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

extension on AppOrderProcessStatus {
  String get titleDisplay => switch (this) {
        AppOrderProcessStatus.driverArrivedStore => 'I\'m at the store'.tr(),
        AppOrderProcessStatus.driverPicked => 'Order picked up'.tr(),
        AppOrderProcessStatus.driverArrivedDestination =>
          'Arrived at destination'.tr(),
        AppOrderProcessStatus.completed => 'Complete delivery'.tr(),
        _ => this.name,
      };
}
