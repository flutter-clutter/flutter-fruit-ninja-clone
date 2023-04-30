import 'dart:ui';

import 'gravitational_object.dart';

class Fruit extends GravitationalObject {
  Fruit({
    required this.width,
    required this.height,
    required super.position,
    super.gravitySpeed = 0.0,
    super.additionalForce = const Offset(0, 0),
    super.rotation = 0.25,
  });

  final double width;
  final double height;

  bool isPointInside(Offset point) {
    if (point.dx < position.dx) {
      return false;
    }

    if (point.dx > position.dx + width) {
      return false;
    }

    if (point.dy < position.dy) {
      return false;
    }

    if (point.dy > position.dy + height) {
      return false;
    }

    return true;
  }
}
