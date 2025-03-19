import 'package:app/src/constants/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internal_core/internal_core.dart';

class AppUploadImage extends StatelessWidget {
  const AppUploadImage({
    super.key,
    required this.title,
    this.isRequired = true,
    this.onSeeInstruction,
    required this.onPickImage,
    this.padding,
    this.subTitle,
    this.width,
  });

  final String title;
  final bool isRequired;
  final VoidCallback? onSeeInstruction;
  final Function(XFile image) onPickImage;
  final EdgeInsets? padding;
  final Widget? subTitle;
  final double? width;

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
              ImagePicker().pickImage(source: ImageSource.camera).then((value) {
                if (value != null) {
                  onPickImage.call(value);
                }
              });
            },
            radius: 4.sw,
            color: grey8,
            child: SizedBox(
              height: 80.sw,
              width: width ?? 80.sw,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const WidgetAppSVG('upload_image'),
                  Gap(2.sw),
                  Text(
                    'Upload'.tr(),
                    style: w400TextStyle(fontSize: 12.sw, color: grey1),
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
