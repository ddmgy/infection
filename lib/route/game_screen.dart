import 'package:flutter/material.dart';

import 'package:infection/game/board.dart';
import 'package:infection/game/cell.dart';
import 'package:infection/game/player.dart';
import 'package:infection/game/position.dart';
import 'package:infection/route/game_arguments.dart';
import 'package:infection/route/routes.dart';

typedef PositionCallback = void Function(Position position);

enum PlayState {
  Running,
  Finished,
}

class GameScreen extends StatefulWidget {
  final int columns;
  final int rows;
  final List<Player> players;

  GameScreen({this.columns, this.rows, this.players});

  @override
  State<StatefulWidget> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _currentPlayer = 0;
  Board _board;
  Player _winner;
  Map<int, Color> _idToColor;

  @override
  void initState() {
    super.initState();
    _board = Board(columns: widget.columns, rows: widget.rows);
    _idToColor = {};
    for (var player in widget.players) {
      _idToColor[player.id] = player.color;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_board.winner != null) {
      _winner = widget.players.firstWhere((player) => player.id == _board.winner);
    }
    bool canSkip = !_board.hasAvailableMove(widget.players[_currentPlayer].id);

    return WillPopScope(
      onWillPop: () async {
        return await _showConfirmDialog();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Game"),
          actions: [
            IconButton(
              icon: Icon(Icons.skip_next),
              tooltip: "Skip turn",
              onPressed: !canSkip
                ? null
                : () {
                  setState(() {
                    _nextPlayer();
                  });
                }
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: List.generate(8, (int index) {
                    bool isSelected = index == _currentPlayer;
                    bool outOfRange = index >= widget.players.length;

                    return Container(
                      width: 40,
                      height: 40,
                      color: (outOfRange || !isSelected)
                        ? Colors.transparent
                        : Colors.white,
                      child: Center(
                        child: Container(
                          width: 36,
                          height: 36,
                          color: outOfRange
                            ? Colors.transparent
                            : widget.players[index].color,
                        ),
                      ),
                    );
                  }),
                ),
                padding: const EdgeInsets.all(4),
              ),
              Container(height: 8),
              if (_winner == null) Container(
                child: Center(
                  child: Text(widget.players[_currentPlayer].name),
                ),
                height: 48,
              ),
              if (_winner != null) FlatButton(
                child: Text("${_winner.name} wins! Press to replay"),
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    Routes.game,
                    arguments: GameArguments(
                      widget.columns,
                      widget.rows,
                      widget.players,
                    ),
                  );
                },
              ),
              Container(height: 8),
              GridView.builder(
                shrinkWrap: true,
                itemCount: widget.columns * widget.rows,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.columns,
                ),
                itemBuilder: (BuildContext context, int index) {
                  Cell cell = _board.cells[index];

                  return Card(
                    color: Colors.grey[800],
                    child: InkWell(
                      onTap: _winner != null
                        ? null
                        : () {
                          var clickPosition = Position(
                            index % widget.columns,
                            index ~/ widget.columns,
                          );
                          var currentId = widget.players[_currentPlayer].id;
                          if (_board.move(clickPosition, currentId)) {
                            setState(() {
                              _currentPlayer = (_currentPlayer + 1) % widget.players.length;
                            });
                          }
                      },
                      child: Center(
                        child: Text(
                          "${cell.count}",
                          style: TextStyle(
                            color: cell.owner == null
                              ? Colors.grey[500].withOpacity(0.4)
                              : _idToColor[cell.owner],
                            fontSize: 16,
                          )
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _nextPlayer() {
    setState(() {
      _currentPlayer = (_currentPlayer + 1) % widget.players.length;
    });
  }

  Future<bool> _showConfirmDialog() async {
    bool result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Are you sure you want to quit the game?"),
          actions: [
            FlatButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            FlatButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}