import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/views/theme/theme.dart';

class StationAppBar extends StatelessWidget {
  final String title;

  const StationAppBar({
    super.key,
    required this.title,
  });

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        margin: const EdgeInsets.only(top: 16), 
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
        color: AppColors.darkGreen, 
        
      ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () => goBack(context),
            ),
            SizedBox(width: 16),
            Text(
              title,
              style: AppTextStyles.heading.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color:AppColors.white,
              ),
            )
          ],
        ),
    );
   
  }
}