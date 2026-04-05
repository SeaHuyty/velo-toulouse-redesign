import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class VeloDivider extends StatelessWidget {
  const VeloDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, thickness: 1, color: AppColors.lightGrey);
  }
}