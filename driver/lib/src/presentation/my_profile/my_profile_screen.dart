import 'package:app/src/constants/constants.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';

import '../widgets/widgets.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  int? selectedReason;
  final TextEditingController reasonController =
      TextEditingController(text: 'Không muốn nữa');

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  List<String> reasons = [
    'Công việc không phù hợp',
    'Có công việc khác',
    'Chuyển sang chạy cho 1 dịch vụ giao hàng khác',
    'Bận việc cá nhân',
    'Không sắp xếp được thời gian',
    'Chuyển nơi sinh sống',
    'Khác',
  ];

  _onStopCooperation() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 300),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.sw, 4.sw, 6.sw, 4.sw),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'REQUEST TO STOP COOPERATION'.tr(),
                        style: w600TextStyle(fontSize: 16.sw, color: grey1),
                      ),
                      const CloseButton(),
                    ],
                  ),
                ),
                const AppDivider(),
                ...List.generate(
                  reasons.length,
                  (index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.sw),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 0.sw),
                            child: RadioListTile(
                              title: Text(
                                reasons[index],
                                style: w400TextStyle(fontSize: 16.sw),
                              ),
                              dense: true,
                              activeColor: appColorPrimary,
                              visualDensity: VisualDensity(horizontal: -4),
                              contentPadding: EdgeInsets.zero,
                              value: index,
                              groupValue: selectedReason,
                              onChanged: (value) {
                                setState(() {
                                  selectedReason = value;
                                });
                              },
                            ),
                          ),
                          if (index != reasons.length - 1) const AppDivider(),
                        ],
                      ),
                    );
                  },
                ),
                if (selectedReason == reasons.length - 1)
                  Padding(
                    padding: EdgeInsets.only(
                        left: 64.sw, right: 16.sw, bottom: 16.sw),
                    child: TextField(
                      controller: reasonController,
                      style: w400TextStyle(fontSize: 16.sw),
                      minLines: 3,
                      maxLines: 5,
                      decoration: InputDecoration(
                        isDense: true,
                        isCollapsed: true,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.sw, vertical: 8.sw),
                        filled: true,
                        fillColor: hexColor('#F4F4F6'),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                const AppDivider(),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.sw, 16.sw, 16.sw,
                      16.sw + context.mediaQueryPadding.bottom),
                  child: WidgetRippleButton(
                    onTap: selectedReason == null
                        ? null
                        : () {
                            // Todo:
                          },
                    color: selectedReason == null ? grey8 : appColorPrimary,
                    child: SizedBox(
                      height: 48.sw,
                      child: Center(
                        child: Text(
                          'Confirm'.tr(),
                          style: w500TextStyle(
                            fontSize: 16.sw,
                            color:
                                selectedReason == null ? grey1 : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Profile'.tr())),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Driver’s ID'.tr(),
                    style: w400TextStyle(fontSize: 16.sw),
                  ),
                  Text(
                    '98765432234',
                    style: w400TextStyle(color: grey9),
                  ),
                ],
              ),
            ),
            _divider,
            WidgetRippleButton(
              onTap: () {
                appContext.pushNamed('personal-info');
              },
              radius: 0,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Personal information'.tr(),
                      style: w400TextStyle(fontSize: 16.sw),
                    ),
                    WidgetAppSVG('chevron_right'),
                  ],
                ),
              ),
            ),
            _divider,
            WidgetRippleButton(
              onTap: () {
                // Todo:
              },
              radius: 0,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Services and contracts'.tr(),
                      style: w400TextStyle(fontSize: 16.sw),
                    ),
                    WidgetAppSVG('chevron_right'),
                  ],
                ),
              ),
            ),
            _divider,
            WidgetRippleButton(
              onTap: () {
                // Todo:
              },
              radius: 0,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tax'.tr(),
                      style: w400TextStyle(fontSize: 16.sw),
                    ),
                    WidgetAppSVG('chevron_right'),
                  ],
                ),
              ),
            ),
            _divider,
            WidgetRippleButton(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return WidgetConfirmDialog(
                      title: 'Stop cooperation'.tr(),
                      subTitle:
                          'Are you sure you want to stop cooperation with FastShip?'
                              .tr(),
                      onConfirm: _onStopCooperation,
                    );
                  },
                );
              },
              radius: 0,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
                child: Row(
                  children: [
                    Text(
                      'Stop cooperation'.tr(),
                      style: w400TextStyle(fontSize: 16.sw),
                    ),
                    const Spacer(),
                    Text(
                      'Pending'.tr(),
                      style: w400TextStyle(color: hexColor('#FFC148')),
                    ),
                    Gap(2.sw),
                    WidgetAppSVG('chevron_right'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _divider => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.sw),
        child: const AppDivider(),
      );
}
