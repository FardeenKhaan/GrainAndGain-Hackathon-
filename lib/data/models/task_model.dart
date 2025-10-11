class TaskModel {
  final String id;
  final String title;
  final String? description;
  final int rewardPoints;
  final String? restaurantId; 
  final String? restaurantName;
  final String status;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.rewardPoints,
    this.restaurantId,
    this.restaurantName,
    required this.status,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    // Handle possible map or string restaurant_id
    final restaurantData = json['users'];
    final restaurantIdValue = json['restaurant_id'];

    return TaskModel(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Untitled Task',
      description: json['description'],
      rewardPoints: json['reward_points'] is int
          ? json['reward_points']
          : int.tryParse(json['reward_points']?.toString() ?? '0') ?? 0,
      restaurantId: restaurantIdValue is String
          ? restaurantIdValue
          : (restaurantIdValue is Map ? restaurantIdValue['id']?.toString() : restaurantIdValue?.toString()),
      restaurantName: restaurantData != null
          ? restaurantData['name'] ?? 'Unknown Restaurant'
          : json['restaurant_name'] ?? 'Unknown Restaurant',
      status: json['status'] ?? 'open',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'reward_points': rewardPoints,
    'restaurant_id': restaurantId,
    'status': status,
  };
}
