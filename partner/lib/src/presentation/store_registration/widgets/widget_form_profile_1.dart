import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:internal_core/extensions/date_extension.dart';
import 'package:internal_core/setup/app_textstyles.dart';
import 'package:internal_core/setup/app_utils.dart';

class WidgetFormProfile1 extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onChanged;
  final Map<String, dynamic>? initialData;
  const WidgetFormProfile1({
    super.key,
    required this.onChanged,
    this.initialData,
  });

  @override
  State<WidgetFormProfile1> createState() => _WidgetFormProfile1State();
}

class _WidgetFormProfile1State extends State<WidgetFormProfile1> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  Gender? _selectedGender;
  DateTime? _birthday;
  HereSearchResult? _selectedAddress;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _fullNameController.text = widget.initialData!['fullName'] ?? '';
      _selectedGender = widget.initialData!['gender'] != null
          ? Gender.values.firstWhere((e) => e.value == widget.initialData!['gender'])
          : null;
      _birthday = widget.initialData!['birthday'];
      _selectedAddress = widget.initialData!['address'];
      _addressController.text = _selectedAddress?.address ?? '';
    }
  }

  void _onChanged() {
    widget.onChanged({
      'fullName': _fullNameController.text,
      'birthday': _birthday,
      'gender': _selectedGender?.value,
      'address': _selectedAddress,
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WidgetTextField(
          controller: _fullNameController,
          label: 'Full name*'.tr(),
          hint: 'Ex: John Doe..'.tr(),
        ),
        Gap(16.sw),
        WidgetDropSelectorBuilder(
          items: Gender.values,
          selectedItem: _selectedGender,
          titleBuilder: (item) => item.name,
          onChanged: (item) {
            setState(() {
              _selectedGender = item;
            });
          },
          child: IgnorePointer(
            ignoring: true,
            child: WidgetTextField(
              controller: TextEditingController(
                text: _selectedGender?.name,
              ),
              label: 'Gender*'.tr(),
              hint: 'Select'.tr(),
              sufixIconWidget: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.instance.grey1,
              ),
            ),
          ),
        ),
        Gap(16.sw),
        GestureDetector(
          onTap: () {
            appHaptic();
            appOpenDateTimePicker(
              DateTime(DateTime.now().year - 18),
              (date) {
                setState(() {
                  _birthday = date;
                });
                _onChanged();
              },
            );
          },
          child: ColoredBox(
            color: Colors.transparent,
            child: IgnorePointer(
              child: WidgetTextField(
                isReadOnly: true,
                controller: TextEditingController(
                  text: _birthday?.formatDate(),
                ),
                label: 'Date of birth*'.tr(),
                hint: 'dd/mm/yyyy',
                sufixIconWidget: Icon(
                  CupertinoIcons.calendar,
                  color: AppColors.instance.grey1,
                ),
              ),
            ),
          ),
        ),
        Gap(16.sw),
        WidgetSearchPlaceBuilder(
          controller: _addressController,
          selectedAddress: _selectedAddress,
          onSubmitted: (HereSearchResult place) {
            setState(() {
              _selectedAddress = place;
            });
            _onChanged();
          },
          builder: (onChanged, controller, loading, key) {
            return WidgetTextField(
              key: key,
              controller: controller,
              onChanged: onChanged,
              label: 'Permanent address*'.tr(),
              hint: 'Add address'.tr(),
              sufixIconWidget: loading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CupertinoActivityIndicator(color: appColorPrimary),
                    )
                  : Icon(
                      Icons.location_on_outlined,
                      color: AppColors.instance.grey1,
                    ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildUploadBox(String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120.sw,
        decoration: BoxDecoration(
          color: hexColor('#FAFAFA'),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: appColorText.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              color: appColorText.withValues(alpha: 0.5),
              size: 32.sw,
            ),
            Gap(8.sw),
            Text(
              title,
              style: w300TextStyle(
                fontSize: 12.sw,
                color: appColorText.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
