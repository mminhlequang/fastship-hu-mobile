import 'package:app/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class WidgetAppTabBar extends StatelessWidget {
  const WidgetAppTabBar({
    super.key,
    required this.tabController,
    required this.tabs,
    required this.children,
  });

  final TabController tabController;
  final List<String> tabs;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 36.sw,
          color: Colors.white,
          child: TabBar(
            controller: tabController,
            tabs: tabs.map((e) => Tab(child: Text(e))).toList(),
            indicatorPadding: EdgeInsets.symmetric(horizontal: 16.sw),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: children,
          ),
        )
      ],
    );
  }
}
