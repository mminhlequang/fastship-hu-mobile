import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

class CustomBottomBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  late Animation<double> _fabPositionAnimation;

  final List<_BottomBarItem> _items = [
    _BottomBarItem(
        icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Trang chủ'),
    _BottomBarItem(
        icon: Icons.restaurant_menu_outlined,
        activeIcon: Icons.restaurant_menu,
        label: 'Đồ ăn'),
    _BottomBarItem(
        icon: Icons.shopping_cart_outlined,
        activeIcon: Icons.shopping_cart,
        label: 'Giỏ hàng'),
    _BottomBarItem(
        icon: Icons.receipt_outlined,
        activeIcon: Icons.receipt,
        label: 'Đơn hàng'),
    _BottomBarItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Tài khoản'),
  ];

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _updateFabPosition(widget.currentIndex);
  }

  @override
  void didUpdateWidget(CustomBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _updateFabPosition(widget.currentIndex);
    }
  }

  void _updateFabPosition(int index) {
    final double startPosition = _getPositionForIndex(widget.currentIndex);
    final double endPosition = _getPositionForIndex(index);

    _fabPositionAnimation = Tween<double>(
      begin: startPosition,
      end: endPosition,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));

    _fabAnimationController.forward(from: 0.0);
  }

  double _getPositionForIndex(int index) {
    // Chuyển đổi index thành vị trí tương đối (0.0 -> 1.0)
    return index / (_items.length - 1);
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Custom shape cho bottom bar
        AnimatedBuilder(
            animation: _fabAnimationController,
            builder: (context, _) {
              return CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 80),
                painter: _BottomBarPainter(
                  fabPosition: _fabPositionAnimation.value,
                ),
              );
            }),

        // Icons trong bottom bar
        SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              return _buildBottomBarButton(index);
            }),
          ),
        ),

        // FAB di chuyển theo tab
        AnimatedBuilder(
          animation: _fabAnimationController,
          builder: (context, child) {
            final double width = MediaQuery.of(context).size.width;
            final double itemWidth = width / _items.length;
            final double fabPosition = itemWidth *
                (0.5 + _fabPositionAnimation.value * (_items.length - 1));

            return Positioned(
              left: fabPosition - 30,
              bottom: 25,
              child: GestureDetector(
                onTap: () => widget.onTap(widget.currentIndex),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appGreenColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    _items[widget.currentIndex].activeIcon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomBarButton(int index) {
    final bool isSelected = widget.currentIndex == index;

    return InkWell(
      onTap: () => widget.onTap(index),
      child: SizedBox(
        width: 60,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 15), // Đẩy icon lên trên để tránh cong
            Icon(
              isSelected ? _items[index].activeIcon : _items[index].icon,
              color: isSelected ? appGreenColor : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              _items[index].label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? appGreenColor : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBarPainter extends CustomPainter {
  final double fabPosition; // 0.0 -> 1.0

  _BottomBarPainter({required this.fabPosition});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final double width = size.width;
    final double height = size.height;

    // Tính vị trí của điểm cao nhất của đường cong
    final double curvePosition = width * fabPosition;

    final Path path = Path()
      ..moveTo(0, 15) // Bắt đầu từ góc trên bên trái
      ..lineTo(curvePosition - 40, 15) // Đến điểm bắt đầu đường cong
      ..quadraticBezierTo(
        curvePosition, -10, // Điểm kiểm soát
        curvePosition + 40, 15, // Điểm kết thúc đường cong
      )
      ..lineTo(width, 15) // Đến điểm cuối bên phải
      ..lineTo(width, height) // Xuống góc dưới bên phải
      ..lineTo(0, height) // Qua góc dưới bên trái
      ..close(); // Đóng đường dẫn

    // Vẽ shadow
    canvas.drawShadow(path, Colors.black, 5, true);

    // Vẽ bottom bar
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BottomBarPainter oldDelegate) {
    return oldDelegate.fabPosition != fabPosition;
  }
}

class _BottomBarItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  _BottomBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

// Placeholder color
const Color appGreenColor = Color(0xFF4CAF50);
