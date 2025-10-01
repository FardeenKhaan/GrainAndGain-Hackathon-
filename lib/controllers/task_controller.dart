import 'package:get/get.dart';
import 'package:grain_and_gain_student/controllers/auth_controller.dart';
import 'package:grain_and_gain_student/data/models/task_model.dart';
import 'package:grain_and_gain_student/data/repositories/task_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// class TaskController extends GetxController {
//   final TaskRepository _repository = TaskRepository();

//   RxList<TaskModel> tasks = <TaskModel>[].obs;
//   RxBool isLoading = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadTasks(); // load tasks automatically when controller starts
//   }

//   Future<void> loadTasks() async {
//     try {
//       isLoading.value = true;
//       final fetchedTasks = await _repository.getTasks();
//       tasks.assignAll(fetchedTasks);
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> applyForTask(String taskId, String studentId) async {
//     try {
//       await _repository.applyForTask(taskId, studentId);
//       Get.snackbar("Applied", "Task applied successfully!");
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     }
//   }

// }

// class TaskController extends GetxController {
//   final TaskRepository _repository = TaskRepository();

//   RxList<TaskModel> tasks = <TaskModel>[].obs;
//   RxBool isLoading = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadTasks();
//   }

//   Future<void> loadTasks() async {
//     try {
//       isLoading.value = true;
//       final fetchedTasks = await _repository.getTasks();
//       tasks.assignAll(fetchedTasks);
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> applyForTask(String taskId, String studentId) async {
//     try {
//       await _repository.applyForTask(taskId, studentId);
//       Get.snackbar("Applied", "Task applied successfully!");
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     }
//   }

//   // 🚀 New: Create Task (for restaurants)
//   Future<void> createTask(String restaurantId, String title, String description, int rewardPoints) async {
//     try {
//       await _repository.createTask(restaurantId, title, description, rewardPoints);
//       Get.snackbar("Success", "Task created successfully!");
//       loadTasks(); // refresh tasks
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     }
//   }
// }

class TaskController extends GetxController {
  final TaskRepository _repository = TaskRepository();

  RxList<TaskModel> tasks = <TaskModel>[].obs;
  RxList<TaskModel> myRestaurantTasks = <TaskModel>[].obs; // 👈 new
  RxBool isLoading = false.obs;

  RealtimeChannel? _taskChannel;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
    _listenToTasks(); // 👈 enable realtime
  }

  @override
  void onClose() {
    _taskChannel?.unsubscribe();
    super.onClose();
  }

  void _listenToTasks() {
    _taskChannel = _repository.subscribeToTasks((data) {
      // Re-fetch open tasks for students
      loadTasks();

      // If restaurant is logged in → refresh their tasks as well
      final authController = Get.find<AuthController>();
      final user = authController.currentUser.value;
      if (user != null && user.role == "restaurant") {
        loadRestaurantTasks(user.id);
      }
    });
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

  // 🚀 Load restaurant tasks
  Future<void> loadRestaurantTasks(String restaurantId) async {
    try {
      isLoading.value = true;
      final fetchedTasks = await _repository.getRestaurantTasks(restaurantId);
      myRestaurantTasks.assignAll(fetchedTasks);
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

  Future<void> createTask(String restaurantId, String title, String description, int rewardPoints) async {
    try {
      await _repository.createTask(restaurantId, title, description, rewardPoints);
      Get.snackbar("Success", "Task created successfully!");
      await loadRestaurantTasks(restaurantId); // 👈 refresh after creation
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> updateTask(String taskId, Map<String, dynamic> updates, String restaurantId) async {
    try {
      await _repository.updateTask(taskId, updates);
      Get.snackbar("Updated", "Task updated successfully!");
      await loadRestaurantTasks(restaurantId); // refresh
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> deleteTask(String taskId, String restaurantId) async {
    try {
      await _repository.deleteTask(taskId);
      Get.snackbar("Deleted", "Task deleted successfully!");
      await loadRestaurantTasks(restaurantId); // refresh
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> changeStatus(String taskId, String status, String restaurantId) async {
    try {
      await _repository.updateTaskStatus(taskId, status);
      Get.snackbar("Updated", "Task marked as $status!");
      await loadRestaurantTasks(restaurantId); // refresh
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
