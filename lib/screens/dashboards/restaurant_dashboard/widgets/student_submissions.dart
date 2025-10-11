import 'package:flutter/material.dart';
import 'package:grain_and_gain_student/controllers/submission_controller.dart';
import 'package:grain_and_gain_student/data/models/submission_model.dart';
import 'package:grain_and_gain_student/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentSubmissions extends StatelessWidget {
  const StudentSubmissions({
    super.key,
    required this.statusColor,
    required this.sub,
    required this.submissionController,
  });

  final MaterialColor statusColor;
  final SubmissionModel sub;
  final SubmissionController submissionController;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 8),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade400, Colors.purple.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.indigo.shade100, blurRadius: 10, offset: const Offset(0, 6))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  // backgroundColor: statusColor.withValues(alpha: 0.15),
                  backgroundColor: FkColors.secondary,
                  child: Icon(Iconsax.user, color: statusColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sub.studentName ?? "Unknown Student",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(sub.taskTitle ?? "Untitled Task", style: TextStyle(color: Colors.white, fontSize: 14)),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  onSelected: (value) => submissionController.changeStatus(sub.id, value),
                  itemBuilder: (context) {
                    final menu = <PopupMenuEntry<String>>[];
                    if (sub.status == "pending") {
                      menu.add(const PopupMenuItem(value: "approved_for_proof", child: Text("Approve (Allow Proof)")));
                      menu.add(const PopupMenuItem(value: "rejected", child: Text("Reject")));
                    } else if (sub.status == "proof_submitted") {
                      menu.add(
                        const PopupMenuItem(value: "approved_final", child: Text("Approve Final (Credit Wallet)")),
                      );
                      menu.add(const PopupMenuItem(value: "rejected", child: Text("Reject")));
                    }
                    return menu;
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Status Chip
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                backgroundColor: statusColor.withValues(alpha: 0.15),
                label: Text(
                  sub.status.toUpperCase(),
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // 📎 Proof Section
            if ((sub.proofUrl?.isNotEmpty ?? false) || (sub.proofLink?.isNotEmpty ?? false))
              Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  // color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                  gradient: LinearGradient(
                    colors: [Colors.pink.shade400, Colors.blue.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Iconsax.coin, size: 18, color: Colors.blue),
                        SizedBox(width: 6),
                        Text("Proofs", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    if (sub.proofUrl?.isNotEmpty ?? false)
                      GestureDetector(
                        onTap: () => launchUrl(Uri.parse(sub.proofUrl!)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Row(
                            children: const [
                              Icon(Iconsax.image, size: 18, color: Colors.blue),
                              SizedBox(width: 6),
                              Text(
                                "View Image Proof",
                                style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (sub.proofLink?.isNotEmpty ?? false)
                      GestureDetector(
                        onTap: () => launchUrl(Uri.parse(sub.proofLink!)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Row(
                            children: const [
                              Icon(Iconsax.link, size: 18, color: Colors.blue),
                              SizedBox(width: 6),
                              Text(
                                "View Link Proof",
                                style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
