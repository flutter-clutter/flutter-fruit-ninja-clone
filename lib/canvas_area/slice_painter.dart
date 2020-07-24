import 'dart:math';

import 'package:flutter/material.dart';

class SlicePainter extends CustomPainter {
  SlicePainter({this.pointsList});

  List<Offset> pointsList;

  @override
  void paint(Canvas canvas, Size size) {
    _drawBlade(canvas, size);

  }

  void _drawBlade(Canvas canvas, Size size) {
    Path pathLeft = Path();
    Path pathRight = Path();
    Paint paintLeft = Paint();
    Paint paintRight = Paint();

    if (pointsList.length < 3) {
      return;
    }

    paintLeft.color = Color.fromRGBO(220, 220, 220, 1);
    paintRight.color = Colors.white;
    pathLeft.moveTo(pointsList[0].dx, pointsList[0].dy);
    pathRight.moveTo(pointsList[0].dx, pointsList[0].dy);

    for (int i = 0; i < pointsList.length; i++) {
      if (pointsList[i] == null) {
        continue;
      }

      if (i <= 1 || i >= pointsList.length - 5) {
        pathLeft.lineTo(pointsList[i].dx, pointsList[i].dy);
        pathRight.lineTo(pointsList[i].dx, pointsList[i].dy);
        continue;
      }

      double x1 = pointsList[i-1].dx;
      double x2 = pointsList[i].dx;
      double lengthX = x2 - x1;

      double y1 = pointsList[i-1].dy;
      double y2 = pointsList[i].dy;
      double lengthY = y2 - y1;

      double length = sqrt((lengthX * lengthX) + (lengthY * lengthY));
      double normalizedVectorX = lengthX / length;
      double normalizedVectorY = lengthY / length;
      double distance = 15;

      double newXLeft = x1 - normalizedVectorY * (i / pointsList.length * distance);
      double newYLeft = y1 + normalizedVectorX * (i / pointsList.length * distance);

      double newXRight = x1 - normalizedVectorY * (i / pointsList.length  * -distance);
      double newYRight = y1 + normalizedVectorX * (i / pointsList.length * -distance);

      pathLeft.lineTo(newXLeft, newYLeft);
      pathRight.lineTo(newXRight, newYRight);
    }

    for (int i = pointsList.length - 1; i >= 0; i--) {
      if (pointsList[i] == null) {
        continue;
      }

      pathLeft.lineTo(pointsList[i].dx, pointsList[i].dy);
      pathRight.lineTo(pointsList[i].dx, pointsList[i].dy);
    }

    canvas.drawShadow(pathLeft, Colors.grey, 3.0, false);
    canvas.drawShadow(pathRight, Colors.grey, 3.0, false);
    canvas.drawPath(pathLeft, paintLeft);
    canvas.drawPath(pathRight, paintRight);
  }

  @override
  bool shouldRepaint(SlicePainter oldDelegate) => true;
}