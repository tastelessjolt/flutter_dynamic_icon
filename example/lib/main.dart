import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Dynamic App Icon'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              OutlineButton.icon(
                icon: Icon(Icons.ac_unit),
                label: Text("Team Fortress"),
                onPressed: () async {
                  try {
                    print(await FlutterDynamicIcon.supportsAlternateIcons);
                    if (await FlutterDynamicIcon.supportsAlternateIcons) {
                      await FlutterDynamicIcon.setAlternateIconName(
                          "teamfortress");
                      _scaffoldKey.currentState.hideCurrentSnackBar();
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text("App icon change successful"),
                      ));
                      return;
                    }
                  } on PlatformException {} catch (e) {}
                  _scaffoldKey.currentState.hideCurrentSnackBar();
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text("Failed to change app icon"),
                  ));
                },
              ),
              OutlineButton.icon(
                icon: Icon(Icons.ac_unit),
                label: Text("Photos"),
                onPressed: () async {
                  try {
                    if (await FlutterDynamicIcon.supportsAlternateIcons) {
                      await FlutterDynamicIcon.setAlternateIconName("photos");
                      _scaffoldKey.currentState.hideCurrentSnackBar();
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text("App icon change successful"),
                      ));
                      return;
                    }
                  } on PlatformException {} catch (e) {}
                  _scaffoldKey.currentState.hideCurrentSnackBar();
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text("Failed to change app icon"),
                  ));
                },
              ),
              OutlineButton.icon(
                icon: Icon(Icons.ac_unit),
                label: Text("Chills"),
                onPressed: () async {
                  try {
                    if (await FlutterDynamicIcon.supportsAlternateIcons) {
                      await FlutterDynamicIcon.setAlternateIconName("chills");
                      _scaffoldKey.currentState.hideCurrentSnackBar();
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text("App icon change successful"),
                      ));
                      return;
                    }
                  } on PlatformException {} catch (e) {}
                  _scaffoldKey.currentState.hideCurrentSnackBar();
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text("Failed to change app icon"),
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
