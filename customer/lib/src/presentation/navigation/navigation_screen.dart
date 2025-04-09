import 'package:app/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_core/internal_core.dart';
import 'package:internal_core/widgets/widgets.dart';

import '../cart/cubit/cart_cubit.dart';
import '../home/home_screen.dart';
import '../cart/cart_screen.dart';
import '../notifications/cubit/notification_cubit.dart';
import '../orders/orders_screen.dart';
import '../account/account_screen.dart';
import '../restaurants/restaurants_screen.dart';
import 'cubit/navigation_cubit.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  @override
  void initState() {
    cartCubit.fetchCarts();
    notificationCubit.fetchNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      bloc: navigationCubit,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: appColorBackground,
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildScreen(state.currentIndex),
              ),
              _CustomBottomBar(
                currentIndex: navigationCubit.state.currentIndex,
                onTap: (index) => navigationCubit.changeIndex(index),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return HomeScreen(key: ValueKey('home'));
      case 1:
        return RestaurantsScreen(key: ValueKey('food'));
      case 2:
        return CartScreen(key: ValueKey('cart'));
      case 3:
        return OrdersScreen(key: ValueKey('orders'));
      case 4:
        return AccountScreen(key: ValueKey('account'));
      default:
        return HomeScreen(key: ValueKey('home'));
    }
  }
}

class _CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const _CustomBottomBar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    double width = (context.width - 12.sw * 2 - 12.sw * 4) / 5;
    return ClipShadowPath(
      clipper: _CustomClipPath(currentIndex: currentIndex, itemWidth: width),
      shadow: Shadow(
          blurRadius: 8,
          color: Colors.black.withOpacity(.035),
          offset: Offset(0, -8)),
      child: Container(
        color: appColorBackground,
        padding: EdgeInsets.fromLTRB(12.sw, 16.sw + 32.sw, 12.sw,
            8.sw + context.mediaQueryPadding.bottom),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              top: -(width / 2),
              left: width * currentIndex + 12.sw * (currentIndex),
              child: PhysicalModel(
                shape: BoxShape.circle,
                color: appColorPrimary,
                elevation: 12.0,
                shadowColor: Colors.black26,
                child: CircleAvatar(
                  radius: width / 2,
                  backgroundColor: appColorPrimary,
                ),
              ),
            ),
            Row(
              spacing: 12.sw,
              children: [
                _buildItem(0, 'icon_home'),
                _buildItem(1, 'icon_food'),
                _buildItem(2, 'icon_cart'),
                _buildItem(3, 'icon_programming'),
                _buildItem(4, 'icon_account'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(int index, String icon) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          appHaptic();
          onTap(index);
        },
        child: SizedBox(
          height: 48.sw,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                top: currentIndex == index ? -27.sw : 0,
                child: Container(
                  height: 48.sw,
                  color: Colors.transparent,
                  child: Center(
                    child: WidgetAppSVG(
                      icon,
                      color:
                          currentIndex == index ? Colors.white : appColorText,
                      width: currentIndex == index ? 28.sw : 24.sw,
                      height: currentIndex == index ? 28.sw : 24.sw,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomClipPath extends CustomClipper<Path> {
  final int currentIndex;
  final double itemWidth;

  _CustomClipPath({required this.currentIndex, required this.itemWidth});

  @override
  Path getClip(Size size) {
    // Tạo đường cắt cho bottom bar
    final path = Path();

    // Kích thước của bottom bar
    final width = size.width;
    final height = size.height;

    // Tính toán vị trí của tab hiện tại
    final horizontalPadding = 12.sw;
    final spaceBetweenItems = 12.sw;
    final totalWidth = width - (horizontalPadding * 2);
    final singleItemWidth = (totalWidth - spaceBetweenItems * 4) / 5;

    // Vị trí trung tâm của vòng cong
    final centerX = horizontalPadding +
        (singleItemWidth / 2) +
        (currentIndex * (singleItemWidth + spaceBetweenItems));

    // Độ cao của vòng cong
    final curveHeight = 31.sw;

    // Bán kính của vòng cong
    final curveRadius = itemWidth;

    // Điểm bắt đầu
    path.moveTo(0, curveHeight);

    // Vẽ đến điểm bắt đầu của đường cong (bên trái)
    path.lineTo(centerX - curveRadius * 1.15, curveHeight);

    // Vẽ nửa đầu của đường cong (bên trái lên trên)
    path.cubicTo(
        centerX - curveRadius * .75,
        curveHeight, // điểm điều khiển 1
        centerX - curveRadius * 0.5,
        0, // điểm điều khiển 2
        centerX,
        0 // điểm đích
        );

    // Vẽ nửa sau của đường cong (từ trên xuống bên phải)
    path.cubicTo(
        centerX + curveRadius * 0.5,
        0, // điểm điều khiển 1
        centerX + curveRadius * 0.75,
        curveHeight, // điểm điều khiển 2
        centerX + curveRadius * 1.15,
        curveHeight // điểm đích
        );

    // Vẽ phần còn lại bên phải
    path.lineTo(width, curveHeight);

    // Vẽ cạnh bên phải xuống dưới
    path.lineTo(width, height);

    // Vẽ cạnh dưới từ phải sang trái
    path.lineTo(0, height);

    // Vẽ cạnh trái từ dưới lên
    path.lineTo(0, curveHeight);

    // Đóng đường dẫn
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // Cần cập nhật lại khi currentIndex thay đổi
    // return oldClipper is _CustomClipPath &&
    //     oldClipper.currentIndex != currentIndex;
    return true;
  }
}

@immutable
class ClipShadowPath extends StatelessWidget {
  final Shadow shadow;
  final CustomClipper<Path> clipper;
  final Widget child;

  ClipShadowPath({
    required this.shadow,
    required this.clipper,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ClipShadowShadowPainter(
        clipper: this.clipper,
        shadow: this.shadow,
      ),
      child: ClipPath(child: child, clipper: this.clipper),
    );
  }
}

class _ClipShadowShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
