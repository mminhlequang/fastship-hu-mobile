import 'package:app/src/constants/constants.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_core/internal_core.dart';

class CheckoutTrackingScreen extends StatelessWidget {
  const CheckoutTrackingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildProgressIndicator(),
                    _buildDeliveryStatus(),
                    _buildAddressCard(),
                    _buildOrderSummary(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  appHaptic();
                  appContext.pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: WidgetAppSVG('icon40', width: 24, height: 24),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Processing',
                style: w400TextStyle(fontSize: 18.sw),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey[100],
                  color: appColorPrimaryOrange,
                ),
              ),
            ],
          ),
          Spacer(),
          TextButton(
            onPressed: () {
              appHaptic();
            },
            child: Text(
              'Cancel',
              style: w400TextStyle(
                fontSize: 16,
                color: const Color(0xFFF17228),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(color: hexColor('#F1EFE9')),
            top: BorderSide(color: hexColor('#F1EFE9'))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.sw),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildProgressIcon(
                  'icon51',
                  isActive: true,
                ),
                Container(
                  width: 60,
                  height: 2,
                  color: const Color(0xFFCEC6C5),
                ),
                _buildProgressIcon(
                  'icon54',
                  isActive: false,
                ),
                Container(
                  width: 60,
                  height: 2,
                  color: const Color(0xFFCEC6C5),
                ),
                _buildProgressIcon(
                  'icon55',
                  isActive: false,
                ),
                Container(
                  width: 60,
                  height: 2,
                  color: const Color(0xFFCEC6C5),
                ),
                _buildProgressIcon(
                  'icon61',
                  isActive: false,
                ),
              ],
            ),
          ),
          Text(
            'We will let you know when your order is shipped.'.tr(),
            style: w400TextStyle(fontSize: 16.sw, color: hexColor('#847D79')),
          ),
          Gap(10.sw),
        ],
      ),
    );
  }

  Widget _buildProgressIcon(String icon, {required bool isActive}) {
    return WidgetAppSVG(
      icon,
      width: 24.sw,
      height: 24.sw,
      color: isActive ? appColorPrimary : const Color(0xFFCEC6C5),
    );
  }

  Widget _buildDeliveryStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF74CA45),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Super fast',
                  style: GoogleFonts.fredoka(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '13:05 - 13:15',
                style: GoogleFonts.fredoka(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                  color: const Color(0xFF120F0F),
                ),
              ),
              Row(
                children: [
                  Text(
                    'On time',
                    style: GoogleFonts.fredoka(
                      fontSize: 14,
                      color: const Color(0xFF74CA45),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'The kitchen is preparing your order.',
                    style: GoogleFonts.fredoka(
                      fontSize: 14,
                      color: const Color(0xFF847D79),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // SvgPicture.asset('assets/cooking_animation.svg',
          //     width: 76, height: 73),
        ],
      ),
    );
  }

  Widget _buildAddressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF74CA45)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            _buildAddressRow(
              icon:
                  '''<svg width="25" height="24" viewBox="0 0 25 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <circle cx="12.5" cy="12" r="8.5" stroke="#F17228"/>
                <circle cx="12.5" cy="12" r="5" fill="#F17228"/>
              </svg>''',
              title: 'Kentucky Fried Chicken',
              address: '3831 Cedar Lane, Somerville, MA 02143',
            ),
            const SizedBox(height: 10),
            _buildAddressRow(
              icon: null,
              title: 'My home',
              address: '3831 Cedar Lane, Somerville, MA 02143',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressRow({
    String? icon,
    required String title,
    required String address,
  }) {
    return Row(
      children: [
        if (icon != null) ...[
          SvgPicture.string(icon),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.fredoka(
                  fontSize: 16,
                  color: const Color(0xFF120F0F),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                address,
                style: GoogleFonts.fredoka(
                  fontSize: 14,
                  color: const Color(0xFF3C3836),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFCEC6C5),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.network(
                'https://cdn.builder.io/api/v1/image/assets/TEMP/c6ed9a544f8bd419f8155b5ddbb37a120a29dde7',
                width: 23,
                height: 24,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 8),
              Text(
                'Kentucky Fried Chicken',
                style: GoogleFonts.fredoka(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const Divider(color: Color(0xFFF1EFE9)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal',
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    color: const Color(0xFF3C3836),
                  ),
                ),
                Text(
                  '\$ 12,00',
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF091230),
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF74CA45)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(120),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Order summary',
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    color: const Color(0xFF74CA45),
                  ),
                ),
                const SizedBox(width: 10),
                SvgPicture.string(
                  '''<svg width="25" height="24" viewBox="0 0 25 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M9.5 6L15.1464 11.6464C15.3417 11.8417 15.3417 12.1583 15.1464 12.3536L9.5 18" stroke="#74CA45" stroke-width="1.5" stroke-linecap="round"/>
                  </svg>''',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
