package io.github.tastelessjolt.flutterdynamicicon;

import android.content.ComponentName;
import android.content.Context;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;

import io.flutter.Log;

public class IconChanger {

    public static ActivityInfo getCurrentEnabledIcon(Context context) {
        PackageManager pm = context.getPackageManager();

        try {
            PackageInfo info = pm.getPackageInfo(context.getPackageName(), PackageManager.GET_ACTIVITIES | PackageManager.GET_DISABLED_COMPONENTS);
            for(ActivityInfo activityInfo: info.activities) {
                Log.d("flutter_dynamic_icon", String.format("%s: %s", activityInfo.name, activityInfo.enabled ? "enabled" : "disabled"));
                if(activityInfo.enabled) {
                    return activityInfo;
                }
            }
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
            return null;
        }
        return null;
    }

    private static ComponentName getComponentName(Context context, String activityName) {
        String packageName = context.getPackageName();
        String componentName = String.format("%s.%s", packageName, activityName);

        ComponentName component = new ComponentName(packageName, componentName);
        return component;
    }

    public static void enableIcon(Context context, String activityName) {
        PackageManager pm = context.getPackageManager();
        ComponentName component = getComponentName(context, activityName);

        pm.setComponentEnabledSetting(component, PackageManager.COMPONENT_ENABLED_STATE_ENABLED, PackageManager.DONT_KILL_APP);
    }

}
