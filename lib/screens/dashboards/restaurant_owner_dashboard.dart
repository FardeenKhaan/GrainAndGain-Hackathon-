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
import 'package:grain_and_gain_student/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

// class RestaurantDashboardView extends StatelessWidget {
//   RestaurantDashboardView({super.key});

//   final authController = Get.find<AuthController>();

//   final taskController = Get.find<TaskController>();

//   final submissionController = Get.find<SubmissionController>();

//   @override
//   Widget build(BuildContext context) {
//     final user = authController.currentUser.value!;

//     // 👇 Load restaurant tasks on init
//     taskController.loadRestaurantTasks(user.id);
//     submissionController.loadRestaurantSubmissions(user.id); // 👈 ADD THIS

//     return Scaffold(
//       appBar: FkAppBar(
//         title: Text('Restaurant Dashboard'),
//         actions: [
//           IconButton(
//             icon: const Icon(Iconsax.logout, color: Colors.red),
//             onPressed: () {
//               authController.signOut();
//               Get.offAllNamed(FkRoutes.logIn);
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 👤 Profile Section
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 32,
//                     backgroundColor: Colors.blue.shade100,
//                     backgroundImage: user.profilePicUrl != null ? NetworkImage(user.profilePicUrl!) : null,
//                     child: user.profilePicUrl == null ? const Icon(Iconsax.user, size: 40, color: Colors.white) : null,
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Welcome, ${user.name}",
//                           style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           user.email,
//                           style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),

//               Obx(() {
//                 if (taskController.isLoading.value) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (taskController.myRestaurantTasks.isEmpty) {
//                   return const Center(child: Text("You haven’t created any tasks yet."));
//                 }

//                 return ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   padding: const EdgeInsets.all(16),
//                   itemCount: taskController.myRestaurantTasks.length,
//                   itemBuilder: (context, index) {
//                     final task = taskController.myRestaurantTasks[index];
//                     return Card(
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [Colors.pink.shade400, Colors.blue.shade600],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                           borderRadius: BorderRadius.circular(15),
//                         ),

//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: ListTile(
//                             title: Text(task.title, overflow: TextOverflow.ellipsis, maxLines: 1),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(task.description ?? "", overflow: TextOverflow.ellipsis, maxLines: 1),
//                                 const SizedBox(height: 4),
//                                 Chip(
//                                   label: Text(task.status, style: const TextStyle(color: Colors.white)),
//                                   backgroundColor: task.status == "open"
//                                       ? Colors.green
//                                       : task.status == "in_progress"
//                                       ? Colors.orange
//                                       : Colors.grey,
//                                 ),
//                               ],
//                             ),
//                             trailing: PopupMenuButton<String>(
//                               onSelected: (value) {
//                                 if (value == "edit") {
//                                   Get.to(() => EditTaskView(task: task));
//                                 } else if (value == "delete") {
//                                   taskController.deleteTask(task.id, authController.currentUser.value!.id);
//                                 } else if (value == "mark_open") {
//                                   taskController.changeStatus(task.id, "open", authController.currentUser.value!.id);
//                                 } else if (value == "mark_in_progress") {
//                                   taskController.changeStatus(
//                                     task.id,
//                                     "in_progress",
//                                     authController.currentUser.value!.id,
//                                   );
//                                 } else if (value == "mark_completed") {
//                                   taskController.changeStatus(
//                                     task.id,
//                                     "completed",
//                                     authController.currentUser.value!.id,
//                                   );
//                                 }
//                               },
//                               itemBuilder: (context) => [
//                                 const PopupMenuItem(value: "edit", child: Text("Edit")),
//                                 const PopupMenuItem(value: "delete", child: Text("Delete")),
//                                 const PopupMenuDivider(),
//                                 const PopupMenuItem(value: "mark_open", child: Text("Mark as Open")),
//                                 const PopupMenuItem(value: "mark_in_progress", child: Text("Mark as In Progress")),
//                                 const PopupMenuItem(value: "mark_completed", child: Text("Mark as Completed")),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               }),
//               const SizedBox(height: 24),
//               Text("Task Submissions", style: Theme.of(context).textTheme.titleLarge),
//               Obx(() {
//                 if (submissionController.isLoading.value) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (submissionController.submissions.isEmpty) {
//                   return const Text("No submissions yet.");
//                 }
//                 return ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   clipBehavior: Clip.none, // 👈 allow popup to overflow
//                   itemCount: submissionController.submissions.length,
//                   itemBuilder: (context, index) {
//                     final sub = submissionController.submissions[index];

//                     return Container(
//                       margin: const EdgeInsets.all(FkSizes.defaultSpace),
//                       padding: EdgeInsets.all(FkSizes.defaultSpace),
//                       decoration: BoxDecoration(
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.3),
//                             spreadRadius: 2,
//                             blurRadius: 5,
//                             offset: const Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: Card(
//                         // margin: const EdgeInsets.symmetric(vertical: 6),
//                         clipBehavior: Clip.none, // 👈 keep overflow visible
//                         child: ListTile(
//                           contentPadding: const EdgeInsets.all(FkSizes.defaultSpace),
//                           title: Text(sub.task?.title ?? "Task", style: Theme.of(context).textTheme.titleMedium),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Text("Student: ${sub.studentId}"),
//                               Text("Status: ${sub.status}"),
//                               if (sub.task != null) Text("Reward: ${sub.task!.rewardPoints} pts"),
//                               const SizedBox(height: 6),
//                               GestureDetector(
//                                 onTap: () => launchUrl(Uri.parse(sub.proofUrl)),
//                                 child: const Text("View Proof", style: TextStyle(color: Colors.blue)),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               }),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: FkColors.primary,
//         onPressed: () => Get.to(() => CreateTaskView()),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

class RestaurantDashboardView extends StatelessWidget {
  final authController = Get.find<AuthController>();
  final taskController = Get.find<TaskController>();
  final submissionController = Get.find<SubmissionController>();

  RestaurantDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = authController.currentUser.value!;

    /// Load tasks and submissions for this restaurant
    taskController.loadRestaurantTasks(user.id);
    submissionController.loadRestaurantSubmissions(user.id);

    return Scaffold(
      appBar: FkAppBar(
        title: const Text("Restaurant Dashboard"),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: FkColors.primary,
        onPressed: () => Get.to(() => CreateTaskView()),
        child: const Icon(Icons.add),
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
              // 👤 Profile Header
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
              Text("Your Created Tasks", style: Theme.of(context).textTheme.titleLarge),

              // 🧱 Restaurant Tasks List
              Obx(() {
                if (taskController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (taskController.myRestaurantTasks.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("You haven’t created any tasks yet."),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: taskController.myRestaurantTasks.length,
                  itemBuilder: (context, index) {
                    final task = taskController.myRestaurantTasks[index];
                    return Card(
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
                        child: ListTile(
                          title: Text(task.title, style: const TextStyle(color: Colors.white)),
                          subtitle: Text(task.description ?? "", style: const TextStyle(color: Colors.white70)),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == "edit") {
                                Get.to(() => EditTaskView(task: task));
                              } else if (value == "delete") {
                                taskController.deleteTask(task.id, user.id);
                              } else if (value == "open" || value == "in_progress" || value == "completed") {
                                taskController.changeStatus(task.id, value, user.id);
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(value: "edit", child: Text("Edit Task")),
                              PopupMenuItem(value: "delete", child: Text("Delete Task")),
                              PopupMenuDivider(),
                              PopupMenuItem(value: "open", child: Text("Mark as Open")),
                              PopupMenuItem(value: "in_progress", child: Text("Mark as In Progress")),
                              PopupMenuItem(value: "completed", child: Text("Mark as Completed")),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),

              const SizedBox(height: 24),
              Text("Student Submissions", style: Theme.of(context).textTheme.titleLarge),

              // 📜 Submissions List
              Obx(() {
                if (submissionController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (submissionController.submissions.isEmpty) {
                  return const Padding(padding: EdgeInsets.all(16.0), child: Text("No submissions yet."));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: submissionController.submissions.length,
                  itemBuilder: (context, index) {
                    final sub = submissionController.submissions[index];

                    Color statusColor;
                    switch (sub.status) {
                      case "pending":
                        statusColor = Colors.orange;
                        break;
                      case "approved_for_proof":
                        statusColor = Colors.blue;
                        break;
                      case "proof_submitted":
                        statusColor = Colors.purple;
                        break;
                      case "approved_final":
                        statusColor = Colors.green;
                        break;
                      case "rejected":
                        statusColor = Colors.red;
                        break;
                      default:
                        statusColor = Colors.grey;
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text("Student: ${sub.studentId}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Task ID: ${sub.taskId}"),
                            const SizedBox(height: 4),
                            Chip(
                              label: Text(sub.status.toUpperCase()),
                              backgroundColor: statusColor.withOpacity(0.15),
                              labelStyle: TextStyle(color: statusColor),
                            ),
                            if (sub.proofUrl != null && sub.proofUrl!.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  launchUrl(Uri.parse(sub.proofUrl!));
                                },
                                child: const Text("View Proof", style: TextStyle(color: Colors.blue)),
                              ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            submissionController.changeStatus(sub.id, value);
                          },
                          itemBuilder: (context) {
                            final List<PopupMenuEntry<String>> menu = [];
                            // if (sub.status == "pending") {
                            //   menu.add(
                            //     const PopupMenuItem(value: "approved_for_proof", child: Text("Approve (Allow Proof)")),
                            //   );
                            //   menu.add(const PopupMenuItem(value: "rejected", child: Text("Reject")));
                            // } else if (sub.status == "proof_submitted") {
                            //   menu.add(
                            //     const PopupMenuItem(
                            //       value: "approved_final",
                            //       child: Text("Approve Final (Credit Wallet)"),
                            //     ),1
                            //   );
                            //   menu.add(const PopupMenuItem(value: "rejected", child: Text("Reject")));
                            // }
                            if (sub.status == "pending") {
                              menu.add(
                                const PopupMenuItem(value: "approved_for_proof", child: Text("Approve (Allow Proof)")),
                              );
                              menu.add(const PopupMenuItem(value: "rejected", child: Text("Reject")));
                            } else if (sub.status == "proof_submitted") {
                              menu.add(
                                const PopupMenuItem(
                                  value: "approved_final",
                                  child: Text("Approve Final (Credit Wallet)"),
                                ),
                              );
                              menu.add(const PopupMenuItem(value: "rejected", child: Text("Reject")));
                            }

                            return menu;
                          },
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
    );
  }
}
