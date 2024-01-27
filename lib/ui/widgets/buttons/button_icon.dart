import 'package:flutter/material.dart';

class IconToggleButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData icon;
  final bool isToggled;
  final Color toggleColor;
  final Color basicColor;

  const IconToggleButton(
      {Key? key,
      required this.label,
      required this.onPressed,
      required this.icon,
      required this.isToggled,
      required this.toggleColor,
      this.basicColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: OutlinedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isToggled ? toggleColor : basicColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
          side: isToggled
              ? BorderSide.none
              : const BorderSide(width: 1, color: Color(0xfff0f0f0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Row(
            children: [
              Icon(
                icon,
                color: isToggled ? basicColor : toggleColor,
                size: 35,
              ),
              SizedBox(width: 24), // Add desired width here
              Text(
                label,
                style: TextStyle(
                  color: isToggled ? basicColor : toggleColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
