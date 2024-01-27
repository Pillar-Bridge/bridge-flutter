import 'package:flutter/material.dart';

class ProgressThreeDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Dot(delay: Duration(milliseconds: 0)),
        SizedBox(width: 20),
        Dot(delay: Duration(milliseconds: 250)),
        SizedBox(width: 20),
        Dot(delay: Duration(milliseconds: 500)),
      ],
    );
  }
}

class Dot extends StatefulWidget {
  final Duration delay;

  Dot({required this.delay});

  @override
  _DotState createState() => _DotState();
}

class _DotState extends State<Dot> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
    );

    _animation = Tween<double>(begin: 0.0, end: 12.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });

    Future.delayed(widget.delay, () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_animation.value),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
