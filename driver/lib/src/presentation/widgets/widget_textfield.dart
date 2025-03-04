import 'package:app/src/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:internal_core/internal_core.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/widgets/intl_phone_number_input/src/utils/selector_config.dart';
import 'package:internal_core/widgets/intl_phone_number_input/src/widgets/input_widget.dart';
import 'package:internal_core/widgets/intl_phone_number_input/src/utils/phone_number.dart';

enum TextFieldErrorType { hint, normal }

double get _heightContainer => 52.sw;

class WidgetTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hint;
  final String? label;
  final TextStyle? labelTextStyle;
  final Function(String value)? onSubmitted;
  final Function(String value)? onChanged;
  final TextInputType? keyboardType;
  final bool isPassword;
  final FocusNode? focusNode;
  final bool autoFocus;
  final Widget? sufixIconWidget;
  final dynamic formatters;
  final int? maxLines;
  final Widget? actionWidget;
  final Widget? prefixW;
  final String? error;
  final TextFieldErrorType errorType;
  final bool isReadOnly;

  const WidgetTextField({
    super.key,
    this.prefixW,
    this.formatters,
    this.autoFocus = true,
    this.controller,
    this.error,
    this.errorType = TextFieldErrorType.normal,
    this.keyboardType,
    this.hint,
    this.label,
    this.labelTextStyle,
    this.onSubmitted,
    this.onChanged,
    this.focusNode,
    this.isPassword = false,
    this.sufixIconWidget,
    this.maxLines,
    this.actionWidget,
    this.isReadOnly = false,
  });

  @override
  State<WidgetTextField> createState() => _WidgetTextFieldState();
}

class _WidgetTextFieldState extends State<WidgetTextField> {
  bool isHideText = false;
  TextEditingController? _controller = TextEditingController();
  FocusNode? _focusNode;

  double get _fontSize => 16;

  @override
  void initState() {
    isHideText = widget.isPassword;
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller?.addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller?.dispose();
    if (widget.focusNode == null) _focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.label!,
                  style:
                      widget.labelTextStyle ?? w500TextStyle(fontSize: 14.sw),
                ),
              ),
              if (widget.actionWidget != null) widget.actionWidget!,
            ],
          ),
          SizedBox(height: 12.sw),
        ],
        if (widget.error != null &&
            widget.errorType == TextFieldErrorType.normal) ...[
          Text(
            widget.error!,
            style: w300TextStyle(fontSize: 14, color: appColorPrimary),
          ),
          SizedBox(height: 12.sw),
        ],
        GestureDetector(
          onTap: widget.isReadOnly
              ? null
              : () {
                  _focusNode?.requestFocus();
                  setState(() {});
                },
          child: Container(
            height: widget.maxLines != null
                ? _fontSize * 1.4 * widget.maxLines! + 46 - _fontSize * 1.2
                : _heightContainer,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: hexColor('#FAFAFA'),
              border: Border.all(
                  width: widget.error == null ? 0 : 1,
                  color: widget.error == null
                      ? Colors.transparent
                      : appColorPrimary),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                if (widget.prefixW != null) widget.prefixW!,
                Expanded(
                  child: _isHintError()
                      ? Text(
                          widget.error!,
                          maxLines: 1,
                          style: w300TextStyle(
                                  fontSize: 16, color: appColorPrimary)
                              .copyWith(overflow: TextOverflow.ellipsis),
                        )
                      : TextField(
                          readOnly: widget.isReadOnly,
                          maxLines: widget.isPassword ? 1 : widget.maxLines,
                          inputFormatters: widget.formatters,
                          autofocus: widget.autoFocus,
                          focusNode: _focusNode,
                          onSubmitted: widget.onSubmitted,
                          onChanged: widget.onChanged,
                          keyboardType: widget.keyboardType,
                          textInputAction: TextInputAction.done,
                          controller: widget.controller,
                          obscureText: isHideText,
                          enableSuggestions: !widget.isPassword,
                          autocorrect: !widget.isPassword,
                          style: w400TextStyle(
                              color: appColorText,
                              fontSize: _fontSize,
                              height: widget.maxLines != null ? 1.4 : 1.2),
                          decoration: InputDecoration.collapsed(
                            hintStyle: w300TextStyle(
                                fontSize: _fontSize,
                                color: hexColor('#86888C')),
                            hintText: widget.hint,
                          ),
                        ),
                ),
                if (widget.sufixIconWidget != null)
                  widget.sufixIconWidget!
                else if (widget.isPassword)
                  GestureDetector(
                    onTap: () {
                      appHaptic();
                      setState(() {
                        isHideText = !isHideText;
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 8, left: 4, top: 2, bottom: 2),
                        child: isHideText
                            ? Icon(CupertinoIcons.eye_slash,
                                color: appColorPrimary, size: 24.sw)
                            : Icon(CupertinoIcons.eye,
                                color: appColorPrimary, size: 24.sw),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool _isHintError() {
    return (widget.error != null &&
        widget.errorType == TextFieldErrorType.hint);
  }
}

class WidgetTextFieldPhone extends StatefulWidget {
  final TextEditingController? controller;
  final String? hint;
  final String? label;
  final TextStyle? labelTextStyle;
  final Function(String value)? onSubmitted;
  final String? initialValue;
  final String initialCountryCode;
  final Function(PhoneNumber phoneNumber)? onPhoneNumberChanged;
  final Function(bool isValid)? onInputValidated;
  final FocusNode? focusNode;
  final bool autoFocus;
  final String? error;
  final TextFieldErrorType errorType;

  const WidgetTextFieldPhone({
    super.key,
    this.controller,
    this.hint,
    this.label,
    this.labelTextStyle,
    this.onSubmitted,
    this.initialValue,
    this.initialCountryCode = 'HU',
    this.onPhoneNumberChanged,
    this.onInputValidated,
    this.focusNode,
    this.autoFocus = false,
    this.error,
    this.errorType = TextFieldErrorType.normal,
  });

  @override
  State<WidgetTextFieldPhone> createState() => _WidgetTextFieldPhoneState();
}

class _WidgetTextFieldPhoneState extends State<WidgetTextFieldPhone> {
  TextEditingController? _controller = TextEditingController();
  FocusNode? _focusNode;

  double get _fontSize => 16;

  @override
  void initState() {
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _controller?.addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller?.dispose();
    if (widget.focusNode == null) _focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: widget.labelTextStyle ?? w500TextStyle(fontSize: 14.sw),
          ),
          SizedBox(height: 12.sw),
        ],
        if (widget.error != null &&
            widget.errorType == TextFieldErrorType.normal) ...[
          Text(
            widget.error!,
            style: w300TextStyle(fontSize: 14, color: appColorPrimary),
          ),
          SizedBox(height: 12.sw),
        ],
        GestureDetector(
          onTap: () {
            _focusNode?.requestFocus();
            setState(() {});
          },
          child: InternationalPhoneNumberInput(
            textFieldController: _controller,
            onInputValidated: widget.onInputValidated,
            spaceBetweenSelectorAndTextField: 12.sw,
            initialValue: PhoneNumber(isoCode: widget.initialCountryCode),
            selectorConfig: SelectorConfig(
              trailingSpace: false,
              selectorTextStyle: w400TextStyle(
                  color: appColorText, fontSize: _fontSize, height: 1.2),
            ),
            textStyle: w400TextStyle(
                color: appColorText, fontSize: _fontSize, height: 1.2),
            inputDecoration: InputDecoration.collapsed(
              border: InputBorder.none,
              hintText: widget.hint,
              hintStyle: w300TextStyle(
                  fontSize: _fontSize, color: hexColor('#86888C')),
            ),
            builderTextField: (child) {
              return Container(
                height: _heightContainer,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: hexColor('#FAFAFA'),
                  border: Border.all(
                      width: widget.error == null ? 0 : 1,
                      color: widget.error == null
                          ? Colors.transparent
                          : appColorPrimary),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: child,
              );
            },
            builderButtonSelector: (child) {
              return Container(
                height: _heightContainer,
                padding: const EdgeInsets.only(left: 8, right: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: hexColor('#FAFAFA'),
                  border: Border.all(
                      width: widget.error == null ? 0 : 1,
                      color: widget.error == null
                          ? Colors.transparent
                          : appColorPrimary),
                ),
                alignment: Alignment.center,
                child: child,
              );
            },
            onInputChanged: widget.onPhoneNumberChanged,
            onFieldSubmitted: widget.onSubmitted,
          ),
        ),
      ],
    );
  }
}
