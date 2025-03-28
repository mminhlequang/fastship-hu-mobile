import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_core/internal_core.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20.sw,
        0,
        20.sw,
        0 + context.mediaQueryPadding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTabItem(0, 'ic_home', 'Home'.tr()),
          _buildTabItem(1, 'ic_bell', 'Notification'.tr()),
          _buildTabItem(2, 'ic_orders', 'Orders'.tr()),
          _buildTabItem(3, 'ic_profile', 'Profile'.tr()),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String icon, String label) {
    bool isNotification = index == 1;
    bool isSelected = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Gap(10.sw),
            Stack(
              clipBehavior: Clip.none,
              children: [
                WidgetAppSVG(
                  icon,
                  width: 24.sw,
                  color: isSelected ? appColorPrimary : hexColor('#E1E1E1'),
                ),
                if (isNotification)
                  Positioned(
                    top: -5.sw,
                    right: -7.sw,
                    child: Container(
                      height: 15.sw,
                      padding: EdgeInsets.symmetric(horizontal: 4.sw),
                      decoration: BoxDecoration(
                        color: hexColor('#FF8832'),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Center(
                        child: Text(
                          '10',
                          style: GoogleFonts.roboto(
                            fontSize: 10.sw,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Gap(2.sw),
            Text(
              label,
              style: w500TextStyle(
                fontSize: 10.sw,
                color: isSelected ? darkGreen : grey9,
              ),
            ),
            Gap(10.sw),
          ],
        ),
      ),
    );
  }
}
