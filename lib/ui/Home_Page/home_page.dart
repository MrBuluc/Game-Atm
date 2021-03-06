import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:game_atm/models/player.dart';
import 'package:game_atm/models/save.dart';
import 'package:game_atm/services/validator.dart';
import 'package:game_atm/ui/Game_Page/game_page.dart';
import 'package:game_atm/ui/Saves_Page/saves_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Settings_Page/settings_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int oyuncuSayisi = 2, oyuncuSayisiBitis = 100, baslangicParasi;

  List<int> oyuncuSayisiList;
  List<String> oyuncuAdlariList = List<String>.empty(growable: true);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  double width, height;

  TextStyle headLineTextStyle;

  @override
  void initState() {
    super.initState();
    oyuncuSayisiList = oyuncuSayisiListOlustur();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    headLineTextStyle = TextStyle(
        color: Theme.of(context).textTheme.headline1.color,
        fontWeight: FontWeight.w600,
        fontSize: 30);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          "Game Atm",
          textAlign: TextAlign.center,
        ),
        actions: [
          PopupMenuButton(
            color: Colors.white,
            elevation: 20,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "Ayarlar",
                child: Text("Ayarlar"),
              )
            ],
            onSelected: (value) {
              switch (value) {
                case "Ayarlar":
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SettingsPage()));
                  break;
              }
            },
          )
        ],
        centerTitle: false,
        elevation: 4,
      ),
      backgroundColor: Color(0xFFEFEFEF),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: Text(
                  "Yeni bir Oyun Ayarla",
                  style: headLineTextStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Text(
                    "Oyuncu adlar??n?? giriniz, ba??lang???? paras??n?? se??iniz ve olu??tura t??klay??n??z"),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text("Oyuncu Say??s??"),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: DropdownButton<int>(
                        value: oyuncuSayisi,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        dropdownColor: Colors.white,
                        elevation: 2,
                        items: oyuncuSayisiList
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                        onChanged: (int newValue) {
                          setState(() {
                            oyuncuSayisi = newValue;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: oyuncuSayisi,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text("Oyuncu ${i + 1}"),
                            ),
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: TextFormField(
                                initialValue: "Oyuncu ${i + 1}",
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 3),
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0)))),
                                style: TextStyle(fontWeight: FontWeight.w600),
                                validator: Validator.isimKontrol,
                                onSaved: (String value) =>
                                    oyuncuAdlariList.add(value),
                              ),
                            )),
                          ],
                        );
                      },
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: Text("Ba??lang???? Paras??"),
                        ),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "0",
                              hintStyle: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 3),
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0))),
                            ),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                            validator: Validator.degerKontrol,
                            onSaved: (String value) =>
                                baslangicParasi = int.parse(value),
                          ),
                        ))
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
                child: Container(
                  width: width,
                  height: 80,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor),
                    child: Text(
                      "Olu??tur",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    onPressed: () {
                      olustur();
                    },
                  ),
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: Colors.black,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: Text(
                  "??nceki Oyunu Y??kle",
                  style: headLineTextStyle,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor),
                      child: Text(
                        "    ??nceki\nOyunu Y??kle",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () async {
                        await loadLastGame();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor),
                      child: Text(
                        "Kaydedilmi??\nOyunlar?? G??r",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SavesPage()));
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<int> oyuncuSayisiListOlustur() {
    List<int> list = List.empty(growable: true);
    for (int i = oyuncuSayisi; i <= oyuncuSayisiBitis; i++) {
      list.add(i);
    }
    return list;
  }

  Future<void> olustur() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      List<Player> playerList = preparePlayerList();

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GamePage(
                playerList: playerList,
                baslangicParasi: baslangicParasi,
              )));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Oyun Olu??turuldu"),
        duration: Duration(seconds: 2),
      ));
      oyuncuAdlariList = List<String>.empty(growable: true);
    }
  }

  List<Player> preparePlayerList() {
    List<Player> playerList = List<Player>.empty(growable: true);

    for (String name in oyuncuAdlariList) {
      Player player = Player(name: name, money: baslangicParasi);
      playerList.add(player);
    }
    return playerList;
  }

  Future<void> loadLastGame() async {
    final SharedPreferences prefs = await _prefs;
    List<String> saveStringList = prefs.getStringList("saveStringList");

    if (saveStringList != null) {
      Save save = Save.fromString(saveStringList.last);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GamePage(
                playerList: save.playerList,
                baslangicParasi: save.baslangicParasi,
                index: saveStringList.length - 1,
              )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Son kaydetti??iniz oyun bulunamamaktad??r"),
        duration: Duration(seconds: 2),
      ));
    }
  }
}
