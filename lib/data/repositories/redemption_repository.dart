import 'package:grain_and_gain_student/data/models/redemption_model.dart';
import 'package:grain_and_gain_student/data/providers/supabase_provider.dart';

class RedemptionRepository {
  final SupabaseProvider _provider = SupabaseProvider();

  /// Create a redemption (student side)
  Future<void> createRedemption(String studentId, String restaurantId, int points) async {
    final code = _generate6DigitCode();

    //  Fetch current wallet
    final wallet = await _provider.getWallet(studentId);
    if (wallet == null) {
      throw Exception("Wallet not found for this student.");
    }

    final currentBalance = wallet['balance_points'] ?? 0;

    //  Check if enough points are available
    if (currentBalance < points) {
      throw Exception("Not enough points in wallet to redeem.");
    }

    //  Create the redemption entry
    await _provider.createRedemption(studentId, restaurantId, code, points);

    //  Deduct points from wallet
    final newBalance = currentBalance - points;
    await _provider.updateWalletBalance(studentId, newBalance);
  }

  /// Validate code (restaurant side)
  Future<RedemptionModel?> validateCode(String code) async {
    final response = await _provider.validateRedemption(code);
    if (response == null) return null;
    return RedemptionModel.fromJson(response);
  }

  /// Mark redemption as used
  Future<void> markAsUsed(String redemptionId) async {
    await _provider.client.from('redemptions').update({'status': 'used'}).eq('id', redemptionId);
  }

  /// Get redemptions for student (including restaurant name)
  Future<List<RedemptionModel>> getStudentRedemptions(String studentId) async {
    final response = await _provider.client
        .from('redemptions')
        .select('*, restaurant:restaurant_id(name)')
        .eq('student_id', studentId)
        .order('created_at', ascending: false);

    return (response as List).map((e) => RedemptionModel.fromJson(e)).toList();
  }

  /// Get redemptions for restaurant
  Future<List<RedemptionModel>> getRestaurantRedemptions(String restaurantId) async {
    final response = await _provider.client
        .from('redemptions')
        .select('*, student:student_id(name)')
        .eq('restaurant_id', restaurantId)
        .order('created_at', ascending: false);

    return (response as List).map((e) => RedemptionModel.fromJson(e)).toList();
  }

  /// Generate random 6-digit redemption code
  String _generate6DigitCode() {
    final random = DateTime.now().millisecondsSinceEpoch % 1000000;
    return random.toString().padLeft(6, '0');
  }
}
