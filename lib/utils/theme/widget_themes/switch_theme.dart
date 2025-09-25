import 'package:flutter/material.dart';
import 'package:grain_and_gain_student/utils/constants/colors.dart';

class SwitchButtonTheme {
  SwitchButtonTheme._();

  static const lightSwitchTheme = SwitchThemeData(
    trackOutlineColor: WidgetStatePropertyAll(FkColors.primary),
    trackColor: WidgetStatePropertyAll(FkColors.primary),
    thumbColor: WidgetStatePropertyAll(FkColors.white),
  );

  static const darkSwitchTheme = SwitchThemeData(
    trackOutlineColor: WidgetStatePropertyAll(FkColors.dark),
    trackColor: WidgetStatePropertyAll(FkColors.dark),
    thumbColor: WidgetStatePropertyAll(FkColors.white),
  );
}
