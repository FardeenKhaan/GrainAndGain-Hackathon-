import 'package:grain_and_gain_student/data/models/task_model.dart';
import 'package:grain_and_gain_student/data/providers/supabase_provider.dart';

class TaskRepository {
  final SupabaseProvider _provider = SupabaseProvider();

  // Get all open tasks
  Future<List<TaskModel>> getTasks() async {
    final response = await _provider.getTasks();
    return response.map((task) => TaskModel.fromJson(task)).toList();
  }

  // Apply for a task
  Future<void> applyForTask(String taskId, String studentId) async {
    await _provider.applyForTask(taskId, studentId);
  }
}
