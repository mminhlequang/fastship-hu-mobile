import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';

class ActivityAreaScreen extends StatefulWidget {
  const ActivityAreaScreen({super.key});

  @override
  State<ActivityAreaScreen> createState() => _ActivityAreaScreenState();
}

class _ActivityAreaScreenState extends State<ActivityAreaScreen> {
  String? selectedArea;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Activity area'.tr())),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.sw),
            child: AppDropdown<String>(
              items: ['Area 1', 'Area 2', 'Area 3'],
              selectedItem: selectedArea,
              title: 'Area'.tr(),
              hintText: 'Select area'.tr(),
              onChanged: (value) {
                setState(() {
                  selectedArea = value;
                });
              },
            ),
          ),
          const Spacer(),
          Container(
            color: Colors.white,
            padding:
                EdgeInsets.fromLTRB(16.sw, 10.sw, 16.sw, 10.sw + context.mediaQueryPadding.bottom),
            child: WidgetRippleButton(
              onTap: () => appContext.push('/select-area'),
              radius: 10.sw,
              enable: selectedArea != null,
              color: appColorPrimary,
              child: SizedBox(
                height: 48.sw,
                child: Center(
                  child: Text(
                    'Continue'.tr(),
                    style: w500TextStyle(
                      fontSize: 16.sw,
                      color: selectedArea != null ? Colors.white : grey1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
