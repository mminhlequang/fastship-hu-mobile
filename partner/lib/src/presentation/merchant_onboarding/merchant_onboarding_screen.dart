import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widget_app_tabbar.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';

class MerchantOnboardingScreen extends StatefulWidget {
  const MerchantOnboardingScreen({super.key});

  @override
  State<MerchantOnboardingScreen> createState() => _MerchantOnboardingScreenState();
}

class _MerchantOnboardingScreenState extends State<MerchantOnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: Text('Merchant Onboarding'.tr()),
        actions: [
          IconButton(
            onPressed: () => appContext.push('/create-store'),
            icon: WidgetAppSVG('ic_add_circle'),
          ),
          Gap(4.sw),
        ],
      ),
      body: WidgetAppTabBar(
        tabController: _tabController,
        tabs: ['My Store'.tr(), 'Store Register'.tr()],
        children: [_myStore, _storeRegister],
      ),
    );
  }

  Widget get _myStore {
    bool isEmpty = false;
    if (isEmpty) {
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
              onTap: () => appContext.push('/create-store'),
              radius: 8.sw,
              borderSide: BorderSide(color: appColorPrimary),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.sw, vertical: 8.sw),
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
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
      itemCount: 2,
      separatorBuilder: (context, index) => Gap(8.sw),
      itemBuilder: (context, index) {
        return WidgetRippleButton(
          onTap: () => appContext.pushReplacement('/navigation'),
          radius: 8.sw,
          child: Padding(
            padding: EdgeInsets.all(8.sw),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    WidgetAppImage(
                      imageUrl:
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR1ESafVZL6sr_AUo1QYgGVF4S-eL2KlMhjZQ&s',
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
                          color: index == 0 ? appColorPrimary : grey1,
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
                        'Bánh cuốn Hồng Liên',
                        style: w600TextStyle(fontSize: 16.sw, color: grey10),
                      ),
                      Gap(4.sw),
                      Text(
                        '41 Quang Trung, Ward 3, Go Vap District, HCMC',
                        style: w400TextStyle(color: grey1),
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

  Widget get _storeRegister {
    return Column();
  }
}
