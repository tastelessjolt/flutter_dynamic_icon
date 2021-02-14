import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class FlutterDynamicIcon {
  /// The [MethodChannel] used by this plugin
  static const MethodChannel _channel =
      const MethodChannel('flutter_dynamic_icon');

  /// Indicates whether the current platform supports dynamic app icons
  static Future<bool> get supportsAlternateIcons async {
    final bool supportsAltIcons =
        await _channel.invokeMethod('mSupportsAlternateIcons');
    return supportsAltIcons;
  }

  /// Fetches the current iconName
  ///
  /// Returns `null` if the current icon is the default icon
  static Future<String> getAlternateIconName() async {
    final String altIconName =
        await _channel.invokeMethod('mGetAlternateIconName');
    return altIconName;
  }

  /// Sets [iconName] as the current icon for the app.
  /// Pass `null` to set the default icon. 
  ///
  /// Throws a [PlatformException] with description if
  /// it can't find [iconName] or there's any other error
  static Future setAlternateIconName(String iconName) async {
    await _channel.invokeMethod(
      'mSetAlternateIconName',
      <String, Object>{'iconName': iconName},
    );
  }

  /// Fetches the icon batch number
  /// On Android there is no batch number, so the method will return 0
  ///
  /// The default value of this property is `0` (to show no batch)
  static Future<int> getApplicationIconBadgeNumber() async {
    if(!Platform.isIOS) return 0; // This functionality is avaible only on iOS
    final int batchIconNumber =
        await _channel.invokeMethod('mGetApplicationIconBadgeNumber');
    return batchIconNumber;
  }

  /// Sets [batchIconNumber] as the batch number for the current icon for the app
  ///
  /// Set to 0 (zero) to hide the badge number.
  ///
  /// Throws a [PlatformException] in case an error
  static Future setApplicationIconBadgeNumber(int batchIconNumber) async {
    if(!Platform.isIOS) return; // This functionality is avaible only on iOS
    await _channel.invokeMethod('mSetApplicationIconBadgeNumber',
        <String, Object>{'batchIconNumber': batchIconNumber});
  }
}
