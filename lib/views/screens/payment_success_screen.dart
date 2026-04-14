import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velo_toulouse_redesign/core/providers/auth_provider.dart';
import 'package:velo_toulouse_redesign/core/providers/ride_session_provider.dart';
import 'package:velo_toulouse_redesign/view_model/ride_history_viewmodel.dart';
import 'package:velo_toulouse_redesign/views/screens/active_ride_screen.dart';
import 'package:velo_toulouse_redesign/views/widgets/buttons/button.dart';
import 'package:velo_toulouse_redesign/views/widgets/success_header.dart';

class PaymentSuccessScreen extends ConsumerWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rideSession = ref.watch(rideSessionProvider);
    if (rideSession == null) {
      return const Scaffold(
        body: Center(
          child: Text('No active ride session found. Please start again.'),
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SuccessHeader(
              title: 'Payment successful',
              subtitle:
                  'Your payment has been completed. Your bike is unlocked!',
              circleColor: Color(0xFFE8F5E9),
              iconColor: Color(0xFF2E7D32),
            ),

            const SizedBox(height: 150),

            VeloButton(
              text: 'Start Riding',
              onPressed: () async {
                final authUser = ref.read(authStateProvider).asData?.value;
                if (authUser == null) return;

                if (rideSession.sessionId == null) {
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
                    ref.read(rideSessionProvider.notifier).state = rideSession
                        .copyWith(
                          sessionId: history.id,
                          userId: history.userId,
                          startedAtMs: history.startedAtMs,
                          amountPaid: history.amountPaid,
                        );
                  }
                }

                if (!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ActiveRideScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
