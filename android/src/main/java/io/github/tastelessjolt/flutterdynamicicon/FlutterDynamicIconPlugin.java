package io.github.tastelessjolt.flutterdynamicicon;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterDynamicIconPlugin */
public class FlutterDynamicIconPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_dynamic_icon");
    channel.setMethodCallHandler(new FlutterDynamicIconPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("mSupportsAlternateIcons")) {
      result.success(false);
    } else if (call.method.equals("mGetAlternateIconName")) {
      result.error("Not supported", "Not supported on Android", null);
    } else if (call.method.equals("mSetAlternateIconName")) {
      result.error("Not supported", "Not supported on Android", null);
    } else if (call.method.equals("mGetApplicationIconBadgeNumber")) {
      result.error("Not supported", "Not supported on Android", null);
    } else if (call.method.equals("mSetApplicationIconBadgeNumber")) {
      result.error("Not supported", "Not supported on Android", null);
    } else {
      result.notImplemented();
    }
  }
}
