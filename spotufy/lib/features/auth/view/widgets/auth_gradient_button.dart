import 'package:flutter/material.dart';
import 'package:spotufy/core/theme/app_pallete.dart';

class AuthGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const AuthGradientButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: AlignmentGeometry.bottomLeft,
          end: AlignmentGeometry.topRight,
          colors: [Pallete.gradient1, Pallete.gradient2],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(395, 55),
          backgroundColor: Pallete.transparentColor,
          shadowColor: Pallete.transparentColor,
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
