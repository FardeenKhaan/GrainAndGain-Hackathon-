import 'package:get/get.dart';
import 'package:grain_and_gain_student/data/models/redemption_model.dart';
import 'package:grain_and_gain_student/data/repositories/redemption_repository.dart';

class RedemptionController extends GetxController {
  final RedemptionRepository _repository = RedemptionRepository();

  RxList<RedemptionModel> redemptions = <RedemptionModel>[].obs;
  RxBool isLoading = false.obs;

  // Load student’s redemptions
  Future<void> loadStudentRedemptions(String studentId) async {
    try {
      isLoading.value = true;
      final list = await _repository.getStudentRedemptions(studentId);
      redemptions.assignAll(list);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Load restaurant’s redemptions
  Future<void> loadRestaurantRedemptions(String restaurantId) async {
    try {
      isLoading.value = true;
      final list = await _repository.getRestaurantRedemptions(restaurantId);
      redemptions.assignAll(list);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Student redeems points
  Future<void> redeemPoints(String studentId, String restaurantId, int points) async {
    try {
      isLoading.value = true;
      await _repository.createRedemption(studentId, restaurantId, points);
      Get.snackbar('Success', 'Redemption created successfully!');
      await loadStudentRedemptions(studentId);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Restaurant validates code
  Future<void> validateCode(String code) async {
    try {
      isLoading.value = true;
      final redemption = await _repository.validateCode(code);

      if (redemption == null) {
        Get.snackbar('Invalid', 'No redemption found for this code');
        return;
      }

      if (redemption.status == 'used') {
        Get.snackbar('Already Used', 'This redemption has already been used.');
        return;
      }

      await _repository.markAsUsed(redemption.id);
      Get.snackbar('Success', 'Redemption validated and marked as used!');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
