import 'package:velo_toulouse_redesign/data/models/station_model.dart';

abstract class StationRepository {
  Future<List<StationModel>> getStations();

  Future<StationModel?> getStationById(String stationId);

  Future<void> checkoutBike({
    required String stationId,
    required String bikeNumber,
  });

  Future<void> dockBike({
    required String stationId,
    required String bikeNumber,
  });
}
