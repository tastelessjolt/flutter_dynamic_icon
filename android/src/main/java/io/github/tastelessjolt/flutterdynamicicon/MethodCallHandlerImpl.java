package io.github.tastelessjolt.flutterdynamicicon;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

class MethodCallHandlerImpl implements MethodChannel.MethodCallHandler {

  @Override
  public void onMethodCall(MethodCall call, MethodChannel.Result result) {
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