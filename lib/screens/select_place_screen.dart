import 'package:flutter/material.dart';

class SelectPlaceScreen extends StatefulWidget {
  const SelectPlaceScreen({super.key});

  @override
  State<SelectPlaceScreen> createState() => _SelectPlaceScreenState();
}

class _SelectPlaceScreenState extends State<SelectPlaceScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '지금 당신의 위치는',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '영화관',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
