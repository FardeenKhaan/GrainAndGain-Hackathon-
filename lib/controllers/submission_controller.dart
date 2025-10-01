import 'dart:io';

import 'package:get/get.dart';
import 'package:grain_and_gain_student/data/models/submission_model.dart';
import 'package:grain_and_gain_student/data/repositories/submission_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// class SubmissionController extends GetxController {
//   final SubmissionRepository _repository = SubmissionRepository();

//   RxList<SubmissionModel> submissions = <SubmissionModel>[].obs;
//   RxBool isLoading = false.obs;
//   RealtimeChannel? _submissionsChannel;

//   @override
//   void onClose() {
//     _submissionsChannel?.unsubscribe();
//     super.onClose();
//   }

//   // 🟢 Restaurant loads submissions
//   Future<void> loadRestaurantSubmissions(String restaurantId) async {
//     try {
//       isLoading.value = true;
//       final data = await _repository.getTaskSubmissions(restaurantId);
//       submissions.assignAll(data);

//       _submissionsChannel ??= _repository.subscribeToSubmissions((payload) {
//         if (payload.isNotEmpty) {
//           final updated = SubmissionModel.fromJson(payload);
//           final index = submissions.indexWhere((s) => s.id == updated.id);
//           if (index != -1) {
//             submissions[index] = updated;
//           } else {
//             submissions.add(updated);
//           }
//         }
//       });
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // 🟡 Student loads their own submissions
//   Future<void> loadMySubmissions(String studentId) async {
//     try {
//       isLoading.value = true;
//       final data = await _repository.getStudentSubmissions(studentId);
//       submissions.assignAll(data);

//       _submissionsChannel ??= _repository.subscribeToSubmissions((payload) {
//         if (payload.isNotEmpty && payload['student_id'] == studentId) {
//           final updated = SubmissionModel.fromJson(payload);
//           final index = submissions.indexWhere((s) => s.id == updated.id);
//           if (index != -1) {
//             submissions[index] = updated;
//           } else {
//             submissions.add(updated);
//           }
//         }
//       });
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // 🟣 Student uploads proof
//   Future<void> uploadAndSubmitProof(File file, String studentId, String taskId) async {
//     try {
//       isLoading.value = true;
//       final proofUrl = await _repository.uploadProof(file, studentId, taskId);
//       await _repository.submitProof(taskId, studentId, proofUrl);
//       Get.snackbar("Success", "Proof submitted successfully!");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // 🔴 Restaurant changes status
//   Future<void> changeStatus(String submissionId, String status) async {
//     await _repository.updateSubmissionStatus(submissionId, status);
//     Get.snackbar("Updated", "Submission marked as $status!");
//   }
// }

class SubmissionController extends GetxController {
  final SubmissionRepository _repository = SubmissionRepository();

  RxList<SubmissionModel> submissions = <SubmissionModel>[].obs;
  RxBool isLoading = false.obs;
  RealtimeChannel? _submissionsChannel;

  @override
  void onClose() {
    _submissionsChannel?.unsubscribe();
    super.onClose();
  }

  // 🟢 Restaurant loads submissions
  Future<void> loadRestaurantSubmissions(String restaurantId) async {
    try {
      isLoading.value = true;
      final data = await _repository.getTaskSubmissions(restaurantId);
      submissions.assignAll(data);

      _submissionsChannel ??= _repository.subscribeToSubmissions((payload) {
        if (payload.isNotEmpty) {
          final updated = SubmissionModel.fromJson(payload);
          final index = submissions.indexWhere((s) => s.id == updated.id);
          if (index != -1) {
            submissions[index] = updated;
          } else {
            submissions.add(updated);
          }
        }
      });
    } finally {
      isLoading.value = false;
    }
  }

  // 🟡 Student loads their own submissions
  Future<void> loadMySubmissions(String studentId) async {
    try {
      isLoading.value = true;
      final data = await _repository.getStudentSubmissions(studentId);
      submissions.assignAll(data);

      _submissionsChannel ??= _repository.subscribeToSubmissions((payload) {
        if (payload.isNotEmpty && payload['student_id'] == studentId) {
          final updated = SubmissionModel.fromJson(payload);
          final index = submissions.indexWhere((s) => s.id == updated.id);
          if (index != -1) {
            submissions[index] = updated;
          } else {
            submissions.add(updated);
          }
        }
      });
    } finally {
      isLoading.value = false;
    }
  }

  // 🟣 Student uploads proof
  Future<void> uploadAndSubmitProof(File file, String studentId, String taskId) async {
    try {
      isLoading.value = true;
      final proofUrl = await _repository.uploadProof(file, studentId, taskId);
      await _repository.submitProof(taskId, studentId, proofUrl);
      Get.snackbar("Success", "Proof submitted successfully!");
    } finally {
      isLoading.value = false;
    }
  }

  // 🔴 Restaurant changes status (✅ with wallet credit)
  Future<void> changeStatus(String submissionId, String status) async {
    try {
      await _repository.updateSubmissionStatus(submissionId, status);

      // ✅ If approved, credit wallet
      if (status == "approved") {
        final sub = submissions.firstWhere((s) => s.id == submissionId);

        // fetch the related task (so we know reward points)
        final task = await _repository.getTaskById(sub.taskId);
        if (task != null) {
          await _repository.creditWallet(sub.studentId, task.rewardPoints);
        }
      }

      Get.snackbar("Updated", "Submission marked as $status!");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
