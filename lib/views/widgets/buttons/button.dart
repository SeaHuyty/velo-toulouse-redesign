import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/views/theme/theme.dart';

class VeloButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const VeloButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkGreen,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}