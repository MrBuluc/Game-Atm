import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:game_atm/models/player.dart';
import 'package:game_atm/models/save.dart';
import 'package:game_atm/services/validator.dart';
import 'package:game_atm/ui/Game_Page/game_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavesPage extends StatefulWidget {
  const SavesPage({Key? key}) : super(key: key);

  @override
  _SavesPageState createState() => _SavesPageState();
}

class _SavesPageState extends State<SavesPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<Save> saveList = List<Save>.empty(growable: true);

  TextStyle adlarVeParaTextStyle =
      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  TextStyle? textButtonTextStyle;

  late Size size;

  EdgeInsets adlarVeParaPadding =
      const EdgeInsets.only(left: 10, top: 10, right: 10);

  MainAxisAlignment adlarVeParaMainAxisAlignment =
      MainAxisAlignment.spaceBetween;

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    textButtonTextStyle =
        TextStyle(color: Theme.of(context).primaryColor, fontSize: 18);
    return WillPopScope(
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
          title: const Text(
            "Oyun Yükle",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          actions: [
            PopupMenuButton(
              color: Colors.white,
              elevation: 20,
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: "Delete",
                  child: Text("Hepsini sil"),
                )
              ],
              onSelected: (value) {
                switch (value) {
                  case "Delete":
                    if (saveList.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                            Text("Silinecek bir oyun kaydınız bulunmamaktadır"),
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
            child: FutureBuilder<void>(
          future: prepareSaveStringList(),
          builder: (context, sonuc) => saveList.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Column(
                    children: [
                      const Text(
                        "Herhangi bir kaydedilmiş oyununuz bulunmamaktadır!!!\n"
                        "Yeni bir oyun oluşturmayı deneyin.",
                        style: TextStyle(fontSize: 20),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                        child: const Text(
                          "Yeni Oyun",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: size.width,
                        height: 35,
                        decoration:
                            const BoxDecoration(color: Color(0xFF8BC34A)),
                        child: const Padding(
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
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: saveList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Card(
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
                                    child: const Center(
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
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 0),
                                          child: Text(
                                            saveList[index].title!,
                                            style: const TextStyle(
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
                                              padding: adlarVeParaPadding,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    adlarVeParaMainAxisAlignment,
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
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: saveList[index]
                                                  .playerList!
                                                  .length,
                                              itemBuilder: (context, index1) {
                                                List<Player> playerList =
                                                    saveList[index].playerList!;

                                                return Padding(
                                                  padding: adlarVeParaPadding,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        adlarVeParaMainAxisAlignment,
                                                    children: [
                                                      Text(playerList[index1]
                                                          .name!),
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
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      GamePage(
                                                        playerList:
                                                            saveList[index]
                                                                .playerList!,
                                                        baslangicParasi:
                                                            saveList[index]
                                                                .baslangicParasi!,
                                                        index: index,
                                                      )));
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
        )),
      ),
    );
  }

  Future<void> prepareSaveStringList() async {
    if (counter == 0) {
      saveList.clear();
      final SharedPreferences prefs = await _prefs;
      List<String>? saveStringList = prefs.getStringList("saveStringList");
      if (saveStringList != null) {
        for (String saveString in saveStringList) {
          Save save = Save.fromString(saveString);
          saveList.add(save);
        }
        counter++;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Kaydedilen oyun bulunamamaktadır"),
          duration: Duration(seconds: 1),
        ));
      }
    }
  }

  Future<void> updateSaveStringList() async {
    final SharedPreferences prefs = await _prefs;
    List<String> saveStringList = [];
    for (Save save in saveList) {
      saveStringList.add(save.toString());
    }
    prefs.setStringList("saveStringList", saveStringList);
  }

  void deleteAllDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Hepsini Silmek?"),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Column(
                  children: [
                    const Text(
                      "Tüm kaydedilen oyunları silmek istediğinize emin misiniz?\n"
                      "Bu işlem geri alınamaz",
                      style: TextStyle(fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text(
                            "Hayır",
                            style: textButtonTextStyle,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: Text(
                            "Evet",
                            style: textButtonTextStyle,
                          ),
                          onPressed: () async {
                            await deleteAll();
                            Navigator.pop(context);
                            setState(() {
                              saveList.clear();
                            });
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

  Future<void> deleteAll() async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove("saveStringList");
  }

  void editTitleDialog(BuildContext context, int index) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    String? saveTitle;

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Başlığı Düzenle"),
            children: [
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: saveList[index].title,
                        validator: Validator.isimKontrol,
                        onSaved: (String? value) => saveTitle = value!,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: Text(
                              "İptal",
                              style: textButtonTextStyle,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("İptal edildi"),
                                duration: Duration(seconds: 1),
                              ));
                            },
                          ),
                          TextButton(
                            child: Text(
                              "Tamam",
                              style: textButtonTextStyle,
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                setState(() {
                                  saveList[index].title = saveTitle;
                                });
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      "Başlık $saveTitle olarak değiştirildi"),
                                  duration: const Duration(seconds: 1),
                                ));
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }
}
