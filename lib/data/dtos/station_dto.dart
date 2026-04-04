import 'package:velo_toulouse_redesign/data/models/bike_model.dart';
import 'package:velo_toulouse_redesign/data/models/station_model.dart';

class StationDto {
  static const String name = 'name';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';
  static const String capacity = 'capacity';
  static const String jsonBikes = 'bikes';

  static StationModel fromSnapshot(String key, dynamic value) {
    final data = Map<String, dynamic>.from(value as Map);

    final rawBikes = data[jsonBikes] as Map;
    final bikes = rawBikes.values
        .map((b) => BikeModel.fromMap(Map<String, dynamic>.from(b as Map)))
        .toList();

    return StationModel(
      id: key,
      name: data[name] as String,
      latitude: (data[latitude] as num).toDouble(),
      longitude: (data[longitude] as num).toDouble(),
      capacity: (data[capacity] as num).toInt(),
      bikes: bikes,
    );
}
}