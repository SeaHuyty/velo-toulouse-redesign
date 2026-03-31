// map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:velo_toulouse_redesign/core/map_box_config.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(13.3590756, 103.8709673),
          initialZoom: 13.5,
        ),
        children: [
          TileLayer(
            urlTemplate: MapBoxConfig.mapboxTileUrl,
          ),
        ],
      ),
    );
  }
}