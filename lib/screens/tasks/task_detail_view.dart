import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grain_and_gain_student/controllers/auth_controller.dart';
import 'package:grain_and_gain_student/controllers/submission_controller.dart';
import 'package:grain_and_gain_student/controllers/task_controller.dart';
import 'package:grain_and_gain_student/data/models/task_model.dart';
import 'package:grain_and_gain_student/routers/routes.dart';
import 'package:grain_and_gain_student/utils/constants/colors.dart';
import 'package:grain_and_gain_student/utils/constants/sizes.dart';

// class TaskDetailView extends StatelessWidget {
//   final TaskModel task;
//   final AuthController authController = Get.find<AuthController>();
//   final TaskController taskController = Get.find<TaskController>();
//   final SubmissionController submissionController = Get.find<SubmissionController>();

//   TaskDetailView({super.key, required this.task});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: FkColors.white),
//         title: const Text("Task Details"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Title
//             Text(task.title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),

//             // Reward points
//             Row(
//               children: [
//                 const Icon(Icons.stars, color: Colors.amber),
//                 const SizedBox(width: 6),
//                 Text(
//                   "${task.rewardPoints} Points",
//                   style: theme.textTheme.titleMedium?.copyWith(color: Colors.amber[700]),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // Description
//             Text(task.description ?? "No description provided.", style: theme.textTheme.bodyLarge),
//             const SizedBox(height: 24),

//             // Status
//             Chip(
//               label: Text(task.status.toUpperCase()),
//               backgroundColor: task.status == "open" ? Colors.green.shade100 : Colors.grey.shade300,
//               labelStyle: TextStyle(color: task.status == "open" ? Colors.green.shade800 : Colors.grey.shade600),
//             ),
//             const Spacer(),

//             // 👇 Submit Proof Button with Loading
//             Obx(() {
//               return ElevatedButton.icon(
//                 onPressed: submissionController.isLoading.value
//                     ? null
//                     : () async {
//                         final result = await FilePicker.platform.pickFiles(type: FileType.image);
//                         if (result != null && result.files.single.path != null) {
//                           final file = File(result.files.single.path!);
//                           final studentId = authController.currentUser.value!.id;

//                           try {
//                             await submissionController.uploadAndSubmitProof(file, studentId, task.id);
//                           } catch (e) {
//                             Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
//                           }
//                         }
//                       },
//                 icon: submissionController.isLoading.value
//                     ? const SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
//                       )
//                     : const Icon(Icons.upload_file),
//                 label: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Text(submissionController.isLoading.value ? "Uploading..." : "Submit Proof"),
//                 ),
//               );
//             }),

//             const SizedBox(height: FkSizes.spaceBtwItems),

//             // Apply button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: task.status == "open"
//                     ? () {
//                         final studentId = authController.currentUser.value!.id;
//                         taskController.applyForTask(task.id, studentId);
//                         Get.toNamed(FkRoutes.dashboard); // go back after applying
//                       }
//                     : null,
//                 icon: const Icon(Icons.check_circle_outline),
//                 label: const Text("Apply for Task"),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class TaskDetailView extends StatelessWidget {
  final TaskModel task;
  final AuthController authController = Get.find<AuthController>();
  final TaskController taskController = Get.find<TaskController>();
  final SubmissionController submissionController = Get.find<SubmissionController>();

  TaskDetailView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final studentId = authController.currentUser.value!.id;

    // 👇 Look for existing submission for this task
    final submission = submissionController.submissions.firstWhereOrNull(
      (s) => s.taskId == task.id && s.studentId == studentId,
    );

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: FkColors.white),
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

            // Task status
            Chip(
              label: Text(task.status.toUpperCase()),
              backgroundColor: task.status == "open" ? Colors.green.shade100 : Colors.grey.shade300,
              labelStyle: TextStyle(color: task.status == "open" ? Colors.green.shade800 : Colors.grey.shade600),
            ),
            const Spacer(),

            // 👇 Conditional Buttons
            if (submission == null) ...[
              // Student has not applied yet → show Apply button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await taskController.applyForTask(task.id, studentId);
                    Get.snackbar("Applied", "Waiting for restaurant approval.");
                    Get.back();
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text("Apply for Task"),
                ),
              ),
            ] else if (submission.status == "approved_for_proof") ...[
              // Restaurant approved → student can submit proof
              Obx(() {
                return ElevatedButton.icon(
                  onPressed: submissionController.isLoading.value
                      ? null
                      : () async {
                          final result = await FilePicker.platform.pickFiles(type: FileType.image);
                          if (result != null && result.files.single.path != null) {
                            final file = File(result.files.single.path!);
                            try {
                              await submissionController.uploadAndSubmitProof(file, studentId, task.id);
                            } catch (e) {
                              Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
                            }
                          }
                        },
                  icon: submissionController.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.upload_file),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(submissionController.isLoading.value ? "Uploading..." : "Submit Proof"),
                  ),
                );
              }),
            ] else ...[
              // Already applied, waiting for approval or final result → show status
              Center(
                child: Text(
                  "Submission Status: ${submission.status}",
                  style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[700], fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
