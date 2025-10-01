import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      leading: showBackButton
          ? IconButton(
              onPressed: Get.back,
              icon: Icon(Iconsax.arrow_left2, color: dark ? Colors.white : Colors.white),
            )
          : null,
      title: title,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
