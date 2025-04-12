import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:app/src/constants/constants.dart';

class NotificationShimmer extends StatelessWidget {
  const NotificationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
      itemCount: 5,
      separatorBuilder: (context, index) => Gap(4.sw),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child:   Padding(
              padding: EdgeInsets.all(16.sw),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 20.sw,
                    color: Colors.white,
                  ),
                  Gap(8.sw),
                  Container(
                    width: double.infinity,
                    height: 40.sw,
                    color: Colors.white,
                  ),
                  Gap(8.sw),
                  Container(
                    width: 100.sw,
                    height: 14.sw,
                    color: Colors.white,
                  ),
                ],
              ),
             
          ),
        );
      },
    );
  }
}
