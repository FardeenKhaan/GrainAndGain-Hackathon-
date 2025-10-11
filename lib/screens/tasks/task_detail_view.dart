import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grain_and_gain_student/controllers/auth_controller.dart';
import 'package:grain_and_gain_student/controllers/submission_controller.dart';
import 'package:grain_and_gain_student/controllers/task_controller.dart';
import 'package:grain_and_gain_student/data/models/task_model.dart';
import 'package:grain_and_gain_student/screens/widgets/reuse_appbar.dart';
import 'package:grain_and_gain_student/utils/helpers/helper_functions.dart';
import 'package:iconsax/iconsax.dart';

class TaskDetailView extends StatelessWidget {
  final TaskModel task;
  final AuthController authController = Get.find<AuthController>();
  final TaskController taskController = Get.find<TaskController>();
  final SubmissionController submissionController = Get.find<SubmissionController>();

  TaskDetailView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final studentId = authController.currentUser.value!.id;
    final isDark = FkHelperFunctions.isDarkMode(context);

    final submission = submissionController.submissions.firstWhereOrNull(
      (s) => s.taskId == task.id && s.studentId == studentId,
    );

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
      appBar: FkAppBar(
        title: const Text("Task Details", style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  Title
              Text(
                task.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              //  Reward Points
              Row(
                children: [
                  const Icon(Iconsax.coin_1, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text(
                    "${task.rewardPoints} Points",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.amber.shade700),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              //  Description
              Text(
                task.description ?? "No description provided.",
                style: TextStyle(fontSize: 15, color: isDark ? Colors.grey[300] : Colors.grey[700], height: 1.5),
              ),
              const SizedBox(height: 24),

              //  Status
              Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  label: Text(task.status.toUpperCase()),
                  backgroundColor: task.status == "open"
                      ? Colors.green.withOpacity(0.15)
                      : Colors.grey.withOpacity(0.15),
                  labelStyle: TextStyle(
                    color: task.status == "open" ? Colors.green.shade700 : Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              //  Conditional Buttons
              if (submission == null) ...[
                // Student has not applied yet
                _gradientButton(
                  icon: Iconsax.tick_circle,
                  text: "Apply for Task",
                  onPressed: () async {
                    await taskController.applyForTask(task.id, studentId);
                    Get.snackbar(
                      "Applied Successfully 🎉",
                      "Your application is pending restaurant approval.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green.shade50,
                      colorText: Colors.black87,
                    );
                    Get.back();
                  },
                ),
              ] else if (submission.status == "approved_for_proof") ...[
                // Student allowed to submit proof
                Obx(() {
                  final TextEditingController linkController = TextEditingController();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: linkController,
                        decoration: InputDecoration(
                          labelText: "Optional Proof Link (e.g., GitHub, Drive, etc.)",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Iconsax.link_1),
                        ),
                      ),
                      const SizedBox(height: 14),
                      _gradientButton(
                        icon: Iconsax.document_upload,
                        text: submissionController.isLoading.value ? "Uploading..." : "Submit Proof",
                        isLoading: submissionController.isLoading.value,
                        onPressed: submissionController.isLoading.value
                            ? null
                            : () async {
                                final result = await FilePicker.platform.pickFiles(type: FileType.image);
                                if (result != null && result.files.single.path != null) {
                                  final file = File(result.files.single.path!);
                                  final link = linkController.text.trim().isEmpty ? null : linkController.text.trim();

                                  try {
                                    await submissionController.uploadAndSubmitProof(
                                      file,
                                      studentId,
                                      task.id,
                                      proofLink: link,
                                    );
                                  } catch (e) {
                                    Get.snackbar(
                                      "Error",
                                      e.toString(),
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red.shade50,
                                      colorText: Colors.black87,
                                    );
                                  }
                                }
                              },
                      ),
                    ],
                  );
                }),
              ] else ...[
                // Other states
                Center(
                  child: Column(
                    children: [
                      Icon(Iconsax.document_text, size: 60, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(
                        "Submission Status: ${submission.status.capitalizeFirst ?? ''}",
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Custom Gradient Button
  Widget _gradientButton({
    required String text,
    required IconData icon,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink.shade400, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Icon(icon, color: Colors.white),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
