import 'package:flutter/material.dart';

class BasicButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const BasicButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: OutlinedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500, // Set the font weight to medium
          ),
        ),
      ),
    );
  }
}
