import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:velo_toulouse_redesign/core/theme/theme.dart';
import 'package:velo_toulouse_redesign/core/utils/app_config.dart';
import 'package:velo_toulouse_redesign/data/models/station_model.dart';
import 'package:velo_toulouse_redesign/view_model/station_viewmodel.dart';
import 'package:velo_toulouse_redesign/views/screens/ride_summary_screen.dart';

class ActiveRideScreen extends ConsumerStatefulWidget {
  final String bikeNumber;

  const ActiveRideScreen({super.key, required this.bikeNumber});

  @override
  ConsumerState<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends ConsumerState<ActiveRideScreen> {
  late final Timer _timer;
  int _secondsElapsed = 0;
  StationModel? _returnStation;
  StationModel? _selectedStation;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _secondsElapsed++);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = _secondsElapsed ~/ 60;
    final seconds = _secondsElapsed % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _onMarkerTap(StationModel station) {
    setState(() => _selectedStation = station);
  }

  void _dismissStationCard() {
    setState(() => _selectedStation = null);
  }

  void _setReturnStation(StationModel station) {
    setState(() {
      _returnStation = station;
      _selectedStation = null;
    });
  }

  void _onDocked() {
    _timer.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => RideSummaryScreen(
          bikeNumber: widget.bikeNumber,
          returnStation: _returnStation!,
          secondsElapsed: _secondsElapsed,
        ),
      ),
    );
  }

  void _showDockConfirmation() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFF4F6F3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFF006D33),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Confirm Return',
              style: AppTextStyles.heading.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Make sure your bike is fully locked into the slot at ${_returnStation!.name} before confirming.',
              textAlign: TextAlign.center,
              style: AppTextStyles.label.copyWith(
                color: Colors.grey[500],
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  _onDocked(); // then navigate
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006D33),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Yes, bike is locked',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text(
                'Go back',
                style: AppTextStyles.label.copyWith(
                  color: Colors.grey[500],
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<StationModel> _returnableStations(List<StationModel> stations) =>
      stations.where((s) => s.availableSpots > 0).toList();

  @override
  Widget build(BuildContext context) {
    final stationsAsync = ref.watch(stationViewModelProvider);
    final hasReturnStation = _returnStation != null;

    return Scaffold(
      body: Stack(
        children: [
          // ── Full screen map ───────────────────────────────────────
          stationsAsync.when(
            loading: () => const SizedBox.expand(),
            error: (_, _) => const SizedBox.expand(),
            data: (stations) {
              final returnable = _returnableStations(stations);
              return FlutterMap(
                options: MapOptions(
                  initialCenter: const LatLng(13.3590756, 103.8709673),
                  initialZoom: 13.5,
                  onTap: (_, _) => _dismissStationCard(),
                ),
                children: [
                  TileLayer(urlTemplate: AppConfig.mapboxTileUrl),
                  MarkerLayer(
                    markers: returnable.map((station) {
                      final isReturn = _returnStation?.id == station.id;
                      final isSelected = _selectedStation?.id == station.id;
                      return Marker(
                        point: LatLng(station.latitude, station.longitude),
                        width: 52,
                        height: 52,
                        child: GestureDetector(
                          onTap: () => _onMarkerTap(station),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isReturn
                                  ? const Color(0xFF006D33)
                                  : isSelected
                                  ? const Color(0xFF004D24)
                                  : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF006D33),
                                width: (isReturn || isSelected) ? 0 : 2.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: isReturn
                                ? const Icon(
                                    Icons.flag_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : Center(
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
              );
            },
          ),

          // ── Legend pill ───────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
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
                      'Tap a station to return your bike',
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

          // ── Station selection bottom card ─────────────────────────
          if (_selectedStation != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 230,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _StationCard(
                  station: _selectedStation!,
                  isCurrentReturn: _returnStation?.id == _selectedStation!.id,
                  onConfirm: () => _setReturnStation(_selectedStation!),
                  onDismiss: _dismissStationCard,
                ),
              ),
            ),

          // ── Floating bottom ride sheet ─────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _RideBottomSheet(
              formattedTime: _formattedTime,
              bikeNumber: widget.bikeNumber,
              returnStation: _returnStation,
              hasReturnStation: hasReturnStation,
              onDocked: _showDockConfirmation,
              onClearReturn: () => setState(() => _returnStation = null),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Ride bottom sheet ───────────────────────────────────────────────────────
class _RideBottomSheet extends StatelessWidget {
  final String formattedTime;
  final String bikeNumber;
  final StationModel? returnStation;
  final bool hasReturnStation;
  final VoidCallback onDocked;
  final VoidCallback onClearReturn;

  const _RideBottomSheet({
    required this.formattedTime,
    required this.bikeNumber,
    required this.returnStation,
    required this.hasReturnStation,
    required this.onDocked,
    required this.onClearReturn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF006D33),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Timer + bike row
          Row(
            children: [
              // Timer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Elapsed time',
                      style: AppTextStyles.label.copyWith(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formattedTime,
                      style: AppTextStyles.heading.copyWith(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              Container(
                width: 1,
                height: 48,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              const SizedBox(width: 20),

              // Bike info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bike in use',
                    style: AppTextStyles.label.copyWith(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.directions_bike_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        bikeNumber,
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Return station row (if selected)
          if (hasReturnStation) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.flag_rounded, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      returnStation!.name,
                      style: AppTextStyles.label.copyWith(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: onClearReturn,
                    child: Text(
                      'Change',
                      style: AppTextStyles.label.copyWith(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // CTA
          hasReturnStation
              ? _SwipeToDock(onDocked: onDocked)
              : SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: null,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.4),
                        width: 1,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Tap a station on the map to return',
                      style: AppTextStyles.label.copyWith(
                        color: Colors.white60,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

// ── Station selection card ──────────────────────────────────────────────────
class _StationCard extends StatelessWidget {
  final StationModel station;
  final bool isCurrentReturn;
  final VoidCallback onConfirm;
  final VoidCallback onDismiss;

  const _StationCard({
    required this.station,
    required this.isCurrentReturn,
    required this.onConfirm,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F3),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station.name,
                      style: AppTextStyles.heading.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      station.address,
                      style: AppTextStyles.label.copyWith(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
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
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isCurrentReturn ? null : onConfirm,
              icon: Icon(
                isCurrentReturn
                    ? Icons.flag_rounded
                    : Icons.check_circle_rounded,
                size: 18,
              ),
              label: Text(
                isCurrentReturn
                    ? 'Selected as return station'
                    : 'Return Bike Here',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isCurrentReturn
                    ? Colors.grey[200]
                    : const Color(0xFF006D33),
                foregroundColor: isCurrentReturn
                    ? Colors.grey[500]
                    : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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

class _SwipeToDock extends StatefulWidget {
  final VoidCallback onDocked;
  const _SwipeToDock({required this.onDocked});

  @override
  State<_SwipeToDock> createState() => _SwipeToDockState();
}

class _SwipeToDockState extends State<_SwipeToDock> {
  double _dragPosition = 0;
  static const double _thumbSize = 56;
  static const double _threshold = 0.85; // 85% of track = confirmed

  void _onDragUpdate(DragUpdateDetails details, double maxWidth) {
    setState(() {
      _dragPosition = (_dragPosition + details.delta.dx).clamp(
        0,
        maxWidth - _thumbSize,
      );
    });
  }

  void _onDragEnd(double maxWidth) {
    final progress = _dragPosition / (maxWidth - _thumbSize);
    if (progress >= _threshold) {
      widget.onDocked();
    } else {
      // Snap back
      setState(() => _dragPosition = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final progress = _dragPosition / (maxWidth - _thumbSize);

        return Container(
          height: _thumbSize,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              // Fill track
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: _dragPosition + _thumbSize,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: progress * 0.25),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              // Hint text
              Center(
                child: Opacity(
                  opacity: (1 - progress * 2).clamp(0, 1),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: _thumbSize * 0.5),
                      Text(
                        "Swipe to confirm dock",
                        style: AppTextStyles.label.copyWith(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Draggable thumb
              Positioned(
                left: _dragPosition,
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  onHorizontalDragUpdate: (d) => _onDragUpdate(d, maxWidth),
                  onHorizontalDragEnd: (_) => _onDragEnd(maxWidth),
                  child: Container(
                    width: _thumbSize,
                    height: _thumbSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      progress >= _threshold
                          ? Icons.check_rounded
                          : Icons.chevron_right_rounded,
                      color: const Color(0xFF006D33),
                      size: 26,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
