import 'dart:math';

import 'package:flutter/material.dart';

import 'models/fruit.dart';
import 'models/fruit_part.dart';
import 'models/touch_slice.dart';
import 'slice_painter.dart';

class CanvasArea extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CanvasAreaState();
  }
}

class _CanvasAreaState<CanvasArea> extends State {
  int score = 0;
  TouchSlice touchSlice;
  List<Fruit> fruits = List();
  List<FruitPart> fruitParts = List();

  @override
  void initState() {
    _spawnRandomFruit();
    _tick();
    super.initState();
  }

  void _spawnRandomFruit() {
    fruits.add(new Fruit(
      position: Offset(0, 200),
      width: 80,
      height: 80,
      additionalForce: Offset(5 + Random().nextDouble() * 5, Random().nextDouble() * -10),
      rotation: Random().nextDouble() / 3 - 0.16
    ));
  }

  void _tick() {
    setState(() {
      for (Fruit fruit in fruits) {
        fruit.applyGravity();
      }
      for (FruitPart fruitPart in fruitParts) {
        fruitPart.applyGravity();
      }

      if (Random().nextDouble() > 0.97) {
        _spawnRandomFruit();
      }
    });

    Future.delayed(Duration(milliseconds: 30), _tick);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _getStack()
    );
  }

  List<Widget> _getStack() {
    List<Widget> widgetsOnStack = List();

    widgetsOnStack.add(_getBackground());
    widgetsOnStack.add(_getSlice());
    widgetsOnStack.addAll(_getFruitParts());
    widgetsOnStack.addAll(_getFruits());
    widgetsOnStack.add(_getGestureDetector());
    widgetsOnStack.add(
      Positioned(
        right: 16,
        top: 16,
        child: Text(
          'Score: $score',
          style: TextStyle(
            fontSize: 24
          ),
        )
      )
    );

    return widgetsOnStack;
  }

  Container _getBackground() {
    return Container(
      decoration: new BoxDecoration(
        gradient: new RadialGradient(
          stops: [0.2, 1.0],
          colors: [
            Color(0xffFFB75E),
            Color(0xffED8F03)
          ],
        )
      ),
    );
  }

  Widget _getSlice() {
    if (touchSlice == null) {
      return Container();
    }

    return CustomPaint(
      size: Size.infinite,
      painter: SlicePainter(
        pointsList: touchSlice.pointsList,
      )
    );
  }

  List<Widget> _getFruits() {
    List<Widget> list = new List();

    for (Fruit fruit in fruits) {
      list.add(
        Positioned(
          top: fruit.position.dy,
          left: fruit.position.dx,
          child: Transform.rotate(
            angle: fruit.rotation * pi * 2,
            child: _getMelon(fruit)
          )
        )
      );
    }

    return list;
  }

  List<Widget> _getFruitParts() {
    List<Widget> list = new List();

    for (FruitPart fruitPart in fruitParts) {
      list.add(
        Positioned(
          top: fruitPart.position.dy,
          left: fruitPart.position.dx,
          child: _getMelonCut(fruitPart)
        )
      );
    }

    return list;
  }

  Widget _getMelonCut(FruitPart fruitPart) {
    return Transform.rotate(
      angle: fruitPart.rotation * pi * 2,
      child: Image.asset(
        fruitPart.isLeft ? 'assets/melon_cut.png': 'assets/melon_cut_right.png',
        height: 80,
        fit: BoxFit.fitHeight
      )
    );
  }

  Widget _getMelon(Fruit fruit) {
    return Image.asset(
      'assets/melon_uncut.png',
      height: 80,
      fit: BoxFit.fitHeight
    );
  }

  Widget _getGestureDetector() {
    return GestureDetector(
      onScaleStart: (details) {
        setState(() {
          _setNewSlice(details);
        });
      },
      onScaleUpdate: (details) {
        setState(() {
          _addPointToSlice(details);
          _checkCollision();
        });
      },
      onScaleEnd: (details) {
        setState(() {
          _resetSlice();
        });
      }
    );
  }

  _checkCollision() {
    if (touchSlice == null) {
      return;
    }

    for (Fruit fruit in List.from(fruits)) {
      bool firstPointOutside = false;
      bool secondPointInside = false;

      for (Offset point in touchSlice.pointsList) {
        if (!firstPointOutside&& !fruit.isPointInside(point)) {
          firstPointOutside = true;
          continue;
        }

        if (firstPointOutside && fruit.isPointInside(point)) {
          secondPointInside = true;
          continue;
        }

        if (secondPointInside && !fruit.isPointInside(point)) {
          fruits.remove(fruit);
          _turnFruitIntoParts(fruit);
          score += 10;
          break;
        }
      }
    }
  }

  void _turnFruitIntoParts(Fruit hit) {
    FruitPart leftFruitPart = FruitPart(
        position: Offset(
          hit.position.dx - hit.width / 8,
          hit.position.dy
        ),
        width: hit.width / 2,
        height: hit.height,
        isLeft: true,
        gravitySpeed: hit.gravitySpeed,
        additionalForce: Offset(hit.additionalForce.dx - 1, hit.additionalForce.dy -5),
        rotation:  hit.rotation
    );

    FruitPart rightFruitPart = FruitPart(
      position: Offset(
        hit.position.dx + hit.width / 4 + hit.width / 8,
        hit.position.dy
      ),
      width: hit.width / 2,
      height: hit.height,
      isLeft: false,
      gravitySpeed: hit.gravitySpeed,
      additionalForce: Offset(hit.additionalForce.dx + 1, hit.additionalForce.dy -5),
      rotation:  hit.rotation
    );

    setState(() {
      fruitParts.add(leftFruitPart);
      fruitParts.add(rightFruitPart);
      fruits.remove(hit);
    });
  }

  void _resetSlice() {
    touchSlice = null;
  }

  void _setNewSlice(details) {
    touchSlice = TouchSlice(pointsList: [details.localFocalPoint]);
  }

  void _addPointToSlice(ScaleUpdateDetails details) {
    if (touchSlice.pointsList.length > 16) {
      touchSlice.pointsList.removeAt(0);
    }
    touchSlice.pointsList.add(details.localFocalPoint);
  }
}