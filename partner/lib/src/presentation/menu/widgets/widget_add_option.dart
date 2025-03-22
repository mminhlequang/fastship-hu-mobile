import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/extensions/context_extension.dart';
import 'package:internal_core/setup/app_textstyles.dart';
import 'package:internal_core/widgets/widget_ripple_button.dart';

class WidgetAddOption extends StatefulWidget {
  const WidgetAddOption({super.key});

  @override
  State<WidgetAddOption> createState() => _WidgetAddOptionState();
}

class _WidgetAddOptionState extends State<WidgetAddOption> {
  bool enableSave = true;
  final TextEditingController _categoryController = TextEditingController();
  final List<TextEditingController> _optionControllers = [TextEditingController()];

  @override
  void dispose() {
    _categoryController.dispose();
    _optionControllers.map((e) => e.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add option'.tr())),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
            ),
          ),
          Container(
            color: Colors.white,
            padding:
                EdgeInsets.fromLTRB(16.sw, 10.sw, 16.sw, 10.sw + context.mediaQueryPadding.bottom),
            child: WidgetRippleButton(
              onTap: () {
                // Todo:
                appContext.pop();
              },
              enable: enableSave,
              color: appColorPrimary,
              child: SizedBox(
                height: 48.sw,
                child: Center(
                  child: Text(
                    'Save'.tr(),
                    style: w500TextStyle(
                      fontSize: 16.sw,
                      color: enableSave ? Colors.white : grey1,
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
