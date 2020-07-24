import 'dart:ui';

abstract class GravitationalObject {
  GravitationalObject({
    this.position,
    this.gravitySpeed = 0.0,
    this.additionalForce = const Offset(0,0),
    this.rotation
  });

  Offset position;
  double gravitySpeed;
  double _gravity = 1.0;
  Offset additionalForce;
  double rotation;

  void applyGravity() {
    gravitySpeed += _gravity;
    position = Offset(
        position.dx + additionalForce.dx,
        position.dy + gravitySpeed + additionalForce.dy
    );
  }
}