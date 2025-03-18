import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

class OrderTrackingWidget extends StatelessWidget {
  final Map<String, dynamic> order;
  final String status;
  final Map<String, dynamic>? driverLocation;
  final VoidCallback onCallDriver;

  const OrderTrackingWidget({
    Key? key,
    required this.order,
    required this.status,
    this.driverLocation,
    required this.onCallDriver,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final driverInfo = order['driver'] ?? {};
    final String driverName = driverInfo['name'] ?? 'Tài xế';
    final String? driverAvatar = driverInfo['avatar'];
    final String vehicleNumber = driverInfo['vehicle_number'] ?? '';
    final String vehicleInfo = driverInfo['vehicle_info'] ?? 'Xe máy';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Trạng thái giao hàng
          Row(
            children: [
              Icon(
                Icons.delivery_dining,
                color: appGreenColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  status,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: appGreenColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _formatEstimatedTime(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: appGreenColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Thông tin tài xế
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // Avatar tài xế
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                    image: driverAvatar != null
                        ? DecorationImage(
                            image: NetworkImage(driverAvatar),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: driverAvatar == null
                      ? const Icon(Icons.person, size: 30, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 12),

                // Thông tin tài xế
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driverName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (vehicleNumber.isNotEmpty)
                        Text(
                          '$vehicleInfo - $vehicleNumber',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),

                // Nút gọi điện
                InkWell(
                  onTap: onCallDriver,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: appGreenColor,
                    ),
                    child: const Icon(
                      Icons.phone,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Vị trí hiện tại (placeholder)
          if (driverLocation != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 120,
                color: Colors.grey[300],
                alignment: Alignment.center,
                child: const Text(
                  'Bản đồ vị trí tài xế',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],

          // Thông tin đơn hàng
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên nhà hàng
                Text(
                  order['restaurant_name'] ?? 'Nhà hàng',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),

                // Các món đã đặt
                Text(
                  _formatOrderItems(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),

                // Tổng tiền
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tổng cộng:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _formatCurrency(order['total_amount'] ?? 0),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: appGreenColor,
                      ),
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

  String _formatOrderItems() {
    final items = order['items'] as List?;
    if (items == null || items.isEmpty) {
      return 'Không có món';
    }

    if (items.length == 1) {
      return '${items[0]['quantity']} x ${items[0]['name']}';
    }

    return '${items[0]['quantity']} x ${items[0]['name']} và ${items.length - 1} món khác';
  }

  String _formatEstimatedTime() {
    if (driverLocation != null &&
        driverLocation!['estimated_arrival_time'] != null) {
      return driverLocation!['estimated_arrival_time'];
    }

    final int estimatedMinutes = order['estimated_time'] ?? 30;
    return '$estimatedMinutes phút';
  }

  String _formatCurrency(dynamic amount) {
    if (amount == null) return '0đ';

    // Chuyển đổi amount thành số nếu nó là string
    double numAmount = 0;
    if (amount is String) {
      numAmount = double.tryParse(amount) ?? 0;
    } else if (amount is num) {
      numAmount = amount.toDouble();
    }

    final formatter = NumberFormat('#,###', 'vi_VN');
    return '${formatter.format(numAmount)}đ';
  }
}

// Placeholder colors
const Color appGreenColor = Color(0xFF4CAF50);

// Placeholder formatter
class NumberFormat {
  final String pattern;
  final String locale;

  NumberFormat(this.pattern, this.locale);

  String format(double number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        );
  }
}
