import 'package:infection/game/player.dart';

class GameArguments {
  final int columns;
  final int rows;
  final List<Player> players;

  GameArguments(this.columns, this.rows, this.players);
}