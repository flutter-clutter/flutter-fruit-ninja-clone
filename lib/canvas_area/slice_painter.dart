import 'dart:math';

import 'package:flutter/material.dart';

class SlicePainter extends CustomPainter {
  const SlicePainter({required this.pointsList});

  final List<Offset> pointsList;

  final Color _shadowColor = Colors.grey;
  final double _shadowElevation = 3.0;
  final Color _bladeLeftPaintColor = const Color.fromRGBO(220, 220, 220, 1);
  final Color _bladeRightPaintColor = Colors.white;
  final int _bladeMinLength = 3;

  @override
  void paint(Canvas canvas, Size size) {
    _drawBlade(canvas, size);
  }

  void _drawBlade(Canvas canvas, Size size) {
    final Path pathLeft = Path();
    final Path pathRight = Path();
    final Paint paintLeft = Paint();
    final Paint paintRight = Paint();

    if (pointsList.length < _bladeMinLength) {
      return;
    }

    paintLeft.color = _bladeLeftPaintColor;
    paintRight.color = _bladeRightPaintColor;
    pathLeft.moveTo(pointsList[0].dx, pointsList[0].dy);
    pathRight.moveTo(pointsList[0].dx, pointsList[0].dy);

    for (int i = 0; i < pointsList.length; i++) {
      if (i <= 1 || i >= pointsList.length - 5) {
        pathLeft.lineTo(pointsList[i].dx, pointsList[i].dy);
        pathRight.lineTo(pointsList[i].dx, pointsList[i].dy);
        continue;
      }

      final double x1 = pointsList[i - 1].dx;
      final double x2 = pointsList[i].dx;
      final double lengthX = x2 - x1;

      final double y1 = pointsList[i - 1].dy;
      final double y2 = pointsList[i].dy;
      final double lengthY = y2 - y1;

      final double length = sqrt((lengthX * lengthX) + (lengthY * lengthY));
      final double normalizedVectorX = lengthX / length;
      final double normalizedVectorY = lengthY / length;
      final double distance = 15;

      final double newXLeft =
          x1 - normalizedVectorY * (i / pointsList.length * distance);
      final double newYLeft =
          y1 + normalizedVectorX * (i / pointsList.length * distance);

      final double newXRight =
          x1 - normalizedVectorY * (i / pointsList.length * -distance);
      final double newYRight =
          y1 + normalizedVectorX * (i / pointsList.length * -distance);

      pathLeft.lineTo(newXLeft, newYLeft);
      pathRight.lineTo(newXRight, newYRight);
    }

    for (int i = pointsList.length - 1; i >= 0; i--) {
      pathLeft.lineTo(pointsList[i].dx, pointsList[i].dy);
      pathRight.lineTo(pointsList[i].dx, pointsList[i].dy);
    }

    canvas.drawShadow(pathLeft, _shadowColor, _shadowElevation, false);
    canvas.drawShadow(pathRight, _shadowColor, _shadowElevation, false);
    canvas.drawPath(pathLeft, paintLeft);
    canvas.drawPath(pathRight, paintRight);
  }

  @override
  bool shouldRepaint(SlicePainter oldDelegate) => true;
}
