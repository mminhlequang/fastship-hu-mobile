import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

class WidgetOrderShimmer extends StatelessWidget {
  const WidgetOrderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: EdgeInsets.all(12.sw),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 16.sw,
              width: 100.sw,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.sw),
              ),
            ),
            Gap(2.sw),
            Container(
              height: 12.sw,
              width: 200.sw,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.sw),
              ),
            ),
            Gap(16.sw),
            Container(
              height: 14.sw,
              width: 80.sw,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.sw),
              ),
            ),
            Gap(8.sw),
            Container(
              height: 1.sw,
              width: double.infinity,
              color: Colors.white,
            ),
            Gap(8.sw),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 14.sw,
                  width: 60.sw,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.sw),
                  ),
                ),
                Container(
                  height: 14.sw,
                  width: 100.sw,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.sw),
                  ),
                ),
              ],
            ),
            Gap(8.sw),
            Container(
              height: 1.sw,
              width: double.infinity,
              color: Colors.white,
            ),
            Gap(8.sw),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 14.sw,
                  width: 60.sw,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.sw),
                  ),
                ),
                Container(
                  height: 14.sw,
                  width: 60.sw,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.sw),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
