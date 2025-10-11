import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grain_and_gain_student/controllers/auth_controller.dart';
import 'package:grain_and_gain_student/controllers/task_controller.dart';
import 'package:grain_and_gain_student/screens/widgets/reuse_appbar.dart';
import 'package:grain_and_gain_student/utils/constants/colors.dart';

class CreateTaskView extends StatelessWidget {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rewardPointsController = TextEditingController();

  final taskController = Get.find<TaskController>();
  final authController = Get.find<AuthController>();

  CreateTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      appBar: FkAppBar(title: const Text("Create Task")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  "Task Details",
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: FkColors.primary),
                ),
                const SizedBox(height: 20),

                // 📝 Task Title
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Task Title",
                    hintText: "Enter task title (e.g., develop a feature)",
                    prefixIcon: const Icon(Icons.title_outlined),
                    filled: true,
                    fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                // 📄 Description
                TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "Describe what needs to be done...",
                    prefixIcon: const Icon(Icons.description_outlined),
                    filled: true,
                    fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                // 💰 Reward Points
                TextField(
                  controller: _rewardPointsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Reward Points",
                    hintText: "Enter points (e.g., 100)",
                    prefixIcon: const Icon(Icons.stars_rounded, color: Colors.amber),
                    filled: true,
                    fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 30),

                // 🎯 Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add_task_rounded),
                    onPressed: () async {
                      final title = _titleController.text.trim();
                      final description = _descriptionController.text.trim();
                      final points = int.tryParse(_rewardPointsController.text.trim()) ?? 0;
                      final restaurantId = authController.currentUser.value!.id;

                      if (title.isEmpty || points <= 0) {
                        Get.snackbar(
                          "Error",
                          "Please fill all required fields correctly.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent.withOpacity(0.8),
                          colorText: Colors.white,
                        );
                        return;
                      }

                      await taskController.createTask(restaurantId, title, description, points);

                      Get.back();
                      Get.snackbar(
                        "Success",
                        "Task created successfully!",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green.withOpacity(0.8),
                        colorText: Colors.white,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FkColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    label: const Text("Create Task"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
