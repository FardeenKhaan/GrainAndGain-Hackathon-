import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:grain_and_gain_student/controllers/auth_controller.dart';
import 'package:grain_and_gain_student/controllers/task_controller.dart';
import 'package:grain_and_gain_student/data/models/task_model.dart';
import 'package:grain_and_gain_student/utils/constants/colors.dart';
import 'package:grain_and_gain_student/utils/constants/sizes.dart';

class EditTaskView extends StatelessWidget {
  final TaskModel task;
  final taskController = Get.find<TaskController>();
  final authController = Get.find<AuthController>();

  EditTaskView({super.key, required this.task});

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final rewardController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = task.title;
    descController.text = task.description ?? "";
    rewardController.text = task.rewardPoints.toString();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: FkColors.white),
        title: const Text("Edit Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: FkSizes.spaceBtwItems,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),

            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: rewardController,
              decoration: const InputDecoration(labelText: "Reward Points"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final updates = {
                  'title': titleController.text,
                  'description': descController.text,
                  'reward_points': int.parse(rewardController.text),
                };
                taskController.updateTask(task.id, updates, authController.currentUser.value!.id);
                Get.back();
              },
              child: SizedBox(
                height: FkSizes.buttonHeight,
                width: FkSizes.buttonWidth,
                child: Center(child: const Text("Save Changes")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
