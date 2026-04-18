import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:velo_toulouse_redesign/view_model/user_viewmodel.dart';
import '../data/models/pass_model.dart';
import '../core/providers/pass_booking_provider.dart';


final passViewModelProvider = AsyncNotifierProvider<PassViewModel, List<PassModel>>(PassViewModel.new);

class PassViewModel extends AsyncNotifier<List<PassModel>> {
  @override
  Future<List<PassModel>> build() async {
    final repo = ref.read(passRepositoryProvider);
    return repo.getAvailablePasses();
  }

  bool hasActivePass() {
    final user = ref.read(userViewModelProvider).value;
    final expiry = user?.activePassExpiry;
    
    if (expiry == null) return false;

    try {
      final expiryDate = DateFormat('d / MMMM / y').parse(expiry);
     
      return expiryDate.isAfter(DateTime.now());
    } catch (e) {
      return false; 
    }
  }

  String getExpiryDate() {
    final selectedPass = ref.read(selectedPassProvider);
    if (selectedPass == null) return '';

    final now = DateTime.now();
    DateTime expiry;
    final duration = selectedPass.duration.toLowerCase();

    if (duration.contains('24 hours') || duration.contains('1 day')) {
      expiry = now.add(const Duration(days: 1));
    } else if (duration.contains('7 days')) {
      expiry = now.add(const Duration(days: 7));
    } else if (duration.contains('30 days')) {
      expiry = now.add(const Duration(days: 30));
    } else if (duration.contains('1 year')) {
      expiry = now.add(const Duration(days: 365));
    } else {
      expiry = now.add(const Duration(days: 1));
    }

    return '${expiry.day} / ${DateFormat('MMMM').format(expiry)} / ${expiry.year}';
  }

  Future<void> purchasePass(PassModel pass) async {
    final expiryDate = getExpiryDate();
    final user = ref.read(userViewModelProvider).value;

    if (user != null) {
      final updatedUser = user.copyWith(
        activePassId: pass.id,
        activePassTitle: pass.title,
        activePassExpiry: expiryDate,
      );
      await ref.read(userViewModelProvider.notifier).updateUserProfile(updatedUser);
    }
  }
}