import 'package:flutter/material.dart';

class SuggestionSentenceButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const SuggestionSentenceButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        side: const BorderSide(
          width: 1.0,
          color: Color(0xFFF5F5F5),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100), // Set button radius to 100
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Container(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xff595959),
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            softWrap: true,
            textAlign: TextAlign.end, // 텍스트 정렬 추가
          ),
        ),
      ),
    );
  }
}
