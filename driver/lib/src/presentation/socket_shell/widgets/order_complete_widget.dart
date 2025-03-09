import 'dart:math';
import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';

class OrderCompleteWidget extends StatefulWidget {
  final Map<String, dynamic> order;
  final VoidCallback onClose;

  const OrderCompleteWidget({
    super.key,
    required this.order,
    required this.onClose,
  });

  @override
  State<OrderCompleteWidget> createState() => _OrderCompleteWidgetState();
}

class _OrderCompleteWidgetState extends State<OrderCompleteWidget>
    with TickerProviderStateMixin {
  late AnimationController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _confettiController.forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Confetti effect
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: ConfettiPainter(_confettiController),
            ),
          ),
        ),

        // Content
        Container(
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
                backgroundColor: green1,
                radius: 35,
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Đơn hàng đã hoàn thành!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: appColorText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Cảm ơn bạn đã giao đơn thành công!',
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
                  children: [
                    _buildInfoRow('Mã đơn hàng:', '#${widget.order['id']}'),
                    const SizedBox(height: 8),
                    _buildInfoRow('Tổng tiền:',
                        _formatCurrency(widget.order['total_amount'])),
                    const SizedBox(height: 8),
                    _buildInfoRow('Phí giao hàng:',
                        _formatCurrency(widget.order['delivery_fee'])),
                    const SizedBox(height: 8),
                    _buildInfoRow('Tiền thưởng:',
                        _formatCurrency(widget.order['bonus'] ?? 0),
                        textColor: green1),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Mở chi tiết đơn hàng
                        widget.onClose();
                        // Chuyển đến màn hình chi tiết (có thể thêm sau)
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: grey5),
                      ),
                      child: Text(
                        'Xem chi tiết',
                        style: TextStyle(
                          color: appColorText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.onClose,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Tiếp tục',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? textColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            color: textColor ?? appColorText,
          ),
        ),
      ],
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

class ConfettiPainter extends CustomPainter {
  final Animation<double> _animation;
  final Random _random = Random();
  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
  ];
  final List<Confetti> _confetti = [];

  ConfettiPainter(Animation<double> animation)
      : _animation = animation,
        super(repaint: animation) {
    // Tạo các hạt confetti
    for (int i = 0; i < 100; i++) {
      _confetti.add(Confetti(
        color: _colors[_random.nextInt(_colors.length)],
        position: Offset(
          _random.nextDouble() * 500,
          -50 - _random.nextDouble() * 300,
        ),
        size: 5 + _random.nextDouble() * 10,
        velocity: Offset(
          -2 + _random.nextDouble() * 4,
          3 + _random.nextDouble() * 5,
        ),
        rotation: _random.nextDouble() * pi * 2,
        rotationSpeed: -0.1 + _random.nextDouble() * 0.2,
      ));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final confetti in _confetti) {
      // Cập nhật vị trí dựa trên animation
      final progress = _animation.value;
      final position = confetti.position + confetti.velocity * progress * 200;
      final rotation =
          confetti.rotation + confetti.rotationSpeed * progress * 20;

      // Vẽ confetti
      paint.color = confetti.color.withOpacity(1 - progress * 0.3);

      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.rotate(rotation);

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: confetti.size,
          height: confetti.size,
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) => true;
}

class Confetti {
  final Color color;
  final Offset position;
  final double size;
  final Offset velocity;
  final double rotation;
  final double rotationSpeed;

  Confetti({
    required this.color,
    required this.position,
    required this.size,
    required this.velocity,
    required this.rotation,
    required this.rotationSpeed,
  });
}
