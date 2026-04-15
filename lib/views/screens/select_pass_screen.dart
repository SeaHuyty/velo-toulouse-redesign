import '../widgets/display/top_bar/app_bar.dart';
import '../widgets/display/card/pass_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/actions/button.dart';
import '../../core/theme/theme.dart';

class SelectPassScreen extends ConsumerStatefulWidget {
   const SelectPassScreen({super.key});

  @override
  ConsumerState<SelectPassScreen> createState() => _SelectPassScreenState();
}

class _SelectPassScreenState extends ConsumerState<SelectPassScreen> {
  int selectedPassIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: StationAppBar(title: 'Select a Pass'),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 180, 
            ),
            children: [
              PassCardWidget(
                title: 'Daily Pass',
                description: 'Valid for 24 hours',
                price: 4.00,
                icon: Icons.calendar_today_outlined,
                isSelected: selectedPassIndex == 0,
                onTap: () => setState(() => selectedPassIndex = 0),
              ),
              const SizedBox(height: 16),
              PassCardWidget(
                title: 'Weekly Pass',
                description: 'Valid for 7 days',
                price: 10.00,
                icon: Icons.calendar_today_outlined,
                isSelected: selectedPassIndex == 1,
                onTap: () => setState(() => selectedPassIndex = 1),
              ),
              const SizedBox(height: 16),
              PassCardWidget(
                title: 'Monthly Pass',
                description: 'Valid for 30 days',
                price: 30.00,
                icon: Icons.calendar_today_outlined,
                isSelected: selectedPassIndex == 2,
                onTap: () => setState(() => selectedPassIndex = 2),
              ),
              const SizedBox(height: 16),
              PassCardWidget(
                title: 'Annual Pass',
                description: 'Valid for 1 year',
                price: 150.00,
                icon: Icons.calendar_today_outlined,
                isSelected: selectedPassIndex == 3,
                onTap: () => setState(() => selectedPassIndex = 3),
              ),
            ],
          ),
          Positioned(
            bottom: 100, 
            left: 16,
            right: 16,
            child: VeloButton(
              text: 'Continue to Payment',
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}





