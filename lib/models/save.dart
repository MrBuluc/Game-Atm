import 'package:game_atm/models/player.dart';

class Save {
  String title;
  List<Player> playerList;
  int baslangicParasi;

  Save(this.title, this.playerList, this.baslangicParasi);

  Save.fromString(String value) {
    List<String> saveStringTitle = value.split("é");
    this.title = saveStringTitle[0];
    this.baslangicParasi = int.parse(saveStringTitle[1]);
    this.playerList = List<Player>.empty(growable: true);
    String playerListString =
        saveStringTitle[2].substring(1, saveStringTitle[2].length - 1);
    List<String> playerListName = playerListString.split(", ");
    for (String playerString in playerListName) {
      Player player = Player.fromString(playerString);
      this.playerList.add(player);
    }
  }

  @override
  String toString() {
    return '$titleé$baslangicParasié$playerList';
  }
}
