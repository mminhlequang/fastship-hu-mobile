import 'package:app/src/constants/constants.dart';
import 'package:network_resources/service/models/models.dart';
import 'package:network_resources/service/repo.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/setup/app_textstyles.dart';
import 'package:internal_core/setup/app_utils.dart';
import 'package:internal_core/widgets/widgets.dart';

class WidgetBusinessType extends StatefulWidget {
  final List<int>? initialData;
  const WidgetBusinessType({super.key, this.initialData});

  @override
  State<WidgetBusinessType> createState() => _WidgetBusinessTypeState();
}

class _WidgetBusinessTypeState extends State<WidgetBusinessType> {
  late List<int> selectedIds = widget.initialData ?? [];
  List<ServiceModel>? _types;
  @override
  initState() {
    super.initState();
    _fetchTypes();
  }

  Future<void> _fetchTypes() async {
    final result = await ServiceRepo().getServices({
      'support_service_id': serviceTypeFoodDelivery,
    });
    if (result.isSuccess) {
      if (mounted) {
        setState(() {
          _types = result.data;
        });
      }
    } else {
      _types = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Service types'.tr(),
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
            child: _types == null ? _buildShimmerList() : _buildServiceList(),
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
      itemCount: _types?.length ?? 0,
      separatorBuilder: (context, index) => AppDivider(
        padding: EdgeInsets.symmetric(horizontal: 16.sw),
      ),
      itemBuilder: (context, index) {
        final serviceModel = _types![index];
        bool isSelected = selectedIds.contains(serviceModel.id);

        return WidgetRippleButton(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedIds.removeWhere((id) => id == serviceModel.id);
              } else {
                selectedIds.add(serviceModel.id!);
              }
            });
          },
          color: Colors.white,
          radius: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 11.sw),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  serviceModel.name ?? '',
                  style: w400TextStyle(),
                ),
                WidgetAppSVG(isSelected ? 'check-box' : 'uncheck-box'),
              ],
            ),
          ),
        );
      },
    );
  }
}
