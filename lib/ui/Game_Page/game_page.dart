import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:game_atm/models/player.dart';
import 'package:game_atm/models/save.dart';
import 'package:game_atm/services/validator.dart';
import 'package:game_atm/ui/Saves_Page/saves_page.dart';
import 'package:game_atm/ui/Settings_Page/settings_page.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamePage extends StatefulWidget {
  final List<Player> playerList;
  final int baslangicParasi;
  final int? index;

  const GamePage(
      {Key? key,
      required this.playerList,
      required this.baslangicParasi,
      this.index})
      : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<Player>? playerList;
  List<Player> startingPlayerList = [];
  List<int> diceDialogList = [1, 2, 3, 4, 5, 6];
  List<int> diceList = List.filled(6, 1);
  List<String>? quickMoneyList;

  String dicePath = 'assets/dice/';

  bool diceOpen = false;
  late bool? sesEffektiAcik;

  int? diceCount, baslangicParasi;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  AudioPlayer? soundPlayer;

  FToast? fToast;

  double? width, height;

  TextStyle? textButtonTextStyle;

  EdgeInsets padding = const EdgeInsets.only(left: 24, right: 24),
      textFormFieldPadding = const EdgeInsets.only(left: 10);

  @override
  void initState() {
    super.initState();
    playerList = widget.playerList;
    prepareSesEffektiAcik();
    baslangicParasi = widget.baslangicParasi;
    if (widget.index == null) saveGame();
    fToast = FToast();
  }

  Future<void> prepareSesEffektiAcik() async {
    final SharedPreferences prefs = await _prefs;
    sesEffektiAcik = prefs.getBool("sesEffektiAcik");
    sesEffektiAcik ??= true;

    if (sesEffektiAcik!) {
      soundPlayer = AudioPlayer();
      await soundPlayer!.setAsset("assets/sound.mp3");
    }
  }

  @override
  void dispose() {
    if (sesEffektiAcik!) soundPlayer!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    textButtonTextStyle =
        TextStyle(color: Theme.of(context).primaryColor, fontSize: 18);
    fToast!.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        title: const Text("Game Atm"),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Image.asset(
                  setDicePath(6),
                  width: 100,
                  height: 100,
                ),
                onPressed: () {
                  if (!diceOpen) {
                    diceDialog(context);
                  } else {
                    setState(() => diceOpen = false);
                  }
                },
              ),
              TextButton(
                child: const Icon(
                  Icons.save,
                  color: Colors.black,
                  size: 35,
                ),
                onPressed: () {
                  saveGame();
                },
              ),
              PopupMenuButton(
                color: Colors.white,
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: "New Game",
                    child: Text("Yeni Oyun"),
                  ),
                  const PopupMenuItem(
                    value: "Reset",
                    child: Text("Oyunu Sıfırla"),
                  ),
                  const PopupMenuItem(
                    value: "Load Game",
                    child: Text("Oyun Yükle"),
                  ),
                  const PopupMenuItem(
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SavesPage()));
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
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (Player player in playerList!)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: const Color(0xFFF5F5F5),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text(
                                player.name!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .color,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            const Divider(
                              thickness: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                              child: Text(
                                player.money.toString(),
                                style: const TextStyle(fontSize: 30),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  child: const Text(
                                    "Ekle",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                  onPressed: () async {
                                    await prepareQuickMoneyList();
                                    addOrRemoveDialog(context, player, 1);
                                  },
                                ),
                                TextButton(
                                  child: const Text(
                                    "Çıkar",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                  onPressed: () async {
                                    await prepareQuickMoneyList();
                                    addOrRemoveDialog(context, player, 0);
                                  },
                                ),
                                TextButton(
                                  child: const Text(
                                    "Transfer",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                  onPressed: () async {
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
            ),
            if (diceOpen)
              Column(
                children: [
                  SizedBox(
                    height: height! * 0.79,
                  ),
                  Container(
                    width: width,
                    height: 60,
                    decoration: const BoxDecoration(color: Color(0xFFE6E6E6)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: diceCount,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            return IconButton(
                              icon: Image.asset(
                                setDicePath(diceList[i]),
                              ),
                              iconSize: 50,
                              onPressed: () {
                                randomDice();
                                setState(() {});
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void diceDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  setDicePath(6),
                  width: 50,
                  height: 50,
                ),
                const Text("Kaç zar gerekli?")
              ],
            ),
            children: [
              for (int dice in diceDialogList)
                ListTile(
                  title: Text(dice.toString()),
                  leading: Radio<int>(
                    value: dice,
                    groupValue: 0,
                    onChanged: (int? value) {
                      setState(() {
                        diceCount = value;
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
    return dicePath + 'dice' + num.toString() + '.png';
  }

  Future<void> saveGame() async {
    int? index = widget.index;
    final SharedPreferences prefs = await _prefs;
    List<String>? saveStringList = prefs.getStringList("saveStringList");
    saveStringList ??= [];

    if (index == null) {
      DateTime suan = DateTime.now();
      String tarih = suan.day.toString() +
          "/" +
          suan.month.toString() +
          "/" +
          suan.year.toString();
      String title = "Kaydedildi " + tarih;
      String saveString = Save(title, playerList, baslangicParasi).toString();

      saveStringList.add(saveString);
    } else {
      Save oldSave = Save.fromString(saveStringList[index]);
      String newSaveString =
          Save(oldSave.title, playerList, baslangicParasi).toString();
      saveStringList.removeAt(index);
      saveStringList.insert(index, newSaveString);
    }

    prefs.setStringList("saveStringList", saveStringList);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Oyun Kaydedildi"),
      duration: Duration(seconds: 2),
    ));
  }

  void resetDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Oyunu sıfırlamak istediğinize emin misiniz?"),
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 24, right: 24),
                    child: Text(
                      "Bu durum oyunu başlangıça sıfırlayacak",
                      style: TextStyle(fontSize: 20),
                    ),
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
                        },
                      ),
                      TextButton(
                        child: Text(
                          "Tamam",
                          style: textButtonTextStyle,
                        ),
                        onPressed: () {
                          setState(() {
                            for (Player player in playerList!) {
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
    quickMoneyList = prefs.getStringList("quickMoneyList");
    quickMoneyList ??= ["100", "200", "500", "1000"];
  }

  void addOrRemoveDialog(BuildContext context, Player player, int dialogType) {
    //dialogType == 1 -> Ekle
    //dialogType == 0 -> Çıkar

    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    int? amount;

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(dialogType == 1
                ? player.name! + "'in hesabına para ekle"
                : player.name! + "'in hesabından para çıkar"),
            children: [
              StatefulBuilder(
                builder: (BuildContext context, StateSetter textButtonState) {
                  return Form(
                    key: formKey,
                    child: Padding(
                      padding: padding,
                      child: Column(
                        children: [
                          Text(
                            dialogType == 1
                                ? player.name! +
                                    "'in hesabına ne kadar para eklemek istiyorsun?"
                                : player.name! +
                                    "'in hesabından ne kadar para çıkarmak istiyorsun?",
                            style: const TextStyle(fontSize: 18),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: dialogType == 1
                                  ? "Eklenecek miktarı girin"
                                  : "Çıkarılacak miktarı girin",
                            ),
                            keyboardType: TextInputType.number,
                            validator: Validator.degerKontrol,
                            onSaved: (String? value) =>
                                amount = int.parse(value!),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              for (String value in quickMoneyList!)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: GestureDetector(
                                    child: Container(
                                      color: Theme.of(context).primaryColor,
                                      width: 50,
                                      height: 50,
                                      child: Center(
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      addOrRemove(
                                          dialogType, player, int.parse(value));
                                      Navigator.pop(context);
                                      showToast(dialogType, value, player.name!,
                                          null);
                                      if (sesEffektiAcik!) {
                                        soundPlayer!.play();
                                        await Future.delayed(
                                            const Duration(seconds: 2));
                                        soundPlayer!.stop();
                                      }
                                    },
                                  ),
                                ),
                              TextButton(
                                child: const Icon(
                                  Icons.edit,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  editQuickMoneyDialog(
                                      context, textButtonState);
                                },
                              )
                            ],
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
                                },
                              ),
                              TextButton(
                                child: Text(
                                  "Tamam",
                                  style: textButtonTextStyle,
                                ),
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                    addOrRemove(dialogType, player, amount!);
                                    Navigator.pop(context);
                                    showToast(dialogType, amount.toString(),
                                        player.name!, null);
                                    if (sesEffektiAcik!) {
                                      soundPlayer!.play();
                                      await Future.delayed(
                                          const Duration(seconds: 2));
                                      soundPlayer!.stop();
                                    }
                                  }
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          );
        });
  }

  void editQuickMoneyDialog(
      BuildContext context, StateSetter textButtonState1) {
    GlobalKey<FormState> formKey1 = GlobalKey<FormState>();

    String? qM0, qM1, qM2, qM3;

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Hızlı Parayı Düzenle"),
            children: [
              Form(
                key: formKey1,
                child: Padding(
                  padding: textFormFieldPadding,
                  child: Column(
                    children: [
                      for (int i = 0; i < 4; i++)
                        TextFormField(
                          initialValue: quickMoneyList![i],
                          keyboardType: const TextInputType.numberWithOptions(),
                          onSaved: (String? value) {
                            switch (i) {
                              case 0:
                                qM0 = value!;
                                break;
                              case 1:
                                qM1 = value!;
                                break;
                              case 2:
                                qM2 = value!;
                                break;
                              case 3:
                                qM3 = value!;
                                break;
                            }
                          },
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: Text(
                              "İptal",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text(
                              "Kaydet",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20),
                            ),
                            onPressed: () async {
                              formKey1.currentState!.save();
                              List<String> tmpQuickMoneyList = [
                                qM0!,
                                qM1!,
                                qM2!,
                                qM3!
                              ];
                              await saveQuickMoney(tmpQuickMoneyList);
                              Navigator.pop(context);
                              textButtonState1(() {
                                quickMoneyList = tmpQuickMoneyList;
                              });
                            },
                          )
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

    int? amount1;

    List<Player> tmpPLayerList = playerList!.toList();
    tmpPLayerList.remove(player);

    Player choosenPlayer = tmpPLayerList[0];

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Para Transferi " + player.name! + "'den:"),
            children: [
              StatefulBuilder(
                builder: (BuildContext context, StateSetter radioState) {
                  return Form(
                    key: formKey2,
                    child: Column(
                      children: [
                        for (Player player1 in tmpPLayerList)
                          ListTile(
                            title: Text(
                              player1.name!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            leading: Radio<Player>(
                              value: player1,
                              groupValue: choosenPlayer,
                              onChanged: (Player? player2) {
                                radioState(() {
                                  choosenPlayer = player2!;
                                });
                              },
                            ),
                          ),
                        Padding(
                          padding: textFormFieldPadding,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Transfer edilecek miktarı girin",
                            ),
                            keyboardType:
                                const TextInputType.numberWithOptions(),
                            validator: Validator.degerKontrol,
                            onSaved: (String? value) =>
                                amount1 = int.parse(value!),
                          ),
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
                              },
                            ),
                            TextButton(
                              child: Text(
                                "Tamam",
                                style: textButtonTextStyle,
                              ),
                              onPressed: () async {
                                if (formKey2.currentState!.validate()) {
                                  formKey2.currentState!.save();
                                  setState(() {
                                    player.transfer(choosenPlayer, amount1!);
                                  });
                                  Navigator.pop(context);
                                  showToast(2, amount1.toString(), player.name!,
                                      choosenPlayer.name);
                                  if (sesEffektiAcik!) {
                                    soundPlayer!.play();
                                    await Future.delayed(
                                        const Duration(seconds: 2));
                                    soundPlayer!.stop();
                                  }
                                }
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
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

  showToast(
      int dialogType, String amount, String player1Name, String? player2Name) {
    fToast!.showToast(
        child: prepareToast(dialogType, amount, player1Name, player2Name),
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(seconds: 2));
  }

  Widget prepareToast(
      int dialogType, String amount, String player1Name, String? player2Name) {
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
            player2Name! +
            " ye " +
            amount +
            " aktarıldı";
        break;
    }
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.grey.shade300),
        child: Text(message));
  }
}
