import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grain_and_gain_student/controllers/auth_controller.dart';
import 'package:grain_and_gain_student/controllers/wallet_controller.dart';
import 'package:grain_and_gain_student/routers/routes.dart';
import 'package:iconsax/iconsax.dart';

class DashboardView extends StatelessWidget {
  final authController = Get.find<AuthController>();
  final walletController = Get.find<WalletController>();

  DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              authController.signOut();
              Get.offAllNamed(FkRoutes.logIn);
            },
          ),
        ],
      ),
      body: Obx(() {
        final user = authController.currentUser.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        // 👇 load wallet once after login
        if (walletController.wallet.value == null && !walletController.isLoading.value) {
          walletController.loadWallet(user.id);
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👤 Profile Section
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.blue.shade100,
                    backgroundImage: user.profilePicUrl != null ? NetworkImage(user.profilePicUrl!) : null,
                    child: user.profilePicUrl == null ? const Icon(Iconsax.user, size: 40, color: Colors.white) : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, ${user.name}",
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          user.email,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 💰 Wallet Card
              Obx(() {
                if (walletController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.pink.shade400, Colors.blue.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Meal Points", style: TextStyle(color: Colors.white70, fontSize: 16)),
                            const SizedBox(height: 8),
                            Text(
                              "${walletController.balance.value}",
                              style: Theme.of(
                                context,
                              ).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Icon(Iconsax.wallet, color: Colors.white, size: 40),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}
