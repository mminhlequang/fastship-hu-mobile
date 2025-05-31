import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:network_resources/models/opening_time_model.dart';
import 'package:app/src/presentation/widgets/widget_app_divider.dart';
import 'package:app/src/presentation/widgets/widget_app_upload_image.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internal_core/internal_core.dart';

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
  List<OpeningTimeModel>? _openTimes;
  List<int>? _businessTypes;
  List<int>? _categories;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    _avatarImage = widget.initialData['avatar_image'];
    _coverImage = widget.initialData['banner_images'];
    _facadeImage = widget.initialData['facade_image'];
    _openTimes = widget.initialData['operating_hours'] ??
        OpeningTimeModel.getDefaultOpeningTimes();
    _businessTypes = widget.initialData['business_type_ids'];
    _categories = widget.initialData['category_ids'];

    // Đảm bảo gọi onChanged ngay lần đầu nếu có dữ liệu initial
    if (widget.initialData.isNotEmpty) {
      _updateData();
    }
  }

  void _updateData() {
    widget.onChanged({
      'avatar_image': _avatarImage,
      'banner_images': _coverImage,
      'facade_image': _facadeImage,
      'operating_hours': _openTimes,
      'business_type_ids': _businessTypes,
      'category_ids': _categories,
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
              xFileImage: _avatarImage,
              aspectRatio: 1.0,
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
              xFileImage: _coverImage,
              aspectRatio: 369 / 124,
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
              xFileImage: _facadeImage,
              aspectRatio: 1.0,
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
              title: 'Opening hours'.tr(),
              route: '/opening-time',
              extra: _openTimes,
              onReturn: (value) {
                if (value != null) {
                  setState(() {
                    _openTimes = value;
                  });
                  _updateData();
                }
              },
            ),
            AppDivider(padding: EdgeInsets.symmetric(horizontal: 16.sw)),
            _buildNavigationItem(
              title: 'Business type'.tr(),
              route: '/business-type',
              extra: _businessTypes,
              onReturn: (value) {
                if (value != null) {
                  setState(() {
                    _businessTypes = value;
                  });
                  _updateData();
                }
              },
            ),
            AppDivider(padding: EdgeInsets.symmetric(horizontal: 16.sw)),
            _buildNavigationItem(
              title: 'Categories'.tr(),
              route: '/store-category',
              extra: _categories,
              onReturn: (value) {
                if (value != null) {
                  setState(() {
                    _categories = value;
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
    String? description,
    required String route,
    required Function(dynamic) onReturn,
    dynamic extra,
  }) {
    return WidgetRippleButton(
      onTap: () async {
        final result = await appContext.push(route, extra: extra);
        print('result: $result');
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
                  if (description != null) ...[
                    Gap(4.sw),
                    Text(
                      description,
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
