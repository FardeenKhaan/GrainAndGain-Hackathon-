import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProvider {
  final SupabaseClient _client = Supabase.instance.client;

  SupabaseClient get client => _client;

  //  AUTH
  Future<AuthResponse> signUp(String email, String password) async {
    try {
      final response = await _client.auth.signUp(email: email, password: password);
      return response;
    } on AuthException catch (e) {
      throw Exception("Auth error: ${e.message}");
    } catch (e) {
      throw Exception("Unknown signup error: $e");
    }
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
    // maybeSingle returns the row or null
    return response;
  }

  Future<void> createUser(Map<String, dynamic> userData) async {
    await _client.from('users').insert(userData);
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _client.from('users').update(data).eq('id', userId);
  }

  // (the rest of your provider methods remain unchanged)
  // 🚀 Get tasks created by a restaurant
  Future<List<Map<String, dynamic>>> getRestaurantTasks(String restaurantId) async {
    final response = await _client.from('tasks').select().eq('restaurant_id', restaurantId);
    return List<Map<String, dynamic>>.from(response);
  }

  // 📋 TASKS
  Future<List<Map<String, dynamic>>> getTasks() async {
    final response = await _client.from('tasks').select().eq('status', 'open');
    return List<Map<String, dynamic>>.from(response);
  }

  // Future<void> applyForTask(String taskId, String studentId) async {
  //   await _client.from('submissions').insert({'task_id': taskId, 'student_id': studentId, 'proof_url': ''});
  // }
  Future<void> applyForTask(String taskId, String studentId) async {
    try {
      await _client.from('submissions').insert({
        'task_id': taskId,
        'student_id': studentId,
        'proof_url': '', // empty initially
        'status': 'pending',
      });
    } catch (e) {
      throw Exception("Failed to apply for task: $e");
    }
  }

  // 📤 SUBMISSIONS
  // Future<void> submitProof(String taskId, String studentId, String proofUrl) async {
  //   await _client.from("submissions").insert({
  //     'task_id': taskId,
  //     'student_id': studentId,
  //     'proof_url': proofUrl,
  //     'status': 'pending',
  //   });
  // }
  Future<void> submitProof(String taskId, String studentId, String proofUrl) async {
    await _client.from("submissions").upsert({
      'task_id': taskId,
      'student_id': studentId,
      'proof_url': proofUrl,
      'status': 'pending',
    }, onConflict: 'task_id,student_id');
  }

  // Future<List<Map<String, dynamic>>> getSubmissions(String studentId) async {
  //   final response = await _client.from('submissions').select().eq('student_id', studentId);
  //   return List<Map<String, dynamic>>.from(response);
  // }
  // 👀 Restaurant fetches all submissions for their tasks
  Future<List<Map<String, dynamic>>> getTaskSubmissions(String restaurantId) async {
    final response = await _client
        .from('submissions')
        .select('*, tasks!inner(title, restaurant_id)')
        .eq('tasks.restaurant_id', restaurantId);
    return List<Map<String, dynamic>>.from(response);
  }

  // 🟢 Approve / 🔴 Reject submission
  // Future<void> updateSubmissionStatus(String submissionId, String status) async {
  //   await _client.from('submissions').update({'status': status}).eq('id', submissionId);
  // }
  // Future<void> updateSubmissionStatus(String submissionId, String status) async {
  //   await _client
  //       .from("submissions")
  //       .update({"status": status})
  //       .eq("id", submissionId); // ✅ use submission id, not user_id
  // }
  // 🛠️ Update submission status
  Future<void> updateSubmissionStatus(String submissionId, String status) async {
    await _client.from('submissions').update({'status': status}).eq('id', submissionId); // ✅ correct filter
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

  // 🚀 Realtime listener for tasks
  RealtimeChannel subscribeToTasks(void Function(Map<String, dynamic> payload) onChange) {
    final channel = _client.channel('public:tasks')
      ..onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'tasks',
        callback: (payload) {
          onChange(payload.newRecord ?? payload.oldRecord ?? {});
        },
      )
      ..subscribe();

    return channel;
  }

  // in SupabaseProvider
  RealtimeChannel subscribeToWallet(String studentId, void Function(Map<String, dynamic> payload) onChange) {
    final channel = _client.channel('public:wallets')
      ..onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'wallets',
        callback: (payload) {
          // Only trigger if this wallet belongs to the student
          final record = payload.newRecord ?? payload.oldRecord ?? {};
          if (record['student_id'] == studentId) {
            onChange(record);
          }
        },
      )
      ..subscribe();

    return channel;
  }

  RealtimeChannel subscribeToSubmissions(void Function(Map<String, dynamic> payload) onChange) {
    final channel = _client.channel('public:submissions')
      ..onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'submissions',
        callback: (payload) {
          onChange(payload.newRecord ?? payload.oldRecord ?? {});
        },
      )
      ..subscribe();

    return channel;
  }
}




// 🧩 What’s Covered Here

// Auth → signUp, signIn, signOut

// Users → fetch, create, update

// Tasks → list open tasks, apply for a task

// Submissions → upload proof, view submissions

// Wallet → fetch student’s wallet balance

// Redemptions → generate code, validate code