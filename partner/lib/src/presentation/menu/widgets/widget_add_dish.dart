import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internal_core/internal_core.dart';

class WidgetAddDish extends StatefulWidget {
  const WidgetAddDish({super.key, this.dish});

  final String? dish;

  @override
  State<WidgetAddDish> createState() => _WidgetAddDishState();
}

class _WidgetAddDishState extends State<WidgetAddDish> {
  String? get _dish => widget.dish;
  XFile? _dishImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _folderController = TextEditingController();
  final TextEditingController _describeController = TextEditingController();
  final ValueNotifier<bool> _status = ValueNotifier(true);
  bool enableSave = true;

  @override
  void initState() {
    super.initState();
    _nameController.text = _dish ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _folderController.dispose();
    _describeController.dispose();
    _status.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_dish ?? 'Add dish'.tr())),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(16.sw),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppUploadImage(
                          title: 'Dish image'.tr(),
                          subTitle: Gap(8.sw),
                          onPickImage: (image) {
                            // Todo:
                            setState(() {
                              _dishImage = XFile(image.path);
                            });
                          },
                        ),
                        Gap(24.sw),
                        AppTextField(
                          controller: _nameController,
                          title: 'Name'.tr(),
                          hintText: 'Enter name'.tr(),
                        ),
                        Gap(24.sw),
                        AppTextField(
                          controller: _priceController,
                          title: 'Price'.tr(),
                          hintText: 'Enter price'.tr(),
                          keyboardType: TextInputType.number,
                        ),
                        Gap(24.sw),
                        AppTextField(
                          controller: _folderController,
                          title: 'Folder'.tr(),
                          hintText: 'Enter folder'.tr(),
                        ),
                        Gap(24.sw),
                        AppTextField(
                          controller: _describeController,
                          title: 'Describe'.tr(),
                          hintText: 'Enter describe'.tr(),
                          minLines: 3,
                        ),
                      ],
                    ),
                  ),
                  Gap(5.sw),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Status'.tr(),
                          style: w400TextStyle(),
                        ),
                        AdvancedSwitch(
                          controller: _status,
                          initialValue: true,
                          height: 22.sw,
                          width: 40.sw,
                          activeColor: appColorPrimary,
                          inactiveColor: hexColor('#E2E2EF'),
                          onChanged: (value) {
                            _status.value = value;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding:
                EdgeInsets.fromLTRB(16.sw, 10.sw, 16.sw, 10.sw + context.mediaQueryPadding.bottom),
            child: _dish == null
                ? WidgetRippleButton(
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
                  )
                : Row(
                    children: [
                      Expanded(
                        child: WidgetRippleButton(
                          onTap: () {
                            // Todo:
                          },
                          borderSide: BorderSide(color: appColorPrimary),
                          child: SizedBox(
                            height: 48.sw,
                            child: Center(
                              child: Text(
                                'Delete'.tr(),
                                style: w500TextStyle(fontSize: 16.sw, color: appColorPrimary),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Gap(10.sw),
                      Expanded(
                        child: WidgetRippleButton(
                          onTap: () {
                            // Todo:
                            appContext.pop();
                          },
                          color: appColorPrimary,
                          child: SizedBox(
                            height: 48.sw,
                            child: Center(
                              child: Text(
                                'Save'.tr(),
                                style: w500TextStyle(fontSize: 16.sw, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
