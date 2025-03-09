import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';

class OrderCanceledWidget extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onClose;
  final VoidCallback onContactSupport;

  const OrderCanceledWidget({
    super.key,
    required this.order,
    required this.onClose,
    required this.onContactSupport,
  });

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
          const SizedBox(height: 8),
          CircleAvatar(
            backgroundColor: appColorPrimaryRed.withOpacity(0.9),
            radius: 35,
            child: const Icon(
              Icons.cancel,
              color: Colors.white,
              size: 50,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Đơn hàng đã bị huỷ!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: appColorPrimaryRed,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Khách hàng đã huỷ đơn hàng này',
            style: TextStyle(
              fontSize: 14,
              color: grey1,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: grey6,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  icon: Icons.info_outline,
                  label: 'Lý do:',
                  value: order['cancel_reason'] ?? 'Không có lý do',
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  icon: Icons.assignment,
                  label: 'Mã đơn:',
                  value: '#${order['id']}',
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  icon: Icons.access_time,
                  label: 'Thời gian:',
                  value: order['canceled_at'] ?? 'N/A',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Bạn cần báo cáo vấn đề hoặc gửi hình ảnh của đơn hàng không?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: grey1,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Mở chức năng báo cáo với hình ảnh
                    _showReportDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orange1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.report, color: Colors.white),
                  label: const Text(
                    'Báo cáo vấn đề',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onContactSupport,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: blue1,
                    side: BorderSide(color: blue1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: Icon(Icons.support_agent, color: blue1),
                  label: Text(
                    'Liên hệ hỗ trợ',
                    style: TextStyle(
                      color: blue1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: onClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: grey5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Đóng',
                    style: TextStyle(
                      color: appColorText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: grey1, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: grey1,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: appColorText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Báo cáo vấn đề',
          style: TextStyle(color: appColorText),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Mô tả vấn đề của bạn...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: grey6,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                // Chức năng chọn ảnh từ gallery
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: blue1,
                side: BorderSide(color: grey5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
              icon: const Icon(Icons.photo_camera),
              label: const Text('Chọn ảnh'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Huỷ'),
          ),
          ElevatedButton(
            onPressed: () {
              // Gửi báo cáo
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã gửi báo cáo thành công!'),
                  backgroundColor: Colors.green,
                ),
              );
              onClose();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appColorPrimary,
            ),
            child: const Text('Gửi báo cáo'),
          ),
        ],
      ),
    );
  }
}
