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
    return Material(
      elevation: 0.0,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 15, // 이 값을 늘려 그림자를 더 퍼지게 만듭니다.
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: isSelected
                ? BorderSide.none
                : const BorderSide(width: 1.0, color: Color(0xFFF8F8F8)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: SizedBox(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF3787FF)
                    : const Color(0xFF595959),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
