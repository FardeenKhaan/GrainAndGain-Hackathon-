import 'package:get/get.dart';
import 'package:grain_and_gain_student/data/models/user_model.dart';
import 'package:grain_and_gain_student/data/repositories/auth_repository.dart';
import 'package:grain_and_gain_student/routers/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final AuthRepository _repository = AuthRepository();

  RxBool isLoading = false.obs;
  var currentUser = Rxn<UserModel>();

  // @override
  // void onInit() {
  //   super.onInit();
  //   initAuth();
  // }

  // // 👇 Check existing session when app starts
  // Future<void> initAuth() async {
  //   final session = Supabase.instance.client.auth.currentSession;

  //   if (session != null && session.user != null) {
  //     final userId = session.user!.id;
  //     await loadProfile(userId);
  //     Get.offAllNamed(FkRoutes.dashboard);
  //   } else {
  //     Get.offAllNamed(FkRoutes.logIn);
  //   }
  // }

  // 🔑 SIGN UP
  Future<void> signUp(String email, String password, String name) async {
    try {
      isLoading.value = true;
      final user = await _repository.signUp(email, password, name);
      if (user != null) {
        currentUser.value = user;
        Get.snackbar("Success", "Account created successfully!");
        // Get.snackbar("Welcome", "Hello ${user.name}!");
        Get.offNamed(FkRoutes.dashboard); // 👈 go to student dashboard
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // 🔑 SIGN IN
  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      final user = await _repository.signIn(email, password);
      if (user != null) {
        currentUser.value = user;
        // Get.snackbar("Welcome", "Hello ${user.name}!");
        Get.offNamed(FkRoutes.dashboard); // 👈 go to student dashboard
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // 🚪 SIGN OUT
  Future<void> signOut() async {
    try {
      await _repository.signOut();
      currentUser.value = null;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // 👤 FETCH USER PROFILE
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

  // ✏️ UPDATE PROFILE
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



// 🧩 How It Works

// AuthController = Business logic + state (isLoading, currentUser).

// AuthRepository = Talks to SupabaseProvider and maps data into UserModel.

// SupabaseProvider = Direct Supabase queries (already built).