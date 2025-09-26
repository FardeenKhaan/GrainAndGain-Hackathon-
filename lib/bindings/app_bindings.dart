import 'package:get/get.dart';
import 'package:grain_and_gain_student/controllers/auth_controller.dart';
import 'package:grain_and_gain_student/controllers/task_controller.dart';
import 'package:grain_and_gain_student/controllers/wallet_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    // Get.lazyPut<AuthController>(() => AuthController());
    Get.put(WalletController(), permanent: true);
    Get.put(TaskController(), permanent: true);
  }
}
