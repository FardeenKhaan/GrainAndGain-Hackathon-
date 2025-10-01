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

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: FkColors.white),
        title: const Text("Create Task"),
      ),
      // appBar: FkAppBar(showBackButton: true, title: Text('Create Task')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Task Title"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _rewardPointsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Reward Points"),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                final title = _titleController.text.trim();
                final description = _descriptionController.text.trim();
                final points = int.tryParse(_rewardPointsController.text.trim()) ?? 0;
                final restaurantId = authController.currentUser.value!.id;

                if (title.isEmpty || points <= 0) {
                  Get.snackbar("Error", "Please fill all required fields");
                  return;
                }

                await taskController.createTask(restaurantId, title, description, points);

                Get.back(); // go back after creating
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                textStyle: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              child: const Text("Create Task"),
            ),
          ],
        ),
      ),
    );
  }
}
