import 'package:grain_and_gain_student/data/models/task_model.dart';

class SubmissionModel {
  final String id;
  final String taskId;
  final String studentId;
  final String proofUrl;
  final String status;
  final DateTime createdAt;
  final String? studentName;
  final String? taskTitle;
  final String? proofLink;
  final TaskModel? task;

  SubmissionModel({
    required this.id,
    required this.taskId,
    required this.studentId,
    required this.proofUrl,
    this.proofLink,
    required this.status,
    required this.createdAt,
    this.studentName,
    this.taskTitle,
    this.task,
  });

  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    return SubmissionModel(
      id: json['id'],
      taskId: json['task_id'],
      studentId: json['student_id'],
      proofUrl: json['proof_url'] ?? '',
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      studentName: json['student']?['name'],
      taskTitle: json['tasks']?['title'],
      proofLink: json['proof_link'],
      task: json['tasks'] != null ? TaskModel.fromJson(json['tasks']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'task_id': taskId,
    'student_id': studentId,
    'proof_url': proofUrl,
    'status': status,
    'proof_link': proofLink,
    'created_at': createdAt.toIso8601String(),
  };
}
