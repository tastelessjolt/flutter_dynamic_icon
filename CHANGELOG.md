## 2.1.0

* Add `showAlert` option to `setAlternateIconName` to hide the icon change alert on iOS using a private API
  * Default is `true` meaning it uses the normal API by default and it is opt-in and at your own risk to use the private API
  * Thanks to @Flucadetena for the PR #17
* Update `targetSdkVersion` to 31 for android

## 2.0.0

* Update sdk dependencies to support null safety (Thanks to @nohli PR #12)

## 1.1.0

* Fix pubspec.yml (plugin was at the wrong place)

## 1.0.0

* Upgrade to AndroidX (both in plugin and example)
* Upgrade to Flutter SDK 1.22.4
* Upgrade to the new Android Platform Plugin V2
* Fix passing `null` to `setAlternateIconName` to revert to the original icon (Fixes #2) 

## 0.2.0

* Can change batch number on app icon 

## 0.1.0

* Update description and changelog

## 0.0.1

* AppIcon changing working on iOS
