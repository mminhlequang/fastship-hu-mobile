import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import 'package:intl/intl.dart';

class OrderActionWidget extends StatelessWidget {
  final Map<String, dynamic> order;
  final Function(String) onUpdateStatus;
  final VoidCallback onComplete;
  final VoidCallback onCall;
  final Function(String) onSendSms;

  const OrderActionWidget({
    super.key,
    required this.order,
    required this.onUpdateStatus,
    required this.onComplete,
    required this.onCall,
    required this.onSendSms,
  });

  @override
  Widget build(BuildContext context) {
    // Xác định đây là trạng thái nào để hiển thị title và các nút thích hợp
    String title = 'Đang giao hàng';
    List<Widget> statusButtons = [];

    // Xác định các nút trạng thái dựa trên trạng thái hiện tại của đơn hàng
    if (order['status'] == 'accepted') {
      title = 'Đã nhận đơn hàng';
      statusButtons = [
        _buildStatusButton(
          context: context,
          status: 'arrived_at_restaurant',
          label: 'Đã đến quán',
          icon: Icons.storefront,
        ),
        _buildStatusButton(
          context: context,
          status: 'picked_up',
          label: 'Đã lấy hàng',
          icon: Icons.shopping_bag,
          isPrimary: true,
        ),
      ];
    } else if (order['status'] == 'picked') {
      title = 'Đã lấy hàng';
      statusButtons = [
        _buildStatusButton(
          context: context,
          status: 'arrived_at_customer',
          label: 'Đã đến nơi giao',
          icon: Icons.location_on,
          isPrimary: true,
        ),
      ];
    } else if (order['status'] == 'in_progress') {
      title = 'Đang giao hàng';
      statusButtons = [
        _buildStatusButton(
          context: context,
          status: 'completed',
          label: 'Hoàn thành giao hàng',
          icon: Icons.check_circle,
          isPrimary: true,
        ),
      ];
    }

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.delivery_dining,
                color: appColorPrimary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: appColorText,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: green1,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${_formatCurrency(order['total_amount'])}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Thông tin đơn hàng
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: grey6,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thông tin quán
                Row(
                  children: [
                    Icon(Icons.storefront, color: appColorPrimary, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${order['restaurant_name']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on,
                        color: appColorPrimaryRed, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${order['restaurant_address']}',
                        style: const TextStyle(fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 16),

                // Địa chỉ giao hàng
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.home, color: green1, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${order['delivery_address']}',
                        style: const TextStyle(fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Các action nhanh
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.call,
                label: 'Gọi',
                color: blue1,
                onTap: onCall,
              ),
              _buildSmsButton(context),
              _buildActionButton(
                icon: Icons.cancel_outlined,
                label: 'Huỷ đơn',
                color: appColorPrimaryRed,
                onTap: () => _showCancelConfirmDialog(context),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Các nút cập nhật trạng thái
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: statusButtons,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: appColorText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmsButton(BuildContext context) {
    return InkWell(
      onTap: () => _showSmsOptionsDialog(context),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sms, color: orange1, size: 24),
            const SizedBox(height: 4),
            Text(
              'SMS',
              style: TextStyle(
                fontSize: 12,
                color: appColorText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton({
    required BuildContext context,
    required String status,
    required String label,
    required IconData icon,
    bool isPrimary = false,
  }) {
    return OutlinedButton.icon(
      onPressed: () => isPrimary ? onComplete() : onUpdateStatus(status),
      style: OutlinedButton.styleFrom(
        backgroundColor: isPrimary ? green1 : Colors.white,
        foregroundColor: isPrimary ? Colors.white : appColorText,
        side: BorderSide(color: isPrimary ? green1 : grey5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      icon: Icon(icon, size: 16),
      label: Text(label),
    );
  }

  void _showSmsOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text('Gửi tin nhắn nhanh', style: TextStyle(color: appColorText)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSmsOption(context, 'Tôi sẽ đến trong 2 phút nữa'),
            _buildSmsOption(context, 'Tôi đang đến'),
            _buildSmsOption(context, 'Tôi đã đến, vui lòng nhận hàng'),
            _buildSmsOption(
                context, 'Tôi không tìm thấy địa chỉ, vui lòng hướng dẫn'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Widget _buildSmsOption(BuildContext context, String message) {
    return ListTile(
      title: Text(message, style: const TextStyle(fontSize: 14)),
      onTap: () {
        Navigator.pop(context);
        onSendSms(message);
      },
    );
  }

  void _showCancelConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận huỷ đơn',
            style: TextStyle(color: appColorPrimaryRed)),
        content: const Text(
          'Việc huỷ đơn có thể ảnh hưởng đến đánh giá của bạn. Bạn có chắc chắn muốn huỷ không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onUpdateStatus('canceled');
            },
            style: TextButton.styleFrom(foregroundColor: appColorPrimaryRed),
            child: const Text('Huỷ đơn'),
          ),
        ],
      ),
    );
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

    // Định dạng số theo chuẩn tiền tệ VN
    final formatter = NumberFormat('#,###', 'vi_VN');
    return '${formatter.format(numAmount)}đ';
  }
}
