import 'package:app/src/base/bloc.dart';
import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:network_resources/models/opening_time_model.dart';
import 'package:network_resources/product/model/product.dart';
import 'package:network_resources/product/repo.dart';
import 'package:network_resources/store/models/menu.dart';
import 'package:network_resources/topping/models/models.dart';
import 'package:network_resources/topping/repo.dart';
import 'package:app/src/presentation/widgets/widget_loading_wrapper.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:app/src/utils/utils.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/network_resources.dart';

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
  final ValueNotifier<bool> _stillAvailable = ValueNotifier(true);

  List<OpeningTimeModel> _openTimes = OpeningTimeModel.getDefaultOpeningTimes();
  List<MenuModel> _toppingGroups = [];
  late List<VariationModel> variations = widget.params.model?.variations ?? [];
  List<int> deleteVariationIds = [];

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _describeFocusNode = FocusNode();

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
      _stillAvailable.value = product.status == 1;
      _imageUrl = product.image;
      _openTimes =
          OpeningTimeModel.fromListOperatingHours(product.operatingHours ?? []);
      _toppingGroups = product.toppings ?? [];
      variations = product.variations ?? [];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _describeController.dispose();
    _stillAvailable.dispose();
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
      // Chờ tạo variation
      final List<int> variationIds = [];
      await Future.wait(variations.map((variation) async {
        final result = await ToppingRepo().createVariation({
          "name": variation.name,
          "values": variation.values
              ?.map((value) => {"value": value.value, "price": value.price})
              .toList(),
          "arrange": variation.arrange,
          "is_active": variation.isActive ?? 1,
          // "is_default": variation.isDefault ?? 0,
          "store_id": authCubit.storeId,
        });

        if (result.data != null && result.data is VariationModel) {
          variationIds.add((result.data as VariationModel).id ?? 0);
        }
      }));

      final r = await ProductRepo().createProduct({
        'name': _nameController.text,
        'price': currencyFromEditController(_priceController),
        'description': _describeController.text,
        'image': imageUrl,
        'store_id': authCubit.storeId,
        'variation_ids': variationIds,
        'category_ids': widget.params.categoryIds,
        'group_topping_ids': _toppingGroups.map((e) => e.id!).toList(),
        "operating_hours": _openTimes
            .map((e) => {
                  "is_off": e.isOpen ? 0 : 1,
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
      // Xử lý cập nhật variation
      final List<int> variationIds = [];

      await Future.wait(deleteVariationIds.map((id) async {
        await ToppingRepo().deleteVariation(id);
      }));

      // Xử lý các topping đã có và topping mới
      await Future.wait(variations.map((variation) async {
        if (variation.id != null) {
          ToppingRepo().updateVariation({
            "id": variation.id,
            "name": variation.name,
            "values": variation.values
                ?.map((value) => {"value": value.value, "price": value.price})
                .toList(),
            "arrange": variation.arrange,
            "is_active": variation.isActive ?? 1,
            // "is_default": variation.isDefault ?? 0,
            "store_id": authCubit.storeId,
          });

          // Topping đã có id, thêm vào danh sách
          variationIds.add(variation.id!);
        } else {
          // Topping mới cần tạo
          final result = await ToppingRepo().createVariation({
            "name": variation.name,
            "values": variation.values
                ?.map((value) => {"value": value.value, "price": value.price})
                .toList(),
            "arrange": variation.arrange,
            "is_active": variation.isActive ?? 1,
            // "is_default": variation.isDefault ?? 0,
            "store_id": authCubit.storeId,
          });

          if (result.data != null && result.data is VariationModel) {
            variationIds.add((result.data as VariationModel).id ?? 0);
          }
        }
      }));

      final r = await ProductRepo().updateProduct({
        'id': widget.params.model!.id,
        'name': _nameController.text,
        'price': currencyFromEditController(_priceController),
        'description': _describeController.text,
        'image': imageUrl ?? widget.params.model!.image,
        'store_id': authCubit.storeId,
        'variation_ids': variationIds,
        'category_ids': widget.params.categoryIds,
        "operating_hours": _openTimes
            .map((e) => {
                  "is_off": e.isOpen ? 0 : 1,
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
                              decimalDigits: 1,
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
                          maxLines: 8,
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
                    padding: EdgeInsets.symmetric(horizontal: 16.sw),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(16.sw),
                        Text(
                          'Dish options'.tr(),
                          style: w400TextStyle(
                              fontSize: 12.sw, color: hexColor('#B0B0B0')),
                        ),
                        Gap(11.sw),
                        const AppDivider(),
                        if (variations.isNotEmpty)
                          ReorderableListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: variations.length,
                            onReorder: (oldIndex, newIndex) {
                              setState(() {
                                if (oldIndex < newIndex) {
                                  newIndex -= 1;
                                }
                                final VariationModel item =
                                    variations.removeAt(oldIndex);
                                variations.insert(newIndex, item);

                                // Cập nhật arrange cho tất cả topping
                                for (int i = 0; i < variations.length; i++) {
                                  variations[i].arrange = i + 1;
                                }

                                // Gọi API để cập nhật thứ tự
                                // ToppingRepo().sortToppings({
                                //   "ids": toppings.map((e) => e.id).toList(),
                                //   "arranges":
                                //       toppings.map((e) => e.arrange).toList(),
                                // });
                              });
                            },
                            itemBuilder: (context, index) {
                              return KeyedSubtree(
                                key: ValueKey(variations[index]),
                                child: Column(
                                  children: [
                                    _buildItemVariation(variations[index]),
                                    const AppDivider(),
                                  ],
                                ),
                              );
                            },
                          )
                        else
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 24.sw),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const WidgetAppSVG('empty_store'),
                                  Gap(16.sw),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'No have any dish options'.tr(),
                                        style: w400TextStyle(fontSize: 15.sw),
                                      ),
                                      Gap(4.sw),
                                      Text(
                                        'Let\'s create your first\ndish options'
                                            .tr(),
                                        style: w400TextStyle(
                                            fontSize: 12.sw, color: grey1),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const AppDivider(),
                        WidgetInkWellTransparent(
                          onTap: () async {
                            final result =
                                await appContext.push('/add-variation');
                            if (result != null && result is VariationModel) {
                              variations.add(result);
                            }
                          },
                          enableInkWell: false,
                          child: SizedBox(
                            height: 34.sw,
                            width: context.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                WidgetAppSVG('ic_add'),
                                Gap(4.sw),
                                Text(
                                  'Add option'.tr(),
                                  style: w400TextStyle(),
                                ),
                              ],
                            ),
                          ),
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
                          'Still available'.tr(),
                          style: w400TextStyle(),
                        ),
                        AdvancedSwitch(
                          controller: _stillAvailable,
                          initialValue: true,
                          height: 22.sw,
                          width: 40.sw,
                          activeColor: appColorPrimary,
                          inactiveColor: hexColor('#E2E2EF'),
                          onChanged: (value) {
                            _stillAvailable.value = value;
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Opening hours'.tr(),
                                  style: w400TextStyle(fontSize: 16.sw),
                                ),
                                if (_openTimes.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(top: 4.sw),
                                    child: Text(
                                      _openTimes
                                          .map((e) =>
                                              "${OpeningTimeModel.getDayOfWeek(e.dayNumber)} (${!e.isOpen ? 'Close' : '${e.openTime} - ${e.closeTime}'})")
                                          .join('\n'),
                                      style: w300TextStyle(
                                          height: 1.4,
                                          fontSize: 12.sw,
                                          color: grey1),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const WidgetAppSVG('chevron-right'),
                        ],
                      ),
                    ),
                  ),
                  Gap(5.sw),
                  WidgetRippleButton(
                    onTap: () async {
                      final r = await appContext.push('/link-topping-group',
                              extra:
                                  _toppingGroups.map((e) => e.id!).toList()) ??
                          [];
                      if (r is List<MenuModel>) {
                        setState(() {
                          _toppingGroups = r;
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
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Toppings to use with this dish'.tr(),
                                style: w400TextStyle(fontSize: 16.sw),
                              ),
                              if (_toppingGroups.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(top: 4.sw),
                                  child: Text(
                                    _toppingGroups
                                        .map((e) =>
                                            "${e.name ?? ''} (${e.toppings?.length ?? 0})")
                                        .join(', '),
                                    style: w300TextStyle(
                                        fontSize: 12.sw, color: grey1),
                                  ),
                                ),
                            ],
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

  Widget _buildItemVariation(VariationModel variation) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        extentRatio: .16,
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              outlinedButtonTheme: const OutlinedButtonThemeData(
                style: ButtonStyle(
                  iconColor: WidgetStatePropertyAll(Colors.white),
                ),
              ),
            ),
            child: SlidableAction(
              onPressed: (_) {
                if (variation.id != null) {
                  deleteVariationIds.add(variation.id ?? 0);
                }
                variations.removeWhere((e) => e == variation);
                setState(() {});
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: CupertinoIcons.delete,
            ),
          ),
        ],
      ),
      child: WidgetInkWellTransparent(
        onTap: () async {
          final result =
              await appContext.push('/add-variation', extra: variation);
          if (result != null) {
            if (result is VariationModel) {
              variations.removeWhere((e) => e == variation);
              variations.add(result);
            } else if (result == -1) {
              deleteVariationIds.add(variation.id ?? 0);
            }
          }
        },
        enableInkWell: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.sw),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      variation.name ?? '',
                      style: w400TextStyle(),
                    ),
                    Gap(2.sw),
                    if (variation.values != null &&
                        variation.values!.isNotEmpty)
                      Text(
                        variation.values!
                            .map((value) =>
                                '${value.value} (${currencyFormatted(value.price ?? 0)})')
                            .join(', '),
                        style: w400TextStyle(fontSize: 12.sw, color: grey1),
                      ),
                  ],
                ),
              ),
              AdvancedSwitch(
                controller: ValueNotifier<bool>(variation.isActive == 1),
                initialValue: variation.isActive == 1,
                height: 22.sw,
                width: 40.sw,
                activeColor: appColorPrimary,
                inactiveColor: hexColor('#E2E2EF'),
                onChanged: (value) {
                  appHaptic();
                  setState(() {
                    variation.isActive = value ? 1 : 0;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
