import 'package:flutter/material.dart';
import 'package:grain_and_gain_student/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';

class FkSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color textColor;

  const FkSectionHeader({
    super.key,
    required this.title,
    this.icon = Iconsax.category,
    this.iconColor = Colors.indigo,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: FkSizes.sm),
        Text(
          title,
          // style: TextStyle(
          //   fontSize: 20,
          //   fontWeight: FontWeight.bold,
          //   color: textColor,
          // ),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: textColor),
        ),
      ],
    );
  }
}
