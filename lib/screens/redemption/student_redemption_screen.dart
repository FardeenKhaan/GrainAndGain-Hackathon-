import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grain_and_gain_student/controllers/task_controller.dart';
import '../../controllers/redemption_controller.dart';
import '../../controllers/auth_controller.dart'; // assuming you have it
import '../../controllers/wallet_controller.dart'; // optional, if you fetch balance

// class StudentRedemptionScreen extends StatelessWidget {
//   final RedemptionController controller = Get.put(RedemptionController());
//   final WalletController walletController = Get.find<WalletController>();
//   final AuthController authController = Get.find<AuthController>();

//   final TextEditingController restaurantIdController = TextEditingController();
//   final TextEditingController pointsController = TextEditingController();

//   StudentRedemptionScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final studentId = authController.currentUser.value!.id;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Redeem Points"), backgroundColor: Colors.teal),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Obx(() {
//           if (controller.isLoading.value) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final wallet = walletController.wallet.value;

//           return SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Available Points: ${wallet?.balancePoints ?? 0}",
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),

//                 const SizedBox(height: 24),
//                 TextField(
//                   controller: restaurantIdController,
//                   decoration: const InputDecoration(labelText: "Restaurant ID", border: OutlineInputBorder()),
//                 ),

//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: pointsController,
//                   decoration: const InputDecoration(labelText: "Points to Redeem", border: OutlineInputBorder()),
//                   keyboardType: TextInputType.number,
//                 ),

//                 const SizedBox(height: 24),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.teal,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                     ),
//                     icon: const Icon(Icons.card_giftcard),
//                     label: const Text("Redeem Points"),
//                     onPressed: () async {
//                       final restaurantId = restaurantIdController.text.trim();
//                       final points = int.tryParse(pointsController.text.trim()) ?? 0;

//                       if (restaurantId.isEmpty || points <= 0) {
//                         Get.snackbar("Error", "Enter valid restaurant and points");
//                         return;
//                       }

//                       await controller.redeemPoints(studentId, restaurantId, points);
//                       restaurantIdController.clear();
//                       pointsController.clear();
//                     },
//                   ),
//                 ),

//                 const Divider(height: 40),
//                 const Text("My Redemptions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

//                 const SizedBox(height: 12),
//                 Obx(() {
//                   if (controller.redemptions.isEmpty) {
//                     return const Text("No redemptions yet.");
//                   }

//                   // return ListView.builder(
//                   //   shrinkWrap: true,
//                   //   physics: const NeverScrollableScrollPhysics(),
//                   //   itemCount: controller.redemptions.length,
//                   //   itemBuilder: (context, index) {
//                   //     final r = controller.redemptions[index];
//                   //     return Card(
//                   //       margin: const EdgeInsets.symmetric(vertical: 6),
//                   //       child: ListTile(
//                   //         leading: const Icon(Icons.confirmation_num),
//                   //         title: Text("Code: ${r.code}"),
//                   //         subtitle: Text("Points: ${r.pointsUsed} | Status: ${r.status}"),
//                   //         trailing: Text(r.status == "used" ? "✅" : "🕒", style: const TextStyle(fontSize: 18)),
//                   //       ),
//                   //     );
//                   //   },
//                   // );
//                   return ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: controller.redemptions.length,
//                     itemBuilder: (context, index) {
//                       final r = controller.redemptions[index];
//                       return Card(
//                         margin: const EdgeInsets.symmetric(vertical: 6),
//                         child: ListTile(
//                           leading: const Icon(Icons.confirmation_num),
//                           title: Text("Code: ${r.code}"),
//                           subtitle: Text("Points: ${r.pointsUsed} | Status: ${r.status}"),
//                           trailing: Text(r.status == "used" ? "✅" : "🕒", style: const TextStyle(fontSize: 18)),
//                         ),
//                       );
//                     },
//                   );
//                 }),
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

// class StudentRedemptionScreen extends StatelessWidget {
//   final String studentId;

//   StudentRedemptionScreen({super.key, required this.studentId});

//   final taskController = Get.find<TaskController>();
//   final redemptionController = Get.find<RedemptionController>();

//   final TextEditingController pointsController = TextEditingController();
//   final RxString selectedRestaurantId = ''.obs;

//   @override
//   Widget build(BuildContext context) {
//     // Load data once
//     redemptionController.loadStudentRedemptions(studentId);
//     taskController.loadRestaurants(); // ensure this method exists in TaskController

//     return Scaffold(
//       appBar: AppBar(title: const Text("Redeem Points")),
//       body: Obx(() {
//         if (redemptionController.isLoading.value || taskController.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               // 🏪 Restaurant Dropdown
//               // DropdownButtonFormField<String>(
//               //   decoration: const InputDecoration(
//               //     labelText: "Select Restaurant",
//               //     border: OutlineInputBorder(),
//               //   ),
//               //   value: selectedRestaurantId.value.isEmpty ? null : selectedRestaurantId.value,
//               //   items: taskController.restaurants.map((restaurant) {
//               //     return DropdownMenuItem(
//               //       value: restaurant.id,
//               //       child: Text(restaurant.name),
//               //     );
//               //   }).toList(),
//               //   onChanged: (value) => selectedRestaurantId.value = value ?? '',
//               // ),
//               Obx(
//                 () => DropdownButtonFormField<String>(
//                   decoration: const InputDecoration(labelText: "Select Restaurant", border: OutlineInputBorder()),
//                   value: selectedRestaurantId.value.isEmpty ? null : selectedRestaurantId.value,
//                   items: taskController.restaurants.map((restaurant) {
//                     return DropdownMenuItem(value: restaurant.id, child: Text(restaurant.name));
//                   }).toList(),
//                   onChanged: (value) => selectedRestaurantId.value = value ?? '',
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // 💎 Points Input
//               TextField(
//                 controller: pointsController,
//                 decoration: const InputDecoration(labelText: "Points to Redeem", border: OutlineInputBorder()),
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 16),

//               // 🔘 Redeem Button
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.redeem),
//                 onPressed: () async {
//                   if (selectedRestaurantId.value.isEmpty || pointsController.text.isEmpty) {
//                     Get.snackbar("Error", "Please select a restaurant and enter points");
//                     return;
//                   }
//                   await redemptionController.redeemPoints(
//                     studentId,
//                     selectedRestaurantId.value,
//                     int.parse(pointsController.text),
//                   );
//                 },
//                 label: const Text("Redeem Points"),
//               ),
//               const SizedBox(height: 24),

//               // 📋 Redemption History
//               const Text("Your Redemptions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 12),

//               ...redemptionController.redemptions.map(
//                 (r) => Card(
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   child: ListTile(
//                     title: Text("Restaurant: ${r.restaurantName ?? 'N/A'}"),
//                     subtitle: Text("Code: ${r.code}\nPoints: ${r.pointsUsed}\nStatus: ${r.status}"),
//                     trailing: Text(
//                       r.createdAt.toLocal().toString().split(' ').first,
//                       style: const TextStyle(fontSize: 12),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }

class StudentRedemptionScreen extends GetView<RedemptionController> {
  final String studentId;

  StudentRedemptionScreen({super.key, required this.studentId});

  final taskController = Get.find<TaskController>();
  final TextEditingController pointsController = TextEditingController();
  final RxString selectedRestaurantId = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Redeem Points")),
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
              const SizedBox(height: 16),

              TextField(
                controller: pointsController,
                decoration: const InputDecoration(labelText: "Points to Redeem", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              ElevatedButton.icon(
                icon: const Icon(Icons.redeem),
                label: const Text("Redeem Points"),
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
              const SizedBox(height: 24),

              const Text("Your Redemptions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

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
