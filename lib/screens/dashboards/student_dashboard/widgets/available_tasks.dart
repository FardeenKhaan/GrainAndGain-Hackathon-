import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grain_and_gain_student/data/models/task_model.dart';
import 'package:grain_and_gain_student/screens/tasks/task_detail_view.dart';
import 'package:iconsax/iconsax.dart';

class AvailableTasks extends StatelessWidget {
  const AvailableTasks({super.key, required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 200),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) => Transform.scale(scale: value, child: child),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade600,
            child: const Icon(Iconsax.task, color: Colors.white),
          ),
          title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.w600)),
          // subtitle: Text(task.description ?? "", maxLines: 2, overflow: TextOverflow.ellipsis),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.description ?? "", overflow: TextOverflow.ellipsis, maxLines: 2),
              const SizedBox(height: 4),
              Text(
                "By: ${task.restaurantName ?? 'Unknown Restaurant'}",
                // style: const TextStyle(fontSize: 12, color: Colors.grey),
                style: TextTheme.of(context).labelSmall,
              ),
            ],
          ),
          trailing: Text("${task.rewardPoints} pts", style: const TextStyle(color: Colors.green)),
          onTap: () => Get.to(() => TaskDetailView(task: task)),
        ),
      ),
    );
  }
}
