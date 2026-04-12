import 'dart:async';
import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/core/theme/theme.dart';
import 'package:velo_toulouse_redesign/data/models/station_model.dart';
import 'package:velo_toulouse_redesign/views/screens/find_return_station_screen.dart';
import 'package:velo_toulouse_redesign/views/screens/ride_summary_screen.dart';
import 'package:velo_toulouse_redesign/views/widgets/buttons/button.dart';

class ActiveRideScreen extends StatefulWidget {
  final String bikeNumber;

  const ActiveRideScreen({super.key, required this.bikeNumber});

  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen> {
  late final Timer _timer;
  int _secondsElapsed = 0;
  StationModel? _returnStation;

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

  Future<void> _openFindReturnStation() async {
    final selected = await Navigator.push<StationModel>(
      context,
      MaterialPageRoute(builder: (context) => const FindReturnStationScreen()),
    );
    if (selected != null) {
      setState(() => _returnStation = selected);
    }
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

  @override
  Widget build(BuildContext context) {
    final hasReturnStation = _returnStation != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F3),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
              child: Column(
                children: [
                  // ── Ride status hero card ───────────────────────
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF006D33),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        Positioned(
                          right: -40,
                          top: -40,
                          child: Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.07),
                            ),
                          ),
                        ),
                        Positioned(
                          left: -30,
                          bottom: -50,
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Status pill
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF90EE90),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Ride in Progress',
                                      style: AppTextStyles.label.copyWith(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Timer
                              Text(
                                _formattedTime,
                                style: AppTextStyles.heading.copyWith(
                                  color: Colors.white,
                                  fontSize: 56,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'elapsed time',
                                style: AppTextStyles.label.copyWith(
                                  color: Colors.white54,
                                  fontSize: 13,
                                ),
                              ),

                              const SizedBox(height: 24),
                              Divider(
                                color: Colors.white.withValues(alpha: 0.15),
                              ),
                              const SizedBox(height: 16),

                              // Bike info
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.15,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.directions_bike_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Bike in use',
                                        style: AppTextStyles.label.copyWith(
                                          color: Colors.white54,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        widget.bikeNumber,
                                        style: AppTextStyles.body.copyWith(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Return station card (after selection) ───────
                  if (hasReturnStation) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF006D33).withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
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
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Returning to',
                                  style: AppTextStyles.label.copyWith(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _returnStation!.name,
                                  style: AppTextStyles.body.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1A1A1A),
                                  ),
                                ),
                                Text(
                                  _returnStation!.address,
                                  style: AppTextStyles.label.copyWith(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: _openFindReturnStation,
                            child: Text(
                              'Change',
                              style: AppTextStyles.label.copyWith(
                                color: const Color(0xFF006D33),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // ── How to return card (before selection) ───────
                  if (!hasReturnStation)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.07),
                          width: 0.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'How to return',
                            style: AppTextStyles.heading.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 14),
                          _ReturnStep(
                            number: '1',
                            text:
                                'Find a nearby Vélo station using the map below',
                          ),
                          const SizedBox(height: 10),
                          _ReturnStep(
                            number: '2',
                            text: 'Dock your bike into any available slot',
                          ),
                          const SizedBox(height: 10),
                          _ReturnStep(
                            number: '3',
                            text: 'Wait for the green light to confirm return',
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ── Bottom CTA ──────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: hasReturnStation
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VeloButton(
                        text: "I've docked my bike",
                        onPressed: _onDocked,
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: _openFindReturnStation,
                        child: Text(
                          'Change return station',
                          style: AppTextStyles.label.copyWith(
                            color: Colors.grey[500],
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  )
                : VeloButton(
                    text: 'Find a Return Station',
                    onPressed: _openFindReturnStation,
                  ),
          ),
        ],
      ),
    );
  }
}

class _ReturnStep extends StatelessWidget {
  final String number;
  final String text;

  const _ReturnStep({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5EE),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              number,
              style: AppTextStyles.label.copyWith(
                color: const Color(0xFF006D33),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.label.copyWith(
              color: Colors.grey[600],
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
