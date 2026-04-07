import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse_redesign/views/widgets/bike_renting_content.dart';
import '../../../data/repositories/stations/station_repository.dart';
import '../../../view_model/bike_renting_view_model.dart';

class BikeRentingScreen extends StatelessWidget {
  final String stationId;
  final String? bikePlateNumber;

  const BikeRentingScreen({
    super.key,
    required this.stationId,
    this.bikePlateNumber,
  });

  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider(
      create: (context) => BikeRentingViewModel(
        context.read<StationRepository>(),
        stationId,
        bikePlateNumber: bikePlateNumber,
      ),
      child: const Scaffold(
        body: SafeArea(
          child: BikeRentingContent(),
        ),
      ),
    );
  }
}