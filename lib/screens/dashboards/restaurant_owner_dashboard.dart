import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grain_and_gain_student/controllers/auth_controller.dart';
import 'package:grain_and_gain_student/routers/routes.dart';
import 'package:iconsax/iconsax.dart';

class RestaurantDashboardView extends StatelessWidget {
  final authController = Get.find<AuthController>();

  RestaurantDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = authController.currentUser.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.logout, color: Colors.red),
            onPressed: () {
              authController.signOut();
              Get.offAllNamed(FkRoutes.logIn);
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome, ${user.name}", style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 20),

                  // 🚀 Add restaurant-specific features here
                  ElevatedButton(
                    onPressed: () {
                      // TODO: navigate to "Create Task" screen
                    },
                    child: const Text("Create New Task"),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      // TODO: navigate to "Manage Wallets" screen
                    },
                    child: const Text("Manage Student Wallets"),
                  ),
                ],
              ),
            ),
    );
  }
}
