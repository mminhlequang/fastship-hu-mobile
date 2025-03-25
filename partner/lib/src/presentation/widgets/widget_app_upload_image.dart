import 'dart:io';

import 'package:app/src/constants/constants.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internal_core/internal_core.dart';

void _showImageSourceOptions(
    BuildContext context, Function(XFile) onImagePicked) {
  Future<void> _pickImage(
      ImageSource source, Function(XFile) onImagePicked) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        onImagePicked(image);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  appHaptic();
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: Text('Take a photo'.tr()),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera, onImagePicked);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text('Choose from gallery'.tr()),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery, onImagePicked);
              },
            ),
          ],
        ),
      );
    },
  );
}

class AppUploadImage extends StatelessWidget {
  const AppUploadImage({
    super.key,
    required this.title,
    this.isRequired = true,
    this.onSeeInstruction,
    required this.onPickImage,
    this.padding,
    this.subTitle,
    this.height,
    this.width,
    this.image,
  });

  final String title;
  final bool isRequired;
  final VoidCallback? onSeeInstruction;
  final Function(XFile image) onPickImage;
  final EdgeInsets? padding;
  final Widget? subTitle;
  final double? height;
  final double? width;
  final XFile? image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: title,
              style: w600TextStyle(),
              children: isRequired
                  ? [
                      TextSpan(
                        text: '*',
                        style: w600TextStyle(color: appColorError),
                      )
                    ]
                  : null,
            ),
          ),
          subTitle ??
              Padding(
                padding: EdgeInsets.only(top: 4.sw, bottom: 16.sw),
                child: GestureDetector(
                  onTap: () {
                    appHaptic();
                    onSeeInstruction?.call();
                  },
                  child: Text(
                    'See instruction'.tr(),
                    style: w400TextStyle(
                      decoration: TextDecoration.underline,
                      color: blue1,
                    ),
                  ),
                ),
              ),
          WidgetRippleButton(
            onTap: () {
              _showImageSourceOptions(context, onPickImage);
            },
            radius: 4.sw,
            color: grey8,
            child: Container(
              height: height ?? 80.sw,
              width: width ?? 80.sw,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: image != null
                    ? DecorationImage(
                        image: AssetImage(image!.path),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const WidgetAppSVG('upload_image'),
                  Gap(2.sw),
                  WidgetGlassBackground(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.sw, vertical: 2.sw),
                    child: Text(
                      'Upload'.tr(),
                      style: w400TextStyle(
                          fontSize: 12.sw,
                          color: image == null ? grey1 : Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppUploadImage2 extends StatelessWidget {
  final String assetSvg;
  final Function(XFile image) onPickImage;
  final XFile? image;
  const AppUploadImage2(
      {super.key,
      required this.assetSvg,
      required this.onPickImage,
      this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        appHaptic();
        _showImageSourceOptions(context, onPickImage);
      },
      child: Stack(
        children: [
          if (image == null)
            WidgetAppSVG(
              assetSvg,
              width: (context.width - 55.sw) / 2,
              height: (context.width - 55.sw) / 3,
            )
          else
            DottedBorder(
              color: grey8,
              strokeWidth: 1,
              radius: Radius.circular(8),
              borderType: BorderType.RRect,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(image!.path),
                  fit: BoxFit.cover,
                  width: (context.width - 55.sw) / 2,
                  height: (context.width - 55.sw) / 3,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
