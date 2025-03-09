import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';

class OrderNotificationWidget extends StatelessWidget {
  final Map<String, dynamic> order;
  final bool isBlinking;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const OrderNotificationWidget({
    super.key,
    required this.order,
    required this.isBlinking,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: const Offset(0, 0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: Container(
        decoration: BoxDecoration(
          color: isBlinking ? appColorPrimary.withOpacity(0.9) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications_active,
                  color: orange1,
                  size: 30,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Đơn hàng mới',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: appColorText,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: orange1,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_formatCurrency(order['total_amount'])}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thông tin quán
                  Row(
                    children: [
                      Icon(Icons.storefront, color: appColorPrimary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${order['restaurant_name']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Địa chỉ quán
                  Row(
                    children: [
                      Icon(Icons.location_on, color: appColorPrimaryRed),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${order['restaurant_address']}',
                          style: const TextStyle(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Địa chỉ giao hàng
                  Row(
                    children: [
                      Icon(Icons.home, color: green1),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${order['delivery_address']}',
                          style: const TextStyle(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Khoảng cách và thời gian
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.directions_bike, color: blue1),
                          const SizedBox(width: 4),
                          Text(
                            '${order['distance']} km',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.access_time, color: orange1),
                          const SizedBox(width: 4),
                          Text(
                            '~${order['estimated_time']} phút',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onReject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Từ chối',
                      style: TextStyle(
                        fontSize: 16,
                        color: appColorText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: green1,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Nhận đơn',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(dynamic amount) {
    if (amount == null) return '0đ';
    final value = amount is int
        ? amount
        : (amount is String ? int.tryParse(amount) ?? 0 : 0);
    final formatter = StringBuffer();
    formatter.write(value.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        ));
    formatter.write('đ');
    return formatter.toString();
  }
}
