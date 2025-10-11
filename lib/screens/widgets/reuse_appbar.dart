import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grain_and_gain_student/utils/constants/colors.dart';
import 'package:grain_and_gain_student/utils/helpers/helper_functions.dart';
import 'package:iconsax/iconsax.dart';

class FkAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FkAppBar({super.key, this.showBackButton = false, this.title, this.actions});

  final bool showBackButton;
  final Widget? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final dark = FkHelperFunctions.isDarkMode(context);

    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      iconTheme: IconThemeData(color: dark ? FkColors.light : FkColors.dark),
      leading: showBackButton ? IconButton(onPressed: Get.back, icon: Icon(Iconsax.arrow_left2)) : null,
      title: title,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
