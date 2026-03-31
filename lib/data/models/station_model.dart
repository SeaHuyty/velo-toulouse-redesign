import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velo_toulouse_redesign/data/models/bike_model.dart';

class StationModel {
  final String id;
  final String name;
  final double latitude;
  final double longtitude;
  final int capacity;
  final List<BikeModel> bikes;

  const StationModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longtitude,
    required this.capacity,
    required this.bikes,
  });

  List<BikeModel> get dockedBikes => bikes.where((b) => b.status == BikeStatus.docked).toList();

  int get availableBikes => dockedBikes.length;
  int get availableSpots => capacity - availableBikes;

  factory StationModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    List<BikeModel> bikes = (data['bikes'] as List<dynamic>)
        .map((b) => BikeModel.fromMap(b as Map<String, dynamic>))
        .toList();

    return StationModel(
      id: doc.id,
      name: data['name'] as String,
      latitude: data['latitude'] as double,
      longtitude: data['longtitude'] as double,
      capacity: data['capacity'] as int,
      bikes: bikes,
    );
  }
}
