class TaskModel {
  final String id;
  final String restaurantId;
  final String title;
  final String? description;
  final int rewardPoints;
  final String status; // open, in_progress, completed
  final DateTime createdAt;

  TaskModel({
    required this.id,
    required this.restaurantId,
    required this.title,
    this.description,
    required this.rewardPoints,
    required this.status,
    required this.createdAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      restaurantId: json['restaurant_id'],
      title: json['title'],
      description: json['description'],
      rewardPoints: json['reward_points'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'restaurant_id': restaurantId,
    'title': title,
    'description': description,
    'reward_points': rewardPoints,
    'status': status,
    'created_at': createdAt.toIso8601String(),
  };
}
