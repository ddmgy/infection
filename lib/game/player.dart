import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class Player extends Equatable {
  final String name;
  final int id;
  final Color color;

  Player({
    this.name,
    this.id,
    this.color,
  }) :
    assert(name != null && name.isNotEmpty),
    assert(color != null);

  Player copyWith({
    String name,
    int id,
    Color color,
  }) => Player(
    name: name ?? this.name,
    id: id ?? this.id,
    color: color ?? this.color,
  );

  @override
  List<Object> get props => [name, id, color];

  @override
  bool get stringify => true;
}