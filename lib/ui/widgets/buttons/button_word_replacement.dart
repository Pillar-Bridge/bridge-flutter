import 'package:flutter/material.dart';

class WordReplacementButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isSelected; // New parameter

  const WordReplacementButton({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.isSelected, // Updated parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 10), // Updated padding
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: isSelected
                ? BorderSide.none
                : const BorderSide(width: 1.0, color: Color(0xFFF8F8F8)),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(100), // Set button radius to 100
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Color(0xFF3787FF) : Color(0xFF595959),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
