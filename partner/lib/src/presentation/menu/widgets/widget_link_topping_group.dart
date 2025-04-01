import 'package:app/src/base/bloc.dart';
import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:network_resources/store/models/menu.dart';
import 'package:network_resources/store/repo.dart';
import 'package:app/src/presentation/widgets/widget_loading_wrapper.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';

class WidgetLinkToppingGroup extends StatefulWidget {
  const WidgetLinkToppingGroup({
    super.key,
    required this.initList,
  });

  final List<int>? initList;

  @override
  State<WidgetLinkToppingGroup> createState() => _WidgetLinkToppingGroupState();
}

class _WidgetLinkToppingGroupState
    extends BaseLoadingState<WidgetLinkToppingGroup> {
  late List<int> selectedIds = [...widget.initList ?? []];
  List<MenuModel>? _allToppingGroups;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setLoading(true);
    try {
      final result = await StoreRepo().getStoreMenus({
        "store_id": authCubit.storeId,
        "type": 2,
      });
      if (result.isSuccess) {
        _allToppingGroups = result.data;
        _isLoading = false;
        if (mounted) {
          setState(() {});
        }
      } else {
        _allToppingGroups = [];
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _allToppingGroups = [];
          _isLoading = false;
        });
      }
    }
    setLoading(false);
  }

  List<MenuModel> get _linkedToppingGroups {
    if (_allToppingGroups == null) return [];
    return _allToppingGroups!
        .where((group) => selectedIds.contains(group.id))
        .toList();
  }

  List<MenuModel> get _unlinkedToppingGroups {
    if (_allToppingGroups == null) return [];
    return _allToppingGroups!
        .where((group) => !selectedIds.contains(group.id))
        .toList();
  }

  @override
  Widget buildContent(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          'Link Topping Groups'.tr(),
          style: w500TextStyle(fontSize: 20.sw, height: 1.2),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: appColorText),
        actions: [
          TextButton(
            onPressed: () {
              appHaptic();
              context.pop(_linkedToppingGroups);
            },
            child: Text(
              'Save'.tr(),
              style: w400TextStyle(fontSize: 16.sw, color: appColorPrimary),
            ),
          ),
          Gap(4.sw),
        ],
      ),
      body: _isLoading ? _buildShimmerList() : _buildToppingGroupList(),
    );
  }

  Widget _buildShimmerList() {
    return ListView.separated(
      padding: EdgeInsets.all(16.sw),
      itemCount: 5,
      separatorBuilder: (context, index) => const AppDivider(),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 12.sw),
          child: Row(
            children: [
              WidgetAppShimmer(
                child: Container(
                  width: 24.sw,
                  height: 24.sw,
                  color: Colors.white,
                ),
              ),
              Gap(12.sw),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetAppShimmer(
                      child: Container(
                        width: 120.sw,
                        height: 16.sw,
                        color: Colors.white,
                      ),
                    ),
                    Gap(4.sw),
                    WidgetAppShimmer(
                      child: Container(
                        width: 80.sw,
                        height: 14.sw,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildToppingGroupList() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.sw),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_linkedToppingGroups.isNotEmpty) ...[
            Text(
              'Linked'.tr(),
              style: w500TextStyle(fontSize: 16.sw),
            ),
            Gap(8.sw),
            _buildToppingGroupSection(_linkedToppingGroups),
            Gap(8.sw),
          ],
          Text(
            'Not Linked'.tr(),
            style: w500TextStyle(fontSize: 16.sw),
          ),
          Gap(8.sw),
          _buildToppingGroupSection(_unlinkedToppingGroups),
        ],
      ),
    );
  }

  Widget _buildToppingGroupSection(List<MenuModel> groups) {
    if (groups.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.sw),
        child: Center(
          child: Text(
            'No topping groups'.tr(),
            style: w400TextStyle(color: grey1),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groups.length,
      separatorBuilder: (_, __) => const AppDivider(),
      itemBuilder: (context, index) {
        final group = groups[index];
        final bool isSelected = selectedIds.contains(group.id);

        return WidgetRippleButton(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedIds.remove(group.id);
              } else {
                selectedIds.add(group.id!);
              }
            });
          },
          radius: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.sw),
            child: Row(
              children: [
                WidgetAppSVG(isSelected ? 'check-box' : 'uncheck-box'),
                Gap(12.sw),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name ?? '',
                        style: w400TextStyle(fontSize: 16.sw),
                      ),
                      if (group.toppings != null && group.toppings!.isNotEmpty)
                        Text(
                          group.toppings!.map((e) => e.name ?? "").join(', '),
                          style: w400TextStyle(color: grey1),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
