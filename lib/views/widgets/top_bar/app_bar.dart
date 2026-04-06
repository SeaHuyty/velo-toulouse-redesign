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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => goBack(context),
          ),
          Text(
            title,
            style: AppTextStyles.body.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color:AppColors.black,
            ),
          )
        ],
          
      ),
      
    );
   
  }
}