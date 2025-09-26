import 'package:flutter/material.dart';
import 'package:grain_and_gain_student/utils/theme/widget_themes/appbar_theme.dart';
import 'package:grain_and_gain_student/utils/theme/widget_themes/bottom_sheet_theme.dart';
import 'package:grain_and_gain_student/utils/theme/widget_themes/checkbox_theme.dart';
import 'package:grain_and_gain_student/utils/theme/widget_themes/chip_theme.dart';
import 'package:grain_and_gain_student/utils/theme/widget_themes/elevated_button_theme.dart';
import 'package:grain_and_gain_student/utils/theme/widget_themes/outlined_button_theme.dart';
import 'package:grain_and_gain_student/utils/theme/widget_themes/text_field_theme.dart';
import 'package:grain_and_gain_student/utils/theme/widget_themes/text_theme.dart';
import '../constants/colors.dart';

class FkAppTheme {
  FkAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    primarySwatch: FkColors.materialColor,
    fontFamily: 'Poppins',
    disabledColor: FkColors.grey,
    brightness: Brightness.light,
    primaryColor: FkColors.primary,
    textTheme: FkTextTheme.lightTextTheme,
    chipTheme: HkChipTheme.lightChipTheme,
    scaffoldBackgroundColor: FkColors.light,
    appBarTheme: HkAppBarTheme.lightAppBarTheme,
    //switchTheme: SwitchButtonTheme.lightSwitchTheme,
    checkboxTheme: HkCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: HkBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: HkElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: HkOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: HkTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: false,
    primarySwatch: FkColors.materialColor,
    fontFamily: 'Poppins',
    disabledColor: FkColors.grey,
    brightness: Brightness.dark,
    primaryColor: FkColors.primary,
    textTheme: FkTextTheme.darkTextTheme,
    chipTheme: HkChipTheme.darkChipTheme,
    scaffoldBackgroundColor: FkColors.dark,
    appBarTheme: HkAppBarTheme.darkAppBarTheme,
    //switchTheme: SwitchButtonTheme.darkSwitchTheme,
    checkboxTheme: HkCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: HkBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: HkElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: HkOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: HkTextFormFieldTheme.darkInputDecorationTheme,
  );
}
