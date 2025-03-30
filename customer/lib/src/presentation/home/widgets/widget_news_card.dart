import 'package:app/src/constants/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';

class WidgetNewsCard extends StatelessWidget {
  final String imageUrl;
  final String date;
  final String title;

  const WidgetNewsCard({
    Key? key,
    required this.imageUrl,
    required this.date,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 287.sw,
      height: 239.sw,
      padding: EdgeInsets.all(12.sw),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EFE9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: WidgetAppImage(
              imageUrl: imageUrl,
              width: double.infinity,
              height: 145,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Blog'.tr(),
                style: w400TextStyle(
                  fontSize: 12.sw,
                  color: const Color(0xFF939191),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 1,
                height: 11,
                color: const Color(0xFFD0D0D0),
              ),
              const SizedBox(width: 8),
              Text(
                string2DateTime(date)!.formatDate(),
                style: w400TextStyle(
                  fontSize: 12.sw,
                  color: hexColor('#F17228'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: w400TextStyle(
              fontSize: 14.sw,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
