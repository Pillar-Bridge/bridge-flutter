import 'package:flutter/material.dart';

class CurrentSituationButton extends StatelessWidget {
  final String situation;

  const CurrentSituationButton({Key? key, required this.situation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 15, // 이 값을 늘려 그림자를 더 퍼지게 만듭니다.
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: IntrinsicWidth(
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.start, // Align children to the left
          children: [
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text to the left
              children: [
                const Row(
                  children: [
                    Text(
                      '💡Recognized Situation',
                      style: TextStyle(
                        color: Color(0xFF939393),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  situation,
                  style: const TextStyle(
                    color: Color(0xff000000),
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
