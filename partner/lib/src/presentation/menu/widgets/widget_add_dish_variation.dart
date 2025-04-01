import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:network_resources/product/model/product.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/utils.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';

class WidgetAddVariation extends StatefulWidget {
  const WidgetAddVariation({super.key, this.variation});

  final VariationModel? variation;

  @override
  State<WidgetAddVariation> createState() => _WidgetAddVariationState();
}

class _WidgetAddVariationState extends State<WidgetAddVariation> {
  late VariationModel? _variation = widget.variation;
  final TextEditingController _nameController = TextEditingController();
  final List<TextEditingController> _valueNameControllers = [];
  final List<TextEditingController> _valuePriceControllers = [];
  final FocusNode _nameFocusNode = FocusNode();
  final List<FocusNode> _valueNameFocusNodes = [];
  final List<FocusNode> _valuePriceFocusNodes = [];
  // bool _isDefault = false;
  bool _isActive = true;

  bool get enableSave =>
      _nameController.text.isNotEmpty &&
      _valueNameControllers.isNotEmpty &&
      _valueNameControllers.every((controller) => controller.text.isNotEmpty) &&
      _valuePriceControllers.every((controller) => controller.text.isNotEmpty);

  @override
  void initState() {
    super.initState();
    _nameController.text = _variation?.name ?? '';
    // _isDefault = _variation?.isDefault == 1;
    _isActive = _variation?.isActive == 1;

    if (_variation?.values != null && _variation!.values!.isNotEmpty) {
      for (var value in _variation!.values!) {
        _valueNameControllers.add(TextEditingController(text: value.value));
        _valuePriceControllers
            .add(TextEditingController(text: value.price?.toString() ?? ''));
        _valueNameFocusNodes.add(FocusNode());
        _valuePriceFocusNodes.add(FocusNode());
      }
    } else {
      _addNewValue();
    }
  }

  void _addNewValue() {
    _valueNameControllers.add(TextEditingController());
    _valuePriceControllers.add(TextEditingController());
    _valueNameFocusNodes.add(FocusNode());
    _valuePriceFocusNodes.add(FocusNode());
    setState(() {});
  }

  void _removeValue(int index) {
    _valueNameControllers[index].dispose();
    _valuePriceControllers[index].dispose();
    _valueNameFocusNodes[index].dispose();
    _valuePriceFocusNodes[index].dispose();
    _valueNameControllers.removeAt(index);
    _valuePriceControllers.removeAt(index);
    _valueNameFocusNodes.removeAt(index);
    _valuePriceFocusNodes.removeAt(index);
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    for (var controller in _valueNameControllers) {
      controller.dispose();
    }
    for (var controller in _valuePriceControllers) {
      controller.dispose();
    }
    for (var node in _valueNameFocusNodes) {
      node.dispose();
    }
    for (var node in _valuePriceFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_variation?.name ?? 'Add dish option'.tr())),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  title: 'Name'.tr(),
                  hintText: 'Enter name'.tr(),
                  onChanged: (value) {
                    setState(() {});
                  },
                  onSubmitted: (_) {
                    if (_valueNameFocusNodes.isNotEmpty) {
                      _valueNameFocusNodes.first.requestFocus();
                    }
                  },
                ),
                Gap(24.sw),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'This options is active'.tr(),
                        style: w400TextStyle(),
                      ),
                    ),
                    Gap(8.sw),
                    AdvancedSwitch(
                      controller: ValueNotifier<bool>(_isActive),
                      initialValue: _isActive,
                      height: 22.sw,
                      width: 40.sw,
                      activeColor: appColorPrimary,
                      inactiveColor: hexColor('#E2E2EF'),
                      onChanged: (value) {
                        appHaptic();
                        setState(() {
                          _isActive = value;
                        });
                      },
                    ),
                  ],
                ),
                Gap(24.sw),
                // Row(
                //   children: [
                //     Expanded(
                //       child: Text(
                //         'This option is default'.tr(),
                //         style: w400TextStyle(),
                //       ),
                //     ),
                //     Gap(8.sw),
                //     AdvancedSwitch(
                //       controller: ValueNotifier<bool>(_isDefault),
                //       initialValue: _isDefault,
                //       height: 22.sw,
                //       width: 40.sw,
                //       activeColor: appColorPrimary,
                //       inactiveColor: hexColor('#E2E2EF'),
                //       onChanged: (value) {
                //         appHaptic();
                //         setState(() {
                //           _isDefault = value;
                //         });
                //       },
                //     ),
                //   ],
                // ),
                // Gap(24.sw),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Values'.tr(),
                      style: w400TextStyle(),
                    ),
                    WidgetInkWellTransparent(
                      onTap: _addNewValue,
                      child: Row(
                        children: [
                          WidgetAppSVG('ic_add'),
                          Gap(4.sw),
                          Text(
                            'Add value'.tr(),
                            style: w400TextStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(16.sw),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _valueNameControllers.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AppTextField(
                                controller: _valueNameControllers[index],
                                focusNode: _valueNameFocusNodes[index],
                                hintText: 'Enter value name'.tr(),
                                onChanged: (value) {
                                  setState(() {});
                                },
                                onSubmitted: (_) {
                                  if (index <
                                      _valuePriceFocusNodes.length - 1) {
                                    _valuePriceFocusNodes[index + 1]
                                        .requestFocus();
                                  }
                                },
                              ),
                            ),
                            Gap(10.sw),
                            Expanded(
                              child: AppTextField(
                                controller: _valuePriceControllers[index],
                                focusNode: _valuePriceFocusNodes[index],
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
                            ),
                            Gap(10.sw),
                            WidgetInkWellTransparent(
                              onTap: () {
                                if (_valueNameControllers.length > 1) {
                                  _removeValue(index);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.sw),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.sw),
                                ),
                                child: Icon(
                                  CupertinoIcons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(16.sw),
                      ],
                    );
                  },
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
            child: _variation?.id == null
                ? WidgetRippleButton(
                    onTap: () {
                      appHaptic();
                      context.pop(
                        VariationModel(
                          id: widget.variation?.id,
                          name: _nameController.text,
                          values: List.generate(
                            _valueNameControllers.length,
                            (index) => VariationValue(
                              value: _valueNameControllers[index].text,
                              price: currencyFromEditController(
                                  _valuePriceControllers[index]),
                            ),
                          ),
                          // isDefault: _isDefault ? 1 : 0,
                          isActive: _isActive ? 1 : 0,
                          arrange: 0,
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
                              VariationModel(
                                id: widget.variation?.id,
                                name: _nameController.text,
                                values: List.generate(
                                  _valueNameControllers.length,
                                  (index) => VariationValue(
                                    value: _valueNameControllers[index].text,
                                    price: currencyFromEditController(
                                        _valuePriceControllers[index]),
                                  ),
                                ),
                                // isDefault: _isDefault ? 1 : 0,
                                isActive: _isActive ? 1 : 0,
                                arrange: _variation?.arrange ?? 0,
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
