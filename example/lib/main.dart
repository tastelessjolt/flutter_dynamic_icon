import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey();
  final TextEditingController controller = TextEditingController();

  int batchIconNumber = 0;
  String currentIconName = "?";
  bool loading = false;

  @override
  void initState() {
    super.initState();
    try {
      FlutterDynamicIcon.getApplicationIconBadgeNumber().then((v) {
        setState(() {
          batchIconNumber = v;
        });
      }).onError<PlatformException>((error, _) {
        setState(() {
          batchIconNumber = -1;
        });
      });
    } on PlatformException catch (e) {}

    FlutterDynamicIcon.getAlternateIconName().then((v) {
      setState(() {
        currentIconName = v ?? "`primary`";
      });
    });
  }

  /// Changes the icon
  Future<void> _changeIcon(String? iconName) async {
    try {
      // Check if the device supports alternative icons
      bool supportAltIcons = await FlutterDynamicIcon.supportsAlternateIcons;
      print(supportAltIcons);

      if (supportAltIcons) {
        // Make the icon swapping
        await FlutterDynamicIcon.setAlternateIconName(iconName);

        _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
        _scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(content: Text("App icon changed successful")));

        // To confirm the swap try get the current icon name
        String? newIconName = await FlutterDynamicIcon.getAlternateIconName();
        setState(() {
          currentIconName = newIconName ?? "`primary`";
        });
      }
    } on PlatformException catch (e) {
      _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
      _scaffoldMessengerKey.currentState
          ?.showSnackBar(SnackBar(content: Text("Failed to change app icon")));
      debugPrint(e.toString());
    }
  }

  Future<void> _setBatchNumber(String val) async {
    if (val.length == 0) {
      return;
    }

    setState(() {
      loading = true;
    });
    int batchNumber = int.parse(val);
    try {
      await FlutterDynamicIcon.setApplicationIconBadgeNumber(batchNumber);
      batchIconNumber =
          await FlutterDynamicIcon.getApplicationIconBadgeNumber();
      _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
      _scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text("Batch number changed successful")));
    } on PlatformException catch (e) {
      _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
      _scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text("Failed to change batch number")));
      debugPrint(e.toString());
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      home: Scaffold(
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
                          child: CircularProgressIndicator(),
                        )
                      : IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () => _setBatchNumber(controller.text),
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
              OutlinedButton.icon(
                icon: Icon(Icons.ac_unit),
                label: Text("Team Fortress"),
                onPressed: () => _changeIcon("teamfortress"),
              ),
              OutlinedButton.icon(
                icon: Icon(Icons.ac_unit),
                label: Text("Photos"),
                onPressed: () => _changeIcon("photos"),
              ),
              OutlinedButton.icon(
                icon: Icon(Icons.ac_unit),
                label: Text("Chills"),
                onPressed: () => _changeIcon("chills"),
              ),
              SizedBox(
                height: 28,
              ),
              OutlinedButton.icon(
                icon: Icon(Icons.restore_outlined),
                label: Text("Restore Icon"),
                onPressed: () => _changeIcon(null),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
