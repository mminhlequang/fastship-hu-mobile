import 'package:app/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';

class WidgetCategoryCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final bool isSelected;
  final Function()? onTap;

  // Constructor cho widget category card
  const WidgetCategoryCard({
    super.key,
    required this.title,
    required this.imageUrl,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 16.sw),
        width: 84.sw,
        height: 12.sw + 50.sw + 3.sw + 12.sw * 1.2 * 2 + 5,
        decoration: isSelected
            ? BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: appColorPrimary,
                    blurRadius: 0,
                    spreadRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
                color: Colors.white,
                border: Border.all(
                  width: .5,
                  color: appColorPrimary,
                ),
                borderRadius: BorderRadius.circular(12.sw),
              )
            : BoxDecoration(),
        padding: EdgeInsets.symmetric(horizontal: 6.sw, vertical: 6.sw),
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
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: w500TextStyle(fontSize: 12.sw),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class WidgetCategoryCardShimmer extends StatelessWidget {
  const WidgetCategoryCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84.sw,
      margin: EdgeInsets.only(right: 16.sw),
      padding: EdgeInsets.symmetric(horizontal: 6.sw, vertical: 6.sw),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            Container(
              width: 80.sw,
              height: 80.sw,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.sw),
              ),
            ),
            SizedBox(height: 8.sw),
            Container(
              width: 60.sw,
              height: 12.sw,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.sw),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
