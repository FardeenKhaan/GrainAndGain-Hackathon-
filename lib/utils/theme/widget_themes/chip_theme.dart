import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class HkChipTheme {
  HkChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: FkColors.grey.withOpacity(0.4),
    labelStyle: const TextStyle(color: FkColors.black),
    selectedColor: FkColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: FkColors.white,
  );

  static ChipThemeData darkChipTheme = const ChipThemeData(
    disabledColor: FkColors.darkerGrey,
    labelStyle: TextStyle(color: FkColors.white),
    selectedColor: FkColors.primary,
    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: FkColors.white,
  );
}
