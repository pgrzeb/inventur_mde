import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final Function() onPressed;

  const ButtonWidget({
    super.key,
    required this.title,
    required this.onPressed,
    });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, 
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.primaryColor),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.backgroundColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}