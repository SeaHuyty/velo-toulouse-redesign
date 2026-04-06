import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/data/models/bike_model.dart';
import 'package:velo_toulouse_redesign/data/repositories/stations/station_repository.dart';
import 'package:velo_toulouse_redesign/data/models/station_model.dart';
import 'package:velo_toulouse_redesign/views/utils/async_value.dart';

class BikeRentingViewModel extends ChangeNotifier {
  final StationRepository repository;
  
  AsyncValue<StationModel> stationStatus = AsyncValue.loading();

   BikeModel? selectedBike;

  BikeRentingViewModel(this.repository, String stationId, {String? bikePlateNumber}) {
    loadStation(stationId, bikePlateNumber: bikePlateNumber);
  }

  Future<void> loadStation(String id, {String? bikePlateNumber}) async {
    stationStatus = AsyncValue.loading();
    notifyListeners();
    
    try {
      final station = await repository.getStationById(id);
      
      if (station != null) {
        if (bikePlateNumber != null) {
          selectedBike = station.bikes.firstWhere(
            (b) => b.plateNumber == bikePlateNumber,
            orElse: () => station.bikes.firstWhere(
              (b) => b.status == BikeStatus.docked,
              orElse: () => station.bikes.first,
            ),
          );
        } else if (station.bikes.isNotEmpty) {
          selectedBike = station.bikes.firstWhere(
            (b) => b.status == BikeStatus.docked,
            orElse: () => station.bikes.first,
          );
        }
        stationStatus = AsyncValue.success(station);
      } else {
        stationStatus = AsyncValue.error("Station not found");
      }
    } catch (e) {
      stationStatus = AsyncValue.error(e);
    }
    
    notifyListeners();
    
  }
      void selectBike(BikeModel bike) {
        selectedBike = bike;
        notifyListeners();
      }
  }


