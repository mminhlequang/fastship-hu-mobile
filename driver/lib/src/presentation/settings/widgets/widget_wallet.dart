import 'package:app/src/base/auth/auth_cubit.dart';
import 'package:app/src/constants/constants.dart';
import 'package:app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';
import 'package:intl/intl.dart';

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
            BlocBuilder<AuthCubit, AuthState>(
              bloc: authCubit,
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Balance: ${NumberFormat.currency(
                        symbol: AppPrefs.instance.currencySymbol,
                        decimalDigits: 2,
                      ).format(state.wallet?.availableBalance ?? 0)}",
                      style:
                          w700TextStyle(fontSize: 24.sw, color: Colors.white),
                    ),
                    Gap(8.sw),
                    Text(
                      'Frozen: ${NumberFormat.currency(
                        symbol: AppPrefs.instance.currencySymbol,
                        decimalDigits: 2,
                      ).format(state.wallet?.frozenBalance ?? 0)}',
                      style:
                          w400TextStyle(fontSize: 12.sw, color: Colors.white),
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
