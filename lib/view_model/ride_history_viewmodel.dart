import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velo_toulouse_redesign/core/providers/auth_provider.dart';
import 'package:velo_toulouse_redesign/data/dtos/ride_history_dto.dart';
import 'package:velo_toulouse_redesign/data/models/ride_history_model.dart';
import 'package:velo_toulouse_redesign/data/repositories/ride_history/ride_history_firebase_repository.dart';

class RideHistoryViewModel extends AsyncNotifier<List<RideHistoryModel>> {
  @override
  Future<List<RideHistoryModel>> build() async {
    final authUser = ref.watch(authStateProvider).asData?.value;
    if (authUser == null) return <RideHistoryModel>[];

    return ref
        .read(rideHistoryRepositoryProvider)
        .getHistoryForUser(authUser.uid);
  }

  Future<RideHistoryModel?> startRide({
    required String userId,
    required String bikeNumber,
    required String fromStationName,
    required String fromStationAddress,
    double amountPaid = 2.0,
  }) async {
    final startedAtMs = DateTime.now().millisecondsSinceEpoch;
    final history = RideHistoryModel(
      id: '',
      userId: userId,
      bikeNumber: bikeNumber,
      fromStationName: fromStationName,
      fromStationAddress: fromStationAddress,
      startedAtMs: startedAtMs,
      amountPaid: amountPaid,
    );

    final sessionId = await ref
        .read(rideHistoryRepositoryProvider)
        .createRideHistory(history);

    return history.copyWith(id: sessionId);
  }

  Future<void> completeRide({
    required String sessionId,
    required String returnStationName,
    required String returnStationAddress,
    required int durationSeconds,
  }) async {
    final endedAtMs = DateTime.now().millisecondsSinceEpoch;

    await ref.read(rideHistoryRepositoryProvider).updateRideHistory(sessionId, {
      RideHistoryDto.returnStationNameKey: returnStationName,
      RideHistoryDto.returnStationAddressKey: returnStationAddress,
      RideHistoryDto.endedAtMsKey: endedAtMs,
      RideHistoryDto.durationSecondsKey: durationSeconds,
    });
  }
}

final rideHistoryViewModelProvider =
    AsyncNotifierProvider<RideHistoryViewModel, List<RideHistoryModel>>(() {
      return RideHistoryViewModel();
    });
