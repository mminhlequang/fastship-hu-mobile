import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/app_colors.dart';

class OrderStatusWidget extends StatelessWidget {
  final Map<String, dynamic> order;
  final String status;
  final VoidCallback onCancel;

  const OrderStatusWidget({
    Key? key,
    required this.order,
    required this.status,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final estimatedTime = order['estimatedTime'] != null
        ? DateTime.parse(order['estimatedTime'])
        : DateTime.now().add(const Duration(minutes: 30));

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LinearProgressIndicator(
              value: null, // Indeterminate
              backgroundColor: appLightGreyColor,
              color: appGreenColor,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.check_circle, color: appGreenColor),
                const SizedBox(width: 8),
                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Dự kiến: ${_formatOrderTime(estimatedTime)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order['restaurant']['name'] ?? 'Nhà hàng',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...(_formatOrderItems(order['items'] as List<dynamic>?)),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tổng cộng:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatCurrency(order['finalTotal'] ?? 0),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: appGreenColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: appRedColor,
                side: const BorderSide(color: appRedColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(double.infinity, 45),
              ),
              child: const Text('Hủy đơn hàng'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _formatOrderItems(List<dynamic>? items) {
    if (items == null || items.isEmpty) {
      return [const Text('Không có món')];
    }

    return items.map<Widget>((item) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${item['quantity']}x ${item['name']}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              _formatCurrency(item['price'] * item['quantity']),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      );
    }).toList();
  }

  String _formatOrderTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatCurrency(dynamic amount) {
    final formatter = NumberFormat('vi_VN', 'vi');
    return formatter.format(amount);
  }
}

// Placeholder colors
const Color appGreenColor = Color(0xFF4CAF50);
const Color appRedColor = Color(0xFFE53935);

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
