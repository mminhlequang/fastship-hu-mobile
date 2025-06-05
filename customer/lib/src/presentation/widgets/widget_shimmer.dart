import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';
import 'package:app/src/utils/utils.dart';

class WidgetShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final EdgeInsets? margin;

  const WidgetShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class WidgetShimmerOrderDetail extends StatelessWidget {
  const WidgetShimmerOrderDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order header shimmer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: hexColor('#F9F8F6'),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const WidgetShimmer(width: 80, height: 14),
                      const WidgetShimmer(width: 100, height: 14),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const WidgetShimmer(width: 80, height: 14),
                      const WidgetShimmer(width: 120, height: 14),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const WidgetShimmer(width: 60, height: 14),
                      const WidgetShimmer(width: 80, height: 24),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Delivery info shimmer
            const WidgetShimmer(width: 160, height: 20),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: hexColor('#F9F8F6'),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const WidgetShimmer(width: 100, height: 20),
                  const SizedBox(height: 8),
                  const WidgetShimmer(width: 200, height: 14),
                  const SizedBox(height: 8),
                  const WidgetShimmer(width: 150, height: 14),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Order items shimmer
            const WidgetShimmer(width: 120, height: 20),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFCEC6C5), width: 0.8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        const WidgetShimmer(
                            width: 34, height: 34, borderRadius: 12),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Row(
                            children: [
                              const WidgetShimmer(
                                  width: 44, height: 44, borderRadius: 8),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const WidgetShimmer(width: 120, height: 14),
                                    const SizedBox(height: 4),
                                    const WidgetShimmer(width: 80, height: 14),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Order summary shimmer
            const WidgetShimmer(width: 140, height: 20),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFCEC6C5), width: 0.8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      WidgetShimmer(width: 80, height: 14),
                      WidgetShimmer(width: 100, height: 14),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      WidgetShimmer(width: 100, height: 14),
                      WidgetShimmer(width: 100, height: 14),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Color(0xFFCEC6C5)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      WidgetShimmer(width: 60, height: 18),
                      WidgetShimmer(width: 120, height: 18),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
