import 'package:app/src/base/bloc.dart';
import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/widgets/widget_loading_wrapper.dart';
import 'package:go_router/go_router.dart';
import 'package:network_resources/store/repo.dart';
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

class _InformationScreenState extends BaseLoadingState<InformationScreen> {
  late final TextEditingController _nameController =
      TextEditingController(text: authCubit.state.store!.name);
  late final TextEditingController _addressController =
      TextEditingController(text: authCubit.state.store!.address);
  PhoneNumber? _phoneNumber;
  XFile? _avatarImage;
  XFile? _coverImage;
  String? _currentAvatarUrl = authCubit.state.store!.avatarImage;
  String? _currentCoverUrl = authCubit.state.store!.bannerImages?.first.image;

  Future<void> _saveChanges() async {
    setLoading(true);

    try {
      String? newAvatarUrl;
      String? newCoverUrl;

      // Upload new images if available
      final uploadFutures = <Future>[];

      if (_avatarImage != null) {
        uploadFutures
            .add(StoreRepo().uploadImage(_avatarImage!.path, 'store_avatar'));
      }

      if (_coverImage != null) {
        uploadFutures
            .add(StoreRepo().uploadImage(_coverImage!.path, 'store_cover'));
      }

      final responses = await Future.wait(uploadFutures);

      if (_avatarImage != null &&
          responses.isNotEmpty &&
          responses[0].isSuccess) {
        newAvatarUrl = responses[0].data;
      }

      if (_coverImage != null &&
          responses.length > 1 &&
          responses[1].isSuccess) {
        newCoverUrl = responses[1].data;
      }

      // Gọi API update thông tin
      final response = await StoreRepo().updateStore({
        'id': authCubit.state.store!.id,
        if (newAvatarUrl != null) 'avatar': newAvatarUrl,
        if (newCoverUrl != null) 'cover_image': newCoverUrl,
        'name': _nameController.text,
      });

      if (response.isSuccess) {
        context.pop();
        appShowSnackBar(
          msg: 'Store information updated successfully'.tr(),
          context: context,
          type: AppSnackBarType.success,
        );
      } else {
        throw Exception(response.msg ?? 'Update failed');
      }
    } catch (e) {
      appShowSnackBar(
        msg: 'Failed to update store information'.tr(),
        context: context,
        type: AppSnackBarType.error,
      );
    } finally {
      setLoading(false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (authCubit.state.store!.phone != null) {
      PhoneNumber.fromRawString(authCubit.state.store!.phone!).then((value) {
        setState(() {
          _phoneNumber = value;
        });
      });
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Information'.tr()),
        actions: [
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
      body: Container(
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
              subTitle:
                  'This phone number can\'t be changed as normally, please contact support if you need to change it.'
                      .tr(),
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
              subTitle:
                  'You can\'t change store address as normally, please contact support if you need to change it.'
                      .tr(),
              hintText: 'Enter address'.tr(),
              keyboardType: TextInputType.text,
              onChanged: (value) {
                setState(() {});
              },
            ),
            AppDivider(padding: EdgeInsets.symmetric(vertical: 12.sw)),
            AppUploadImage(
              title: 'Avatar'.tr(),
              imageUrl: _avatarImage != null ? null : _currentAvatarUrl,
              xFileImage: _avatarImage,
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
              imageUrl: _coverImage != null ? null : _currentCoverUrl,
              xFileImage: _coverImage,
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
