import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velo_toulouse_redesign/data/models/station_model.dart';
import 'package:velo_toulouse_redesign/data/repositories/stations/station_repository_firebase.dart';

class StationViewModel extends AsyncNotifier<List<StationModel>> {
  @override
  Future<List<StationModel>> build() async {
    return fetchStations();
  }

  Future<List<StationModel>> fetchStations() async {
    final repository = ref.read(stationRepositoryProvider);
    return repository.getStations();
  }
}

final stationViewModelProvider = AsyncNotifierProvider<StationViewModel, List<StationModel>>(() {
  return StationViewModel();
});