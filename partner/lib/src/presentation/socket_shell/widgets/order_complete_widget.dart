import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

class OrderCompleteWidget extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onClose;
  final Function(int, String?) onRateOrder;

  const OrderCompleteWidget({
    Key? key,
    required this.order,
    required this.onClose,
    required this.onRateOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
        children: [
          // Icon và trạng thái
          CircleAvatar(
            radius: 30,
            backgroundColor: appGreenColor,
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Đơn hàng đã giao thành công!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mã đơn hàng: ${order['order_id'] ?? order['id'] ?? ''}',
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

          const SizedBox(height: 16),

          // Đánh giá
          const Text(
            'Đánh giá trải nghiệm của bạn',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Rating stars
          RatingBar(
            onRatingChanged: (rating) {
              _showRatingDialog(context, rating);
            },
          ),

          const SizedBox(height: 16),

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

  void _showRatingDialog(BuildContext context, int rating) {
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Đánh giá $rating sao',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Bạn có thể để lại nhận xét:'),
            const SizedBox(height: 8),
            TextField(
              controller: commentController,
              decoration: const InputDecoration(
                hintText: 'Nhận xét của bạn...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              onRateOrder(
                  rating,
                  commentController.text.isEmpty
                      ? null
                      : commentController.text);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appGreenColor,
            ),
            child: const Text(
              'Gửi đánh giá',
              style: TextStyle(color: Colors.white),
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

// Widget RatingBar tùy chỉnh
class RatingBar extends StatefulWidget {
  final Function(int) onRatingChanged;

  const RatingBar({
    Key? key,
    required this.onRatingChanged,
  }) : super(key: key);

  @override
  State<RatingBar> createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return IconButton(
          onPressed: () {
            setState(() {
              _rating = starIndex;
            });
            widget.onRatingChanged(starIndex);
          },
          icon: Icon(
            starIndex <= _rating ? Icons.star : Icons.star_border,
            color: starIndex <= _rating ? Colors.amber : Colors.grey,
            size: 30,
          ),
        );
      }),
    );
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
