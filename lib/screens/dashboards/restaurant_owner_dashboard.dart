import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grain_and_gain_student/controllers/auth_controller.dart';
import 'package:grain_and_gain_student/controllers/submission_controller.dart';
import 'package:grain_and_gain_student/controllers/task_controller.dart';
import 'package:grain_and_gain_student/routers/routes.dart';
import 'package:grain_and_gain_student/screens/tasks/restaurant/create_task.dart';
import 'package:grain_and_gain_student/screens/tasks/restaurant/edit_task.dart';
import 'package:grain_and_gain_student/screens/widgets/reuse_appbar.dart';
import 'package:grain_and_gain_student/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantDashboardView extends StatelessWidget {
  final authController = Get.find<AuthController>();
  final taskController = Get.find<TaskController>();
  final submissionController = Get.find<SubmissionController>();

  RestaurantDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = authController.currentUser.value!;

    // 👇 Load restaurant tasks on init
    taskController.loadRestaurantTasks(user.id);
    submissionController.loadRestaurantSubmissions(user.id); // 👈 ADD THIS

    return Scaffold(
      appBar: FkAppBar(
        title: Text('Restaurant Dashboard'),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👤 Profile Section
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.blue.shade100,
                    backgroundImage: user.profilePicUrl != null ? NetworkImage(user.profilePicUrl!) : null,
                    child: user.profilePicUrl == null ? const Icon(Iconsax.user, size: 40, color: Colors.white) : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome, ${user.name}",
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          user.email,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Obx(() {
                if (taskController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (taskController.myRestaurantTasks.isEmpty) {
                  return const Center(child: Text("You haven’t created any tasks yet."));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: taskController.myRestaurantTasks.length,
                  itemBuilder: (context, index) {
                    final task = taskController.myRestaurantTasks[index];
                    return Card(
                      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      // child: ListTile(
                      //   title: Text(task.title),
                      //   subtitle: Text(task.description ?? ""),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.pink.shade400, Colors.blue.shade600],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(task.title, overflow: TextOverflow.ellipsis, maxLines: 1),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(task.description ?? "", overflow: TextOverflow.ellipsis, maxLines: 1),
                                const SizedBox(height: 4),
                                Chip(
                                  label: Text(task.status, style: const TextStyle(color: Colors.white)),
                                  backgroundColor: task.status == "open"
                                      ? Colors.green
                                      : task.status == "in_progress"
                                      ? Colors.orange
                                      : Colors.grey,
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == "edit") {
                                  Get.to(() => EditTaskView(task: task));
                                } else if (value == "delete") {
                                  taskController.deleteTask(task.id, authController.currentUser.value!.id);
                                } else if (value == "mark_open") {
                                  taskController.changeStatus(task.id, "open", authController.currentUser.value!.id);
                                } else if (value == "mark_in_progress") {
                                  taskController.changeStatus(
                                    task.id,
                                    "in_progress",
                                    authController.currentUser.value!.id,
                                  );
                                } else if (value == "mark_completed") {
                                  taskController.changeStatus(
                                    task.id,
                                    "completed",
                                    authController.currentUser.value!.id,
                                  );
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(value: "edit", child: Text("Edit")),
                                const PopupMenuItem(value: "delete", child: Text("Delete")),
                                const PopupMenuDivider(),
                                const PopupMenuItem(value: "mark_open", child: Text("Mark as Open")),
                                const PopupMenuItem(value: "mark_in_progress", child: Text("Mark as In Progress")),
                                const PopupMenuItem(value: "mark_completed", child: Text("Mark as Completed")),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
              const SizedBox(height: 24),
              Text("Task Submissions", style: Theme.of(context).textTheme.titleLarge),
              Obx(() {
                if (submissionController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (submissionController.submissions.isEmpty) {
                  return const Text("No submissions yet.");
                }

                // return ListView.builder(
                //   itemCount: submissionController.submissions.length,
                //   itemBuilder: (context, index) {
                //     final sub = submissionController.submissions[index];
                //     return Card(
                //       child: ListTile(
                //         title: Text("Student: ${sub.studentId}"),
                //         subtitle: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text("Status: ${sub.status}"),
                //             GestureDetector(
                //               onTap: () {
                //                 // open proof in browser
                //                 launchUrl(Uri.parse(sub.proofUrl));
                //               },
                //               child: Text("View Proof", style: TextStyle(color: Colors.blue)),
                //             ),
                //           ],
                //         ),
                //         trailing: PopupMenuButton<String>(
                //           onSelected: (value) {
                //             submissionController.changeStatus(sub.id, value);
                //           },
                //           itemBuilder: (context) => [
                //             const PopupMenuItem(value: "approved", child: Text("Approve")),
                //             const PopupMenuItem(value: "rejected", child: Text("Reject")),
                //           ],
                //         ),
                //       ),
                //     );
                //   },
                // );
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: submissionController.submissions.length,
                  itemBuilder: (context, index) {
                    final sub = submissionController.submissions[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: const Icon(Iconsax.task),
                        title: Text(sub.task?.title ?? "Task"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Student: ${sub.studentId}"),
                            Text("Status: ${sub.status}"),
                            if (sub.task != null) Text("Reward: ${sub.task!.rewardPoints} pts"),
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: () => launchUrl(Uri.parse(sub.proofUrl)),
                              child: const Text("View Proof", style: TextStyle(color: Colors.blue)),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            submissionController.changeStatus(sub.id, value);
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: "approved", child: Text("Approve")),
                            const PopupMenuItem(value: "rejected", child: Text("Reject")),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: FkColors.primary,
        onPressed: () => Get.to(() => CreateTaskView()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
