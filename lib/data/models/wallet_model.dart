class WalletModel {
  final String studentId;
  final int balancePoints;
  final DateTime updatedAt;

  WalletModel({required this.studentId, required this.balancePoints, required this.updatedAt});

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      studentId: json['student_id'],
      balancePoints: json['balance_points'],
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'student_id': studentId,
    'balance_points': balancePoints,
    'updated_at': updatedAt.toIso8601String(),
  };
}
