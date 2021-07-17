import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:game_atm/models/game.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Settings_Page/settings_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool ayarlariKaydet;

  int oyuncuSayisi = 2, oyuncuSayisiBitis = 100, baslangicParasi;

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
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          "Game Atm",
          textAlign: TextAlign.center,
        ),
        actions: [
          PopupMenuButton(
            color: Colors.black,
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
              }
            },
          )
        ],
        centerTitle: false,
        elevation: 4,
      ),
      backgroundColor: Color(0xFFEFEFEF),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: Text(
                "Yeni bir Oyun Ayarla",
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline1.color,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
            for (int i = 1; i < oyuncuSayisi; i++)
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text("Oyuncu $i"),
                        ),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: TextFormField(
                            initialValue: "Oyuncu $i",
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 3),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0)))),
                            style: TextStyle(fontWeight: FontWeight.w600),
                            validator: (String value) {
                              if (value.length == 0)
                                return "Lütfen Oyuncu adını giriniz";
                              return null;
                            },
                            onSaved: (String value) =>
                                oyuncuAdlariList[i] = value,
                          ),
                        )),
                      ],
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
                            keyboardType: TextInputType.numberWithOptions(),
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
            )
          ],
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
    if (ayarlariKaydet) {
      final SharedPreferences prefs = await _prefs;
      prefs.setInt("oyuncuSayisi", oyuncuSayisi);
      prefs.setStringList("oyuncuAdlariList", oyuncuAdlariList);
      prefs.setInt("baslangicParasi", baslangicParasi);
    }

    Game game = Game();
    game.oyuncuSayisi = oyuncuSayisi;
    game.oyuncuAdlariList = oyuncuAdlariList;
    game.baslangicParasi = baslangicParasi;

    // Navigator.of(context).push(
    //     MaterialPageRoute(builder: (context) => GamePage()));
  }
}
