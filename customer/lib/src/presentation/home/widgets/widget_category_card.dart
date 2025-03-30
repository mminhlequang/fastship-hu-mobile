import 'package:app/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';

class WidgetCategoryCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  // Constructor cho widget category card
  const WidgetCategoryCard({
    super.key,
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Column(
        children: [
          WidgetAppImage(
            imageUrl: imageUrl,
            width: 72.sw,
            height: 50.sw,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 3.sw),
          Text(
            title,
            style: w500TextStyle(fontSize: 12.sw),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}