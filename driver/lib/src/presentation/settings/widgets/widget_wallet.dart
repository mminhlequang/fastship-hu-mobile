import 'package:app/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';

class WidgetWallet extends StatefulWidget {
  final VoidCallback onTap;
  const WidgetWallet({super.key, required this.onTap});

  @override
  State<WidgetWallet> createState() => _WidgetWalletState();
}

class _WidgetWalletState extends State<WidgetWallet> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.sw),
          image: DecorationImage(
            image: AssetImage(assetpng('wallet_background')),
            fit: BoxFit.cover,
          ),
        ),
        height: 115.sw,
        padding: EdgeInsets.only(top: 20.sw, left: 20.sw, right: 20.sw),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Wallet',
              style: w400TextStyle(fontSize: 16.sw, color: Colors.white),
            ),
            Gap(8.sw),
            Text(
              '\$2000',
              style: w700TextStyle(fontSize: 24.sw, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
