import 'package:app/src/constants/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';

class WidgetSearchField extends StatefulWidget {
 final VoidCallback? onTap;
  final TextEditingController? controller;
  const WidgetSearchField({super.key, this.onTap, this.controller});


  @override
  State<WidgetSearchField> createState() => _WidgetSearchFieldState();
}

class _WidgetSearchFieldState extends State<WidgetSearchField> {
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ?? () {
              focusNode.requestFocus();
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(56),
        ),
        child: Row(
          children: [
            WidgetAppSVG(
              'icon29',
              width: 24.sw,
              height: 24.sw,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                focusNode: focusNode,
                controller: widget.controller,
                onTap: widget.onTap,
                style: w400TextStyle(
                  fontSize: 16.sw,
                ),
                decoration: InputDecoration.collapsed(
                  border: InputBorder.none,
                  hintText: 'What are you craving?.....'.tr(),
                  hintStyle: w400TextStyle(
                    fontSize: 16.sw,
                    color: const Color(0xFFACA9A9),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}