import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internal_core/internal_core.dart';

class WidgetAddTopping extends StatefulWidget {
  const WidgetAddTopping({super.key, this.topping});

  final String? topping;

  @override
  State<WidgetAddTopping> createState() => _WidgetAddToppingState();
}

class _WidgetAddToppingState extends State<WidgetAddTopping> {
  String? get _topping => widget.topping;
  XFile? _toppingImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool enableSave = true;

  @override
  void initState() {
    super.initState();
    _nameController.text = _topping ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_topping ?? 'Add topping'.tr())),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppUploadImage(
                  title: 'Topping image'.tr(),
                  subTitle: Gap(8.sw),
                  onPickImage: (image) {
                    // Todo:
                    setState(() {
                      _toppingImage = XFile(image.path);
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
              ],
            ),
          ),
          Gap(5.sw),
          WidgetRippleButton(
            onTap: () => appContext.push('/add-option'),
            radius: 0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.sw, 12.sw, 12.sw, 12.sw),
              child: Row(
                children: [
                  Text(
                    'Options'.tr(),
                    style: w400TextStyle(),
                  ),
                  const Spacer(),
                  Text(
                    'Optional, max 9 toppings',
                    style: w400TextStyle(fontSize: 12.sw, color: grey1),
                  ),
                  Gap(4.sw),
                  const WidgetAppSVG('chevron-right'),
                ],
              ),
            ),
          ),
          const Spacer(),
          Container(
            color: Colors.white,
            padding:
                EdgeInsets.fromLTRB(16.sw, 10.sw, 16.sw, 10.sw + context.mediaQueryPadding.bottom),
            child: _topping == null
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
