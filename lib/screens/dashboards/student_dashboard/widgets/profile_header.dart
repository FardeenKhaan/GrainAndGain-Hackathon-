import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:grain_and_gain_student/controllers/auth_controller.dart';
import 'package:grain_and_gain_student/data/models/user_model.dart';
import 'package:grain_and_gain_student/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user});

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final user = authController.currentUser.value;
    if (user == null) return const Center(child: CircularProgressIndicator());
    return AnimatedSlide(
      offset: const Offset(0, -0.2),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: 1,
        duration: const Duration(milliseconds: 500),
        child: Row(
          children: [
            Hero(
              tag: "profile_pic",
              child: CircleAvatar(
                radius: 35,
                backgroundColor: FkColors.secondary,
                backgroundImage: user.profilePicUrl != null ? NetworkImage(user.profilePicUrl!) : null,
                child: user.profilePicUrl == null ? const Icon(Iconsax.user, color: Colors.white, size: 36) : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi, ${user.name}",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(user.email, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
