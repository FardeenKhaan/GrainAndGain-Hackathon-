import 'package:get/get.dart';
import 'package:grain_and_gain_student/controllers/auth_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Get.put(AuthController());
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
