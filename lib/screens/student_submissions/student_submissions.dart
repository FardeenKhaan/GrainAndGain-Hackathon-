import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grain_and_gain_student/controllers/submission_controller.dart';
import 'package:grain_and_gain_student/screens/dashboards/student_dashboard/widgets/shimmer_list.dart';
import 'package:grain_and_gain_student/screens/widgets/reuse_appbar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentSubmissionsList extends StatelessWidget {
  const StudentSubmissionsList({super.key});

  @override
  Widget build(BuildContext context) {
    final submissionController = Get.find<SubmissionController>();
    return Scaffold(
      appBar: FkAppBar(title: const Text("My Submissions")),
      body: Obx(() {
        if (submissionController.isLoading.value) {
          return FkShimmerList();
        }

        if (submissionController.submissions.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text("You haven’t submitted any tasks yet.", style: TextStyle(color: Colors.grey)),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: submissionController.submissions.length,
            itemBuilder: (context, index) {
              final sub = submissionController.submissions[index];
              return TweenAnimationBuilder(
                duration: Duration(milliseconds: 300 + (index * 80)),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, value, child) => Transform.scale(scale: value, child: child),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    leading: const Icon(Iconsax.document, color: Colors.indigo),
                    title: Text(sub.task?.title ?? "Task", style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Status: ${sub.status}"),
                        if (sub.proofUrl.isNotEmpty)
                          GestureDetector(
                            onTap: () => launchUrl(Uri.parse(sub.proofUrl)),
                            child: const Text(
                              "View Proof",
                              style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                            ),
                          ),
                      ],
                    ),
                    trailing: Column(
                      children: [
                        Text("${sub.task?.rewardPoints ?? 0} pts", style: const TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: List.generate(
          3,
          (index) => Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            height: 70,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}
