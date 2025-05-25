import 'dart:io';

import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internal_core/internal_core.dart';

class ReportOrderScreen extends StatefulWidget {
  const ReportOrderScreen({super.key});

  @override
  State<ReportOrderScreen> createState() => _ReportOrderScreenState();
}

class _ReportOrderScreenState extends State<ReportOrderScreen> {
  File? _pickedImage;

  _selectSource(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(24),
          titlePadding: const EdgeInsets.fromLTRB(16, 4, 6, 2),
          contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Colors.white,
          titleTextStyle: w600TextStyle(fontSize: 16.sw),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pick image from'.tr()),
              IconButton(
                onPressed: () {
                  appHaptic();
                  context.pop();
                },
                icon: Icon(Icons.close_rounded),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  context.pop();
                  _pickImage(ImageSource.camera);
                },
                child: Row(
                  children: [
                    WidgetAppSVG('ic_camera'),
                    Gap(8.sw),
                    Text('Camera'.tr(), style: w400TextStyle(fontSize: 15.sw)),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
                child: Row(
                  children: [
                    WidgetAppSVG('ic_image'),
                    Gap(8.sw),
                    Text('Gallery'.tr(), style: w400TextStyle(fontSize: 15.sw)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Report'.tr())),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '436EREHS',
                  style: w500TextStyle(fontSize: 16.sw),
                ),
                Gap(2.sw),
                Text(
                  '26 Feb 2025, 8:30',
                  style:
                      w400TextStyle(color: appColorText.withValues(alpha: .5)),
                ),
              ],
            ),
          ),
          AppDivider(height: 5.sw, thickness: 5.sw, color: appColorBackground),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: 'Order’s image'.tr(),
                    style: w600TextStyle(),
                    children: [
                      TextSpan(
                        text: '*',
                        style: w600TextStyle(color: appColorError),
                      ),
                    ],
                  ),
                ),
                Gap(8.sw),
                WidgetInkWellTransparent(
                  onTap: () {
                    appHaptic();
                    _selectSource(context);
                  },
                  radius: 2,
                  child: _pickedImage != null
                      ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: Image.file(
                                _pickedImage!,
                                height: 64.sw,
                                width: 64.sw,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 4.sw,
                              right: 4.sw,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _pickedImage = null;
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 8.sw,
                                  backgroundColor:
                                      Colors.black.withValues(alpha: .5),
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 14.sw,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : DottedBorder(
                          options: RoundedRectDottedBorderOptions(
                            radius: const Radius.circular(2),
                            color: hexColor('#E7E7E7'),
                            strokeWidth: 1,
                            dashPattern: [8, 8],
                          ),
                          child: Container(
                            width: 64.sw,
                            height: 64.sw,
                            color: hexColor('#F9F9F9'),
                            child: Center(
                              child: WidgetAppSVG('ic_camera_plus'),
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
