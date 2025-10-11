import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:grain_and_gain_student/data/models/user_model.dart';
import 'package:grain_and_gain_student/screens/redemption/restaurant_redemption_screen.dart';
import 'package:grain_and_gain_student/screens/redemption/student_redemption_screen.dart';
import 'package:grain_and_gain_student/utils/constants/colors.dart';
import 'package:grain_and_gain_student/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FkSizes.borderRadiusLg)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(FkSizes.defaultSpace),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: FkColors.secondary,
              backgroundImage: user.profilePicUrl != null ? NetworkImage(user.profilePicUrl!) : null,
              child: user.profilePicUrl == null ? const Icon(Iconsax.user, size: 40, color: Colors.white) : null,
            ),
            const SizedBox(width: FkSizes.defaultSpace),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome, ${user.name}",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(user.email),
                  const SizedBox(height: FkSizes.sm),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.qr_code_2),
                    label: const Text("Validate Redemption"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (user.role == 'student') {
                        Get.to(() => StudentRedemptionScreen(studentId: user.id));
                      } else if (user.role == 'restaurant') {
                        Get.to(() => RestaurantRedemptionScreen(restaurantId: user.id));
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
