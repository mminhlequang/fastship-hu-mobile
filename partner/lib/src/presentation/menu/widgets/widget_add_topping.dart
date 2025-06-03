import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:network_resources/topping/models/models.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/utils.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/network_resources.dart';

class WidgetAddTopping extends StatefulWidget {
  const WidgetAddTopping({super.key, this.topping});

  final ToppingModel? topping;

  @override
  State<WidgetAddTopping> createState() => _WidgetAddToppingState();
}

class _WidgetAddToppingState extends State<WidgetAddTopping> {
  late ToppingModel? _topping = widget.topping;
  XFile? _xImage;
  String? _imageUrl;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();

  bool get enableSave =>
      (_xImage != null || _imageUrl != null) &&
      _nameController.text.isNotEmpty &&
      _priceController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _nameController.text = _topping?.name ?? '';
    _priceController.text = _topping?.price?.toString() ?? '';
    _imageUrl = _topping?.image != null && _topping?.isLocalImage != true
        ? _topping?.image
        : null;
    _xImage = _topping?.image != null && _topping?.isLocalImage == true
        ? XFile(_topping?.image ?? '')
        : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _nameFocusNode.dispose();
    _priceFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_topping?.name ?? 'Add topping'.tr())),
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
                  xFileImage: _xImage,
                  imageUrl: _imageUrl,
                  onPickImage: (image) {
                    setState(() {
                      _xImage = XFile(image.path);
                    });
                  },
                ),
                Gap(24.sw),
                AppTextField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  title: 'Name'.tr(),
                  hintText: 'Enter name'.tr(),
                  onChanged: (value) {
                    setState(() {});
                  },
                  onSubmitted: (_) {
                    _priceFocusNode.requestFocus();
                  },
                ),
                Gap(24.sw),
                AppTextField(
                  controller: _priceController,
                  focusNode: _priceFocusNode,
                  title: 'Price'.tr(),
                  hintText: 'Enter price'.tr(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {});
                  },
                  inputFormatters: [
                    currencyTextInputFormatter,
                  ],
                ),
              ],
            ),
          ),
          Gap(5.sw),
          const Spacer(),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(
                16.sw, 10.sw, 16.sw, 10.sw + context.mediaQueryPadding.bottom),
            child: _topping?.id == null
                ? WidgetRippleButton(
                    onTap: () {
                      appHaptic();
                      context.pop(
                        ToppingModel(
                          id: widget.topping?.id,
                          name: _nameController.text,
                          price: currencyFromEditController(_priceController),
                          image: _xImage?.path,
                          isLocalImage: true,
                        ),
                      );
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
                            appHaptic();
                            appContext.pop(-1);
                          },
                          borderSide: BorderSide(color: appColorPrimary),
                          child: SizedBox(
                            height: 48.sw,
                            child: Center(
                              child: Text(
                                'Delete'.tr(),
                                style: w500TextStyle(
                                    fontSize: 16.sw, color: appColorPrimary),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Gap(10.sw),
                      Expanded(
                        child: WidgetRippleButton(
                          enable: enableSave,
                          onTap: () {
                            appHaptic();
                            appContext.pop(
                              ToppingModel(
                                id: widget.topping?.id,
                                name: _nameController.text,
                                price: currencyFromEditController(
                                    _priceController),
                                image: _xImage?.path,
                                isLocalImage: true,
                              ),
                            );
                          },
                          color: appColorPrimary,
                          child: SizedBox(
                            height: 48.sw,
                            child: Center(
                              child: Text(
                                'Save'.tr(),
                                style: w500TextStyle(
                                    fontSize: 16.sw, color: Colors.white),
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
