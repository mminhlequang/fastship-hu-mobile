import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

class OrderCanceledWidget extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onClose;
  final VoidCallback onContactSupport;

  const OrderCanceledWidget({
    Key? key,
    required this.order,
    required this.onClose,
    required this.onContactSupport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String cancelReason = order['cancel_reason'] ?? 'Đơn hàng đã bị hủy';

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
          // Icon và trạng thái
          CircleAvatar(
            radius: 30,
            backgroundColor: appRedColor,
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Đơn hàng đã bị hủy',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            cancelReason,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),

          // Thông tin đơn hàng
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

                // Thông tin hủy đơn
                const Divider(),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hủy lúc:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      _formatCancelTime(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Nút liên hệ hỗ trợ
          OutlinedButton(
            onPressed: onContactSupport,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(color: appBlueColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.headset_mic, color: appBlueColor),
                const SizedBox(width: 8),
                Text(
                  'Liên hệ hỗ trợ',
                  style: TextStyle(color: appBlueColor),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Nút đóng
          ElevatedButton(
            onPressed: onClose,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(45),
              backgroundColor: appGreenColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Đóng',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
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

  String _formatCancelTime() {
    final cancelTime = order['cancelled_at'] ?? order['updated_at'] ?? '';
    if (cancelTime is String && cancelTime.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(cancelTime);
        return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.day}/${dateTime.month}/${dateTime.year}';
      } catch (e) {
        return cancelTime;
      }
    }
    return 'Không có thông tin';
  }
}

// Placeholder colors
const Color appGreenColor = Color(0xFF4CAF50);
const Color appRedColor = Color(0xFFE53935);
const Color appBlueColor = Color(0xFF2196F3);
