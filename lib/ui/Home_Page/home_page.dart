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
  bool ayarlariKaydet = true;

  int oyuncuSayisi = 2, oyuncuSayisiBitis = 101, baslangicParasi;

  List<int> oyuncuSayisiList;
  List<String> oyuncuAdlariList = List<String>.filled(100, "Null");

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    oyuncuSayisiList = oyuncuSayisiListOlustur();
  }

  @override
  Widget build(BuildContext context) {
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
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline1.color,
                      fontWeight: FontWeight.w600,
                      fontSize: 30),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Text(
                    "Oyuncu adlarını giriniz, başlangıç parasını seçiniz ve oluştura tıklayınız"),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text("Oyuncu Sayısı"),
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
                                    oyuncuAdlariList[i] = value,
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
                          child: Text("Başlangıç Parası"),
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
                            validator: (String value) {
                              if (value == null || value.length == 0) {
                                return "Lütfen bir başlangıç parası girin";
                              } else if (value.contains(",") ||
                                  value.contains(".")) {
                                return "Lütfen tam sayı giriniz";
                              }
                              return null;
                            },
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
                padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: Text("Mevcut ayarları kaydet"),
                    ),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Checkbox(
                        value: ayarlariKaydet,
                        activeColor: Theme.of(context).primaryColor,
                        checkColor: Colors.white,
                        onChanged: (newValue) =>
                            setState(() => ayarlariKaydet = newValue),
                      ),
                    )),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                        child: Text(
                          "Oluştur",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          olustur();
                        },
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: Colors.black,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 30, 0, 0),
                child: Text(
                  "Önceki Oyunu Yükle",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                        child: Text(
                          "Önceki Oyunu Yükle",
                          style: TextStyle(color: Colors.white),
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
                          "Kaydedilmiş Oyunları Gör",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.normal),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SavesPage()));
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<int> oyuncuSayisiListOlustur() {
    List<int> list = List.empty(growable: true);
    for (int i = oyuncuSayisi; i < oyuncuSayisiBitis; i++) {
      list.add(i);
    }
    return list;
  }

  Future<void> olustur() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (ayarlariKaydet) {
        final SharedPreferences prefs = await _prefs;
        prefs.setInt("oyuncuSayisi", oyuncuSayisi);
        prefs.setStringList("oyuncuAdlariList", oyuncuAdlariList);
        prefs.setInt("baslangicParasi", baslangicParasi);
      }

      List<Player> playerList = preparePlayerList();

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GamePage(
                playerList: playerList,
                baslangicParasi: baslangicParasi,
              )));
    }
  }

  List<Player> preparePlayerList() {
    List<Player> playerList = List<Player>.empty(growable: true);

    for (int i = 1; i <= oyuncuSayisi; i++) {
      Player player = Player(name: oyuncuAdlariList[i], money: baslangicParasi);
      playerList.add(player);
    }
    return playerList;
  }

  Future<void> loadLastGame() async {
    final SharedPreferences prefs = await _prefs;
    List<String> saveStringList;
    try {
      saveStringList = prefs.getStringList("saveStringList");
      Save save = Save.fromString(saveStringList.last);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GamePage(
                playerList: save.playerList,
                baslangicParasi: save.baslangicParasi,
              )));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Son kaydettiğiniz oyun bulunamamaktadır"),
        duration: Duration(seconds: 2),
      ));
    }
  }
}
