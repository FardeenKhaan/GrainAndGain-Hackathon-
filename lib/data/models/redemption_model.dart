// class RedemptionModel {
//   final String id;
//   final String studentId;
//   final String restaurantId;
//   final String code; // 6-digit redemption code
//   final int pointsUsed;
//   final String status; // unused, used, expired
//   final DateTime createdAt;

//   RedemptionModel({
//     required this.id,
//     required this.studentId,
//     required this.restaurantId,
//     required this.code,
//     required this.pointsUsed,
//     required this.status,
//     required this.createdAt,
//   });

//   factory RedemptionModel.fromJson(Map<String, dynamic> json) {
//     return RedemptionModel(
//       id: json['id'],
//       studentId: json['student_id'],
//       restaurantId: json['restaurant_id'],
//       code: json['code'],
//       pointsUsed: json['points_used'],
//       status: json['status'],
//       createdAt: DateTime.parse(json['created_at']),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'student_id': studentId,
//     'restaurant_id': restaurantId,
//     'code': code,
//     'points_used': pointsUsed,
//     'status': status,
//     'created_at': createdAt.toIso8601String(),
//   };
// }

class RedemptionModel {
  final String id;
  final String studentId;
  final String restaurantId;
  final String? restaurantName;
  final String? studentName;
  final String code;
  final int pointsUsed;
  final String status;
  final DateTime createdAt;

  RedemptionModel({
    required this.id,
    required this.studentId,
    required this.restaurantId,
    this.restaurantName,
    this.studentName,
    required this.code,
    required this.pointsUsed,
    required this.status,
    required this.createdAt,
  });

  factory RedemptionModel.fromJson(Map<String, dynamic> json) {
    return RedemptionModel(
      id: json['id'],
      studentId: json['student_id'],
      restaurantId: json['restaurant_id'],
      restaurantName: json['restaurant']?['name'],
      studentName: json['student']?['name'],
      code: json['code'],
      pointsUsed: json['points_used'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'student_id': studentId,
    'restaurant_id': restaurantId,
    'restaurant_name': restaurantName,
    'student_name': studentName,
    'code': code,
    'points_used': pointsUsed,
    'status': status,
    'created_at': createdAt.toIso8601String(),
  };
}
