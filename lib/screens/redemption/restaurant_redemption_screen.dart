import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grain_and_gain_student/screens/widgets/reuse_appbar.dart';
import 'package:iconsax/iconsax.dart';
import '../../controllers/redemption_controller.dart';

class RestaurantRedemptionScreen extends StatelessWidget {
  final String restaurantId;

  RestaurantRedemptionScreen({super.key, required this.restaurantId});

  final redemptionController = Get.find<RedemptionController>();
  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    redemptionController.loadRestaurantRedemptions(restaurantId);

    return Scaffold(
      appBar: FkAppBar(title: const Text("Validate Redemptions")),
      body: Obx(() {
        if (redemptionController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Input for redemption code
              TextField(
                controller: codeController,
                decoration: const InputDecoration(labelText: "Enter Redemption Code", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),

              ElevatedButton.icon(
                icon: Icon(Iconsax.verify),
                onPressed: () async {
                  if (codeController.text.isEmpty) {
                    Get.snackbar("Error", "Please enter a code");
                    return;
                  }
                  await redemptionController.validateCode(codeController.text);
                },
                label: Padding(padding: const EdgeInsets.all(8.0), child: const Text("Validate Code")),
              ),

              const SizedBox(height: 24),

              const Text("All Redemptions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              ...redemptionController.redemptions.map(
                (r) => Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text("Student: ${r.studentName ?? 'N/A'}"),
                    subtitle: Text("Code: ${r.code}\nPoints: ${r.pointsUsed}\nStatus: ${r.status}"),
                    trailing: Text(
                      r.createdAt.toLocal().toString().split(' ').first,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
