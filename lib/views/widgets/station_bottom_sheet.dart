import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velo_toulouse_redesign/data/models/station_model.dart';
import 'package:velo_toulouse_redesign/views/screens/bike_renting_screen.dart';

class StationBottomSheet extends StatelessWidget {
  final StationModel station;
  const StationBottomSheet({super.key, required this.station});

  Future<void> _openDirections(BuildContext context) async {
    final destination = '${station.latitude},${station.longitude}';
    final mapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$destination&travelmode=walking',
    );

    final launched = await launchUrl(
      mapsUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Google Maps.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        // Station name + bike count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  station.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${station.availableBikes} bikes',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),

        // Available spots
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${station.availableSpots} spots available',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ),
        ),

        const SizedBox(height: 12),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openDirections(context),
              icon: const Icon(Icons.directions),
              label: const Text('Get Directions'),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Bike list — scrollable
        Expanded(
          child: ListView.builder(
            itemCount: station.dockedBikes.length,
            itemBuilder: (_, i) {
              final bike = station.dockedBikes[i];
              return ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BikeRentingScreen(
                    stationName: station.name, stationAddress: 'Testing', bike: bike,
                  )),
                ),
                leading: const CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.pedal_bike_outlined, color: Colors.white),
                ),
                title: Text('Standard ${bike.plateNumber}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              );
            },
          ),
        ),

        const SizedBox(height: 8),
      ],
    );
  }
}
