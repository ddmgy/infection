import 'package:infection/game/cell.dart';
import 'package:infection/game/position.dart';

class Board {
  final int columns;
  final int rows;
  int winner;
  bool firstRun = true;

  List<Cell> _cells;
  List<Cell> get cells => _cells;

  Board({
    this.columns,
    this.rows,
  }) :
    assert(columns != null && columns > 0),
    assert(rows != null && rows > 0) {
    _cells = List(columns * rows);
    for (int i = 0; i < columns * rows; i++ ) {
      int x = i % columns;
      int y = i ~/ columns;
      _cells[i] = Cell(
        x,
        y,
        onHorizontalEdge: y == 0 || y == rows - 1,
        onVerticalEdge: x == 0 || x == columns - 1,
      );
    }
  }

  Cell getAtXY(int x, int y) => getAtPosition(Position(x, y));

  Cell getAtPosition(Position pos) {
    if (pos.x < 0 || pos.x >= columns || pos.y < 0 || pos.y >= rows) {
      return null;
    }
    return cells.firstWhere((cell) => cell.pos == pos);
  }

  bool move(Position pos, int ownerId) {
    Cell cell = getAtPosition(pos);
    if (cell == null || (cell.owner != null && cell.owner != ownerId)) {
      return false;
    }
    cell.count += 1;
    cell.owner = ownerId;
    settle();
    checkWon();
    return true;
  }

  void settle() {
    while (true) {
      List<Position> unstable = [];
      for (var cell in cells) {
        if (cell.isCritical) {
          unstable.add(cell.pos);
        }
      }
      if (unstable.length == 0) {
        break;
      }

      for (var pos in unstable) {
        var cell = getAtPosition(pos);
        if (cell != null) {
          cell.count -= cell.criticalMass;
          for (var neighbor in neighbors(pos)) {
            neighbor.count += 1;
            neighbor.owner = cell.owner;
          }
          if (cell.count == 0) {
            cell.owner = null;
          }
        }
      }

      if (checkWon()) {
        break;
      }
    }
  }

  bool checkWon() {
    if (firstRun) {
      firstRun = false;
      return false;
    }
    Cell cell = cells.firstWhere((cell) => cell.owner != null, orElse: () => null);
    if (cell == null) {
      return false;
    }
    int ownerId = cell.owner;
    bool won = cells.every((cell) => cell.owner == null || cell.owner == ownerId);
    if (won) {
      winner = ownerId;
      return true;
    }
    return false;
  }

  bool hasAvailableMove(int ownerId) {
    return cells.any((cell) => cell.count == 0 || cell.owner == ownerId);
  }

  List<Cell> neighbors(Position pos) {
    List<Cell> result = [];
    for (var dir in Position.all) {
      var cell = getAtPosition(pos + dir);
      if (cell != null) {
        result.add(cell);
      }
    }
    return result;
  }

  bool get isSettled {
    return cells.every((cell) {
      return !cell.isCritical;
    });
  }
}