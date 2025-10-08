import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grain_and_gain_student/data/models/wallet_model.dart';
import 'package:grain_and_gain_student/data/repositories/wallet_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

      // Enable realtime after initial load
      _walletChannel ??= _repository.subscribeToWallet(studentId, (payload) {
        final updated = WalletModel.fromJson(payload);
        if (updated.balancePoints > balance.value) {
          Get.snackbar(
            "🎉 Points Added!",
            "You’ve earned ${updated.balancePoints - balance.value} new points!",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green.shade600,
            colorText: Colors.white,
          );
        }
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
    }
  }
}
