import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Add option'.tr())),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.sw),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextField(
                    controller: _categoryController,
                    title: 'Category'.tr(),
                    hintText: 'Enter category'.tr(),
                  ),
                  ...List.generate(
                    _optionControllers.length,
                    (index) {
                      return Padding(
                        padding: EdgeInsets.only(top: 24.sw),
                        child: AppTextField(
                          controller: _optionControllers[index],
                          title: '${'Option'.tr()} ${index + 1}',
                          hintText: 'Option'.tr(),
                        ),
                      );
                    },
                  ),
                  Gap(16.sw),
                  WidgetRippleButton(
                    onTap: () {
                      setState(() {
                        _optionControllers.add(TextEditingController());
                      });
                    },
                    radius: 8.sw,
                    borderSide: BorderSide(color: grey1),
                    child: SizedBox(
                      height: 35.sw,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WidgetAppSVG('ic_add', color: grey1),
                          Gap(4.sw),
                          Text(
                            'Add option'.tr(),
                            style: w500TextStyle(fontSize: 16.sw, color: grey1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const AppDivider(),
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
