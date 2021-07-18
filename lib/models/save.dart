import 'package:game_atm/models/player.dart';

class Save {
  String title;
  List<Player> playerList;

  Save(this.title, this.playerList);

  Save.fromString(String value) {
    List<String> saveStringTitle = value.split("é");
    String title = saveStringTitle[0];
    this.title = title;
    this.playerList = List<Player>.empty(growable: true);
    String playerListString = saveStringTitle[1];
    List<String> playerListName = playerListString.split(",");
    for (String playerString in playerListName) {
      Player player = Player.fromString(playerString);
      this.playerList.add(player);
    }
  }

  @override
  String toString() {
    return '$titleé$playerList';
  }
}
