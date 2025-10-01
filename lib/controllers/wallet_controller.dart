import 'dart:async';

import 'package:get/get.dart';
import 'package:grain_and_gain_student/data/models/wallet_model.dart';
import 'package:grain_and_gain_student/data/repositories/wallet_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// class WalletController extends GetxController {
//   final WalletRepository _repository = WalletRepository();

//   var wallet = Rxn<WalletModel>();
//   var balance = 0.obs;
//   var isLoading = false.obs;

//   // load wallet for student
//   Future<void> loadWallet(String studentId) async {
//     try {
//       isLoading.value = true;
//       final data = await _repository.getWallet(studentId);

//       if (data != null) {
//         wallet.value = data;
//         balance.value = data.balancePoints;
//       } else {
//         // if no wallet exists yet → create one
//         await _repository.createWallet(studentId);
//         final newWallet = await _repository.getWallet(studentId);
//         if (newWallet != null) {
//           wallet.value = newWallet;
//           balance.value = newWallet.balancePoints;
//         }
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // update balance
//   Future<void> updateBalance(int newBalance) async {
//     final studentId = wallet.value?.studentId;
//     if (studentId != null) {
//       await _repository.updateBalance(studentId, newBalance);
//       balance.value = newBalance;
//     }
//   }
// }

class WalletController extends GetxController {
  final WalletRepository _repository = WalletRepository();

  var wallet = Rxn<WalletModel>();
  var balance = 0.obs;
  var isLoading = false.obs;

  RealtimeChannel? _walletChannel;

  @override
  void onClose() {
    _walletChannel?.unsubscribe();
    super.onClose();
  }

  // load wallet for student + subscribe
  Future<void> loadWallet(String studentId) async {
    try {
      isLoading.value = true;
      final data = await _repository.getWallet(studentId);

      if (data != null) {
        wallet.value = data;
        balance.value = data.balancePoints;
      } else {
        await _repository.createWallet(studentId);
        final newWallet = await _repository.getWallet(studentId);
        if (newWallet != null) {
          wallet.value = newWallet;
          balance.value = newWallet.balancePoints;
        }
      }

      // ✅ Enable realtime after initial load
      _walletChannel ??= _repository.subscribeToWallet(studentId, (payload) {
        final updated = WalletModel.fromJson(payload);
        wallet.value = updated;
        balance.value = updated.balancePoints;
      });
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // update balance
  Future<void> updateBalance(int newBalance) async {
    final studentId = wallet.value?.studentId;
    if (studentId != null) {
      await _repository.updateBalance(studentId, newBalance);
      // no need to set `balance.value = newBalance`
      // because realtime subscription will auto-update
    }
  }
}
