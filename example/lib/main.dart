import 'dart:developer';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final TextEditingController controller = TextEditingController();

  int batchIconNumber = 0;
  String currentIconName = "?";
  bool loading = false;

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

  /// Changes the icon
  Future<void> _changeIcon(String iconName) async {
    try {
      // Check if the device supports alternative icons
      bool supportAltIcons = await FlutterDynamicIcon.supportsAlternateIcons;
      print(supportAltIcons);

      if (supportAltIcons) {
        // Make the icon swapping
        await FlutterDynamicIcon.setAlternateIconName(iconName);

        log("App icon changed successful");

        // To confirm the swap try get the current icon name
        String newIconName = await FlutterDynamicIcon.getAlternateIconName();
        setState(() {
          currentIconName = newIconName ?? "`primary`";
        });
      }
    } on PlatformException catch (e) {
      log("Failed to change app icon");

      debugPrint(e.toString());
    }
  }

  Future<void> _setBatchNumber(String val) async {
    setState(() {
      loading = true;
    });
    int batchNumber = int.parse(val);
    try {
      await FlutterDynamicIcon.setApplicationIconBadgeNumber(batchNumber);
      batchIconNumber =
          await FlutterDynamicIcon.getApplicationIconBadgeNumber();
      log("Batch number changed successful");
    } catch (e) {
      log("Failed to change batch number");
      debugPrint(e.toString());
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              IconButton(
                icon: Icon(Icons.ac_unit),
                onPressed: () => _changeIcon("teamfortress"),
              ),
              IconButton(
                icon: Icon(Icons.ac_unit),
                onPressed: () => _changeIcon("photos"),
              ),
              IconButton(
                icon: Icon(Icons.ac_unit),
                onPressed: () => _changeIcon("chills"),
              ),
              SizedBox(
                height: 28,
              ),
              IconButton(
                icon: Icon(Icons.restore_outlined),
                onPressed: () => _changeIcon(null),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
