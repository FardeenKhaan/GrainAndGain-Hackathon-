import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class HkTextFormFieldTheme {
  HkTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: FkColors.darkGrey,
    suffixIconColor: FkColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: TSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: FkSizes.fontSizeMd, color: FkColors.black),
    hintStyle: const TextStyle().copyWith(fontSize: FkSizes.fontSizeSm, color: FkColors.black),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(color: FkColors.black.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(FkSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: FkColors.grey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(FkSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: FkColors.grey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(FkSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: FkColors.dark),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(FkSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: FkColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(FkSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: FkColors.warning),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: FkColors.darkGrey,
    suffixIconColor: FkColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: TSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: FkSizes.fontSizeMd, color: FkColors.white),
    hintStyle: const TextStyle().copyWith(fontSize: FkSizes.fontSizeSm, color: FkColors.white),
    floatingLabelStyle: const TextStyle().copyWith(color: FkColors.white.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(FkSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: FkColors.darkGrey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(FkSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: FkColors.darkGrey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(FkSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: FkColors.white),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(FkSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: FkColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(FkSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: FkColors.warning),
    ),
  );
}
