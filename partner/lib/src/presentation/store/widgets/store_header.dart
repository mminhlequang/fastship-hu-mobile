import 'package:flutter/material.dart';

class StoreHeader extends StatelessWidget {
  const StoreHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.green.shade50,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quản lý cửa hàng',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text('Thông tin cửa hàng và các sản phẩm')
        ],
      ),
    );
  }
}
