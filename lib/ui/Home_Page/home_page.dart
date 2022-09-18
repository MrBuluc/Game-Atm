import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:game_atm/models/player.dart';
import 'package:game_atm/models/save.dart';
import 'package:game_atm/services/validator.dart';
import 'package:game_atm/ui/Game_Page/game_page.dart';
import 'package:game_atm/ui/Saves_Page/saves_page.dart';
import 'package:game_atm/ui/Settings_Page/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int oyuncuSayisi = 2, oyuncuSayisiBitis = 10;
  int? baslangicParasi;

  List<int>? oyuncuSayisiList;
  List<String> oyuncuAdlariList = [];

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  double? width, height;

  TextStyle? headLineTextStyle;

  @override
  void initState() {
    super.initState();
    oyuncuSayisiList = oyuncuSayisiListOlustur();
  }

  List<int> oyuncuSayisiListOlustur() {
    List<int> list = [];
    for (int i = oyuncuSayisi; i <= oyuncuSayisiBitis; i++) {
      list.add(i);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    headLineTextStyle = TextStyle(
        color: Theme.of(context).textTheme.headline1!.color,
        fontWeight: FontWeight.w600,
        fontSize: 30);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        title: const Text(
          "Game Atm",
          textAlign: TextAlign.center,
        ),
        actions: [
          PopupMenuButton(
            color: Colors.white,
            elevation: 20,
            itemBuilder: (context) => [
              const PopupMenuItem(
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
      backgroundColor: const Color(0xFFEFEFEF),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: Text(
                  "Yeni bir Oyun Ayarla",
                  style: headLineTextStyle,
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Text(
                    "Oyuncu adlarını giriniz, başlangıç parasını seçiniz ve oluştura tıklayınız"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text("Oyuncu Sayısı"),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: DropdownButton<int>(
                        value: oyuncuSayisi,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        dropdownColor: Colors.white,
                        elevation: 2,
                        items: oyuncuSayisiList!
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          setState(() {
                            oyuncuSayisi = newValue!;
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
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: oyuncuSayisi,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text("Oyuncu ${i + 1}"),
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                                validator: Validator.isimKontrol,
                                onSaved: (String? value) =>
                                    oyuncuAdlariList.add(value!),
                              ),
                            )),
                          ],
                        );
                      },
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: Text("Başlangıç Parası"),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "0",
                              hintStyle: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 3),
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0))),
                            ),
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                            validator: Validator.degerKontrol,
                            onSaved: (String? value) =>
                                baslangicParasi = int.parse(value!),
                          ),
                        ))
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
                child: SizedBox(
                  width: width,
                  height: 80,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor),
                    child: const Text(
                      "Oluştur",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    onPressed: () {
                      olustur();
                    },
                  ),
                ),
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: Text(
                  "Önceki Oyunu Yükle",
                  style: headLineTextStyle,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor),
                      child: const Text(
                        "    Önceki\nOyunu Yükle",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () async {
                        await loadLastGame();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor),
                      child: const Text(
                        "Kaydedilmiş\nOyunları Gör",
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

  Future<void> olustur() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      List<Player> playerList = preparePlayerList();

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GamePage(
                playerList: playerList,
                baslangicParasi: baslangicParasi!,
              )));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Oyun Oluşturuldu"),
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
    List<String>? saveStringList = prefs.getStringList("saveStringList");

    if (saveStringList!.isNotEmpty) {
      Save save = Save.fromString(saveStringList.last);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GamePage(
                playerList: save.playerList!,
                baslangicParasi: save.baslangicParasi!,
                index: saveStringList.length - 1,
              )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Son kaydettiğiniz oyun bulunamamaktadır"),
        duration: Duration(seconds: 2),
      ));
    }
  }
}
