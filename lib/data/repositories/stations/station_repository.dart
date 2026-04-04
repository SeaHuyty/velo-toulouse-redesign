import 'package:velo_toulouse_redesign/data/models/station_model.dart';

abstract class StationRepository {
  Future<List<StationModel>> getStations();
}