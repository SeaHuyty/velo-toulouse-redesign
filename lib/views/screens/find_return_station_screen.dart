import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:velo_toulouse_redesign/core/theme/theme.dart';
import 'package:velo_toulouse_redesign/core/utils/app_config.dart';
import 'package:velo_toulouse_redesign/data/models/station_model.dart';
import 'package:velo_toulouse_redesign/view_model/station_viewmodel.dart';

class FindReturnStationScreen extends ConsumerStatefulWidget {
  const FindReturnStationScreen({super.key});

  @override
  ConsumerState<FindReturnStationScreen> createState() =>
      _FindReturnStationScreenState();
}

class _FindReturnStationScreenState
    extends ConsumerState<FindReturnStationScreen> {
  StationModel? _selectedStation;

  void _onMarkerTap(StationModel station) {
    setState(() => _selectedStation = station);
  }

  void _dismiss() {
    setState(() => _selectedStation = null);
  }

  List<StationModel> _returnableStations(List<StationModel> stations) =>
      stations.where((s) => s.availableSpots > 0).toList();

  void _confirmReturn() {
    Navigator.pop(context, _selectedStation);
  }

  @override
  Widget build(BuildContext context) {
    final stationsAsync = ref.watch(stationViewModelProvider);

    return stationsAsync.when(
      loading: () => const Scaffold(
        backgroundColor: Color(0xFFF4F6F3),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF006D33)),
        ),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: const Color(0xFFF4F6F3),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.grey,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                'Failed to load stations',
                style: AppTextStyles.body.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
      data: (stations) {
        final returnable = _returnableStations(stations);

        return Scaffold(
          backgroundColor: const Color(0xFFF4F6F3),
          body: Stack(
            children: [
              // ── Map ────────────────────────────────────────────────
              FlutterMap(
                options: MapOptions(
                  initialCenter: const LatLng(13.3590756, 103.8709673),
                  initialZoom: 13.5,
                  onTap: (_, _) => _dismiss(),
                ),
                children: [
                  TileLayer(urlTemplate: AppConfig.mapboxTileUrl),

                  // Station markers
                  MarkerLayer(
                    markers: returnable.map((station) {
                      final isSelected = _selectedStation?.id == station.id;
                      return Marker(
                        point: LatLng(station.latitude, station.longitude),
                        width: 48,
                        height: 48,
                        child: GestureDetector(
                          onTap: () => _onMarkerTap(station),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF006D33)
                                  : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF006D33),
                                width: isSelected ? 0 : 2.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '${station.availableSpots}',
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF006D33),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              // ── Legend pill ────────────────────────────────────────
              Positioned(
                top: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF006D33),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Number shows available docking spots',
                          style: AppTextStyles.label.copyWith(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Station bottom card ────────────────────────────────
              if (_selectedStation != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _StationReturnCard(
                    station: _selectedStation!,
                    onDismiss: _dismiss,
                    onConfirm: _confirmReturn,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _StationReturnCard extends StatelessWidget {
  final StationModel station;
  final VoidCallback onDismiss;
  final VoidCallback onConfirm;

  const _StationReturnCard({
    required this.station,
    required this.onDismiss,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF4F6F3),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Station info row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5EE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_parking_rounded,
                  color: Color(0xFF006D33),
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station.name,
                      style: AppTextStyles.heading.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 13,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            station.address,
                            style: AppTextStyles.label.copyWith(
                              color: Colors.grey[500],
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Spot count badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF006D33),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${station.availableSpots} spots',
                  style: AppTextStyles.label.copyWith(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // CTA button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onConfirm,
              label: const Text(
                'Return Bike Here',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006D33),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
