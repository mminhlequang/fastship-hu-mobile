import 'package:app/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/setup/app_textstyles.dart';
import 'package:internal_core/setup/app_utils.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.title,
    this.isRequired = true,
    this.controller,
    this.maxLines,
    this.minLines,
    this.readOnly = false,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onSubmitted,
    this.hintText,
  });

  final String title;
  final bool isRequired;
  final TextEditingController? controller;
  final int? maxLines;
  final int? minLines;
  final bool readOnly;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final Function(String value)? onChanged;
  final Function(String value)? onSubmitted;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Gap(8.sw),
        TextFormField(
          controller: controller,
          style: w400TextStyle(fontSize: 16.sw),
          maxLines: maxLines,
          minLines: minLines,
          readOnly: readOnly,
          focusNode: focusNode,
          keyboardType: keyboardType,
          cursorColor: appColorText,
          onChanged: onChanged?.call,
          onFieldSubmitted: onSubmitted?.call,
          decoration: InputDecoration(
            isDense: true,
            isCollapsed: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12.sw, vertical: 8.sw),
            filled: true,
            fillColor: appColorBackground,
            hintText: hintText,
            hintStyle: w400TextStyle(fontSize: 16.sw, color: hexColor('#8A8C91')),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8.sw),
            ),
          ),
        ),
      ],
    );
  }
}
