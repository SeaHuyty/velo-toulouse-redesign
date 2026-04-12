import 'dart:async';
import 'dart:ui';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/views/screens/payment_success_screen.dart';
import 'package:velo_toulouse_redesign/views/widgets/top_bar/app_bar.dart';

enum ProcessStage { initialize, paying, processing, paid }

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Timer? _stageTimer;
  ProcessStage stage = ProcessStage.initialize;

  @override
  void initState() {
    super.initState();
    _startStageTimer();
  }

  void _startStageTimer() {
    _stageTimer?.cancel();

    final duration = switch (stage) {
      ProcessStage.initialize => const Duration(seconds: 3),
      ProcessStage.paying => const Duration(seconds: 6),
      ProcessStage.processing => const Duration(seconds: 2),
      ProcessStage.paid => null,
    };

    if (duration == null) return;

    _stageTimer = Timer(duration, () {
      if (!mounted) return;
      _advanceStage();
    });
  }

  void _advanceStage() {
    final next = switch (stage) {
      ProcessStage.initialize => ProcessStage.paying,
      ProcessStage.paying => ProcessStage.processing,
      ProcessStage.processing => ProcessStage.paid,
      ProcessStage.paid => null,
    };

    if (next == null) return;

    setState(() => stage = next);

    if (next != ProcessStage.paid) {
      _startStageTimer();
    }
  }

  @override
  void dispose() {
    _stageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return switch (stage) {
      ProcessStage.initialize => _buildInitialize(),
      ProcessStage.paying => _buildPayingWithOverlay(),
      ProcessStage.processing => _buildPayingWithOverlay(),
      ProcessStage.paid => const PaymentSuccessScreen(),
    };
  }

  Widget _buildInitialize() {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Initializing payment'),
          ],
        ),
      ),
    );
  }

  Widget _buildPayingWithOverlay() {
    return Stack(
      children: [
        _buildPaying(),
        if (stage == ProcessStage.processing) _buildProcessingOverlay(),
      ],
    );
  }

  Widget _buildProcessingOverlay() {
    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            color: Colors.black.withValues(alpha: 0.35),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Processing payment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaying() {
    return Scaffold(
      appBar: StationAppBar(title: 'Please wait'),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
        child: Column(
          children: [
            const SizedBox(height: 70),
            Image.asset('assets/images/mock_qr.JPG', width: 230),
            const SizedBox(height: 15),
            const Text('Scan to Pay'),
            const SizedBox(height: 3),
            const Text('or', style: TextStyle(color: Colors.blueGrey)),
            const SizedBox(height: 3),
            const Text('Download QR', style: TextStyle(color: Colors.blue)),
            const SizedBox(height: 3),
            SizedBox(
              width: 230,
              child: const Text(
                'and upload to Mobile Banking app supporting KHQR',
                style: TextStyle(color: Colors.blueGrey, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 55),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Subtotal:'), Text('2.00 USD')],
            ),
            const SizedBox(height: 15),
            const DottedLine(
              dashLength: 6,
              dashGapLength: 4,
              lineThickness: 1,
              dashColor: Colors.grey,
            ),
            const SizedBox(height: 15),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('2.00 USD', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
