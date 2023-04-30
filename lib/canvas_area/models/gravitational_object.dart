import 'dart:ui';

abstract class GravitationalObject {
  GravitationalObject({
    required this.position,
    required this.rotation,
    this.gravitySpeed = 0.0,
    this.additionalForce = const Offset(0, 0),
  });

  Offset position;
  double gravitySpeed;
  final double _gravity = 1.0;
  final Offset additionalForce;
  final double rotation;

  void applyGravity() {
    gravitySpeed += _gravity;
    position = Offset(position.dx + additionalForce.dx,
        position.dy + gravitySpeed + additionalForce.dy);
  }
}
