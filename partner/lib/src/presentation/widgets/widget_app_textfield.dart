import 'package:app/src/constants/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';
import 'package:internal_core/internal_core.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:network_resources/network_resources.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.title,
    this.subTitle,
    this.isRequired = true,
    this.controller,
    this.maxLines,
    this.minLines,
    this.readOnly = false,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.hintText,
    this.onTap,
    this.padding,
  });

  final String? title;
  final String? subTitle;
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
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
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
            if (subTitle != null)
              Padding(
                padding: EdgeInsets.only(top: 4.sw, bottom: 8.sw),
                child: Text(
                  subTitle!,
                  style: w400TextStyle(color: appColorTextLabel),
                ),
              )
            else
              Gap(8.sw)
          ],
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
            onTap: onTap?.call,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              isDense: true,
              isCollapsed: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.sw, vertical: 12.sw),
              filled: true,
              fillColor: appColorBackground,
              hintText: hintText,
              hintStyle: w400TextStyle(
                fontSize: 16.sw,
                color: hexColor('#8A8C91'),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8.sw),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WidgetAppTextFieldPhone extends StatelessWidget {
  final String title;
  final String? subTitle;
  final bool isRequired;
  final String? hintText;
  final bool readOnly;
  final FocusNode? focusNode;
  final Function(PhoneNumber)? onChanged;
  final Function(dynamic)? onSubmitted;
  final PhoneNumber? initialValue;
  final String? Function(String?)? validator;

  const WidgetAppTextFieldPhone({
    super.key,
    required this.title,
    this.subTitle,
    this.isRequired = false,
    this.hintText,
    this.readOnly = false,
    this.focusNode,
    this.onChanged,
    this.initialValue,
    this.validator,
    this.onSubmitted,
  });

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
        if (subTitle != null)
          Padding(
            padding: EdgeInsets.only(top: 4.sw, bottom: 8.sw),
            child: Text(
              subTitle!,
              style: w400TextStyle(color: appColorTextLabel),
            ),
          )
        else
          Gap(8.sw),
        Container(
          decoration: BoxDecoration(
            color: appColorBackground,
            borderRadius: BorderRadius.circular(8.sw),
          ),
          child: InternationalPhoneNumberInput(
            onInputChanged: onChanged,
            onFieldSubmitted: onSubmitted,
            initialValue: initialValue,
            countries:
                ["VN"] + euroCounries.map((e) => e['code'].toString()).toList(),
            selectorConfig: SelectorConfig(
              selectorType: PhoneInputSelectorType.DROPDOWN,
              selectorTextStyle: w400TextStyle(fontSize: 16.sw),
              bgColor: Colors.white,
            ),
            ignoreBlank: false,
            autoValidateMode: AutovalidateMode.disabled,
            textStyle: w400TextStyle(fontSize: 16.sw),
            inputDecoration: InputDecoration(
              isDense: true,
              isCollapsed: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.sw, vertical: 8.sw),
              filled: true,
              fillColor: appColorBackground,
              hintText: hintText,
              hintStyle: w400TextStyle(
                fontSize: 16.sw,
                color: hexColor('#8A8C91'),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8.sw),
              ),
            ),
            validator: validator,
            spaceBetweenSelectorAndTextField: 0,
            keyboardType: TextInputType.phone,
            textFieldController: TextEditingController(),
            formatInput: true,
            keyboardAction: TextInputAction.done,
            cursorColor: appColorText,
          ),
        ),
      ],
    );
  }
}
