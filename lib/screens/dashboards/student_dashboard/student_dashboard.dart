import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grain_and_gain_student/controllers/auth_controller.dart';
import 'package:grain_and_gain_student/controllers/submission_controller.dart';
import 'package:grain_and_gain_student/controllers/task_controller.dart';
import 'package:grain_and_gain_student/controllers/wallet_controller.dart';
import 'package:grain_and_gain_student/routers/routes.dart';
import 'package:grain_and_gain_student/screens/dashboards/student_dashboard/widgets/available_tasks.dart';
import 'package:grain_and_gain_student/screens/dashboards/student_dashboard/widgets/profile_header.dart';
import 'package:grain_and_gain_student/screens/dashboards/student_dashboard/widgets/section_header.dart';
import 'package:grain_and_gain_student/screens/dashboards/student_dashboard/widgets/shimmer_list.dart';
import 'package:grain_and_gain_student/screens/redemption/restaurant_redemption_screen.dart';
import 'package:grain_and_gain_student/screens/redemption/student_redemption_screen.dart';
import 'package:grain_and_gain_student/screens/student_submissions/student_submissions.dart';
import 'package:grain_and_gain_student/screens/widgets/reuse_appbar.dart';
import 'package:grain_and_gain_student/utils/constants/colors.dart';
import 'package:grain_and_gain_student/utils/constants/sizes.dart';
import 'package:grain_and_gain_student/utils/constants/text_strings.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';

class StudentDashboardView extends StatelessWidget {
  final authController = Get.find<AuthController>();
  final walletController = Get.find<WalletController>();
  final taskController = Get.find<TaskController>();
  final submissionController = Get.find<SubmissionController>();

  StudentDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = authController.currentUser.value;

    if (user != null && submissionController.submissions.isEmpty && !submissionController.isLoading.value) {
      submissionController.loadMySubmissions(user.id);
    }

    return Scaffold(
      appBar: FkAppBar(
        title: Text(FkTexts.studentDashboard),
        actions: [
          IconButton(
            icon: Icon(Iconsax.logout, color: Colors.redAccent),
            onPressed: () {
              authController.signOut();
              Get.offAllNamed(FkRoutes.logIn);
            },
          ),
        ],
      ),
      body: Obx(() {
        final user = authController.currentUser.value;
        if (user == null) return const Center(child: CircularProgressIndicator());

        if (walletController.wallet.value == null && !walletController.isLoading.value) {
          walletController.loadWallet(user.id);
        }

        return RefreshIndicator(
          onRefresh: () async {
            await taskController.loadTasks();
            await walletController.loadWallet(user.id);
            await submissionController.loadMySubmissions(user.id);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(FkSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// --- Profile Header Section
                ProfileHeader(user: user),

                SizedBox(height: FkSizes.defaultSpace),

                /// --- Wallet Card (Animated Gradient + Shimmer)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigo.shade400, Colors.purple.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.indigo.shade100, blurRadius: 10, offset: const Offset(0, 6))],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        if (walletController.isLoading.value) {
                          return Shimmer.fromColors(
                            baseColor: Colors.white54,
                            highlightColor: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(height: 14, width: 80, color: Colors.white),
                                const SizedBox(height: 10),
                                Container(height: 30, width: 60, color: Colors.white),
                              ],
                            ),
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(FkTexts.mealPoints, style: TextTheme.of(context).bodyLarge),
                            const SizedBox(height: FkSizes.xs),
                            Text(
                              "${walletController.balance.value}",
                              // style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                              style: TextTheme.of(
                                context,
                              ).headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: FkSizes.sm),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withValues(alpha: 0.25),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(FkSizes.borderRadiusMd),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: FkSizes.md / 1.1, vertical: FkSizes.md),
                              ),
                              icon: Icon(Iconsax.gift, color: Colors.white),
                              label: Text(
                                "Redeem",
                                style: TextTheme.of(
                                  context,
                                ).bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                                if (user.role == 'student') {
                                  Get.to(() => StudentRedemptionScreen(studentId: user.id));
                                } else {
                                  Get.to(() => RestaurantRedemptionScreen(restaurantId: user.id));
                                }
                              },
                            ),
                          ],
                        );
                      }),
                      Icon(Iconsax.wallet_3, color: Colors.white, size: 40),
                    ],
                  ),
                ),

                SizedBox(height: FkSizes.spaceBtwSections),

                /// --- Tasks Section
                // _animatedSectionHeader("", context),
                FkSectionHeader(title: FkTexts.availaleTasks),
                SizedBox(height: FkSizes.md / 1.5),

                Obx(() {
                  if (taskController.isLoading.value) {
                    // return _buildShimmerList();
                    return FkShimmerList();
                  }

                  if (taskController.tasks.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(FkSizes.lg),
                        child: Text(FkTexts.noTaskAvailable, style: TextStyle(color: Colors.grey)),
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: taskController.tasks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final task = taskController.tasks[index];
                      return AvailableTasks(task: task);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: FkColors.buttonPrimary,
        onPressed: () {
          Get.to(() => StudentSubmissionsList());
        },
        icon: const Icon(Iconsax.eye),
        label: const Text(FkTexts.viewSubmissions),
      ),
    );
  }
}
