import 'package:flutter/material.dart';

class SelectButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isSelected; // New parameter

  const SelectButton({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.isSelected, // Updated parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? Colors.black : Colors.white,
          side: isSelected
              ? BorderSide.none
              : BorderSide(width: 1.0, color: Color(0xFFF8F8F8)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Color(0xFF868686),
            fontSize: 16,
            fontWeight: FontWeight.w500,

          ),
        ),
      ),
    );
  }
}
