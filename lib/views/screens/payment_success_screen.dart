import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velo_toulouse_redesign/core/providers/ride_session_provider.dart';
import 'package:velo_toulouse_redesign/views/screens/active_ride_screen.dart';
import 'package:velo_toulouse_redesign/views/widgets/actions/button.dart';
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
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ActiveRideScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
