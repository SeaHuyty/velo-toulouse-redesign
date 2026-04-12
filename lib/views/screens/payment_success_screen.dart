import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/views/screens/active_ride_screen.dart';
import 'package:velo_toulouse_redesign/views/widgets/buttons/button.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String plateNumber;
  const PaymentSuccessScreen({super.key, required this.plateNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 92,
                height: 92,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 54,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Payment successful',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your payment has been completed. Your bike is unlocked!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blueGrey),
              ),

              const SizedBox(height: 180),
              VeloButton(
                text: "Start Riding",
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActiveRideScreen(bikeNumber: plateNumber),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
