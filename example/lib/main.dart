import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int batchIconNumber = 0;

  String currentIconName = "?";

  bool loading = false;

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    FlutterDynamicIcon.getApplicationIconBadgeNumber().then((v) {
      setState(() {
        batchIconNumber = v;
      });
    });

    FlutterDynamicIcon.getAlternateIconName().then((v) {
      setState(() {
        currentIconName = v ?? "`primary`";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Dynamic App Icon'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 28),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Current batch number: $batchIconNumber",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              TextField(
                controller: controller,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("\\d+")),
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Set Batch Icon Number",
                  suffixIcon: loading
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(
                              // strokeWidth: 2,
                              ),
                        )
                      : IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            try {
                              await FlutterDynamicIcon
                                  .setApplicationIconBadgeNumber(
                                      int.parse(controller.text));
                              batchIconNumber = await FlutterDynamicIcon
                                  .getApplicationIconBadgeNumber();
                            } on PlatformException {} catch (e) {}
                            if (this.mounted) {
                              _scaffoldKey.currentState?.hideCurrentSnackBar();
                              _scaffoldKey.currentState?.showSnackBar(SnackBar(
                                content: Text("Failed to change batch number"),
                              ));
                            }
                            setState(() {
                              loading = false;
                            });
                          },
                        ),
                ),
              ),
              SizedBox(
                height: 28,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Current Icon Name: $currentIconName",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              OutlineButton.icon(
                icon: Icon(Icons.ac_unit),
                label: Text("Team Fortress"),
                onPressed: () async {
                  try {
                    print(await FlutterDynamicIcon.supportsAlternateIcons);
                    if (await FlutterDynamicIcon.supportsAlternateIcons) {
                      await FlutterDynamicIcon.setAlternateIconName(
                          "teamfortress");
                      _scaffoldKey.currentState?.hideCurrentSnackBar();
                      _scaffoldKey.currentState?.showSnackBar(SnackBar(
                        content: Text("App icon change successful"),
                      ));
                      FlutterDynamicIcon.getAlternateIconName().then((v) {
                        setState(() {
                          currentIconName = v ?? "`primary`";
                        });
                      });
                      return;
                    }
                  } on PlatformException {} catch (e) {}
                  _scaffoldKey.currentState?.hideCurrentSnackBar();
                  _scaffoldKey.currentState?.showSnackBar(SnackBar(
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
                      _scaffoldKey.currentState?.hideCurrentSnackBar();
                      _scaffoldKey.currentState?.showSnackBar(SnackBar(
                        content: Text("App icon change successful"),
                      ));
                      FlutterDynamicIcon.getAlternateIconName().then((v) {
                        setState(() {
                          currentIconName = v ?? "`primary`";
                        });
                      });
                      return;
                    }
                  } on PlatformException {} catch (e) {}
                  _scaffoldKey.currentState?.hideCurrentSnackBar();
                  _scaffoldKey.currentState?.showSnackBar(SnackBar(
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
                      _scaffoldKey.currentState?.hideCurrentSnackBar();
                      _scaffoldKey.currentState?.showSnackBar(SnackBar(
                        content: Text("App icon change successful"),
                      ));
                      FlutterDynamicIcon.getAlternateIconName().then((v) {
                        setState(() {
                          currentIconName = v ?? "`primary`";
                        });
                      });
                      return;
                    }
                  } on PlatformException {} catch (e) {}
                  _scaffoldKey.currentState?.hideCurrentSnackBar();
                  _scaffoldKey.currentState?.showSnackBar(SnackBar(
                    content: Text("Failed to change app icon"),
                  ));
                },
              ),
              SizedBox(
                height: 28,
              ),
              OutlineButton.icon(
                icon: Icon(Icons.restore_outlined),
                label: Text("Restore Icon"),
                onPressed: () async {
                  try {
                    if (await FlutterDynamicIcon.supportsAlternateIcons) {
                      await FlutterDynamicIcon.setAlternateIconName(null);
                      _scaffoldKey.currentState?.hideCurrentSnackBar();
                      _scaffoldKey.currentState?.showSnackBar(SnackBar(
                        content: Text("App icon restore successful"),
                      ));
                      FlutterDynamicIcon.getAlternateIconName().then((v) {
                        setState(() {
                          currentIconName = v ?? "`primary`";
                        });
                      });
                      return;
                    }
                  } on PlatformException {} catch (e) {}
                  _scaffoldKey.currentState?.hideCurrentSnackBar();
                  _scaffoldKey.currentState?.showSnackBar(SnackBar(
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
