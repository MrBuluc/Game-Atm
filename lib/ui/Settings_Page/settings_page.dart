import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool sesEffektiAcik = true;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: true,
        centerTitle: true,
        elevation: 4,
        title: Text(
          "Ayarlar",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Ses Effekti",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Switch(
                    value: sesEffektiAcik,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (newValue) async {
                      final SharedPreferences prefs = await _prefs;
                      setState(() {
                        sesEffektiAcik = newValue;
                        prefs.setBool("sesEffektiAcik", sesEffektiAcik);
                      });
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
