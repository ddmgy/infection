import 'package:infection/game/position.dart';

class Cell {
  final Position pos;
  bool onHorizontalEdge;
  bool onVerticalEdge;
  int count;
  int owner;
  int criticalMass;

  Cell(
    int x,
    int y,
    {
    this.onHorizontalEdge = false,
    this.onVerticalEdge = false,
    this.count = 0,
    this.owner,
  }) :
    assert(x != null),
    assert(y != null),
    assert(onHorizontalEdge != null),
    assert(onVerticalEdge != null),
    assert(count != null && count >= 0),
    pos = Position(x, y),
    criticalMass = 4 - (onHorizontalEdge ? 1 : 0) - (onVerticalEdge ? 1 : 0);

  int get x => pos.x;
  int get y => pos.y;
  bool get isCritical => count >= criticalMass;

  @override
  String toString() => "Cell(x: $x, y: $y, count: $count, owner: $owner)";
}