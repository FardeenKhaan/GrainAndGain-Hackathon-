import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/redemption_controller.dart';
import '../../controllers/auth_controller.dart';

// class RestaurantValidateScreen extends StatelessWidget {
//   final RedemptionController controller = Get.put(RedemptionController());
//   final AuthController authController = Get.find<AuthController>();

//   final TextEditingController codeController = TextEditingController();

//   RestaurantValidateScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final restaurantId = authController.currentUser.value!.id;

//     // Load restaurant redemptions initially
//     controller.loadRestaurantRedemptions(restaurantId);

//     return Scaffold(
//       appBar: AppBar(title: const Text("Validate Redemptions"), backgroundColor: Colors.deepOrange),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Obx(() {
//           if (controller.isLoading.value) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextField(
//                   controller: codeController,
//                   decoration: const InputDecoration(labelText: "Enter 6-digit Code", border: OutlineInputBorder()),
//                 ),

//                 const SizedBox(height: 16),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.deepOrange,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                     ),
//                     icon: const Icon(Icons.qr_code_2),
//                     label: const Text("Validate Code"),
//                     onPressed: () async {
//                       final code = codeController.text.trim();
//                       if (code.isEmpty) {
//                         Get.snackbar("Error", "Please enter a code");
//                         return;
//                       }

//                       await controller.validateCode(code);
//                       codeController.clear();

//                       // Refresh list after validation
//                       await controller.loadRestaurantRedemptions(restaurantId);
//                     },
//                   ),
//                 ),

//                 const Divider(height: 40),
//                 const Text("Recent Redemptions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

//                 const SizedBox(height: 12),
//                 Obx(() {
//                   if (controller.redemptions.isEmpty) {
//                     return const Text("No redemptions yet.");
//                   }

//                   return ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: controller.redemptions.length,
//                     itemBuilder: (context, index) {
//                       final r = controller.redemptions[index];
//                       return Card(
//                         margin: const EdgeInsets.symmetric(vertical: 6),
//                         child: ListTile(
//                           title: Text("Code: ${r.code}"),
//                           subtitle: Text("Student: ${r.studentId.substring(0, 8)} | Points: ${r.pointsUsed}"),
//                           trailing: Text(
//                             r.status == "used" ? "✅ Used" : "🟡 Unused",
//                             style: TextStyle(
//                               color: r.status == "used" ? Colors.green : Colors.orange,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
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

class RestaurantRedemptionScreen extends StatelessWidget {
  final String restaurantId;

  RestaurantRedemptionScreen({super.key, required this.restaurantId});

  final redemptionController = Get.find<RedemptionController>();
  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    redemptionController.loadRestaurantRedemptions(restaurantId);

    return Scaffold(
      appBar: AppBar(title: const Text("Validate Redemptions")),
      body: Obx(() {
        if (redemptionController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 🔍 Input for redemption code
              TextField(
                controller: codeController,
                decoration: const InputDecoration(labelText: "Enter Redemption Code", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),

              ElevatedButton.icon(
                icon: const Icon(Icons.verified),
                onPressed: () async {
                  if (codeController.text.isEmpty) {
                    Get.snackbar("Error", "Please enter a code");
                    return;
                  }
                  await redemptionController.validateCode(codeController.text);
                },
                label: const Text("Validate Code"),
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
