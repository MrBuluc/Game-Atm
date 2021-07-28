import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:game_atm/models/player.dart';
import 'package:game_atm/models/save.dart';
import 'package:game_atm/services/validator.dart';
import 'package:game_atm/ui/Game_Page/game_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavesPage extends StatefulWidget {
  @override
  _SavesPageState createState() => _SavesPageState();
}

class _SavesPageState extends State<SavesPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<Save> saveList = List<Save>.empty(growable: true);

  TextStyle adlarVeParaTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    prepareSaveStringList();
  }

  @override
  Widget build(BuildContext context) {
    return saveList.isEmpty
        ? Column(
            children: [
              Text("Herhangibir kaydedilmiş oyununuz bulunmamaktadır!!!\n"
                  "Yeni bir oyun oluşturmayı deneyin."),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor),
                child: Text(
                  "Yeni Oyun",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          )
        : WillPopScope(
            onWillPop: () async {
              updateSaveStringList();
              return true;
            },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                automaticallyImplyLeading: true,
                centerTitle: false,
                elevation: 4,
                title: Text(
                  "Oyun Yükle",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                actions: [
                  PopupMenuButton(
                    color: Colors.black,
                    elevation: 20,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: "Delete",
                        child: Text("Hepsini sil"),
                      )
                    ],
                    onSelected: (value) {
                      switch (value) {
                        case "Delete":
                          if (saveList.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Silinecek bir oyun kaydınız bulunmamaktadır"),
                              duration: Duration(seconds: 2),
                            ));
                          } else {
                            deleteAllDialog(context);
                          }
                          break;
                      }
                    },
                  )
                ],
              ),
              body: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 35,
                      decoration: BoxDecoration(color: Color(0xFF8BC34A)),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text(
                          "Kaydedilen Oyunlar",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: saveList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Color((math.Random().nextDouble() * 0xFFFFFF)
                                  .toInt())
                              .withOpacity(1),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Dismissible(
                                key: Key(saveList[index].hashCode.toString()),
                                onDismissed: (direction) {
                                  setState(() {
                                    saveList.removeAt(index);
                                  });
                                },
                                background: Container(
                                  color: Colors.red,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 50, left: 100),
                                    child: Text(
                                      "Kaldır",
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        child: Text(
                                          saveList[index].title,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      onTap: () {
                                        editTitleDialog(context, index);
                                      },
                                    ),
                                    GestureDetector(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 10, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "Adlar",
                                                  style: adlarVeParaTextStyle,
                                                ),
                                                Text(
                                                  "Para",
                                                  style: adlarVeParaTextStyle,
                                                )
                                              ],
                                            ),
                                          ),
                                          ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: saveList[index]
                                                .playerList
                                                .length,
                                            itemBuilder: (context, index1) {
                                              List<Player> playerList =
                                                  saveList[index].playerList;

                                              return Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 10, 0, 0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(playerList[index1]
                                                        .name),
                                                    Text(playerList[index1]
                                                        .money
                                                        .toString())
                                                  ],
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        updateSaveStringList();
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => GamePage(
                                                      playerList:
                                                          saveList[index]
                                                              .playerList,
                                                      baslangicParasi:
                                                          saveList[index]
                                                              .baslangicParasi,
                                                    )));
                                      },
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          );
  }

  Future<void> prepareSaveStringList() async {
    final SharedPreferences prefs = await _prefs;
    try {
      List<String> saveStringList = prefs.getStringList("saveStringList");
      for (String saveString in saveStringList) {
        Save save = Save.fromString(saveString);
        saveList.add(save);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Kaydedilen oyun bulunamamaktadır"),
        duration: Duration(seconds: 1),
      ));
    }
  }

  void deleteAllDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Hepsini Silmek?"),
            children: [
              Column(
                children: [
                  Text(
                      "Tüm kaydedilen oyunları silmek istediğinize emin misiniz?\n"
                      "Bu işlem geri alınamaz"),
                  Row(
                    children: [
                      TextButton(
                        child: Text("Hayır"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text("Evet"),
                        onPressed: () async {
                          await deleteAll();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )
                ],
              )
            ],
          );
        });
  }

  Future<void> deleteAll() async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove("saveStringList");
  }

  Future<void> updateSaveStringList() async {
    final SharedPreferences prefs = await _prefs;
    List<String> saveStringList = List<String>.empty(growable: true);
    for (Save save in saveList) {
      saveStringList.add(save.toString());
    }
    prefs.setStringList("saveStringList", saveStringList);
  }

  void editTitleDialog(BuildContext context, int index) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    String saveTitle;

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Başlığı Düzenle"),
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: saveList[index].title,
                      validator: Validator.isimKontrol,
                      onSaved: (String value) => saveTitle = value,
                    ),
                    Row(
                      children: [
                        TextButton(
                          child: Text("İptal"),
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("İptal edildi"),
                              duration: Duration(seconds: 1),
                            ));
                          },
                        ),
                        TextButton(
                          child: Text("Tamam"),
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();
                              setState(() {
                                saveList[index].title = saveTitle;
                              });
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    "Başlık $saveTitle olarak değiştirildi"),
                                duration: Duration(seconds: 1),
                              ));
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          );
        });
  }
}
