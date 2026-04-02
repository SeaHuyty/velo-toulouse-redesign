import 'package:velo_toulouse_redesign/data/models/bike_model.dart';

class StationModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final int capacity;
  final List<BikeModel> bikes;

  const StationModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.capacity,
    required this.bikes,
  });

  List<BikeModel> get dockedBikes =>
      bikes.where((b) => b.status == BikeStatus.docked).toList();

  int get availableBikes => dockedBikes.length;
  int get availableSpots => capacity - availableBikes;

  factory StationModel.fromSnapshot(String key, dynamic value) {
    final data = Map<String, dynamic>.from(value as Map);

    final rawBikes = data['bikes'] as Map;
    final bikes = rawBikes.values
        .map((b) => BikeModel.fromMap(Map<String, dynamic>.from(b as Map)))
        .toList();

    return StationModel(
      id: key,
      name: data['name'] as String,
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      capacity: (data['capacity'] as num).toInt(),
      bikes: bikes,
    );
  }
}