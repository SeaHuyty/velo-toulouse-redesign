import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/views/theme/theme.dart';
import 'package:velo_toulouse_redesign/views/widgets/display/devider.dart';

class SingleTicketCard extends StatelessWidget {
  final String title;
  final double price;

  const SingleTicketCard({
    super.key,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1000,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGrey, 
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.darkGreen,
          width: 3,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.confirmation_number_outlined,
              color: Colors.brown[700],
              size: 40,
            ),
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.heading.copyWith(
                  color: AppColors.darkGreen,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '€ ${price.toStringAsFixed(2)}',
                style: AppTextStyles.heading.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          VeloDivider(),
        ],
      ),
    );
  }
}
