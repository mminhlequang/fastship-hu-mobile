import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/widgets/widget_app_divider.dart';
import 'package:app/src/presentation/widgets/widget_app_upload_image.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internal_core/extensions/context_extension.dart';
import 'package:internal_core/setup/app_textstyles.dart';
import 'package:internal_core/widgets/widgets.dart';

class WidgetFormProfile3 extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onChanged;

  const WidgetFormProfile3({
    super.key,
    this.initialData = const {},
    required this.onChanged,
  });

  @override
  State<WidgetFormProfile3> createState() => _WidgetFormProfile3State();
}

class _WidgetFormProfile3State extends State<WidgetFormProfile3> {
  XFile? _avatarImage;
  XFile? _coverImage;
  XFile? _facadeImage;
  String? _selectedOpeningTime;
  String? _selectedServiceType;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    _avatarImage = widget.initialData['avatarImage'];
    _coverImage = widget.initialData['coverImage'];
    _facadeImage = widget.initialData['facadeImage'];
    _selectedOpeningTime = widget.initialData['openingTime'];
    _selectedServiceType = widget.initialData['serviceType'];
    _categories = List<String>.from(widget.initialData['categories'] ?? []);

    // Đảm bảo gọi onChanged ngay lần đầu nếu có dữ liệu initial
    if (widget.initialData.isNotEmpty) {
      _updateData();
    }
  }

  void _updateData() {
    widget.onChanged({
      'avatarImage': _avatarImage,
      'coverImage': _coverImage,
      'facadeImage': _facadeImage,
      'openingTime': _selectedOpeningTime,
      'serviceType': _selectedServiceType,
      'categories': _categories,
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppUploadImage(
              title: 'Avatar'.tr(),
              padding: EdgeInsets.symmetric(horizontal: 16.sw),
              subTitle: Padding(
                padding: EdgeInsets.only(bottom: 8.sw),
                child: Text(
                  '550x550px',
                  style: w400TextStyle(fontSize: 12.sw, color: grey1),
                ),
              ),
              image: _avatarImage,
              onPickImage: (image) {
                setState(() {
                  _avatarImage = image;
                });
                _updateData();
              },
            ),
            Gap(24.sw),
            AppUploadImage(
              title: 'Cover image'.tr(),
              width: context.width,
              height: 120.sw,
              padding: EdgeInsets.symmetric(horizontal: 16.sw),
              subTitle: Padding(
                padding: EdgeInsets.only(bottom: 8.sw),
                child: Text(
                  '960x550px',
                  style: w400TextStyle(fontSize: 12.sw, color: grey1),
                ),
              ),
              image: _coverImage,
              onPickImage: (image) {
                setState(() {
                  _coverImage = image;
                });
                _updateData();
              },
            ),
            Gap(24.sw),
            AppUploadImage(
              title: 'Facade image'.tr(),
              padding: EdgeInsets.symmetric(horizontal: 16.sw),
              subTitle: Padding(
                padding: EdgeInsets.only(bottom: 8.sw),
                child: Text(
                  '550x550px',
                  style: w400TextStyle(fontSize: 12.sw, color: grey1),
                ),
              ),
              image: _facadeImage,
              onPickImage: (image) {
                setState(() {
                  _facadeImage = image;
                });
                _updateData();
              },
            ),
            Gap(16.sw),
            Container(height: 8.sw, color: appColorBackground),
            _buildNavigationItem(
              title: 'Opening time'.tr(),
              route: '/provide-info/opening-time',
              selectedValue: _selectedOpeningTime,
              onReturn: (value) {
                if (value != null) {
                  setState(() {
                    _selectedOpeningTime = value;
                  });
                  _updateData();
                }
              },
            ),
            AppDivider(padding: EdgeInsets.symmetric(horizontal: 16.sw)),
            _buildNavigationItem(
              title: 'Business type'.tr(),
              route: '/provide-info/service-type',
              selectedValue: _selectedServiceType,
              onReturn: (value) {
                if (value != null) {
                  setState(() {
                    _selectedServiceType = value;
                  });
                  _updateData();
                }
              },
            ),
            AppDivider(padding: EdgeInsets.symmetric(horizontal: 16.sw)),
            _buildNavigationItem(
              title: 'Categories'.tr(),
              route: '/provide-info/cuisine',
              selectedValue: _categories.isNotEmpty
                  ? '${_categories.length} selected'
                  : null,
              onReturn: (value) {
                if (value != null) {
                  setState(() {
                    _categories = List<String>.from(value);
                  });
                  _updateData();
                }
              },
            ),
            Gap(24.sw),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationItem({
    required String title,
    required String route,
    required Function(dynamic) onReturn,
    String? selectedValue,
  }) {
    return WidgetRippleButton(
      onTap: () async {
        final result = await appContext.push(route);
        onReturn(result);
      },
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: w400TextStyle(),
                  ),
                  if (selectedValue != null) ...[
                    Gap(4.sw),
                    Text(
                      selectedValue,
                      style: w400TextStyle(fontSize: 12.sw, color: grey1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            WidgetAppSVG('chevron-right'),
          ],
        ),
      ),
    );
  }
}
