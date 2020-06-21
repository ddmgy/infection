import 'package:flutter/material.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:tuple/tuple.dart';

import 'package:infection/game/player.dart';
import 'package:infection/route/game_arguments.dart';
import 'package:infection/route/routes.dart';
import 'package:infection/utils.dart';

const List<Color> _colorPickerColors = [
  Colors.red, Colors.blue, Colors.green, Colors.yellow,
  Colors.pink, Colors.indigo, Colors.teal, Colors.orange,
  Colors.purple, Colors.deepPurple, Colors.brown, Colors.deepOrange,
  Colors.blueGrey,
];

class SetupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  int _size = 5;
  List<Player> _players = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Set up game"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Add new player",
            onPressed: _players.length < 8
              ? () {
                _showCreatePlayerDialog();
              }
              : null,
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            tooltip: "Play game",
            onPressed: _players.length < 2
              ? null
              : () {
                Navigator.pushReplacementNamed(
                  context,
                  Routes.game,
                  arguments: GameArguments(
                    _size,
                    _size,
                    _players,
                  ),
                );
              }
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          InkWell(
            onTap: () {
              _showSizeDialog();
            },
            child: _row("Size", _size),
          ),
          Container(
            child: Row(
              children: [
                Text(
                  "Players",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.start,
                ),
                Spacer(),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 16,
            ),
          ),
          Expanded(
            child: Container(
              child: Scrollbar(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _players.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Container(
                        width: 16,
                        height: 16,
                        color: _players[index].color,
                      ),
                      title: Text(_players[index].name),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _players.removeAt(index);
                          });
                        },
                      ),
                      onLongPress: () {
                        _showEditPlayerDialog(index);
                      },
                      dense: true,
                    );
                  },
                ),
              ),
              padding: const EdgeInsets.only(right: 4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String title, int value) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.start,
            ),
            flex: 2,
          ),
          Expanded(
            child: Text(
              "$value x $value",
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            flex: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 16,
      ),
    );
  }

  void _showSizeDialog() async {
    var result = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return NumberPickerDialog.integer(
          title: const Text("Choose number of rows/columns"),
          initialIntegerValue: _size,
          minValue: 2,
          maxValue: 10,
          step: 1,
          textMapper: (String value) => "$value x $value",
        );
      }
    );

    if (result != null) {
      setState(() {
        _size = result;
      });
    }
  }

  void _showCreatePlayerDialog() async {
    var availableColors = _colorPickerColors.where((color) {
      return !_players.any((player) => player.color == color);
    }).toList();

    var result = await showDialog<Tuple2<String, Color>>(
      context: context,
      builder: (BuildContext context) {
        String name;
        Color color = availableColors[0];
        return AlertDialog(
          title: const Text("Create player"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      onChanged: (String value) {
                        setState(() {
                          name = value;
                        });
                      },
                    ),
                    Container(height: 16),
                    BlockPicker(
                      availableColors: availableColors,
                      pickerColor: color,
                      onColorChanged: (Color value) {
                        setState(() {
                          color = value;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            FlatButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context, null),
            ),
            FlatButton(
              child: const Text("Create"),
              onPressed: () {
                Navigator.pop(context, Tuple2(name, color));
              },
            ),
          ],
        );
      }
    );

    if (result != null) {
      if (result.item1 == null || result.item2 == null) {
        return;
      }
      int maxId = _players.maxBy((player) => player.id);
      setState(() {
        _players.add(Player(
          name: result.item1,
          color: result.item2,
          id: maxId == null ? 0 : maxId + 1,
        ));
      });
    }
  }

  void _showEditPlayerDialog(int index) async {
    Player toEdit = _players[index];
    var availableColors = _colorPickerColors.where((color) {
      return color == toEdit.color || !_players.any((player) => player.color == color);
    }).toList();

    Player player = await showDialog<Player>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController()
          ..text = toEdit.name;
        Color color = toEdit.color;

        return AlertDialog(
          title: const Text("Edit player"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: controller,
                    ),
                    Container(height: 16),
                    BlockPicker(
                      availableColors: availableColors,
                      pickerColor: color,
                      onColorChanged: (Color value) {
                        setState(() {
                          color = value;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            FlatButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context, null),
            ),
            FlatButton(
              child: const Text("Create"),
              onPressed: () {
                Player player = toEdit.copyWith(
                  name: controller.text,
                  color: color,
                );
                Navigator.pop(context, player);
              },
            ),
          ],
        );
      }
    );

    if (player != null) {
      setState(() {
        _players[index] = player;
      });
    }
  }
}