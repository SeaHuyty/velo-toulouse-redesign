import 'package:velo_toulouse_redesign/views/screens/pass_payment_screen.dart';
import '../../core/providers/pass_booking_provider.dart';
import '../../view_model/pass_view_model.dart';
import '../widgets/display/top_bar/app_bar.dart';
import '../widgets/display/card/pass_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/actions/button.dart';
import '../../core/theme/theme.dart';

class SelectPassScreen extends ConsumerWidget {
  const SelectPassScreen({super.key});

  void goToPayment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PassPaymentScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passesAsync = ref.watch(passViewModelProvider);
    final selectedPass = ref.watch(selectedPassProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const StationAppBar(title: 'Select a Pass'),
      body: passesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (passes) {
          return Stack(
            children: [
              ListView.builder(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: 180,
                ),
                itemCount: passes.length,
                itemBuilder: (context, index) {
                  final pass = passes[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: PassCardWidget(
                      pass: pass,
                      description: 'Valid for ${pass.duration}',
                      icon: Icons.calendar_today_outlined,
                      isSelected: selectedPass?.title == pass.title,
                      onTap: () {
                        ref.read(selectedPassProvider.notifier).state = pass;
                      },
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 100,
                left: 16,
                right: 16,
                child: VeloButton(
                  text: 'Continue to Payment',
                  onPressed: () => goToPayment(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}







