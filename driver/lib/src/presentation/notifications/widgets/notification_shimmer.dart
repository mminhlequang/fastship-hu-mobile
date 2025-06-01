import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:app/src/constants/constants.dart';

class NotificationShimmer extends StatelessWidget {
  const NotificationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.sw),
          topRight: Radius.circular(20.sw),
        ),
      ),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 16.sw),
        itemCount: 6,
        separatorBuilder: (context, index) => Gap(8.sw),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.sw),
              border: Border.all(
                color: grey8,
                width: 1.sw,
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Padding(
                padding: EdgeInsets.all(16.sw),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon placeholder
                    Container(
                      width: 48.sw,
                      height: 48.sw,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.sw),
                      ),
                    ),
                    Gap(12.sw),

                    // Content placeholder
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title placeholder
                          Container(
                            width: double.infinity,
                            height: 16.sw,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.sw),
                            ),
                          ),
                          Gap(8.sw),

                          // Content placeholder - 2 lines
                          Container(
                            width: double.infinity,
                            height: 14.sw,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.sw),
                            ),
                          ),
                          Gap(4.sw),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: 14.sw,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.sw),
                            ),
                          ),
                          Gap(8.sw),

                          // Time and badge row
                          Row(
                            children: [
                              Container(
                                width: 80.sw,
                                height: 12.sw,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.sw),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                width: 60.sw,
                                height: 20.sw,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.sw),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
