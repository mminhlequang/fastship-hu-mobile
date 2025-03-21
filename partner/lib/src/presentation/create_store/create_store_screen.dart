import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internal_core/extensions/context_extension.dart';

class CreateStoreScreen extends StatefulWidget {
  const CreateStoreScreen({super.key});

  @override
  State<CreateStoreScreen> createState() => _CreateStoreScreenState();
}

class _CreateStoreScreenState extends State<CreateStoreScreen> {
  XFile? storeAvatar;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isEnable = false;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Create new store'.tr())),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.sw),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppUploadImage(
                    title: 'Store avatar'.tr(),
                    isRequired: false,
                    subTitle: Gap(8.sw),
                    onPickImage: (image) {
                      // Todo:
                    },
                  ),
                  Gap(16.sw),
                  AppTextField(
                    controller: _nameController,
                    title: 'Name'.tr(),
                    hintText: 'Enter name'.tr(),
                  ),
                  Gap(24.sw),
                  AppTextField(
                    controller: _addressController,
                    title: 'Address'.tr(),
                    hintText: 'Enter address'.tr(),
                  ),
                  Gap(24.sw),
                  const WidgetOpeningTime(),
                ],
              ),
            ),
          ),
          Container(
            padding:
                EdgeInsets.fromLTRB(16.sw, 10.sw, 16.sw, 10.sw + context.mediaQueryPadding.bottom),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: appColorBackground)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: WidgetAppButtonCancel(
                    onTap: () {
                      // Todo:
                    },
                    label: 'Cancel'.tr(),
                    height: 48.sw,
                  ),
                ),
                Gap(10.sw),
                Expanded(
                  child: WidgetAppButtonOK(
                    onTap: () {
                      // Todo:
                    },
                    enable: _isEnable,
                    label: 'Confirm'.tr(),
                    height: 48.sw,
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
