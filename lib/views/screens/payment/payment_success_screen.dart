import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:velo_toulouse_redesign/core/providers/pass_booking_provider.dart';
import 'package:velo_toulouse_redesign/core/providers/ride_session_provider.dart';
import 'package:velo_toulouse_redesign/view_model/pass_viewmodel.dart';
import 'package:velo_toulouse_redesign/core/providers/auth_provider.dart';
import 'package:velo_toulouse_redesign/view_model/ride_history_viewmodel.dart';
import 'package:velo_toulouse_redesign/views/screens/ride/active_ride_screen.dart';
import 'package:velo_toulouse_redesign/views/screens/core/main_screen.dart';
import 'package:velo_toulouse_redesign/views/widgets/actions/button.dart';
import 'package:velo_toulouse_redesign/views/widgets/display/payment_info_card_widget.dart';
import 'package:velo_toulouse_redesign/views/widgets/success_header.dart';

class PaymentSuccessScreen extends ConsumerStatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  ConsumerState<PaymentSuccessScreen> createState() =>
      _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends ConsumerState<PaymentSuccessScreen> {
  bool _isStartingRide = false;

  @override
  Widget build(BuildContext context) {
    final rideSession = ref.watch(rideSessionProvider);
    final selectedPass = ref.watch(selectedPassProvider);

    if (rideSession == null && selectedPass == null) {
      return const Scaffold(
        body: Center(child: Text('No active ride sessionfound.')),
      );
    }

    final isPassFlow = selectedPass != null;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SuccessHeader(
                title: isPassFlow ? 'Pass Activated!' : 'Payment successful!',
                subtitle: isPassFlow
                    ? 'Your ${selectedPass.title} is now active. Enjoy your rides!'
                    : 'Your payment has been completed. Your bike is unlocked!',
                circleColor: const Color(0xFFE8F5E9),
                iconColor: const Color(0xFF2E7D32),
              ),
              if (isPassFlow) ...[
                const SizedBox(height: 30),
                PaymentInfoCardWidget(
                  pass: selectedPass,
                  expiryDate: ref.read(passViewModelProvider.notifier).getExpiryDate(),
                ),
              ],
              const SizedBox(height: 50),
              VeloButton(
                text: isPassFlow ? 'Go to Map' : 'Start Riding',
                onPressed: _isStartingRide
                    ? null
                    : () async {
                        if (isPassFlow) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainScreen(),
                            ),
                            (route) => false,
                          );
                        } else {
                          final authUser = ref.read(authStateProvider).asData?.value;
                          if (authUser == null || rideSession == null) return;

                          setState(() {
                            _isStartingRide = true;
                          });
                          try {
                            final history = await ref
                                .read(rideHistoryViewModelProvider.notifier)
                                .startRide(
                                  userId: authUser.uid,
                                  bikeNumber: rideSession.bikeNumber,
                                  fromStationName: rideSession.fromStationName,
                                  fromStationAddress: rideSession.fromStationAddress,
                                  amountPaid: rideSession.amountPaid ?? 2.0,
                                );

                            if (history != null) {
                              ref.read(rideSessionProvider.notifier).state =
                                  rideSession.copyWith(
                                sessionId: history.id,
                                userId: history.userId,
                                startedAtMs: history.startedAtMs,
                                amountPaid: history.amountPaid,
                              );
                            }

                            if (!context.mounted) return;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ActiveRideScreen(),
                              ),
                            );
                          } finally {
                            if (mounted) {
                              setState(() {
                                _isStartingRide = false;
                              });
                            }
                          }
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

