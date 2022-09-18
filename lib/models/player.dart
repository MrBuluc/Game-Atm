import 'package:flutter/cupertino.dart';

class Player {
  String? name;
  int? money;

  Player({@required this.name, @required this.money});

  Player.fromString(String value) {
    List<String> nameMoney = value.split("-");
    name = nameMoney[0];
    money = int.parse(nameMoney[1]);
  }

  void ekle(int value) {
    money = money! + value;
  }

  void cikar(int value) {
    money -= value;
  }

  void transfer(Player player2, int value) {
    cikar(value);
    player2.ekle(value);
  }

  @override
  String toString() {
    return '$name-$money';
  }
}
