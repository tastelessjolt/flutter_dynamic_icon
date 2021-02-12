package io.github.tastelessjolt.flutterdynamicicon;

import android.content.Context;
import android.content.pm.ActivityInfo;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

class MethodCallHandlerImpl implements MethodChannel.MethodCallHandler {

  Context context;

  public MethodCallHandlerImpl(Context c) {
    context = c;
  }

  @Override
  public void onMethodCall(MethodCall call, MethodChannel.Result result) {
    if (call.method.equals("mSupportsAlternateIcons")) {
      result.success(true);
    } else if (call.method.equals("mGetAlternateIconName")) {
      ActivityInfo activityInfo = IconChanger.getCurrentEnabledIcon(context);
      result.success(activityInfo.name);
    } else if (call.method.equals("mSetAlternateIconName")) {
      String iconName = call.argument("iconName");
      IconChanger.enableIcon(context, iconName);
      IconChanger.disableIcon(context, "MainActivity");
    } else if (call.method.equals("mGetApplicationIconBadgeNumber")) {
      result.error("Not supported", "Not supported on Android", null);
    } else if (call.method.equals("mSetApplicationIconBadgeNumber")) {
      result.error("Not supported", "Not supported on Android", null);
    } else {
      result.notImplemented();
    }
  }
}