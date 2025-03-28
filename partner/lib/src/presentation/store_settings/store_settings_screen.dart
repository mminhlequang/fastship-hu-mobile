import 'package:app/src/base/bloc.dart';
import 'package:app/src/constants/constants.dart';
import 'package:app/src/network_resources/models/opening_time_model.dart';
import 'package:app/src/network_resources/store/repo.dart';
import 'package:app/src/presentation/widgets/widget_app_divider.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/setup/app_textstyles.dart';
import 'package:internal_core/widgets/widgets.dart';

class StoreSettingsScreen extends StatefulWidget {
  const StoreSettingsScreen({super.key});

  @override
  State<StoreSettingsScreen> createState() => _StoreSettingsScreenState();
}

class _StoreSettingsScreenState extends State<StoreSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Store settings'.tr())),
      body: ColoredBox(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            WidgetRippleButton(
              onTap: () => appContext.pushNamed('information'),
              radius: 0,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Information'.tr(),
                      style: w400TextStyle(fontSize: 16.sw),
                    ),
                    const WidgetAppSVG('chevron-right'),
                  ],
                ),
              ),
            ),
            AppDivider(
              color: grey8,
              padding: EdgeInsets.symmetric(horizontal: 16.sw),
            ),
            WidgetRippleButton(
              onTap: () async {
                final r = await appContext.push('/opening-time',
                        extra: OpeningTimeModel.fromListOperatingHours(
                            authCubit.state.store!.operatingHours ?? [])) ??
                    [];
                if (r is List<int>) {
                  StoreRepo().updateStore({
                    "id": authCubit.state.store!.id!,
                    "opening_hours": r
                  }).then((v) {
                    if (v.isSuccess) {
                      authCubit.refreshStore();
                      appShowSnackBar(
                        context: context,
                        msg: "Opening hours updated successfully!".tr(),
                        type: AppSnackBarType.success,
                      );
                    } else {
                      appShowSnackBar(
                          context: context,
                          msg:
                              "Failed to update opening hours, please try again later!"
                                  .tr());
                    }
                  });
                }
              },
              radius: 0,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Opening hours'.tr(),
                      style: w400TextStyle(fontSize: 16.sw),
                    ),
                    const WidgetAppSVG('chevron-right'),
                  ],
                ),
              ),
            ),
            WidgetRippleButton(
              onTap: () async {  
                final r =
                    await appContext.push('/store-category', extra: authCubit.state.store?.categories
                        ?.map((e) => e.id!)
                        .toList() ?? []);
                if (r is List<int>) {
                  StoreRepo().updateStore({
                    "id": authCubit.state.store!.id!,
                    "category_ids": r
                  }).then((v) {
                    if (v.isSuccess) {
                      appShowSnackBar(
                        context: context,
                        msg: "Store categories updated successfully!".tr(),
                        type: AppSnackBarType.success,
                      );
                      authCubit.refreshStore();
                    } else {
                      appShowSnackBar(
                          context: context,
                          msg:
                              "Failed to update store info, please try again later!"
                                  .tr());
                    }
                  });
                }
              },
              radius: 0,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Store categories'.tr(),
                      style: w400TextStyle(fontSize: 16.sw),
                    ),
                    const WidgetAppSVG('chevron-right'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
