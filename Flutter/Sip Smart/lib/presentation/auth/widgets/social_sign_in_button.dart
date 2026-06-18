import 'package:flutter/material.dart';
import 'package:gradution_project_smart_sip/core/constants/app_colors.dart'; 

class SocialSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final String iconPath; 

  const SocialSignInButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primary; 

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0), 
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: BorderSide(color: primaryColor.withOpacity(0.5), width: 1), 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             
              Image.asset(iconPath, height: 24, width: 24), 
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}