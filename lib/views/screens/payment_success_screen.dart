import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velo_toulouse_redesign/core/providers/pass_booking_provider.dart';
import 'package:velo_toulouse_redesign/core/providers/ride_session_provider.dart';
import 'package:velo_toulouse_redesign/view_model/pass_view_model.dart';
import 'package:velo_toulouse_redesign/views/screens/active_ride_screen.dart';
import 'package:velo_toulouse_redesign/views/screens/main_screen.dart';
import 'package:velo_toulouse_redesign/views/widgets/actions/button.dart';
import 'package:velo_toulouse_redesign/views/widgets/display/payment_Info_Card_widget.dart';
import 'package:velo_toulouse_redesign/views/widgets/success_header.dart';

class PaymentSuccessScreen extends ConsumerWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rideSession = ref.watch(rideSessionProvider);
    final selectedPass = ref.watch(selectedPassProvider);

    if (rideSession == null && selectedPass == null) {
      return const Scaffold(
        body: Center(
          child: Text('No active ride sessionfound.'),
        ),
      );
    }

    final isPassFlow = selectedPass != null;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
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
              onPressed: () {
                if (isPassFlow) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  MainScreen(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  ActiveRideScreen(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
