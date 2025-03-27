import 'package:app/src/base/bloc.dart';
import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/network_resources/models/opening_time_model.dart';
import 'package:app/src/network_resources/product/repo.dart';
import 'package:app/src/network_resources/store/models/menu.dart';
import 'package:app/src/presentation/widgets/widget_loading_wrapper.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:app/src/utils/utils.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internal_core/internal_core.dart';

class AddDishParams {
  final ProductModel? model;
  final List<int> categoryIds;

  AddDishParams({
    this.model,
    required this.categoryIds,
  });
}

class WidgetAddDish extends StatefulWidget {
  const WidgetAddDish({super.key, required this.params});

  final AddDishParams params;

  @override
  State<WidgetAddDish> createState() => _WidgetAddDishState();
}

class _WidgetAddDishState extends BaseLoadingState<WidgetAddDish> {
  XFile? _dishImage;
  String? _imageUrl;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _describeController = TextEditingController();
  final ValueNotifier<bool> _status = ValueNotifier(true);

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _describeFocusNode = FocusNode();

  List<OpeningTimeModel> _openTimes = OpeningTimeModel.getDefaultOpeningTimes();
  bool get enableSave =>
      (_dishImage != null || _imageUrl != null) &&
      _nameController.text.isNotEmpty &&
      _priceController.text.isNotEmpty &&
      _describeController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    if (widget.params.model != null) {
      final product = widget.params.model as ProductModel;
      _nameController.text = product.name ?? '';
      _priceController.text = product.price?.toString() ?? '';
      _describeController.text = product.description ?? '';
      _status.value = product.status == 1;
      _imageUrl = product.image;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _describeController.dispose();
    _status.dispose();
    _nameFocusNode.dispose();
    _priceFocusNode.dispose();
    _describeFocusNode.dispose();
    super.dispose();
  }

  _onPressedSave() async {
    setLoading(true);

    String? imageUrl;
    if (_dishImage != null) {
      final r = await ProductRepo().uploadImage(_dishImage!.path);
      if (r.isSuccess) {
        imageUrl = r.data;
      }
    }

    if (widget.params.model == null) {
      final r = await ProductRepo().createProduct({
        'name': _nameController.text,
        'price': currencyFromEditController(_priceController),
        'description': _describeController.text,
        'image': imageUrl,
        'store_id': authCubit.storeId,
        'category_ids': widget.params.categoryIds,
        "operating_hours": _openTimes
            .map((e) => {
                  "day": e.dayNumber,
                  "hours": [e.openTime, e.closeTime]
                })
            .toList()
      });
      if (r.isSuccess) {
        context.pop(r.data);
        appShowSnackBar(
          context: context,
          msg: 'Create product successfully!',
          type: AppSnackBarType.success,
        );
      } else {
        appShowSnackBar(
          context: context,
          msg: 'Create product failed!',
          type: AppSnackBarType.error,
        );
      }
    } else {
      final r = await ProductRepo().updateProduct({
        'id': widget.params.model!.id,
        'name': _nameController.text,
        'price': currencyFromEditController(_priceController),
        'description': _describeController.text,
        'image': imageUrl,
        'store_id': authCubit.storeId,
        'category_ids': widget.params.categoryIds,
        "operating_hours": _openTimes
            .map((e) => {
                  "day": e.dayNumber,
                  "hours": [e.openTime, e.closeTime]
                })
            .toList()
      });
      if (r.isSuccess) {
        context.pop(r.data);
        appShowSnackBar(
          context: context,
          msg: 'Update product successfully!',
          type: AppSnackBarType.success,
        );
      } else {
        appShowSnackBar(
          context: context,
          msg: 'Update product failed!',
          type: AppSnackBarType.error,
        );
      }
    }
    setLoading(false);
  }

  _onPressedDelete() async {
    setLoading(true);
    if (widget.params.model?.id != null) {
      await appOpenDialog(WidgetConfirmDialog(
          title: 'Delete product'.tr(),
          subTitle: 'Are you sure you want to delete this product?'.tr(),
          onConfirm: () async {
            final r =
                await ProductRepo().deleteProduct(widget.params.model!.id!);
            if (r.isSuccess) {
              context.pop(r.data);
              appShowSnackBar(
                context: context,
                msg: 'Delete product successfully!',
                type: AppSnackBarType.success,
              );
            } else {
              appShowSnackBar(
                context: context,
                msg: 'Delete product failed!',
                type: AppSnackBarType.error,
              );
            }
          }));
    }
    setLoading(false);
  }

  @override
  Widget buildContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add dish'.tr())),
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
                          xFileImage: _dishImage,
                          imageUrl: _imageUrl,
                          onPickImage: (image) {
                            setState(() {
                              _dishImage = image;
                              _imageUrl = null;
                            });
                          },
                        ),
                        Gap(24.sw),
                        AppTextField(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          title: 'Name'.tr(),
                          hintText: 'Enter name'.tr(),
                          onSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          onChanged: (value) {
                            setState(() {});
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
                            CurrencyTextInputFormatter.currency(
                              locale: 'en_EU',
                              symbol: AppPrefs.instance.currencySymbol,
                              enableNegative: false,
                              decimalDigits: 2,
                            ),
                          ],
                        ),
                        Gap(24.sw),
                        AppTextField(
                          controller: _describeController,
                          focusNode: _describeFocusNode,
                          title: 'Describe'.tr(),
                          hintText: 'Enter describe'.tr(),
                          minLines: 3,
                          onSubmitted: (_) {
                            FocusScope.of(context).unfocus();
                          },
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  Gap(5.sw),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.sw, vertical: 12.sw),
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
                  WidgetRippleButton(
                    onTap: () async {
                      final r = await appContext.push('/opening-time',
                              extra: _openTimes) ??
                          [];
                      if (r is List<OpeningTimeModel>) {
                        setState(() {
                          _openTimes = r;
                        });
                      }
                    },
                    radius: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.sw, vertical: 12.sw),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Opening hours'.tr(),
                            style: w400TextStyle(fontSize: 16.sw),
                          ),
                          const WidgetAppSVG('chevron-right'),
                        ],
                      ),
                    ),
                  ),
                  Gap(24.sw),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(
                16.sw, 10.sw, 16.sw, 10.sw + context.mediaQueryPadding.bottom),
            child: widget.params.model == null
                ? WidgetRippleButton(
                    onTap: _onPressedSave,
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
                          onTap: _onPressedDelete,
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
                          onTap: _onPressedSave,
                          enable: enableSave,
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
