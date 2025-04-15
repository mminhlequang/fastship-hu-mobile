import 'package:app/src/presentation/cart/cubit/cart_cubit.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:network_resources/enums.dart';
import 'dart:async';
import 'dart:convert';

import 'package:app/src/base/cubit/location_cubit.dart';
import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/socket_shell/controllers/socket_controller.dart';
import 'package:app/src/presentation/widgets/widget_appbar.dart';
import 'package:app/src/presentation/widgets/widget_button.dart';
import 'package:app/src/presentation/cart/widgets/widget_sheet_process.dart';
import 'package:app/src/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/cart/models/models.dart';
import 'package:network_resources/order/models/models.dart';
import 'package:network_resources/transaction/models/models.dart';

import 'package:network_resources/order/repo.dart';
import 'widget_sheet_locations.dart';

// logic tính phí ship để tính khi giao hàng
// Dưới 2 km	2.50 eur	 (Phí cơ bản)
// Mỗi km tiếp theo	+1.00

class WidgetPreviewOrder extends StatefulWidget {
  final CartModel cart;
  const WidgetPreviewOrder({super.key, required this.cart});

  @override
  _WidgetPreviewOrderState createState() => _WidgetPreviewOrderState();
}

class _WidgetPreviewOrderState extends State<WidgetPreviewOrder> {
  double tip = 0;
  AppOrderDeliveryType deliveryType = AppOrderDeliveryType.ship;
  double distanceInMet = 0.0;
  String duration = '';
  bool isCalculatingRoute = false;
  final dio = Dio();
  String ship_polyline = '';
  int ship_distance = 0;
  String ship_estimate_time = '';

  // Các trường cần thiết cho HERE API
  Map<String, dynamic>? routeData;

  double get subtotal =>
      widget.cart.cartItems?.fold(
        0,
        (sum, cartItem) =>
            sum! +
            (cartItem.product!.price! * cartItem.quantity! +
                cartItem.variations!.fold(
                      0,
                      (sum, variation) => sum + variation.price!.toInt(),
                    ) *
                    2),
      ) ??
      0;
  double get shippingFee {
    if (distanceInMet < 2000) {
      return 2.5;
    } else {
      return 2.5 + (distanceInMet - 2000) * 1;
    }
  }

  double get applicationFee => subtotal * 0.1; //TODO: Get from backend
  double get discount => 0.5; //TODO: Get from backend;

  double get total => subtotal + applicationFee + tip - discount;

  late int selectedPaymentWalletProvider = kDebugMode
      ? paymentWalletProviders.last.id!
      : paymentWalletProviders.first.id!;
  List<PaymentWalletProvider> get paymentWalletProviders => [
        PaymentWalletProvider(
          id: 4,
          name: "Stripe",
          iconUrl: "storage/images/news/stripe.jpg",
          isActive: 1,
        ),
        PaymentWalletProvider(
          id: 5,
          name: "Cash",
          iconUrl: "storage/images/news/cash.png",
          isActive: 1,
        ),
      ];

  bool get isPickup => deliveryType == AppOrderDeliveryType.pickup;

  @override
  void initState() {
    super.initState();
    // Tính toán quãng đường và lộ trình khi khởi tạo widget
    if (!isPickup) {
      _calculateRoute();
    }
  }

  // Phương thức tính toán quãng đường và lộ trình sử dụng HERE API
  Future<void> _calculateRoute() async {
    if (widget.cart.store == null ||
        widget.cart.store!.lat == null ||
        widget.cart.store!.lng == null ||
        locationCubit.latitude == null ||
        locationCubit.longitude == null) {
      _showRouteError(
          'Không tìm thấy thông tin vị trí cửa hàng hoặc người dùng');
      return;
    }

    setState(() {
      isCalculatingRoute = true;
    });

    try {
      // Tọa độ của cửa hàng
      final storeLatitude = widget.cart.store!.lat;
      final storeLongitude = widget.cart.store!.lng;

      // Tọa độ của người dùng
      final userLatitude = locationCubit.latitude;
      final userLongitude = locationCubit.longitude;

      // Gọi API HERE để tính toán lộ trình
      final response = await dio.get(
        'https://router.hereapi.com/v8/routes',
        queryParameters: {
          'apiKey': hereMapApiKey,
          'transportMode': 'scooter', // Sử dụng scooter để mô phỏng xe máy/moto
          'origin': '$storeLatitude,$storeLongitude',
          'destination': '$userLatitude,$userLongitude',
          'return': 'summary,polyline'
        },
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException('Kết nối với HERE API quá thời gian');
      });

      if (response.statusCode == 200) {
        final data = response.data;

        print("calculate route data: $data");

        // Lưu dữ liệu lộ trình
        routeData = data;

        // Lấy thông tin quãng đường và thời gian
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final sections = route['sections'];

          if (sections != null && sections.isNotEmpty) {
            final section = sections[0];
            final summary = section['summary'];

            // Quãng đường (mét)
            distanceInMet = summary['length']?.toDouble() ?? 0;
            ship_distance =
                summary['length']; // Lưu lại khoảng cách dưới dạng mét (int)

            // Thời gian (giây)
            final durationInSeconds = summary['duration'];
            final durationInMinutes = (durationInSeconds / 60).ceil();
            duration = '${durationInMinutes} min';
            ship_estimate_time = duration; // Lưu lại thời gian ước tính

            // Lấy polyline nếu có
            if (section['polyline'] != null) {
              ship_polyline = section['polyline'];
            }

            setState(() {
              isCalculatingRoute = false;
            });

            // Cập nhật giá shipping dựa trên quãng đường
            _updateShippingFee();
          } else {
            _showRouteError('Không tìm thấy chi tiết lộ trình');
          }
        } else {
          _showRouteError('Không tìm thấy lộ trình phù hợp');
        }
      } else {
        _showRouteError('Lỗi khi kết nối với HERE API: ${response.statusCode}');
      }
    } catch (e) {
      _showRouteError('Lỗi khi tính toán lộ trình: ${e.toString()}');
    }
  }

  // Cập nhật phí shipping dựa trên quãng đường
  void _updateShippingFee() {
    // TODO: Thực hiện tính toán phí ship dựa trên quãng đường
    // Đoạn này sẽ được thực hiện sau khi tích hợp với backend
  }

  // Hiển thị lỗi khi tính toán lộ trình
  void _showRouteError(String message) {
    print('HERE API Error: $message');
    setState(() {
      isCalculatingRoute = false;
    });

    if (mounted) {
      appShowSnackBar(
        context: context,
        msg: message,
        type: AppSnackBarType.error,
      );
    }
  }

  void _createOrder() async {
    appHaptic();
    final processer =
        ValueNotifier<SheetProcessStatus>(SheetProcessStatus.loading);

    // Nếu cần ship, tính toán lộ trình trước khi tạo đơn hàng
    if (!isPickup) {
      await _calculateRoute();
    }

    callback() async {
      processer.value = SheetProcessStatus.loading;
      final r = await OrderRepo().createOrder({
        "store_id": widget.cart.store!.id!,
        "delivery_type": deliveryType.name,
        "payment_id": selectedPaymentWalletProvider,
        // "voucher_id": 0,
        // "voucher_value": 0,
        "tip": tip,
        "ship_fee": isPickup ? 0 : shippingFee,
        "ship_distance": isPickup ? 0 : ship_distance,
        "ship_estimate_time": isPickup ? '' : ship_estimate_time,
        "ship_polyline": isPickup ? '' : ship_polyline,
        "ship_here_raw": isPickup ? '' : jsonEncode(routeData),
        // "note": "string",
        // "phone": "123456",
        "address": locationCubit.addressDetail ?? '',
        "lat": locationCubit.latitude,
        "lng": locationCubit.longitude,
        "street": locationCubit.state.addressDetail!.address?.street,
        "zip": locationCubit.state.addressDetail!.address?.postalCode,
        "city": locationCubit.state.addressDetail!.address?.city,
        "state": locationCubit.state.addressDetail!.address?.state,
        "country": locationCubit.state.addressDetail!.address?.countryName,
        "country_code": locationCubit.state.addressDetail!.address?.countryCode,
      });
      if (r.isSuccess) {
        cartCubit.fetchCarts();
        CreateOrderResponse orderResponse = r.data!;

        if (selectedPaymentWalletProvider == 4 &&
            orderResponse.clientSecret != null) {
          try {
            // Hiển thị giao diện thanh toán
            await Stripe.instance.initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: orderResponse.clientSecret,
                merchantDisplayName: 'FastshipHu', // Tên app của Minh
                customerId:
                    AppPrefs.instance.user?.uid, // ID khách hàng từ Stripe
                // customerEphemeralKeySecret:
                //     ephemeralKeySecret, // Khóa tạm thời để xác thực
                // Cấu hình bổ sung cho khách hàng
                billingDetails: BillingDetails(
                  name: AppPrefs.instance.user?.name,
                  email: AppPrefs.instance.user?.email,
                  phone: AppPrefs.instance.user?.phone,
                  // address: const Address(
                  //   city: 'Hà Nội',
                  //   country: 'VN',
                  //   line1: 'Địa chỉ nhà, phố',
                  //   line2: 'Quận/Huyện',
                  //   postalCode: '100000',
                  //   state: 'Hà Nội',
                  // ),
                ),
                applePay: PaymentSheetApplePay(
                  merchantCountryCode: 'US', // Thay bằng mã quốc gia hợp lệ
                ),
                googlePay: PaymentSheetGooglePay(
                  merchantCountryCode: 'US', // Thay bằng mã quốc gia hợp lệ
                  testEnv: kDebugMode, // Bỏ `testEnv: true` khi lên production
                ),
              ),
            );

            // Mở Payment Sheet
            await Stripe.instance.presentPaymentSheet();

            await appShowSnackBar(
              context: context,
              msg: "We received your payment!",
              type: AppSnackBarType.success,
            );
          } on StripeException catch (e) {
            print(e.error.message);
            await appShowSnackBar(
              context: context,
              msg: e.error.message,
              type: AppSnackBarType.error,
            );
            processer.value = SheetProcessStatus.error_payment;
            return;
          }
        }

        if (deliveryType == AppOrderDeliveryType.pickup) {
          processer.value = SheetProcessStatus.createPickupSuccess;
          Timer(
            const Duration(seconds: 2),
            () async {
              context.pop();
              context.pushReplacement('/checkout-tracking',
                  extra: orderResponse.order);
            },
          );
          return;
        }

        final socketResult =
            await socketController.createOrder(orderResponse.order!);
        if (socketResult) {
          processer.value = SheetProcessStatus.findingDriverSuccess;
          Timer(
            const Duration(seconds: 2),
            () async {
              context.pop();
              if (socketResult) {
                context.pushReplacement('/checkout-tracking');
              }
            },
          );
        } else {
          processer.value = SheetProcessStatus.error_no_driver;
        }
      } else {
        processer.value = SheetProcessStatus.error_create_order;
      }
    }

    callback();

    appOpenBottomSheet(
      WidgetBottomSheetProcess(
        processer: processer,
        onTryAgain: callback,
      ),
      isDismissible: kDebugMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                spacing: 20.sw,
                children: [
                  WidgetAppBar(
                    title: widget.cart.store?.name ?? "",
                    actions: [
                      WidgetInkWellTransparent(
                        onTap: () {
                          MapLauncher.installedMaps.then((maps) {
                            maps.first.showMarker(
                              coords: Coords(widget.cart.store!.lat!,
                                  widget.cart.store!.lng!),
                              title: widget.cart.store?.name ?? "",
                            );
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: WidgetAppSVG('icon20',
                              width: 18.sw, height: 18.sw),
                        ),
                      ),
                      // Text(
                      //   "0.6 Km",
                      //   maxLines: 1,
                      //   overflow: TextOverflow.ellipsis,
                      //   style: w400TextStyle(
                      //     fontSize: 14.sw,
                      //     color: Color(0xFFF17228),
                      //   ),
                      // ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      spacing: 20.sw,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAddressSection(),
                        // _buildShippingOptions(),
                        _buildOrderItems(),
                        _buildPaymentMethod(),
                        _buildCourierTip(),
                        _buildOrderSummary(),
                        _buildDiscountSection(),
                        SizedBox(
                            height: 150 +
                                MediaQuery.of(context)
                                    .padding
                                    .bottom), // Space for bottom bar
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomCheckout(context),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.sw,
      children: [
        GestureDetector(
          onTap: () {
            appHaptic();
            setState(() {
              deliveryType = AppOrderDeliveryType.ship;
            });
            // Tính toán lộ trình khi chuyển sang chế độ giao hàng
            _calculateRoute();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: !isPickup
                ? appBoxDecorationSelected
                : appBoxDecorationUnSelected,
            child: Column(
              children: [
                Row(
                  children: [
                    WidgetAppSVG(
                      'icon20',
                      width: 24.sw,
                    ),
                    SizedBox(width: 8.sw),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Delivery address'.tr(),
                                  style: w500TextStyle(
                                    fontSize: 16.sw,
                                  ),
                                ),
                              ),
                              WidgetInkWellTransparent(
                                onTap: () {
                                  appHaptic();
                                  appOpenBottomSheet(
                                          const WidgetSheetLocations())
                                      .then((_) {
                                    // Tính toán lại lộ trình khi thay đổi địa chỉ
                                    if (deliveryType ==
                                        AppOrderDeliveryType.ship) {
                                      _calculateRoute();
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: WidgetAppSVG(
                                    'icon28',
                                    width: 24.sw,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          BlocBuilder<LocationCubit, LocationState>(
                              bloc: locationCubit,
                              builder: (context, state) {
                                return Text(
                                  locationCubit.addressDetail ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF3C3836),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
                // Hiển thị thông tin quãng đường và thời gian giao hàng
                if (!isPickup && (distanceInMet > 0 || isCalculatingRoute))
                  Container(
                    margin: EdgeInsets.only(top: 8.sw),
                    decoration: BoxDecoration(
                      color: hexColor('#F9F8F6'),
                      borderRadius: BorderRadius.circular(8.sw),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 2.sw),
                            isCalculatingRoute
                                ? SizedBox(
                                    width: 16.sw,
                                    height: 16.sw,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          appColorPrimaryOrange),
                                    ),
                                  )
                                : WidgetAppSVG(
                                    'icon38', // Biểu tượng thời gian
                                    width: 16.sw,
                                    color: appColorPrimaryOrange,
                                  ),
                            SizedBox(width: 12.sw),
                            Text(
                              isCalculatingRoute
                                  ? 'Calculating route...'.tr()
                                  : ('Estimated time'.tr() +
                                      ': $duration (${distanceFormatted(distanceInMet)})'),
                              style: w500TextStyle(
                                fontSize: 14.sw,
                                color: hexColor('#F17228'),
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
        ),
        GestureDetector(
          onTap: () {
            appHaptic();
            setState(() {
              deliveryType = AppOrderDeliveryType.pickup;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: deliveryType == AppOrderDeliveryType.pickup
                ? appBoxDecorationSelected
                : appBoxDecorationUnSelected,
            child: Row(
              children: [
                WidgetAppSVG('icon38'),
                const SizedBox(width: 8),
                Text(
                  'Pick up yourself'.tr(),
                  style: w400TextStyle(
                    fontSize: 16,
                    color: hexColor('#847D79'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildShippingOptions() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Shipping options',
  //         style: TextStyle(
  //           fontSize: 16,
  //           fontWeight: FontWeight.w500,
  //           color: Color(0xFF14142A),
  //         ),
  //       ),
  //       const SizedBox(height: 12),
  //       Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(12),
  //           border: Border.all(color: Color(0xFF74CA45)),
  //           color: Color(0xFFF9F8F6),
  //         ),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Row(
  //               children: [
  //                 Text(
  //                   'Super fast',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     color: Color(0xFF847D79),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 8),
  //                 Text(
  //                   '10 mins',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w500,
  //                     color: Color(0xFF3C3836),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Text(
  //               '\$ 1,00',
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w500,
  //                 color: Color(0xFF120F0F),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       const SizedBox(height: 8),
  //       Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(12),
  //           color: Color(0xFFF9F8F6),
  //         ),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Row(
  //               children: [
  //                 Text(
  //                   'basic',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     color: Color(0xFF847D79),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 8),
  //                 Text(
  //                   '25 mins',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w500,
  //                     color: Color(0xFF3C3836),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Text(
  //               '\$ 2,00',
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w500,
  //                 color: Color(0xFF120F0F),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildOrderItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order items'.tr(),
              style: w500TextStyle(fontSize: 16.sw),
            ),
            // GestureDetector(
            //   onTap: () {
            //     appHaptic();
            //     Navigator.pop(context);
            //   },
            //   child: Row(
            //     children: [
            //       WidgetAppSVG(
            //         'icon53',
            //         height: 18.sw,
            //         color: appColorPrimary,
            //       ),
            //       SizedBox(width: 4.sw),
            //       Text(
            //         'Add more'.tr(),
            //         style: w400TextStyle(
            //           fontSize: 16.sw,
            //           color: appColorPrimary,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: 12),
        DottedBorder(
          borderType: BorderType.RRect,
          radius: Radius.circular(16),
          padding: EdgeInsets.all(12),
          strokeWidth: .8,
          dashPattern: [8, 4],
          color: Color(0xFFCEC6C5),
          child: Column(
            spacing: 12.sw,
            children: widget.cart.cartItems
                    ?.map((cartItem) => _buildOrderItem(cartItem))
                    .toList() ??
                [],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItem(CartItemModel cartItem) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.sw),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 4.sw),
            height: 34.sw,
            width: 34.sw,
            decoration: BoxDecoration(
              color: hexColor('#F2F1F1'),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              cartItem.quantity.toString(),
              style: w500TextStyle(
                fontSize: 16.sw,
                height: 1,
              ),
            ),
          ),
          SizedBox(width: 12.sw),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 44.sw,
                      height: 44.sw,
                      padding: EdgeInsets.all(1.sw),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFFF8F1F0)),
                      ),
                      child: WidgetAppImage(
                        imageUrl: cartItem.product?.image ?? '',
                        width: 44.sw,
                        height: 44.sw,
                        radius: 8,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 8.sw),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cartItem.product?.name ?? "",
                            style: w500TextStyle(
                              fontSize: 14.sw,
                              color: Color(0xFF3C3836),
                            ),
                          ),
                          Gap(4.sw),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: currencyFormatted(cartItem
                                              .product!.price! *
                                          cartItem.quantity! +
                                      cartItem.variations!.fold(
                                              0,
                                              (sum, variation) =>
                                                  sum +
                                                  variation.price!.toInt()) *
                                          cartItem.quantity!),
                                  style: w500TextStyle(
                                    fontSize: 14.sw,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      " (${currencyFormatted(cartItem.product!.price!)} x ${cartItem.quantity} + ${currencyFormatted(cartItem.variations!.fold(0, (sum, variation) => sum + variation.price!.toInt()) * cartItem.quantity!)})",
                                  style: w400TextStyle(
                                      fontSize: 14.sw, color: appColorText2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ...cartItem.product!.variations!.map((e) => _buildMenuSection(
                      e.name ?? '',
                      e.values?.map(
                            (e) {
                              bool isSelected = cartItem.variations!
                                  .any((element) => element.id == e.id);
                              return _MenuItem(
                                title: e.value ?? '',
                                price:
                                    "+${currencyFormatted(e.price?.toDouble())}",
                                isSelected: isSelected,
                              );
                            },
                          ).toList() ??
                          [],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Payment method',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF14142A),
              ),
            ),
            Row(
              children: [
                Icon(Icons.add, color: Color(0xFF74CA45)),
                Text(
                  'Add more',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF74CA45),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Color(0xFFF9F8F6),
          ),
          child: Column(
            children: [
              _buildPaymentOption(
                m: paymentWalletProviders[0],
              ),
              Divider(color: Color(0xFFF1EFE9)),
              _buildPaymentOption(
                m: paymentWalletProviders[1],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({required PaymentWalletProvider m}) {
    bool isSelected = selectedPaymentWalletProvider == m.id;
    return WidgetInkWellTransparent(
      onTap: () {
        appHaptic();
        setState(() {
          selectedPaymentWalletProvider = m.id!;
        });
      },
      enableInkWell: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            const SizedBox(width: 12),
            WidgetAppImage(
              imageUrl: m.iconUrl ?? '',
              fit: BoxFit.scaleDown,
              height: 24,
              width: 24,
              radius: 4,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                m.name ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
                  letterSpacing: 0.28,
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Color(0xFF333333) : Color(0xFFCEC6C5),
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF333333),
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourierTip() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add courier tip'.tr(),
              style: w400TextStyle(
                fontSize: 16.sw,
              ),
            ),
            Text(
              '100% of the tip goes to your courier'.tr(),
              style: w400TextStyle(
                fontSize: 14.sw,
                color: hexColor('#847D79'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12.sw,
          runSpacing: 12.sw,
          children: [
            _buildTipOption(0),
            _buildTipOption(5),
            _buildTipOption(10),
            _buildTipOption(15),
            _buildTipOption(20),
          ],
        ),
      ],
    );
  }

  Widget _buildTipOption(double amount) {
    bool isSelected = tip == amount;
    return GestureDetector(
      onTap: () {
        appHaptic();
        setState(() {
          tip = amount;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Color(0xFF74CA45) : Color(0xFFCEC6C5),
          ),
          color: Colors.white,
        ),
        child: Text(
          '+ ${currencyFormatted(amount, decimalDigits: 0)}',
          style: w500TextStyle(
            fontSize: 16.sw,
            height: 1,
            color: isSelected ? appColorPrimary : hexColor('#847D79'),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(16),
      padding: EdgeInsets.all(12),
      strokeWidth: .8,
      dashPattern: [8, 4],
      color: Color(0xFFCEC6C5),
      child: Column(
        spacing: 12.sw,
        children: [
          _buildSummaryRow('Subtotal', currencyFormatted(subtotal)),
          _buildSummaryRow(
              'Application fee', currencyFormatted(applicationFee)),
          if (shippingFee > 0)
            _buildSummaryRow('Shipping fee', currencyFormatted(shippingFee)),
          _buildSummaryRow('Courier tip', currencyFormatted(tip),
              color: appColorPrimary),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  WidgetAppSVG('icon34',
                      height: 18.sw, color: hexColor('#F17228')),
                  const SizedBox(width: 8),
                  Text(
                    '\$0.50 off, more deals below',
                    style: w400TextStyle(
                      fontSize: 16.sw,
                      color: hexColor('#3C3836'),
                    ),
                  ),
                ],
              ),
              Text(
                '- ${currencyFormatted(discount)}',
                style: w500TextStyle(
                  fontSize: 16.sw,
                  color: hexColor('#F17228'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String amount, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: w400TextStyle(
            fontSize: 16.sw,
            color: hexColor('#3C3836'),
          ),
        ),
        Text(
          amount,
          style: w500TextStyle(
            fontSize: 16.sw,
            color: color ?? hexColor('#091230'),
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountSection() {
    return GestureDetector(
      onTap: () {
        appHaptic();
        context.push('/vouchers', extra: widget.cart.store?.id);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: hexColor('#F9F8F6'),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                WidgetAppSVG('icon34',
                    height: 18.sw, color: hexColor('#F17228')),
                const SizedBox(width: 12),
                Text(
                  'Use a discount or promotion'.tr(),
                  style: w500TextStyle(
                    fontSize: 16.sw,
                    color: hexColor('#F17228'),
                  ),
                ),
              ],
            ),
            WidgetAppSVG('icon28', height: 18.sw, color: appColorText2),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomCheckout(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
            16, 16, 16, MediaQuery.of(context).padding.bottom + 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: Offset(17, 10),
              blurRadius: 30,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total'.tr(),
                  style: w500TextStyle(
                    fontSize: 18.sw,
                  ),
                ),
                Text(
                  currencyFormatted(total),
                  style: w500TextStyle(
                    fontSize: 24.sw,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            WidgetButtonConfirm(
              onPressed: _createOrder,
              text: 'Check out'.tr(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.sw),
        Text(title, style: w600TextStyle(fontSize: 16.sw)),
        SizedBox(height: 8.sw),
        ...items,
      ],
    );
  }
}

// Menu Item Widget
class _MenuItem extends StatelessWidget {
  final String title;
  final String price;
  final bool isSelected;

  const _MenuItem({
    Key? key,
    required this.title,
    required this.price,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: isSelected
          ? BoxDecoration(
              border: Border.all(color: appColorPrimary),
              color: hexColor('#E6FBDA'),
              borderRadius: BorderRadius.circular(12),
            )
          : BoxDecoration(
              color: hexColor('#F9F8F6'),
              borderRadius: BorderRadius.circular(12),
            ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: w400TextStyle(
                  color: isSelected ? Colors.black : hexColor('#7D7575'),
                  fontSize: 14.sw,
                ),
              ),
            ),
            Text(
              price,
              style: w500TextStyle(
                color: isSelected ? hexColor('#538D33') : hexColor('#B6B6B6'),
                fontSize: 14.sw,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
