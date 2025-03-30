import 'package:app/src/base/bloc.dart';
import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/network_resources/store/repo.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/app_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internal_core/internal_core.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  final _storeRepo = StoreRepo();
  bool _isLoading = false;
  late TextEditingController _nameController =
      TextEditingController(text: authCubit.state.store!.name);
  late TextEditingController _addressController =
      TextEditingController(text: authCubit.state.store!.address);
  late PhoneNumber? _phoneNumber =
      PhoneNumber(phoneNumber: authCubit.state.store!.phone);
  XFile? _avatarImage;
  XFile? _coverImage;
  String? _currentAvatarUrl = authCubit.state.store!.avatarImage;
  String? _currentCoverUrl = authCubit.state.store!.bannerImages?.first.image;

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);

    try {
      String? newAvatarUrl;
      String? newCoverUrl;

      // Upload ảnh mới nếu có
      if (_avatarImage != null) {
        final avatarResponse =
            await _storeRepo.uploadImage(_avatarImage!.path, 'store_avatar');
        if (avatarResponse.isSuccess) {
          newAvatarUrl = avatarResponse.data;
        }
      }

      if (_coverImage != null) {
        final coverResponse =
            await _storeRepo.uploadImage(_coverImage!.path, 'store_cover');
        if (coverResponse.isSuccess) {
          newCoverUrl = coverResponse.data;
        }
      }

      // Gọi API update thông tin
      final response = await _storeRepo.updateStore({
        if (newAvatarUrl != null) 'avatar': newAvatarUrl,
        if (newCoverUrl != null) 'cover_image': newCoverUrl,
        'name': _nameController.text,
      });

      if (response.isSuccess) {
        appShowSnackBar(
          msg: 'Store information updated successfully',
          context: context,
          type: AppSnackBarType.success,
        );
      } else {
        throw Exception(response.msg ?? 'Update failed');
      }
    } catch (e) {
      appShowSnackBar(
        msg: 'Failed to update store information',
        context: context,
        type: AppSnackBarType.error,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Information'.tr()),
        actions: [
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            TextButton(
              onPressed: _saveChanges,
              child: Text(
                'Save'.tr(),
                style: w500TextStyle(fontSize: 16.sw, color: Colors.white),
              ),
            ),
          Gap(4.sw),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    readOnly: true,
                    controller: _nameController,
                    title: 'Name'.tr(),
                    hintText: 'Enter name'.tr(),
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  Gap(12.sw),
                  WidgetAppTextFieldPhone(
                    initialValue: _phoneNumber,
                    readOnly: true,
                    isRequired: true,
                    title: 'Phone number'.tr(),
                    hintText: 'Enter phone number'.tr(),
                    onChanged: (_) {
                      _phoneNumber = _;
                      setState(() {});
                    },
                  ),
                  Gap(12.sw),
                  AppTextField(
                    readOnly: true,
                    controller: _addressController,
                    title: 'Address'.tr(),
                    hintText: 'Enter address'.tr(),
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  AppDivider(padding: EdgeInsets.symmetric(vertical: 12.sw)),
                  AppUploadImage(
                    title: 'Avatar'.tr(),
                    imageUrl: _currentAvatarUrl,
                    subTitle: Padding(
                      padding: EdgeInsets.only(bottom: 8.sw, top: 4.sw),
                      child: Text(
                        '550x550px',
                        style: w400TextStyle(fontSize: 12.sw, color: grey1),
                      ),
                    ),
                    onPickImage: (image) {
                      setState(() => _avatarImage = image);
                    },
                  ),
                  Gap(16.sw),
                  AppUploadImage(
                    title: 'Cover image'.tr(),
                    imageUrl: _currentCoverUrl,
                    height: 140.sw,
                    width: context.width,
                    subTitle: Padding(
                      padding: EdgeInsets.only(bottom: 8.sw, top: 4.sw),
                      child: Text(
                        '960x550px',
                        style: w400TextStyle(fontSize: 12.sw, color: grey1),
                      ),
                    ),
                    onPickImage: (image) {
                      setState(() => _coverImage = image);
                    },
                  ),
                  Gap(4.sw),
                ],
              ),
            ),
    );
  }
}
