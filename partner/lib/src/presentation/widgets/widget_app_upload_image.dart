import 'dart:io';

import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:app/src/constants/constants.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:internal_core/internal_core.dart';

// Function để crop image với aspect ratio specific
Future<XFile?> _cropImage(XFile imageFile, double aspectRatio) async {
  final croppedFile = await ImageCropper().cropImage(
    sourcePath: imageFile.path,
    aspectRatio: CropAspectRatio(ratioX: aspectRatio, ratioY: 1.0),
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Crop Image'.tr(),
        toolbarColor: Colors.black,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: true, // Khóa aspect ratio
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
        ],
      ),
      IOSUiSettings(
        title: 'Crop Image'.tr(),
        aspectRatioLockEnabled: true, // Khóa aspect ratio
        resetAspectRatioEnabled: false,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
        ],
      ),
    ],
  );

  if (croppedFile != null) {
    return XFile(croppedFile.path);
  }
  return null;
}

void _showImageSourceOptions(
    BuildContext context, Function(XFile) onImagePicked,
    {double? aspectRatio}) {
  Future<void> _pickImage(
      ImageSource source, Function(XFile) onImagePicked) async {
    context.pop();
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        if (aspectRatio != null) {
          // Crop image theo aspect ratio nếu có
          final croppedImage = await _cropImage(image, aspectRatio);
          if (croppedImage != null) {
            onImagePicked(croppedImage);
          }
        } else {
          onImagePicked(image);
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  appHaptic();
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return WidgetAppBottomSheet(
        title: 'Choose image source'.tr(),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () => _pickImage(ImageSource.camera, onImagePicked),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Gap(32.sw),
                    Container(
                      height: 72.sw,
                      width: 72.sw,
                      decoration: BoxDecoration(
                        border: Border.all(color: grey8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: const WidgetAppSVG('ic_camera'),
                      ),
                    ),
                    Gap(16.sw),
                    Text('Take a photo'.tr(), style: w400TextStyle()),
                    Gap(56.sw),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () => _pickImage(ImageSource.gallery, onImagePicked),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Gap(32.sw),
                    Container(
                      height: 72.sw,
                      width: 72.sw,
                      decoration: BoxDecoration(
                        border: Border.all(color: grey8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: const WidgetAppSVG('ic_gallery'),
                      ),
                    ),
                    Gap(16.sw),
                    Text('Choose from gallery'.tr(), style: w400TextStyle()),
                    Gap(56.sw),
                  ],
                ),
              ),
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
    this.xFileImage,
    this.imageUrl,
    this.aspectRatio,
  });

  final String title;
  final bool isRequired;
  final VoidCallback? onSeeInstruction;
  final Function(XFile image) onPickImage;
  final EdgeInsets? padding;
  final Widget? subTitle;
  final double? height;
  final double? width;
  final XFile? xFileImage;
  final String? imageUrl;
  final double? aspectRatio;

  bool get haveImage => xFileImage != null || imageUrl != null;

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
              _showImageSourceOptions(context, onPickImage,
                  aspectRatio: aspectRatio);
            },
            radius: 4.sw,
            color: grey8,
            child: SizedBox(
              height: height ?? 80.sw,
              width: width ?? 80.sw,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (imageUrl != null)
                    Positioned.fill(
                      child: WidgetAppImage(
                        imageUrl: imageUrl,
                        radius: 8,
                      ),
                    )
                  else if (xFileImage != null)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(xFileImage!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const WidgetAppSVG('upload_image'),
                      Gap(2.sw),
                      WidgetGlassBackground(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.sw, vertical: 2.sw),
                        child: Text(
                          'Upload'.tr(),
                          style: w400TextStyle(
                              fontSize: 12.sw,
                              color: !haveImage ? grey1 : Colors.white),
                        ),
                      ),
                    ],
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
  final double? aspectRatio;

  const AppUploadImage2(
      {super.key,
      required this.assetSvg,
      required this.onPickImage,
      this.image,
      this.aspectRatio});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        appHaptic();
        _showImageSourceOptions(context, onPickImage, aspectRatio: aspectRatio);
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
              options: RoundedRectDottedBorderOptions(
                color: grey8,
                strokeWidth: 1,
                radius: Radius.circular(8),
              ),
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
