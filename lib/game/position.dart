import 'package:equatable/equatable.dart';

class Position extends Equatable {
  static const north = Position(0, -1);
  static const south = Position(0, 1);
  static const west = Position(-1, 0);
  static const east = Position(1, 0);

  static const all = [
    north,
    south,
    east,
    west,
  ];

  final int x;
  final int y;

  const Position(this.x, this.y) :
    assert(x != null),
    assert(y != null);

  List<Position> get neighbors {
    var result = [];
    for (var dir in all) {
      result.add(this + dir);
    }
    return result;
  }

  Position operator +(Position other) => Position(x + other.x, y + other.y);

  @override
  List<Object> get props => [x, y];

  @override
  bool get stringify => true;
}