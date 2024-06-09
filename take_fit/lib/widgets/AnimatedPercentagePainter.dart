import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/widgets.dart';

class ResponsiveAnimatedPercentageCircle extends StatelessWidget {
  final double percentage;
  final Color colors;
  final double size;
  final bool bool1;

  ResponsiveAnimatedPercentageCircle({
    required this.percentage,
    required this.colors,
    required this.size,
    required this.bool1
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: AnimatedPercentageCircle(
        percentage: percentage,
        size: size,
        colors: colors,
        bool1: bool1,
      ),
    );
  }
}

class AnimatedPercentageCircle extends StatefulWidget {
  final double percentage;
  final double size;
  final Color colors;
  final bool bool1;

  AnimatedPercentageCircle({
    required this.percentage,
    required this.size,
    required this.colors,
    required this.bool1
  });

  @override
  _AnimatedPercentageCircleState createState() =>
      _AnimatedPercentageCircleState();
}

class _AnimatedPercentageCircleState extends State<AnimatedPercentageCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = Tween<double>(begin: 0, end: widget.percentage)
        .animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animationController.forward(from: 0);
  }

  @override
  void didUpdateWidget(covariant AnimatedPercentageCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.percentage != oldWidget.percentage) {
      _animation = Tween<double>(begin: _animation.value, end: widget.percentage)
          .animate(_animationController);
      _animationController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.size * 0.08),
      child: CustomPaint(
        painter: AnimatedPercentagePainter(
          percentage: _animation.value,
          size: widget.size * 0.6,
          colors: widget.colors,
        ),
        child: Container(
          width: widget.size * 0.6,
          height: widget.size * 0.6,
          alignment: Alignment.center,
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Opacity(
               opacity: widget.bool1 ? 1.0 : 0.0,
               child: Text(
                  "${(_animation.value * 100).toInt()}%",
                  style: TextStyle(
                    color: widget.colors,
                    fontWeight: FontWeight.bold,
                  ),
                ),
             ),
              Opacity(
                opacity: widget.bool1 ? 0.0 : 1.0,
                child: Text(
                  "${(_animation.value * 100).toInt()}%",
                  style: TextStyle(
                    color: widget.colors,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class AnimatedPercentagePainter extends CustomPainter {
  final double percentage;
  final double size;
  final Color colors;

  AnimatedPercentagePainter({
    required this.percentage,
    required this.size,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint bgPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Paint fillPaint = Paint()
      ..color = colors
      ..strokeWidth = 15 // Doluluk genişliğini burada ayarla
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    double angle = 2 * pi * percentage;
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ),
      -pi / 2,
      angle,
      false,
      fillPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ),
      angle - pi / 2,
      2 * pi - angle,
      false,
      bgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
