import 'package:grain_and_gain_student/data/models/user_model.dart';
import 'package:grain_and_gain_student/data/providers/supabase_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseProvider _provider = SupabaseProvider();

  // SIGN UP
  Future<UserModel?> signUp(String email, String password, String name, String role, String phone) async {
    try {
      final authResponse = await _provider.signUp(email, password);
      final user = authResponse.user;

      if (user == null) {
        throw Exception("Signup failed. Maybe this email already exists.");
      }

      // Insert into your users table
      final newUser = {
        'id': user.id,
        'role': role,
        'name': name,
        'email': email,
        'phone': phone,
        'created_at': DateTime.now().toIso8601String(),
      };

      final existing = await _provider.getUser(user.id);
      if (existing == null) {
        await _provider.createUser(newUser);
      }

      return UserModel.fromJson(newUser);
    } on AuthException catch (e) {
      throw Exception("Signup failed: ${e.message}");
    } catch (e) {
      throw Exception("Unknown error: $e");
    }
  }

  // SIGN IN
  Future<UserModel?> signIn(String email, String password) async {
    final authResponse = await _provider.signIn(email, password);
    final user = authResponse.user;

    if (user != null) {
      var data = await _provider.getUser(user.id);

      if (data == null) {
        // If there's no user row in `users` table, create a minimal record.
        // Defaulting to 'student' is a safety-net — you can change this behavior.
        final newUser = {
          'id': user.id,
          'role': 'student',
          'name': user.email?.split('@')[0] ?? 'User',
          'email': user.email ?? '',
          'created_at': DateTime.now().toIso8601String(),
        };
        await _provider.createUser(newUser);
        data = newUser;
      }

      return UserModel.fromJson(data);
    }

    return null;
  }

  // SIGN OUT
  Future<void> signOut() async {
    await _provider.signOut();
  }

  // FETCH USER PROFILE
  Future<UserModel?> getProfile(String userId) async {
    final data = await _provider.getUser(userId);
    if (data != null) {
      return UserModel.fromJson(data);
    }
    return null;
  }

  // UPDATE PROFILE
  Future<void> updateProfile(String userId, Map<String, dynamic> updates) async {
    await _provider.updateUser(userId, updates);
  }
}
