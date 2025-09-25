class SubmissionModel {
  final String id;
  final String taskId;
  final String studentId;
  final String proofUrl;
  final String status; // pending, approved, rejected
  final DateTime createdAt;

  SubmissionModel({
    required this.id,
    required this.taskId,
    required this.studentId,
    required this.proofUrl,
    required this.status,
    required this.createdAt,
  });

  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    return SubmissionModel(
      id: json['id'],
      taskId: json['task_id'],
      studentId: json['student_id'],
      proofUrl: json['proof_url'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'task_id': taskId,
    'student_id': studentId,
    'proof_url': proofUrl,
    'status': status,
    'created_at': createdAt.toIso8601String(),
  };
}
