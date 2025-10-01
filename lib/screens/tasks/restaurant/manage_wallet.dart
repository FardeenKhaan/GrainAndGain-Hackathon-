import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grain_and_gain_student/controllers/wallet_controller.dart';

class ManageWalletsView extends StatelessWidget {
  final WalletController walletController = Get.find<WalletController>();

  ManageWalletsView({super.key});

  final _studentIdController = TextEditingController();
  final _pointsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Wallets")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _studentIdController,
              decoration: const InputDecoration(labelText: "Student ID"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pointsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "New Balance Points"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final studentId = _studentIdController.text.trim();
                final points = int.tryParse(_pointsController.text.trim()) ?? -1;

                if (studentId.isEmpty || points < 0) {
                  Get.snackbar("Error", "Please provide valid student ID and points");
                  return;
                }

                await walletController.updateBalance(points);
                Get.snackbar("Success", "Wallet updated for student $studentId");
              },
              child: const Text("Update Wallet"),
            ),
          ],
        ),
      ),
    );
  }
}
