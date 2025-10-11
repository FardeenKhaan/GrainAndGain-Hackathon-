import 'package:get/get.dart';
import 'package:grain_and_gain_student/data/models/user_model.dart';
import 'package:grain_and_gain_student/data/repositories/auth_repository.dart';
import 'package:grain_and_gain_student/routers/routes.dart';

class AuthController extends GetxController {
  final AuthRepository _repository = AuthRepository();

  RxBool isLoading = false.obs;
  var currentUser = Rxn<UserModel>();

  // SIGN UP (now accepts a role: "student" or "restaurant")
  Future<void> signUp(String email, String password, String name, String role, String phone) async {
    try {
      isLoading.value = true;
      final user = await _repository.signUp(email, password, name, role, phone);
      if (user != null) {
        currentUser.value = user;
        Get.snackbar("Success", "Account created successfully!");

        // Redirect depending on role
        if (user.role == 'student') {
          Get.offAllNamed(FkRoutes.studentDashboard);
        } else if (user.role == 'restaurant') {
          Get.offAllNamed(FkRoutes.restaurantDashboard);
        } else {
          // fallback
          Get.offAllNamed(FkRoutes.studentDashboard);
        }
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // SIGN IN (redirects based on role)
  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      final user = await _repository.signIn(email, password);
      if (user != null) {
        currentUser.value = user;

        // Redirect depending on role
        if (user.role == 'student') {
          Get.offAllNamed(FkRoutes.studentDashboard);
        } else if (user.role == 'restaurant') {
          Get.offAllNamed(FkRoutes.restaurantDashboard);
        } else {
          Get.offAllNamed(FkRoutes.studentDashboard);
        }
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // SIGN OUT
  Future<void> signOut() async {
    try {
      await _repository.signOut();
      currentUser.value = null;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // FETCH USER PROFILE
  Future<void> loadProfile(String userId) async {
    try {
      isLoading.value = true;
      final user = await _repository.getProfile(userId);
      if (user != null) {
        currentUser.value = user;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // UPDATE PROFILE
  Future<void> updateProfile(Map<String, dynamic> updates) async {
    try {
      final userId = currentUser.value?.id;
      if (userId != null) {
        await _repository.updateProfile(userId, updates);
        await loadProfile(userId); // refresh
        Get.snackbar("Updated", "Profile updated successfully!");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}





// How It Works

// AuthController = Business logic + state (isLoading, currentUser).

// AuthRepository = Talks to SupabaseProvider and maps data into UserModel.

// SupabaseProvider = Direct Supabase queries (already built).