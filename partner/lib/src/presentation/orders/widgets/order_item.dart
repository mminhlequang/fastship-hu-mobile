import 'package:flutter/material.dart';
import '../cubit/orders_cubit.dart';

class OrderItem extends StatelessWidget {
  final Order order;

  const OrderItem({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID và thời gian
            Row(
              children: [
                Text(
                  order.id,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const Spacer(),
                Text(
                  'Giao lúc ${order.deliveryTime} (${order.timeRemaining})',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Tên người dùng
            Text(
              order.username,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),

            // Đường phân cách
            const Divider(),

            // Trạng thái
            Row(
              children: [
                const Text(
                  'Trạng thái:',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                _buildStatusText(order.status),
              ],
            ),
            const SizedBox(height: 8),

            // Số lượng món và giá
            Row(
              children: [
                Text(
                  order.items.first, // Hiển thị mục đầu tiên
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${order.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusText(OrderStatus status) {
    Color textColor;
    String statusText;

    switch (status) {
      case OrderStatus.searching:
        textColor = Colors.orange;
        statusText = 'Đang tìm Shipper';
        break;
      case OrderStatus.found:
        textColor = Colors.blue;
        statusText = 'Đã tìm được Shipper';
        break;
      case OrderStatus.inProgress:
        textColor = Colors.blue;
        statusText = 'Đang giao hàng';
        break;
      case OrderStatus.completed:
        textColor = Colors.green;
        statusText = 'Hoàn thành';
        break;
      case OrderStatus.cancelled:
        textColor = Colors.red;
        statusText = 'Đã hủy';
        break;
    }

    return Text(
      statusText,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
    );
  }
}
