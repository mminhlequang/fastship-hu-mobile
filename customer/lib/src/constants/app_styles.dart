import 'package:app/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';

BoxDecoration get appBoxDecorationUnSelected => BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: hexColor('#F1EFE9')),
      color: Colors.white,
    );

BoxDecoration get appBoxDecorationSelected => BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: appColorPrimary),
      color: hexColor('#F9F8F6'),
    );
