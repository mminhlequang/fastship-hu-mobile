import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';
import 'package:internal_core/setup/app_textstyles.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetAppTabBar(
      tabController: _tabController,
      tabWidgets: List.generate(
        3,
        (index) => Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(index == 0
                  ? 'Order'.tr()
                  : index == 1
                      ? 'News'.tr()
                      : 'Promotion'.tr()),
              if (index == 0)
                Padding(
                  padding: EdgeInsets.only(left: 4.sw),
                  child: Container(
                    height: 13.sw,
                    width: 17.sw,
                    decoration: BoxDecoration(
                      color: appColorPrimary,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Center(
                      child: Text(
                        '12',
                        style: w400TextStyle(fontSize: 10.sw, color: Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      children: [_order, _news, _promotion],
    );
  }

  Widget get _order {
    bool isEmpty = false;
    return isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const WidgetAppSVG('ic_empty_order'),
              Gap(16.sw),
              Text(
                'There’s nothing here...yet'.tr(),
                style: w500TextStyle(fontSize: 18.sw),
              ),
              Gap(4.sw),
              Text(
                'We’ll let you know when we get news for you'.tr(),
                style: w400TextStyle(color: grey1),
              ),
            ],
          )
        : RefreshIndicator(
            onRefresh: () async {},
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
              itemCount: 3,
              separatorBuilder: (context, index) => Gap(8.sw),
              itemBuilder: (context, index) {
                return WidgetRippleButton(
                  onTap: () {
                    // Todo: go detail
                  },
                  radius: 12.sw,
                  child: Padding(
                    padding: EdgeInsets.all(12.sw),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetAppImage(
                          imageUrl:
                              'https://images.immediate.co.uk/production/volatile/sites/30/2020/08/flat-white-3402c4f.jpg',
                          height: 32.sw,
                          width: 32.sw,
                          radius: 4.sw,
                        ),
                        Gap(8.sw),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'New order',
                                style: w500TextStyle(),
                              ),
                              Gap(4.sw),
                              Text(
                                'You have a new order. ID: 987-4323234',
                                style: w400TextStyle(fontSize: 12.sw, color: grey10),
                              ),
                              Gap(4.sw),
                              Text(
                                '24/02/2025 11:11',
                                style: w400TextStyle(fontSize: 10.sw, color: grey1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }

  Widget get _news {
    bool isEmpty = true;
    return isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const WidgetAppSVG('ic_empty_order'),
              Gap(16.sw),
              Text(
                'There’s nothing here...yet'.tr(),
                style: w500TextStyle(fontSize: 18.sw),
              ),
              Gap(4.sw),
              Text(
                'We’ll let you know when we get news for you'.tr(),
                style: w400TextStyle(color: grey1),
              ),
            ],
          )
        : RefreshIndicator(
            onRefresh: () async {},
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
              itemCount: 3,
              separatorBuilder: (context, index) => Gap(8.sw),
              itemBuilder: (context, index) {
                return WidgetRippleButton(
                  onTap: () {
                    // Todo: go detail
                  },
                  radius: 12.sw,
                  child: Padding(
                    padding: EdgeInsets.all(12.sw),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetAppImage(
                          imageUrl:
                              'https://images.immediate.co.uk/production/volatile/sites/30/2020/08/flat-white-3402c4f.jpg',
                          height: 32.sw,
                          width: 32.sw,
                          radius: 4.sw,
                        ),
                        Gap(8.sw),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'New order',
                                style: w500TextStyle(),
                              ),
                              Gap(4.sw),
                              Text(
                                'You have a new order. ID: 987-4323234',
                                style: w400TextStyle(fontSize: 12.sw, color: grey10),
                              ),
                              Gap(4.sw),
                              Text(
                                '24/02/2025 11:11',
                                style: w400TextStyle(fontSize: 10.sw, color: grey1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }

  Widget get _promotion {
    bool isEmpty = false;
    return isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const WidgetAppSVG('ic_empty_order'),
              Gap(16.sw),
              Text(
                'There’s nothing here...yet'.tr(),
                style: w500TextStyle(fontSize: 18.sw),
              ),
              Gap(4.sw),
              Text(
                'We’ll let you know when we get news for you'.tr(),
                style: w400TextStyle(color: grey1),
              ),
            ],
          )
        : RefreshIndicator(
            onRefresh: () async {},
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
              itemCount: 3,
              separatorBuilder: (context, index) => Gap(8.sw),
              itemBuilder: (context, index) {
                return WidgetRippleButton(
                  onTap: () {
                    // Todo: go detail
                  },
                  radius: 12.sw,
                  child: Padding(
                    padding: EdgeInsets.all(12.sw),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetAppImage(
                          imageUrl:
                              'https://images.immediate.co.uk/production/volatile/sites/30/2020/08/flat-white-3402c4f.jpg',
                          height: 32.sw,
                          width: 32.sw,
                          radius: 4.sw,
                        ),
                        Gap(8.sw),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'New promotion',
                                style: w500TextStyle(),
                              ),
                              Gap(4.sw),
                              Text(
                                'You have a new order. ID: 987-4323234',
                                style: w400TextStyle(fontSize: 12.sw, color: grey10),
                              ),
                              Gap(4.sw),
                              Text(
                                '24/02/2025 11:11',
                                style: w400TextStyle(fontSize: 10.sw, color: grey1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }
}
