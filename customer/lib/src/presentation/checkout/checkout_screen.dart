import 'package:app/src/utils/utils.dart';
import 'package:flutter/material.dart';

class DeliveryTrackingScreen extends StatelessWidget {
  const DeliveryTrackingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          constraints: const BoxConstraints(maxWidth: 480),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _buildTopBar(),
              _buildTrackingSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '9:41',
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.4,
              letterSpacing: 0.2,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.arrow_back, size: 24),
              const SizedBox(width: 12),
              Text(
                'Delivered your order',
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  color: const Color(0xFF120F0F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(Icons.description_outlined, size: 24),
        _buildDashedDivider(),
        Image.network(
            'https://cdn.builder.io/api/v1/image/assets/TEMP/938c75e7b97da8d836b04b6b9c9b05f62815a3d4?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
            width: 24,
            height: 24,
            fit: BoxFit.contain),
        _buildDashedDivider(),
        Image.network(
            'https://cdn.builder.io/api/v1/image/assets/TEMP/a3fa55e531a32095342cdebe92882e189d205183?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
            width: 24,
            height: 24,
            fit: BoxFit.contain),
        _buildDashedDivider(),
        Image.network(
            'https://cdn.builder.io/api/v1/image/assets/TEMP/083d496a583fb8c120c34d603ec93b0df3d85333?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
            width: 24,
            height: 24,
            fit: BoxFit.contain),
      ],
    );
  }

  Widget _buildDashedDivider() {
    return Container(
      width: 60,
      height: 2,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFCEC6C5),
          width: 2,
          style: BorderStyle.none,
        ),
      ),
      child: CustomPaint(
        painter: DashedLinePainter(),
      ),
    );
  }

  Widget _buildTrackingSection() {
    return Stack(
      children: [
        Image.network(
          'https://cdn.builder.io/api/v1/image/assets/TEMP/ee678e0c63333a9271e1292312e1af8f7cfb54fb?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
          width: double.infinity,
          height:
              MediaQuery.of(appContext).size.width * 1.84, // Aspect ratio 0.544
          fit: BoxFit.cover,
        ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 147, 16, 54),
            child: Column(
              children: [
                _buildAnimatedCircles(),
                const Spacer(),
                _buildDriverSearchCard(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedCircles() {
    return Container(
      width: 177,
      height: 177,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF74CA45).withOpacity(0.2),
      ),
      child: Center(
        child: Container(
          width: 141,
          height: 141,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF74CA45).withOpacity(0.3),
          ),
          child: Center(
            child: Container(
              width: 111,
              height: 111,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF74CA45).withOpacity(0.5),
              ),
              child: Center(
                child: Image.network(
                  'https://cdn.builder.io/api/v1/image/assets/TEMP/0b88702e244dfb843417216af93f063c72469919?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                  width: 71,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDriverSearchCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF111111).withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(1000),
            child: Image.network(
              'https://cdn.builder.io/api/v1/image/assets/TEMP/8184abcc919445869d993fa7c03e4f51869fc74d?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
              width: 78,
              height: 78,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Finding you a nearby driver...',
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 20,
              fontWeight: FontWeight.w500,
              height: 1.2,
              color: const Color(0xFF120F0F),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'This may take a few seconds...',
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.4,
              letterSpacing: 0.16,
              color: const Color(0xFF847D79),
            ),
          ),
        ],
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCEC6C5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 5;
    const dashSpace = 3;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
