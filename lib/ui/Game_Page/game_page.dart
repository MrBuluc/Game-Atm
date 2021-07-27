import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:game_atm/models/player.dart';
import 'package:game_atm/models/save.dart';
import 'package:game_atm/ui/Saves_Page/saves_page.dart';
import 'package:game_atm/ui/Settings_Page/settings_page.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamePage extends StatefulWidget {
  final List<Player> playerList;
  final int baslangicParasi;

  GamePage({@required this.playerList, @required this.baslangicParasi});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<Player> playerList = List<Player>.empty(growable: true);
  List<Player> startingPlayerList = List.empty(growable: true);
  List<int> diceDialogList = [1, 2, 3, 4, 5, 6];
  List<int> diceList = List.filled(6, 1);
  List<String> quickMoneyList = List<String>.empty(growable: true);

  String dicePath = "assets/dice/";

  bool diceOpen = false, sesEffektiAcik;

  int diceCount, baslangicParasi;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  AudioPlayer soundPlayer;

  FToast fToast;

  @override
  void initState() {
    super.initState();
    playerList = widget.playerList;
    //preparePlayerList();
    prepareSesEffektiAcik();
    if (sesEffektiAcik) soundPlayer = AudioPlayer();
    baslangicParasi = widget.baslangicParasi;
  }

  @override
  void dispose() {
    if (sesEffektiAcik) soundPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        title: Text("Game Atm"),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                child: Image.asset(setDicePath(6)),
                onPressed: () {
                  if (!diceOpen)
                    diceDialog(context);
                  else
                    setState(() => diceOpen = false);
                },
              ),
              TextButton(
                child: Icon(
                  Icons.save,
                  color: Colors.black,
                  size: 35,
                ),
                onPressed: () {
                  saveGame();
                },
              ),
              PopupMenuButton(
                color: Colors.black,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: "New Game",
                    child: Text("Yeni Oyun"),
                  ),
                  PopupMenuItem(
                    value: "Reset",
                    child: Text("Oyunu Sıfırla"),
                  ),
                  PopupMenuItem(
                    value: "Load Game",
                    child: Text("Oyun Yükle"),
                  ),
                  PopupMenuItem(
                    value: "Settings",
                    child: Text("Ayarlar"),
                  ),
                ],
                onSelected: (value) {
                  switch (value) {
                    case "New Game":
                      Navigator.pop(context);
                      break;
                    case "Reset":
                      resetDialog(context);
                      break;
                    case "Load Game":
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SavesPage()));
                      break;
                    case "Settings":
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SettingsPage()));
                      break;
                  }
                },
              )
            ],
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (Player player in playerList)
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: Color(0xFFF5F5F5),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              player.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .color,
                                  fontSize: 18),
                            ),
                          ),
                          Divider(
                            thickness: 2,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                            child: Text(
                              player.money.toString(),
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                child: Text(
                                  "Ekle",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                                onPressed: () async {
                                  await prepareQuickMoneyList();
                                  if (sesEffektiAcik)
                                    await soundPlayer
                                        .setAsset("assets/sound.mp3");
                                  addOrRemoveDialog(context, player, 1);
                                },
                              ),
                              TextButton(
                                child: Text(
                                  "Çıkar",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                                onPressed: () async {
                                  await prepareQuickMoneyList();
                                  if (sesEffektiAcik)
                                    await soundPlayer
                                        .setAsset("assets/sound.mp3");
                                  addOrRemoveDialog(context, player, 0);
                                },
                              ),
                              TextButton(
                                child: Text(
                                  "Transfer",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                                onPressed: () async {
                                  await soundPlayer
                                      .setAsset("assets/sound.mp3");
                                  transferDialog(context, player);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
              ],
            ),
            if (diceOpen)
              Padding(
                padding: EdgeInsets.fromLTRB(0, 580, 0, 0),
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(color: Color(0xFFE6E6E6)),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        for (int i = 0; i < diceCount; i++)
                          TextButton(
                            child: Image.asset(setDicePath(diceList[i])),
                            onPressed: () {
                              randomDice();
                              setState(() {});
                            },
                          )
                      ],
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Future<void> prepareSesEffektiAcik() async {
    final SharedPreferences prefs = await _prefs;
    try {
      sesEffektiAcik = prefs.getBool("sesEffektiAcik");
    } catch (e) {
      sesEffektiAcik = true;
    }
  }

  Widget prepareToast(
      int dialogType, String amount, String player1Name, String player2Name) {
    String message;
    switch (dialogType) {
      case 0:
        message = player1Name + "'in hesabından " + amount + " çıkarıldı";
        break;
      case 1:
        message = player1Name + "'in hesabına " + amount + " eklendi";
        break;
      default:
        message = player1Name +
            " den " +
            player2Name +
            " ye " +
            amount +
            " aktarıldı";
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), color: Colors.greenAccent),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12,
          ),
          Text(message)
        ],
      ),
    );
  }

  void diceDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Row(
              children: [
                Container(
                  child: Image.asset(setDicePath(6)),
                ),
                Text("Kaç zar gerekli?")
              ],
            ),
            children: [
              for (int dice in diceDialogList)
                ListTile(
                  title: Text(dice.toString()),
                  leading: Radio<int>(
                    value: diceCount,
                    groupValue: dice,
                    onChanged: (int value) {
                      setState(() {
                        diceCount = value;
                      });
                      setState(() {
                        diceOpen = true;
                      });
                      Navigator.pop(context);
                    },
                  ),
                )
            ],
          );
        });
  }

  String setDicePath(int num) {
    return dicePath + "dice" + num.toString() + ".png";
  }

  Future<void> saveGame() async {
    DateTime suan = DateTime.now();
    String tarih = suan.day.toString() +
        "/" +
        suan.month.toString() +
        "/" +
        suan.year.toString();
    String title = "Kaydedildi " + tarih;
    Save save = Save(title, playerList, baslangicParasi);
    String saveString = save.toString();

    final SharedPreferences prefs = await _prefs;
    List<String> saveStringList;
    try {
      saveStringList = prefs.getStringList("saveStringList");
    } catch (e) {
      saveStringList = List.empty(growable: true);
    }
    saveStringList.add(saveString);
    prefs.setStringList("saveStringList", saveStringList);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Oyun Kaydedildi"),
      duration: Duration(seconds: 2),
    ));
  }

  void resetDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Oyunu sıfırlamak istediğinize emin misiniz?"),
            children: [
              Column(
                children: [
                  Text("Bu durum oyunu başlangıça sıfırlayacak"),
                  Row(
                    children: [
                      TextButton(
                        child: Text("İptal"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text("Tamam"),
                        onPressed: () {
                          setState(() {
                            for (Player player in playerList) {
                              player.money = baslangicParasi;
                            }
                          });
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

  Future<void> prepareQuickMoneyList() async {
    final SharedPreferences prefs = await _prefs;
    try {
      quickMoneyList = prefs.getStringList("quickMoneyList");
    } catch (e) {
      quickMoneyList.add("100");
      quickMoneyList.add("200");
      quickMoneyList.add("500");
      quickMoneyList.add("1000");
    }
  }

  void addOrRemoveDialog(BuildContext context, Player player, int dialogType) {
    //dialogType == 1 -> Ekle
    //dialogType == 0 -> Çıkar

    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    int amount;

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(dialogType == 1
                ? player.name + "'in hesabına para ekle"
                : player.name + "'in hesabından para çıkar"),
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Text(dialogType == 1
                        ? player.name +
                            "'in hesabına ne kadar para eklemek istiyorsun?"
                        : player.name +
                            "'in hesabından ne kadar para çıkarmak istiyorsun?"),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: dialogType == 1
                            ? "Eklenecek"
                            : "Çıkarılacak" + " miktarı girin",
                      ),
                      keyboardType: TextInputType.numberWithOptions(),
                      onSaved: (String value) => amount = int.parse(value),
                    ),
                    Row(
                      children: [
                        for (String value in quickMoneyList)
                          TextButton(
                            child: Text(value),
                            onPressed: () {
                              addOrRemove(dialogType, player, int.parse(value));
                              Navigator.pop(context);
                            },
                          ),
                        TextButton(
                          child: Icon(Icons.edit),
                          onPressed: () {
                            editQuickMoneyDialog(context);
                          },
                        )
                      ],
                    ),
                    Row(
                      children: [
                        TextButton(
                          child: Text("İptal"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: Text("Tamam"),
                          onPressed: () {
                            formKey.currentState.save();
                            addOrRemove(dialogType, player, amount);
                            if (sesEffektiAcik) soundPlayer.play();
                            Navigator.pop(context);
                            showToast(dialogType, amount.toString(),
                                player.name, null);
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

  showToast(
      int dialogType, String amount, String player1Name, String player2Name) {
    fToast.showToast(
        child: prepareToast(dialogType, amount, player1Name, player2Name),
        gravity: ToastGravity.CENTER,
        toastDuration: Duration(seconds: 2));
  }

  void editQuickMoneyDialog(BuildContext context) {
    GlobalKey<FormState> formKey1 = GlobalKey<FormState>();

    String qM0, qM1, qM2, qM3;

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Hızlı Parayı Düzenle"),
            children: [
              Form(
                key: formKey1,
                child: Column(
                  children: [
                    for (int i = 0; i < 4; i++)
                      TextFormField(
                        initialValue: quickMoneyList[i],
                        keyboardType: TextInputType.numberWithOptions(),
                        onSaved: (String value) {
                          switch (i) {
                            case 0:
                              qM0 = value;
                              break;
                            case 1:
                              qM1 = value;
                              break;
                            case 2:
                              qM2 = value;
                              break;
                            case 3:
                              qM3 = value;
                              break;
                          }
                        },
                      ),
                    Row(
                      children: [
                        TextButton(
                          child: Text("İptal"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: Text("Kaydet"),
                          onPressed: () async {
                            formKey1.currentState.save();
                            List<String> tmpQuickMoneyList = [
                              qM0,
                              qM1,
                              qM2,
                              qM3
                            ];
                            await saveQuickMoney(tmpQuickMoneyList);
                            Navigator.pop(context);
                          },
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  Future<void> saveQuickMoney(List<String> tmpQuickMoneyList) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setStringList("quickMoneyList", tmpQuickMoneyList);
  }

  void addOrRemove(int dialogType, Player player, int value) {
    switch (dialogType) {
      case 1:
        setState(() {
          player.ekle(value);
        });
        break;
      default:
        setState(() {
          player.cikar(value);
        });
        break;
    }
  }

  void transferDialog(BuildContext context, Player player) {
    GlobalKey<FormState> formKey2 = GlobalKey<FormState>();

    int amount1;

    List<Player> tmpPLayerList = playerList.toList();
    tmpPLayerList.remove(player);

    Player choosenPlayer;

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Para Transferi " + player.name + "'den:"),
            children: [
              Form(
                key: formKey2,
                child: Column(
                  children: [
                    for (Player player1 in tmpPLayerList)
                      ListTile(
                        title: Text(player1.name),
                        leading: Radio<Player>(
                          value: choosenPlayer,
                          groupValue: player1,
                          onChanged: (Player player2) {
                            setState(() {
                              choosenPlayer = player2;
                            });
                          },
                        ),
                      ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Transfer edilecek miktarı girin",
                      ),
                      keyboardType: TextInputType.numberWithOptions(),
                      onSaved: (String value) => amount1 = int.parse(value),
                    ),
                    Row(
                      children: [
                        TextButton(
                          child: Text("İptal"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: Text("Tamam"),
                          onPressed: () {
                            formKey2.currentState.save();
                            setState(() {
                              player.transfer(choosenPlayer, amount1);
                            });
                            soundPlayer.play();
                            Navigator.pop(context);
                            showToast(2, amount1.toString(), player.name,
                                choosenPlayer.name);
                          },
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  void randomDice() {
    Random random = Random();
    for (int i = 0; i < 6; i++) {
      int ranNum = random.nextInt(6) + 1;
      diceList[i] = ranNum;
    }
  }
}
