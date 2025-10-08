import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:grain_and_gain_student/controllers/auth_controller.dart';
import 'package:grain_and_gain_student/data/models/submission_model.dart';
import 'package:grain_and_gain_student/data/models/task_model.dart';
import 'package:grain_and_gain_student/data/providers/supabase_provider.dart';

// lib/data/repositories/submission_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';

// class SubmissionRepository {
//   final SupabaseProvider _provider = SupabaseProvider();

//   // Upload proof file to Supabase storage
//   Future<String> uploadProof(File file, String studentId, String taskId) async {
//     final fileName = "${studentId}_${taskId}_${DateTime.now().millisecondsSinceEpoch}.jpg";
//     final filePath = "proofs/$fileName";

//     await _provider.client.storage.from("proofs").upload(filePath, file);

//     // return public URL
//     final url = _provider.client.storage.from("proofs").getPublicUrl(filePath);
//     return url;
//   }

//   // Student submits proof
//   Future<void> submitProof(String taskId, String studentId, String proofUrl) async {
//     await _provider.submitProof(taskId, studentId, proofUrl);
//   }

//   // Restaurant fetches submissions for its tasks
//   Future<List<SubmissionModel>> getTaskSubmissions(String restaurantId) async {
//     final response = await _provider.getTaskSubmissions(restaurantId);
//     return response.map((s) => SubmissionModel.fromJson(s)).toList();
//   }

//   // Restaurant approves/rejects
//   Future<void> updateSubmissionStatus(String submissionId, String status) async {
//     await _provider.updateSubmissionStatus(submissionId, status);
//   }

//   // Subscribe to submissions in realtime
//   RealtimeChannel subscribeToSubmissions(
//     void Function(Map<String, dynamic> payload) onChange,
//   ) {
//     return _provider.subscribeToSubmissions(onChange);
//   }
// }

class SubmissionRepository {
  final SupabaseProvider _provider = SupabaseProvider();

  // Upload proof
  Future<String> uploadProof(File file, String studentId, String taskId) async {
    final fileName = "${studentId}_${taskId}_${DateTime.now().millisecondsSinceEpoch}.jpg";
    final filePath = "proofs/$fileName";

    await _provider.client.storage.from("proofs").upload(filePath, file, fileOptions: const FileOptions(upsert: true));

    return _provider.client.storage.from("proofs").getPublicUrl(filePath);
  }

  // Insert/Update proof
  Future<void> submitProof(String taskId, String studentId, String proofUrl) async {
    await _provider.submitProof(taskId, studentId, proofUrl);
  }

  // Restaurant fetch
  // Future<List<SubmissionModel>> getTaskSubmissions(String restaurantId) async {
  //   final response = await _provider.getTaskSubmissions(restaurantId);
  //   return response.map((s) => SubmissionModel.fromJson(s)).toList();
  // }
  Future<List<SubmissionModel>> getTaskSubmissions(String restaurantId) async {
    final response = await _provider.client
        .from('submissions')
        .select('id, task_id, student_id, proof_url, status, created_at, tasks!inner(*)')
        .eq('tasks.restaurant_id', restaurantId)
        .order('created_at', ascending: false);

    return (response as List).map((e) => SubmissionModel.fromJson(e)).toList();
  }

  // 🟡 Student fetch

  // Future<List<SubmissionModel>> getStudentSubmissions(String studentId) async {
  //   final response = await _provider.client.from("submissions").select("*, tasks(title)").eq("student_id", studentId);

  //   return (response as List).map((s) => SubmissionModel.fromJson(s)).toList();
  // }
  Future<List<SubmissionModel>> getStudentSubmissions(String studentId) async {
    final response = await _provider.client
        .from("submissions")
        .select("*, tasks(*)") // 👈 fetch full task object
        .eq("student_id", studentId)
        .order("created_at", ascending: false);

    return (response as List).map((s) => SubmissionModel.fromJson(s)).toList();
  }

  // Update status
  // Future<void> updateSubmissionStatus(
  //   String submissionId,
  //   String status,
  // ) async {
  //   await _provider.updateSubmissionStatus(submissionId, status);
  // }
  // Future<void> updateSubmissionStatus(String submissionId, String status) async {
  //   final restaurantId = Get.find<AuthController>().currentUser.value!.id;
  //   await _provider.updateSubmissionStatus(submissionId, status);
  //   Get.snackbar("Updated", "Submission marked as $status!");
  // }
  Future<void> updateSubmissionStatus(String submissionId, String status) async {
    await _provider.updateSubmissionStatus(submissionId, status);
  }

  // Realtime
  RealtimeChannel subscribeToSubmissions(void Function(Map<String, dynamic> payload) onChange) {
    return _provider.subscribeToSubmissions(onChange);
  }

  Future<TaskModel?> getTaskById(String taskId) async {
    final response = await _provider.client.from('tasks').select().eq('id', taskId).maybeSingle();
    return response != null ? TaskModel.fromJson(response) : null;
  }

  Future<void> creditWallet(String studentId, int amount) async {
    await _provider.client.rpc('credit_wallet', params: {'student_id': studentId, 'amount': amount});
  }
}
