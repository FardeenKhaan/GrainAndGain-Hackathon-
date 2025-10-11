import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class FkSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;

  const FkSectionHeader({super.key, required this.title, this.icon = Iconsax.category, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor ?? Colors.indigo),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
