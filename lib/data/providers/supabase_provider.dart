import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProvider {
  final SupabaseClient _client = Supabase.instance.client;

  SupabaseClient get client => _client; // 👈 add this

  // 🔑 AUTH
  Future<AuthResponse> signUp(String email, String password) async {
    return await _client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // 👤 USERS
  Future<Map<String, dynamic>?> getUser(String userId) async {
    final response = await _client.from('users').select().eq('id', userId).maybeSingle();
    return response;
  }

  Future<void> createUser(Map<String, dynamic> userData) async {
    await _client.from('users').insert(userData);
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _client.from('users').update(data).eq('id', userId);
  }

  // 📋 TASKS
  Future<List<Map<String, dynamic>>> getTasks() async {
    final response = await _client.from('tasks').select().eq('status', 'open');
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> applyForTask(String taskId, String studentId) async {
    await _client.from('submissions').insert({'task_id': taskId, 'student_id': studentId, 'proof_url': ''});
  }

  // 📤 SUBMISSIONS
  Future<void> submitProof(String taskId, String studentId, String proofUrl) async {
    await _client.from('submissions').update({'proof_url': proofUrl, 'status': 'pending'}).match({
      'task_id': taskId,
      'student_id': studentId,
    });
  }

  Future<List<Map<String, dynamic>>> getSubmissions(String studentId) async {
    final response = await _client.from('submissions').select().eq('student_id', studentId);
    return List<Map<String, dynamic>>.from(response);
  }

  // 💰 WALLET
  Future<Map<String, dynamic>?> getWallet(String studentId) async {
    final response = await _client.from('wallets').select().eq('student_id', studentId).maybeSingle();
    return response;
  }

  // 🔑 REDEMPTIONS
  Future<void> createRedemption(String studentId, String restaurantId, String code, int points) async {
    await _client.from('redemptions').insert({
      'student_id': studentId,
      'restaurant_id': restaurantId,
      'code': code,
      'points_used': points,
      'status': 'unused',
    });
  }

  Future<Map<String, dynamic>?> validateRedemption(String code) async {
    final response = await _client.from('redemptions').select().eq('code', code).maybeSingle();
    return response;
  }
}




// 🧩 What’s Covered Here

// Auth → signUp, signIn, signOut

// Users → fetch, create, update

// Tasks → list open tasks, apply for a task

// Submissions → upload proof, view submissions

// Wallet → fetch student’s wallet balance

// Redemptions → generate code, validate code