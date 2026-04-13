import 'package:flutter_riverpod/legacy.dart';

class RideSession {
  final String bikeNumber;
  final String fromStationName;
  final String fromStationAddress;
  final String? returnStationName;
  final String? returnStationAddress;

  const RideSession({
    required this.bikeNumber,
    required this.fromStationName,
    required this.fromStationAddress,
    this.returnStationName,
    this.returnStationAddress,
  });

  RideSession copyWith({
    String? bikeNumber,
    String? fromStationName,
    String? fromStationAddress,
    String? returnStationName,
    String? returnStationAddress,
  }) {
    return RideSession(
      bikeNumber: bikeNumber ?? this.bikeNumber,
      fromStationName: fromStationName ?? this.fromStationName,
      fromStationAddress: fromStationAddress ?? this.fromStationAddress,
      returnStationName: returnStationName ?? this.returnStationName,
      returnStationAddress: returnStationAddress ?? this.returnStationAddress,
    );
  }
}

final rideSessionProvider = StateProvider<RideSession?>((ref) => null);
