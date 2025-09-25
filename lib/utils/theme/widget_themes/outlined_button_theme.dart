import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

/* -- Light & Dark Outlined Button Themes -- */
class HkOutlinedButtonTheme {
  HkOutlinedButtonTheme._(); //To avoid creating instances

  /* -- Light Theme -- */
  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: FkColors.dark,
      side: const BorderSide(color: FkColors.borderPrimary),
      textStyle: const TextStyle(fontSize: 16, color: FkColors.black, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: FkSizes.buttonHeight, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FkSizes.buttonRadius)),
    ),
  );

  /* -- Dark Theme -- */
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: FkColors.light,
      side: const BorderSide(color: FkColors.borderPrimary),
      textStyle: const TextStyle(fontSize: 16, color: FkColors.textWhite, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: FkSizes.buttonHeight, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FkSizes.buttonRadius)),
    ),
  );
}
