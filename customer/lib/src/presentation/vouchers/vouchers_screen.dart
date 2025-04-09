import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widget_appbar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:go_router/go_router.dart';
import 'package:network_resources/voucher/repo.dart';
import 'package:network_resources/voucher/models/models.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';

class VouchersScreen extends StatefulWidget {
  final int? storeId;
  const VouchersScreen({super.key, this.storeId});

  @override
  State<VouchersScreen> createState() => _VouchersScreenState();
}

class _VouchersScreenState extends State<VouchersScreen> {
  final TextEditingController _promoController = TextEditingController();

  List<VoucherModel>? vouchers;

  @override
  void initState() {
    super.initState();
    fetchVouchers();
  }

  Future<void> fetchVouchers() async {
    final response = await (widget.storeId == null
        ? VoucherRepo().getSavedVouchers({})
        : VoucherRepo().getVouchers({'store_id': widget.storeId}));
    setState(() {
      vouchers = response.data ?? [];
    });
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          WidgetAppBar(
            title: "Discount or promotion".tr(),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: hexColor('#F9F8F6'),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _promoController,
                              style: w400TextStyle(
                                fontSize: 16.sw,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter promo code'.tr(),
                                hintStyle: w400TextStyle(
                                  fontSize: 16.sw,
                                  color: hexColor('#847D79'),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14.sw,
                                  vertical: 12.sw,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hexColor('#F17228'),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Apply',
                            style: w500TextStyle(
                              fontSize: 16.sw,
                              height: 1,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(12),
                      padding: const EdgeInsets.all(16),
                      strokeWidth: 1,
                      dashPattern: const [8, 4],
                      color: const Color(0xFFCEC6C5),
                      child: vouchers == null
                          ? _buildShimmerState()
                          : ListView.separated(
                              padding: EdgeInsets.zero,
                              separatorBuilder: (context, index) => Container(
                                height: 1,
                                margin: EdgeInsets.symmetric(vertical: 16.sw),
                                width: context.width,
                                color: hexColor('#F1EFE9'),
                              ),
                              shrinkWrap: true,
                              itemCount: vouchers!.length,
                              itemBuilder: (context, index) => _WidgetItem(
                                voucher: vouchers![index],
                                onTap: () {
                                  appHaptic();
                                  if (vouchers![index].isValid == 1) {
                                    context.pop(vouchers![index]);
                                  }
                                },
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerState() {
    return ListView.separated(
      padding: EdgeInsets.zero,
      separatorBuilder: (context, index) => Container(
        height: 1,
        margin: EdgeInsets.symmetric(vertical: 16.sw),
        width: context.width,
        color: hexColor('#F1EFE9'),
      ),
      shrinkWrap: true,
      itemCount: 4,
      itemBuilder: (context, index) => _buildPromotionCardShimmer(),
    );
  }

  Widget _buildPromotionCardShimmer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WidgetAppShimmer(
          width: 70.sw,
          height: 70.sw,
          borderRadius: BorderRadius.circular(12),
        ),
        SizedBox(width: 12.sw),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WidgetAppShimmer(
                width: double.infinity,
                height: 24.sw,
              ),
              SizedBox(height: 4.sw),
              WidgetAppShimmer(
                width: double.infinity,
                height: 16.sw,
              ),
            ],
          ),
        ),
        SizedBox(width: 12.sw),
        WidgetAppShimmer(
          width: 42.sw,
          height: 42.sw,
          borderRadius: BorderRadius.circular(21),
        ),
      ],
    );
  }
}

class _WidgetItem extends StatelessWidget {
  final VoucherModel voucher;
  final VoidCallback onTap;

  const _WidgetItem({
    Key? key,
    required this.voucher,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 70.sw,
          height: 70.sw,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hexColor('#F8F1F0'),
              width: 1,
            ),
          ),
          child: WidgetAppImage(imageUrl: voucher.image ?? ''),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: w500TextStyle(
                    fontSize: 20.sw,
                    color: voucher.isValid == 1
                        ? hexColor('#091230')
                        : hexColor('#847D79'),
                  ),
                  children: [
                    TextSpan(text: voucher.name ?? ''),
                    TextSpan(
                      text: voucher.value.toString(),
                      style: w400TextStyle(
                        color: voucher.isValid == 1
                            ? appColorPrimary
                            : hexColor('#847D79'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                voucher.description ?? '',
                style: w400TextStyle(
                  fontSize: 14.sw,
                  color: hexColor('#847D79'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
