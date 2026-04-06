import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/data/models/bike_model.dart';
import 'package:velo_toulouse_redesign/data/models/station_model.dart';
import 'package:velo_toulouse_redesign/core/theme/theme.dart';
import 'package:velo_toulouse_redesign/views/widgets/display/devider.dart';


class StationInfoWidget extends StatelessWidget {
  final StationModel station;
  final BikeModel? bike;

  const StationInfoWidget({
    super.key,
    required this.station,
    required this.bike,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Station Info",
            style: AppTextStyles.heading.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF006D33), 
            ),
          ),
          const SizedBox(height: 50),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on, 
                color: Colors.green, 
                size: 40
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station.name,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Sivatha Rd, Siem Reap", 
                      style: AppTextStyles.label.copyWith(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              const Icon(
                Icons.directions_bike, 
                color: Colors.brown, 
                size: 40
              ),
              const SizedBox(width: 16),
              Text(
                "NO. ${bike?.plateNumber}",
                style: AppTextStyles.body.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

           VeloDivider(), 
        ],
      ),
    );
  }
}