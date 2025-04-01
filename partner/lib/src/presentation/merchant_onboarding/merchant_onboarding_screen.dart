import 'package:app/src/base/bloc.dart';
import 'package:app/src/constants/constants.dart';
import 'package:network_resources/store/models/models.dart';
import 'package:app/src/presentation/widgets/widget_app_tabbar.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';

class MerchantOnboardingScreen extends StatefulWidget {
  const MerchantOnboardingScreen({super.key});

  @override
  State<MerchantOnboardingScreen> createState() =>
      _MerchantOnboardingScreenState();
}

class _MerchantOnboardingScreenState extends State<MerchantOnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2,
        vsync: this,
        initialIndex:
            authCubit.state.stores!.where((e) => e.active == 1).isNotEmpty
                ? 0
                : 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("    ${'Merchant Onboarding'.tr()}"),
        actions: [
          IconButton(
            onPressed: () {
              appHaptic();
              appContext.push('/store-registration');
            },
            icon: WidgetAppSVG('ic_add_circle'),
          ),
          Gap(4.sw),
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        bloc: authCubit,
        builder: (context, state) {
          if (state.stores?.isNotEmpty != true) {
            return Container(
              color: Colors.white,
              constraints: const BoxConstraints.expand(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const WidgetAppSVG('empty_store'),
                  Gap(16.sw),
                  Text(
                    'No stores available'.tr(),
                    style: w500TextStyle(fontSize: 18.sw),
                  ),
                  Gap(4.sw),
                  Text(
                    'Let\'s create your first store'.tr(),
                    style: w400TextStyle(color: grey1),
                  ),
                  Gap(12.sw),
                  WidgetRippleButton(
                    onTap: () => appContext.push('/store-registration'),
                    radius: 8.sw,
                    borderSide: BorderSide(color: appColorPrimary),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.sw, vertical: 8.sw),
                      child: Text(
                        'Create new store'.tr(),
                        style: w500TextStyle(color: appColorPrimary),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return WidgetAppTabBar(
            tabController: _tabController,
            tabs: ['My Store'.tr(), 'Store Register'.tr()],
            children: [
              _buildListStores(
                  state.stores!.where((e) => e.active == 1).toList()),
              _buildListStores(
                  state.stores!.where((e) => e.active == 0).toList(),
                  isNotActive: true)
            ],
          );
        },
      ),
    );
  }

  Widget _buildListStores(List<StoreModel> stores, {bool isNotActive = false}) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
      itemCount: stores.length,
      separatorBuilder: (context, index) => Gap(8.sw),
      itemBuilder: (context, index) {
        StoreModel store = stores[index];
        return WidgetRippleButton(
          onTap: () {
            appHaptic();

            if (isNotActive) {
              appShowSnackBar(
                msg:
                    "Your store is in review process, please wait for approval!"
                        .tr(),
                type: AppSnackBarType.notitfication,
              );
            } else {
              authCubit.setStore(store);
              appContext.pushReplacement('/navigation');
            }
          },
          radius: 8.sw,
          child: Padding(
            padding: EdgeInsets.all(8.sw),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    WidgetAppImage(
                      imageUrl: store.avatarImage ?? '',
                      height: 64.sw,
                      width: 64.sw,
                      radius: 4.sw,
                    ),
                    Positioned(
                      bottom: -2.sw,
                      right: -2.sw,
                      child: Container(
                        height: 12.sw,
                        width: 12.sw,
                        decoration: BoxDecoration(
                          color: isNotActive
                              ? Colors.deepOrange
                              : store.isOpen == 1
                                  ? appColorPrimary
                                  : grey1,
                          shape: BoxShape.circle,
                          border: Border.all(width: 2.sw, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(8.sw),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.name ?? 'Unnamed',
                        style: w600TextStyle(fontSize: 16.sw, color: grey10),
                      ),
                      Gap(4.sw),
                      Text(
                        store.address ?? 'Unknown address',
                        style: w400TextStyle(color: grey1),
                      ),
                      if (isNotActive) Gap(4.sw),
                      if (isNotActive)
                        Text(
                          'In review process'.tr(),
                          style: w400TextStyle(color: Colors.deepOrange),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
