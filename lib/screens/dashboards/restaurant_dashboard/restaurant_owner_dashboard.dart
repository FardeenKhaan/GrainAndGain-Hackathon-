import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grain_and_gain_student/controllers/auth_controller.dart';
import 'package:grain_and_gain_student/controllers/submission_controller.dart';
import 'package:grain_and_gain_student/controllers/task_controller.dart';
import 'package:grain_and_gain_student/routers/routes.dart';
import 'package:grain_and_gain_student/screens/dashboards/restaurant_dashboard/widgets/profile_section.dart';
import 'package:grain_and_gain_student/screens/dashboards/restaurant_dashboard/widgets/student_submissions.dart';
import 'package:grain_and_gain_student/screens/dashboards/restaurant_dashboard/widgets/task_list.dart';
import 'package:grain_and_gain_student/screens/tasks/restaurant/create_task.dart';
import 'package:grain_and_gain_student/screens/widgets/reuse_appbar.dart';
import 'package:grain_and_gain_student/utils/constants/colors.dart';
import 'package:grain_and_gain_student/utils/constants/sizes.dart';
import 'package:grain_and_gain_student/utils/constants/text_strings.dart';
import 'package:iconsax/iconsax.dart';

class RestaurantDashboardView extends StatelessWidget {
  final authController = Get.find<AuthController>();
  final taskController = Get.find<TaskController>();
  final submissionController = Get.find<SubmissionController>();

  RestaurantDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = authController.currentUser.value!;
    taskController.loadRestaurantTasks(user.id);
    submissionController.loadRestaurantSubmissions(user.id);

    return Scaffold(
      appBar: FkAppBar(
        title: Text(FkTexts.resturantDashboard),

        actions: [
          IconButton(
            icon: const Icon(Iconsax.logout, color: Colors.red),
            onPressed: () {
              authController.signOut();
              Get.offAllNamed(FkRoutes.logIn);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: FkColors.primary,
        onPressed: () => Get.to(() => CreateTaskView()),
        icon: const Icon(Iconsax.add_circle),
        label: const Text(FkTexts.createTask),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await taskController.loadRestaurantTasks(user.id);
          await submissionController.loadRestaurantSubmissions(user.id);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// --- Profile Header Section
              ProfileSection(user: user),

              const SizedBox(height: 24),

              /// --- Restaurant Tasks List
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    FkTexts.createdTasks,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: const Icon(Iconsax.refresh, color: Colors.blueGrey),
                    onPressed: () => taskController.loadRestaurantTasks(user.id),
                  ),
                ],
              ),

              Obx(() {
                if (taskController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (taskController.myRestaurantTasks.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(FkSizes.lg),
                    child: Center(child: Text(FkTexts.noCreatedTask)),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: taskController.myRestaurantTasks.length,
                  itemBuilder: (context, index) {
                    final task = taskController.myRestaurantTasks[index];

                    final statusColor = switch (task.status) {
                      "open" => Colors.green,
                      "in_progress" => Colors.orange,
                      _ => Colors.grey,
                    };

                    return TaskList(task: task, statusColor: statusColor, taskController: taskController, user: user);
                  },
                );
              }),

              const SizedBox(height: FkSizes.lg),

              /// --- Student Submissions Task List
              Text(
                FkTexts.studentSubmissions,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),

              SizedBox(height: FkSizes.sm),

              Obx(() {
                if (submissionController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (submissionController.submissions.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(FkSizes.lg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.document_upload, size: 60, color: Colors.grey.shade400),
                        const SizedBox(height: FkSizes.sm * 1.5),
                        Text(
                          FkTexts.noStudentSubmissions,
                          // style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: submissionController.submissions.length,
                  itemBuilder: (context, index) {
                    final sub = submissionController.submissions[index];

                    final colorMap = {
                      "pending": Colors.orange,
                      "approved_for_proof": Colors.blue,
                      "proof_submitted": Colors.purple,
                      "approved_final": Colors.green,
                      "rejected": Colors.red,
                    };
                    final statusColor = colorMap[sub.status] ?? Colors.grey;

                    return StudentSubmissions(
                      statusColor: statusColor,
                      sub: sub,
                      submissionController: submissionController,
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
