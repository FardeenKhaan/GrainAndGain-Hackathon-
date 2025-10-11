import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grain_and_gain_student/controllers/task_controller.dart';
import 'package:grain_and_gain_student/screens/widgets/reuse_appbar.dart';
import 'package:grain_and_gain_student/utils/constants/sizes.dart';
import '../../controllers/redemption_controller.dart';

class StudentRedemptionScreen extends GetView<RedemptionController> {
  final String studentId;

  StudentRedemptionScreen({super.key, required this.studentId});

  final taskController = Get.find<TaskController>();
  final TextEditingController pointsController = TextEditingController();
  final RxString selectedRestaurantId = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FkAppBar(title: const Text("Redeem Points")),
      body: Obx(() {
        if (controller.isLoading.value || taskController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Obx(
                () => DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Select Restaurant", border: OutlineInputBorder()),
                  value: selectedRestaurantId.value.isEmpty ? null : selectedRestaurantId.value,
                  items: taskController.restaurants.map((restaurant) {
                    return DropdownMenuItem(value: restaurant.id, child: Text(restaurant.name));
                  }).toList(),
                  onChanged: (value) => selectedRestaurantId.value = value ?? '',
                ),
              ),
              const SizedBox(height: FkSizes.md),

              TextField(
                controller: pointsController,
                decoration: const InputDecoration(labelText: "Points to Redeem", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: FkSizes.md),

              ElevatedButton.icon(
                icon: const Icon(Icons.redeem),
                label: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: const Text("Redeem Points"),
                ),
                onPressed: () async {
                  if (selectedRestaurantId.value.isEmpty || pointsController.text.isEmpty) {
                    Get.snackbar("Error", "Please select a restaurant and enter points");
                    return;
                  }

                  await controller.redeemPoints(
                    studentId,
                    selectedRestaurantId.value,
                    int.parse(pointsController.text),
                  );
                },
              ),
              const SizedBox(height: FkSizes.lg),

              const Text("Your Redemptions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: FkSizes.sm * 1.5),

              ...controller.redemptions.map(
                (r) => Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text("Restaurant: ${r.restaurantName ?? 'N/A'}"),
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
