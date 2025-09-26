import 'package:get/get.dart';
import '../../data/providers/supabase_provider.dart';

class TaskController extends GetxController {
  final SupabaseProvider _provider = SupabaseProvider();

  var tasks = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  Future<void> loadTasks() async {
    try {
      isLoading.value = true;
      final data = await _provider.getTasks();
      tasks.assignAll(data);
    } catch (e) {
      print("❌ Error loading tasks: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
