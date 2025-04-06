import 'package:intl/intl.dart';

enum AppOrderProcessStatus {
  pending, // Đơn hàng mới 
  findDriver, // Đang tìm tài xế
  driverAccepted, // Tài xế đã chấp nhận đơn
  storeAccepted, // Cửa hàng đã chấp nhận đơn
  driverArrivedStore, // Tài xế đã đến địa điểm giao hàng
  driverPicked, // Tài xế đã lấy hàng
  driverArrivedDestination, // Tài xế đã đến địa điểm giao hàng
  completed, // Đơn hàng hoàn thành
  cancelled 
}

enum AppFindDriverStatus {
  finding, // Đang tìm tài xế
  availableDrivers, // Tài xế khả dụng
  found, // Đã tìm thấy tài xế
  noDriver, // Không tìm thấy tài xế
  error // Lỗi
}

enum AppPaymentOrderStatus {
  pending, // Đang chờ thanh toán
  paid, // Đã thanh toán
  failed, // Thanh toán thất bại
}

enum AppOrderType {
  delivery, // Giao hàng
  pickup, // Món đặt lấy
}


String currencyFormatted(num? amount, {int? decimalDigits}) {
  return NumberFormat.currency(
    locale: 'vi_VN',
    symbol: "€",
    decimalDigits: decimalDigits ?? 2,
  ).format(amount ?? 0);
}

String distanceFormatted(num metter) {
  if (metter < 1000) {
    return '${metter}m';
  } else {
    return '${(metter / 1000).toStringAsFixed(1)}km';
  }
}
