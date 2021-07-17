class Game {
  static Game _game;
  int oyuncuSayisi;
  List<String> oyuncuAdlariList;
  int baslangicParasi;

  factory Game() {
    if (_game == null) {
      _game = Game.internal();
      return _game;
    } else {
      return _game;
    }
  }

  Game.internal();
}
