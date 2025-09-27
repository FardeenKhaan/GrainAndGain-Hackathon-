import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grain_and_gain_student/controllers/auth_controller.dart';
import 'package:grain_and_gain_student/controllers/task_controller.dart';
import 'package:grain_and_gain_student/data/models/task_model.dart';
import 'package:grain_and_gain_student/utils/constants/colors.dart';

class TaskDetailView extends StatelessWidget {
  final TaskModel task;
  final AuthController authController = Get.find<AuthController>();
  final TaskController taskController = Get.find<TaskController>();

  TaskDetailView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: FkColors.white),
        title: const Text("Task Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(task.title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // Reward points
            Row(
              children: [
                const Icon(Icons.stars, color: Colors.amber),
                const SizedBox(width: 6),
                Text(
                  "${task.rewardPoints} Points",
                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.amber[700]),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Description
            Text(task.description ?? "No description provided.", style: theme.textTheme.bodyLarge),
            const SizedBox(height: 24),

            // Status
            Chip(
              label: Text(task.status.toUpperCase()),
              backgroundColor: task.status == "open" ? Colors.green.shade100 : Colors.grey.shade300,
              labelStyle: TextStyle(color: task.status == "open" ? Colors.green.shade800 : Colors.grey.shade600),
            ),
            const Spacer(),

            // Apply button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: task.status == "open"
                    ? () {
                        final studentId = authController.currentUser.value!.id;
                        taskController.applyForTask(task.id, studentId);
                        Get.back(); // go back after applying
                      }
                    : null,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("Apply for Task"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
