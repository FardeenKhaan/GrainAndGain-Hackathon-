import 'package:grain_and_gain_student/data/models/task_model.dart';
import 'package:grain_and_gain_student/data/providers/supabase_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TaskRepository {
  final SupabaseProvider _provider = SupabaseProvider();

  // For students
  Future<List<TaskModel>> getTasks() async {
    final response = await _provider.getTasks();
    return response.map((task) => TaskModel.fromJson(task)).toList();
  }

  // For restaurants
  Future<List<TaskModel>> getRestaurantTasks(String restaurantId) async {
    final response = await _provider.getRestaurantTasks(restaurantId);
    return response.map((task) => TaskModel.fromJson(task)).toList();
  }

  Future<void> applyForTask(String taskId, String studentId) async {
    await _provider.applyForTask(taskId, studentId);
  }

  Future<void> createTask(String restaurantId, String title, String description, int rewardPoints) async {
    await _provider.client.from('tasks').insert({
      'restaurant_id': restaurantId,
      'title': title,
      'description': description,
      'reward_points': rewardPoints,
      'status': 'open',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> updateTask(String taskId, Map<String, dynamic> updates) async {
    await _provider.client.from('tasks').update(updates).eq('id', taskId);
  }

  Future<void> deleteTask(String taskId) async {
    await _provider.client.from('tasks').delete().eq('id', taskId);
  }

  Future<void> updateTaskStatus(String taskId, String status) async {
    await _provider.client.from('tasks').update({'status': status}).eq('id', taskId);
  }

  RealtimeChannel subscribeToTasks(void Function(Map<String, dynamic>) onChange) {
    return _provider.subscribeToTasks(onChange);
  }
}
