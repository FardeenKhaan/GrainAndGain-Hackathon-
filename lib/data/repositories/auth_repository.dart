import 'package:grain_and_gain_student/data/models/user_model.dart';
import 'package:grain_and_gain_student/data/providers/supabase_provider.dart';

class AuthRepository {
  final SupabaseProvider _provider = SupabaseProvider();

  // 🔑 SIGN UP
  Future<UserModel?> signUp(String email, String password, String name) async {
    // create user in Supabase Auth
    final authResponse = await _provider.signUp(email, password);

    final user = authResponse.user;
    if (user != null) {
      // insert into "users" table if not exists
      final newUser = {'id': user.id, 'role': 'student', 'name': name, 'email': email};

      // Check if already exists (avoid duplicate error if re-signing up)
      final existing = await _provider.getUser(user.id);
      if (existing == null) {
        await _provider.createUser(newUser);
      }

      // 👉 Immediately return as signed-in user
      return UserModel.fromJson(newUser);
    }
    return null;
  }

  // 🔑 SIGN IN
  Future<UserModel?> signIn(String email, String password) async {
    final authResponse = await _provider.signIn(email, password);
    final user = authResponse.user;

    if (user != null) {
      var data = await _provider.getUser(user.id);

      if (data == null) {
        // 👇 create a minimal user row if it doesn't exist
        final newUser = {
          'id': user.id,
          'role': 'student',
          'name': user.email?.split('@')[0] ?? 'Student',
          'email': user.email ?? '',
        };
        await _provider.createUser(newUser);
        data = newUser;
      }

      return UserModel.fromJson(data);
    }

    return null;
  }

  // 🚪 SIGN OUT
  Future<void> signOut() async {
    await _provider.signOut();
  }

  // 👤 FETCH USER PROFILE
  Future<UserModel?> getProfile(String userId) async {
    final data = await _provider.getUser(userId);
    if (data != null) {
      return UserModel.fromJson(data);
    }
    return null;
  }

  // ✏️ UPDATE PROFILE
  Future<void> updateProfile(String userId, Map<String, dynamic> updates) async {
    await _provider.updateUser(userId, updates);
  }
}
