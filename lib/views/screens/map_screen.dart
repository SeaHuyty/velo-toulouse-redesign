import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:velo_toulouse_redesign/core/utils/app_config.dart';
import 'package:velo_toulouse_redesign/data/models/station_model.dart';
import 'package:velo_toulouse_redesign/view_model/station_viewmodel.dart';
import 'package:velo_toulouse_redesign/views/widgets/station_bottom_sheet.dart';
import 'package:velo_toulouse_redesign/views/widgets/station_markers_layer.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  void _showStationInfo(StationModel station) {
    final screenHeight = MediaQuery.of(context).size.height;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: screenHeight * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: StationBottomSheet(station: station),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) {
      return const Scaffold(body: SizedBox.expand());
    }

    final stationsAsync = ref.watch(stationViewModelProvider);

    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(13.3590756, 103.8709673),
          initialZoom: 13.5,
        ),
        children: [
          TileLayer(urlTemplate: AppConfig.mapboxTileUrl),
          stationsAsync.when(
            data: (stations) {
              if (!mounted) return const MarkerLayer(markers: []);
              return StationMarkersLayer(
                stations: stations,
                returnStationId: null,
                selectedStationId: null,
                onMarkerTap: _showStationInfo,
              );
            },
            error: (e, st) {
              return const MarkerLayer(markers: []);
            },
            loading: () => const MarkerLayer(markers: []),
          ),
        ],
      ),
    );
  }
}
