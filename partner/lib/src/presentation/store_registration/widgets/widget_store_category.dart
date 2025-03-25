import 'package:app/src/constants/constants.dart';
import 'package:app/src/network_resources/category/model/category.dart';
import 'package:app/src/network_resources/category/repo.dart';
import 'package:app/src/network_resources/service/models/models.dart';
import 'package:app/src/network_resources/service/repo.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/setup/app_textstyles.dart';
import 'package:internal_core/setup/app_utils.dart';
import 'package:internal_core/widgets/widgets.dart';

class WidgetStoreCategory extends StatefulWidget {
  final List<int>? initialData;
  const WidgetStoreCategory({super.key, this.initialData});

  @override
  State<WidgetStoreCategory> createState() => _WidgetStoreCategoryState();
}

class _WidgetStoreCategoryState extends State<WidgetStoreCategory> {
  late List<int> selectedIds = widget.initialData ?? [];
  List<CategoryModel>? _items;
  @override
  initState() {
    super.initState();
    _fetchTypes();
  }

  Future<void> _fetchTypes() async {
    final result = await CategoryRepo().getCategories();
    if (result != null) {
      if (mounted) {
        setState(() {
          _items = result;
        });
      }
    } else {
      _items = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Store categories'.tr(),
          style: w500TextStyle(fontSize: 20.sw, height: 1.2),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: appColorText),
        actions: [
          TextButton(
            onPressed: () {
              appHaptic();
              Navigator.pop(context, selectedIds);
            },
            child: Text(
              'Save'.tr(),
              style: w400TextStyle(fontSize: 16.sw, color: darkGreen),
            ),
          ),
          Gap(4.sw),
        ],
      ),
      body: Column(
        children: [
          const AppDivider(),
          Expanded(
            child: _items == null ? _buildShimmerList() : _buildServiceList(),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.separated(
      itemCount: 5,
      separatorBuilder: (context, index) => AppDivider(
        padding: EdgeInsets.symmetric(horizontal: 16.sw),
      ),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 11.sw),
          child: WidgetAppShimmer(
            child: Container(
              height: 20.sw,
              width: double.infinity,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildServiceList() {
    return ListView.separated(
      itemCount: _items?.length ?? 0,
      separatorBuilder: (context, index) => AppDivider(
        padding: EdgeInsets.symmetric(horizontal: 16.sw),
      ),
      itemBuilder: (context, index) {
        final m = _items![index];
        return _buildItem(m);
      },
    );
  }

  Widget _buildItem(CategoryModel m, {bool isChild = false}) {
    bool isSelected = selectedIds.contains(m.id);

    return Column(
      children: [
        WidgetRippleButton(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedIds.removeWhere((id) => id == m.id);
              } else {
                selectedIds.add(m.id!);
              }
            });
          },
          color: Colors.white,
          radius: 0,
          child: Padding(
            padding: isChild
                ? EdgeInsets.fromLTRB(4.sw, 8.sw, 16.sw, 8.sw)
                : EdgeInsets.symmetric(horizontal: 16.sw, vertical: 10.sw),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  m.name ?? '',
                  style: w400TextStyle(),
                ),
                WidgetAppSVG(isSelected ? 'check-box' : 'uncheck-box'),
              ],
            ),
          ),
        ),
        if (m.children != null)
          ...m.children!.map((e) => Padding(
                padding: EdgeInsets.fromLTRB(20.sw, 0, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 14.sw, right: 8.sw),
                      child: Icon(
                        Icons.circle,
                        size: 8.sw,
                        color: grey1,
                      ),
                    ),
                    Expanded(child: _buildItem(e, isChild: true)),
                  ],
                ),
              )),
      ],
    );
  }
}
