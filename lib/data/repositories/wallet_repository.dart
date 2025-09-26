import 'package:grain_and_gain_student/data/providers/supabase_provider.dart';
import '../models/wallet_model.dart';

class WalletRepository {
  final SupabaseProvider _provider = SupabaseProvider();

  // fetch wallet by studentId
  Future<WalletModel?> getWallet(String studentId) async {
    final response = await _provider.client.from('wallets').select().eq('student_id', studentId).maybeSingle();

    if (response != null) {
      return WalletModel.fromJson(response);
    }
    return null;
  }

  // update balance
  Future<void> updateBalance(String studentId, int newBalance) async {
    await _provider.client
        .from('wallets')
        .update({'balance_points': newBalance, 'updated_at': DateTime.now().toIso8601String()})
        .eq('student_id', studentId);
  }

  // create wallet for new student
  Future<void> createWallet(String studentId) async {
    await _provider.client.from('wallets').insert({'student_id': studentId, 'balance_points': 0});
  }
}
