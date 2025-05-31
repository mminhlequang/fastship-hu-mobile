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
      child: Container(
        padding: EdgeInsets.all(12.sw),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.sw),
          border: Border.all(color: grey8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header với order code và status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 16.sw,
                  width: 120.sw,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.sw),
                  ),
                ),
                Container(
                  height: 20.sw,
                  width: 60.sw,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.sw),
                  ),
                ),
              ],
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
            Gap(12.sw),

            // Customer info shimmer
            Row(
              children: [
                Container(
                  width: 16.sw,
                  height: 16.sw,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.sw),
                  ),
                ),
                Gap(6.sw),
                Container(
                  height: 13.sw,
                  width: 150.sw,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.sw),
                  ),
                ),
              ],
            ),
            Gap(8.sw),

            // Time info shimmer
            Row(
              children: [
                Container(
                  width: 16.sw,
                  height: 16.sw,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.sw),
                  ),
                ),
                Gap(6.sw),
                Container(
                  height: 13.sw,
                  width: 180.sw,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.sw),
                  ),
                ),
              ],
            ),
            Gap(8.sw),

            // Divider
            Container(
              height: 1.sw,
              width: double.infinity,
              color: Colors.white,
            ),
            Gap(8.sw),

            // Delivery type row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 14.sw,
                  width: 80.sw,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.sw),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 16.sw,
                      height: 16.sw,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.sw),
                      ),
                    ),
                    Gap(4.sw),
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
            Gap(8.sw),
            Container(
              height: 1.sw,
              width: double.infinity,
              color: Colors.white,
            ),
            Gap(8.sw),

            // Status row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 14.sw,
                  width: 100.sw,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.sw),
                  ),
                ),
                Container(
                  height: 14.sw,
                  width: 70.sw,
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

            // Items and price row
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
                  height: 16.sw,
                  width: 80.sw,
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
