import 'dart:io';

import 'package:app/src/base/bloc.dart';
import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/network_resources/store/models/models.dart';
import 'package:app/src/network_resources/topping/models/models.dart';
import 'package:app/src/network_resources/topping/repo.dart';
import 'package:app/src/presentation/widgets/widget_loading_wrapper.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:app/src/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';

class WidgetAddToppingGroup extends StatefulWidget {
  const WidgetAddToppingGroup({
    super.key,
    this.model,
  });

  final MenuModel? model;

  @override
  State<WidgetAddToppingGroup> createState() => _WidgetAddToppingGroupState();
}

class _WidgetAddToppingGroupState
    extends BaseLoadingState<WidgetAddToppingGroup> {
  late MenuModel? model = widget.model;

  List<int> deleteIds = [];
  late List<ToppingModel> toppings = model?.toppings ?? [];
  late final TextEditingController _nameController =
      TextEditingController(text: widget.model?.name ?? '');

  bool get enableSave => _nameController.text.isNotEmpty && toppings.isNotEmpty;

  _onPressSave() async {
    setLoading(true);

    if (model?.id == null) {
      // Chờ tạo topping
      final List<int> toppingIds = [];
      await Future.wait(toppings.map((topping) async {
        if (topping.isLocalImage == true && topping.image != null) {
          String filePath = topping.image ?? '';
          final result = await ToppingRepo().createTopping({
            "name": topping.name,
            "price": topping.price,
            "arrange": topping.arrange,
            "status": 1,
            "store_id": authCubit.storeId,
            'image': await MultipartFile.fromFile(filePath, filename: filePath),
          });

          if (result.data != null && result.data is ToppingModel) {
            toppingIds.add((result.data as ToppingModel).id ?? 0);
          }
        }
      }));

      final result = await ToppingRepo().createGroupTopping({
        "name": _nameController.text,
        "store_id": authCubit.storeId,
        "topping_ids": toppingIds,
        "max_quantity": 99,
      });

      if (result.isSuccess) {
        appShowSnackBar(
          context: context,
          msg: 'Topping group created successfully'.tr(),
          type: AppSnackBarType.success,
        );
        context.pop();
      } else {
        appShowSnackBar(
          context: context,
          msg: 'Topping group created failed'.tr(),
          type: AppSnackBarType.error,
        );
      }
    } else {
      // Xử lý cập nhật topping group
      final List<int> toppingIds = [];

      await Future.wait(deleteIds.map((id) async {
        await ToppingRepo().deleteTopping(id);
      }));

      // Xử lý các topping đã có và topping mới
      await Future.wait(toppings.map((topping) async {
        if (topping.id != null) {
          String? filePath =
              topping.isLocalImage == true ? topping.image : null;
          ToppingRepo().updateTopping({
            "id": topping.id,
            "name": topping.name,
            "price": topping.price,
            "arrange": topping.arrange,
            "status": 1,
            "store_id": authCubit.storeId,
            'image': filePath != null
                ? await MultipartFile.fromFile(filePath, filename: filePath)
                : null,
          });

          // Topping đã có id, thêm vào danh sách
          toppingIds.add(topping.id!);
        } else if (topping.isLocalImage == true && topping.image != null) {
          // Topping mới cần tạo
          String filePath = topping.image ?? '';
          final result = await ToppingRepo().createTopping({
            "name": topping.name,
            "price": topping.price,
            "arrange": topping.arrange,
            "status": 1,
            "store_id": authCubit.storeId,
            'image': await MultipartFile.fromFile(filePath, filename: filePath),
          });

          if (result.data != null && result.data is ToppingModel) {
            toppingIds.add((result.data as ToppingModel).id ?? 0);
          }
        }
      }));

      // Gọi API cập nhật group topping
      final result = await ToppingRepo().updateGroupTopping({
        "id": model?.id,
        "name": _nameController.text,
        "store_id": authCubit.storeId,
        "topping_ids": toppingIds,
        "max_quantity": 99,
      });

      if (result.isSuccess) {
        appShowSnackBar(
          context: context,
          msg: 'Topping group updated successfully'.tr(),
          type: AppSnackBarType.success,
        );
        context.pop();
      } else {
        appShowSnackBar(
          context: context,
          msg: 'Topping group updated failed'.tr(),
          type: AppSnackBarType.error,
        );
      }
    }

    setLoading(false);
  }

  _onPressDelete() async {
    setLoading(true);

    if (model?.id != null) {
      appOpenDialog(WidgetConfirmDialog(
          title: 'Delete topping group'.tr(),
          subTitle: 'Are you sure you want to delete this topping group?'.tr(),
          onConfirm: () async {
            await Future.wait(toppings.map((topping) async {
              if (topping.id != null) {
                await ToppingRepo().deleteTopping(topping.id ?? 0);
              }
            }));

            await ToppingRepo().deleteGroupTopping(model?.id ?? 0);
          }));
    }

    setLoading(false);
  }

  @override
  Widget buildContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add topping group'.tr())),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(16.sw),
                    child: AppTextField(
                      controller: _nameController,
                      title: 'Name'.tr(),
                      hintText: 'Enter name'.tr(),
                      onChanged: (value) {
                        setState(() {});
                      },
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
                          'Extra dishes'.tr(),
                          style: w400TextStyle(
                              fontSize: 12.sw, color: hexColor('#B0B0B0')),
                        ),
                        Gap(11.sw),
                        const AppDivider(),
                        if (toppings.isNotEmpty)
                          ReorderableListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: toppings.length,
                            onReorder: (oldIndex, newIndex) {
                              setState(() {
                                if (oldIndex < newIndex) {
                                  newIndex -= 1;
                                }
                                final ToppingModel item =
                                    toppings.removeAt(oldIndex);
                                toppings.insert(newIndex, item);

                                // Cập nhật arrange cho tất cả topping
                                for (int i = 0; i < toppings.length; i++) {
                                  toppings[i].arrange = i + 1;
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
                                key: ValueKey(toppings[index]),
                                child: Column(
                                  children: [
                                    _buildItemTopping(toppings[index]),
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
                                        'No have any extra dishes'.tr(),
                                        style: w400TextStyle(fontSize: 15.sw),
                                      ),
                                      Gap(4.sw),
                                      Text(
                                        'Let\'s create your first\nextra dishes'
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
                                await appContext.push('/add-topping');
                            if (result != null && result is ToppingModel) {
                              toppings.add(result);
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
                                  'Add dish'.tr(),
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
                  WidgetRippleButton(
                    onTap: () => appContext.push('/add-option'),
                    radius: 0,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16.sw, 12.sw, 12.sw, 12.sw),
                      child: Row(
                        children: [
                          Text(
                            'Dishes linked'.tr(),
                            style: w400TextStyle(),
                          ),
                          const Spacer(),
                          Text(
                            'Select dishes appear'.tr(),
                            style: w400TextStyle(fontSize: 12.sw, color: grey1),
                          ),
                          Gap(4.sw),
                          const WidgetAppSVG('chevron-right'),
                        ],
                      ),
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
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(
                16.sw, 10.sw, 16.sw, 10.sw + context.mediaQueryPadding.bottom),
            child: model == null
                ? WidgetRippleButton(
                    onTap: _onPressSave,
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
                          onTap: _onPressDelete,
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
                          onTap: _onPressSave,
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

  Widget _buildItemTopping(ToppingModel topping) {
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
                if (topping.id != null) {
                  deleteIds.add(topping.id ?? 0);
                }
                toppings.removeWhere((e) => e == topping);
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
          final result = await appContext.push('/add-topping', extra: topping);
          if (result != null) {
            if (result is ToppingModel) {
              toppings.removeWhere((e) => e == topping);
              toppings.add(result);
            } else if (result == -1) {
              deleteIds.add(topping.id ?? 0);
              toppings.removeWhere((e) => e == topping);
            }
          }
        },
        enableInkWell: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.sw),
          child: Row(
            children: [
              if (topping.isLocalImage == true && topping.image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.sw),
                  child: Image.file(
                    File(topping.image ?? ''),
                    fit: BoxFit.cover,
                    width: 48.sw,
                    height: 48.sw,
                  ),
                )
              else
                WidgetAppImage(
                  imageUrl: topping.image ?? '',
                  width: 48.sw,
                  height: 48.sw,
                  radius: 4,
                ),
              Gap(12.sw),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topping.name ?? '',
                      style: w400TextStyle(),
                    ),
                    Gap(2.sw),
                    // Text(
                    //   topping.name ?? '',
                    //   style: w400TextStyle(fontSize: 10.sw, color: grey1),
                    // ),
                    // Gap(1.sw),
                    Text(
                      currencyFormatted(topping.price),
                      style: w400TextStyle(color: darkGreen),
                    ),
                  ],
                ),
              ),
              AdvancedSwitch(
                controller: ValueNotifier<bool>(true),
                initialValue: true,
                height: 22.sw,
                width: 40.sw,
                activeColor: appColorPrimary,
                inactiveColor: hexColor('#E2E2EF'),
                onChanged: (value) {
                  appHaptic();
                  setState(() {
                    topping.status = value ? 1 : 0;
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
