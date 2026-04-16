import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/pass.dart';
import '../../data/repositories/passes/pass_repository_firebase.dart';
import '../core/providers/pass_booking_provider.dart';


final passViewModelProvider = AsyncNotifierProvider<PassViewModel, List<PassModel>>(PassViewModel.new);


class PassViewModel extends AsyncNotifier<List<PassModel>> {
  @override
  Future<List<PassModel>> build() async {
    final repo = ref.read(passRepositoryProvider);
    return repo.getAvailablePasses();
  }

  void selectPass(PassModel pass) {
    ref.read(selectedPassProvider.notifier).state = pass;
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

    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return 'Le: ${expiry.day} / ${months[expiry.month - 1]} / ${expiry.year}';
  }
}