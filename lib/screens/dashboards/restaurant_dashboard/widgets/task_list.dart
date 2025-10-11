import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:grain_and_gain_student/controllers/task_controller.dart';
import 'package:grain_and_gain_student/data/models/task_model.dart';
import 'package:grain_and_gain_student/data/models/user_model.dart';
import 'package:grain_and_gain_student/screens/tasks/restaurant/edit_task.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.task,
    required this.statusColor,
    required this.taskController,
    required this.user,
  });

  final TaskModel task;
  final MaterialColor statusColor;
  final TaskController taskController;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink.shade400, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.description ?? "", maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            Chip(
              label: Text(task.status.toUpperCase(), style: const TextStyle(color: Colors.white)),
              backgroundColor: statusColor,
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == "edit") {
              Get.to(() => EditTaskView(task: task));
            } else if (value == "delete") {
              taskController.deleteTask(task.id, user.id);
            } else {
              taskController.changeStatus(task.id, value, user.id);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: "edit", child: Text("Edit")),
            const PopupMenuItem(value: "delete", child: Text("Delete")),
            const PopupMenuDivider(),
            const PopupMenuItem(value: "open", child: Text("Mark as Open")),
            const PopupMenuItem(value: "in_progress", child: Text("Mark as In Progress")),
            const PopupMenuItem(value: "completed", child: Text("Mark as Completed")),
          ],
        ),
      ),
    );
  }
}
