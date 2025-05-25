import 'package:app/src/base/auth/auth_cubit.dart';
import 'package:app/src/constants/constants.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';
import 'package:intl/intl.dart';
import 'package:network_resources/network_resources.dart';

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
        padding: EdgeInsets.only(left: 16.sw, top: 16.sw, bottom: 12.sw),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.sw),
          image: DecorationImage(
            image: AssetImage(assetpng('wallet_background')),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BALANCE'.tr(),
              style: w400TextStyle(fontSize: 12.sw, color: Colors.white),
            ),
            Gap(4.sw),
            BlocBuilder<AuthCubit, AuthState>(
              bloc: authCubit,
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currencyFormatted(state.wallet?.availableBalance ?? 0),
                      style: w600TextStyle(fontSize: 24.sw, color: Colors.white),
                    ),
                    Gap(23.sw),
                    Text(
                      '${'PENDING'.tr()}: - ${currencyFormatted(state.wallet?.frozenBalance ?? 0)}',
                      style: w400TextStyle(color: Colors.white),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
