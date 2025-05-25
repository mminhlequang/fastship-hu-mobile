import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:internal_core/internal_core.dart';

class WidgetAppTabBar extends StatelessWidget {
  const WidgetAppTabBar({
    super.key,
    required this.tabController,
    this.tabs = const [],
    this.tabColors = const [],
    this.tabWidgets,
    this.body,
    this.children = const [],
    this.physics,
    this.onTap,
    this.count,
    this.isScrollable = false,
    this.tabAlignment,
  });

  final TabController tabController;
  final List<String> tabs;
  final List<Color>? tabColors;
  final List<Widget>? tabWidgets;
  final Widget? body;
  final List<Widget> children;
  final ScrollPhysics? physics;
  final Function(int index)? onTap;
  final int? count;
  final bool isScrollable;
  final TabAlignment? tabAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 36.sw,
          color: Colors.white,
          child: TabBar(
            controller: tabController,
            isScrollable: isScrollable,
            tabs: tabWidgets ??
                tabs
                    .mapIndexed((index, e) => Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                e,
                                style: w400TextStyle(
                                    fontSize: 14.sw,
                                    color: tabColors?.isNotEmpty == true
                                        ? tabColors![index]
                                        : appColorText),
                              ),
                              if (count != null)
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
                                        '$count',
                                        style: w400TextStyle(
                                            fontSize: 10.sw,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ))
                    .toList(),
            indicatorPadding: EdgeInsets.symmetric(horizontal: 16.sw),
            tabAlignment: tabAlignment,
            onTap: onTap?.call,
          ),
        ),
        Expanded(
          child: body ??
              TabBarView(
                controller: tabController,
                physics: physics,
                children: children,
              ),
        )
      ],
    );
  }
}
