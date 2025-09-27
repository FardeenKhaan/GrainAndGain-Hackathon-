import 'package:get/get.dart';
import 'package:grain_and_gain_student/data/models/task_model.dart';
import 'package:grain_and_gain_student/data/repositories/task_repository.dart';

class TaskController extends GetxController {
  final TaskRepository _repository = TaskRepository();

  RxList<TaskModel> tasks = <TaskModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks(); // load tasks automatically when controller starts
  }

  Future<void> loadTasks() async {
    try {
      isLoading.value = true;
      final fetchedTasks = await _repository.getTasks();
      tasks.assignAll(fetchedTasks);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> applyForTask(String taskId, String studentId) async {
    try {
      await _repository.applyForTask(taskId, studentId);
      Get.snackbar("Applied", "Task applied successfully!");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
