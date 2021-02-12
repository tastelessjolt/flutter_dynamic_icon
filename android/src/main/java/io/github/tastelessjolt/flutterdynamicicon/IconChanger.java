package io.github.tastelessjolt.flutterdynamicicon;

import android.content.ComponentName;
import android.content.Context;
import android.content.pm.ActivityInfo;
import android.content.pm.ComponentInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import io.flutter.Log;

public class IconChanger {

    static private String TAG = "flutterdynamicicon";

    public static ActivityInfo getCurrentEnabledIcon(Context context) {
        PackageManager pm = context.getPackageManager();

        try {
            PackageInfo info = pm.getPackageInfo(context.getPackageName(), PackageManager.GET_ACTIVITIES | PackageManager.GET_DISABLED_COMPONENTS);
            ActivityInfo enabled = null;
            for(ActivityInfo activityInfo: info.activities) {
                boolean isEnabled = isComponentEnabled(pm, context.getPackageName(), activityInfo.name);
                Log.d(TAG, String.format("%s: %s", activityInfo.name, isEnabled ? "enabled" : "disabled"));
                if(isEnabled) {
                    enabled = activityInfo;
                }
            }
            return enabled;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
            return null;
        }
    }

    private static boolean isComponentEnabled(PackageManager pm, String pkgName, String clsName) {
        ComponentName componentName = new ComponentName(pkgName, clsName);
        int componentEnabledSetting = pm.getComponentEnabledSetting(componentName);

        switch (componentEnabledSetting) {
            case PackageManager.COMPONENT_ENABLED_STATE_DISABLED:
                return false;
            case PackageManager.COMPONENT_ENABLED_STATE_ENABLED:
                return true;
            case PackageManager.COMPONENT_ENABLED_STATE_DEFAULT:
            default:
                // We need to get the application info to get the component's default state
                try {
                    PackageInfo packageInfo = pm.getPackageInfo(pkgName, PackageManager.GET_ACTIVITIES
                            | PackageManager.GET_RECEIVERS
                            | PackageManager.GET_SERVICES
                            | PackageManager.GET_PROVIDERS
                            | PackageManager.GET_DISABLED_COMPONENTS);

                    List<ComponentInfo> components = new ArrayList<>();
                    if (packageInfo.activities != null) Collections.addAll(components, packageInfo.activities);

                    for (ComponentInfo componentInfo : components) {
                        if (componentInfo.name.equals(clsName)) {
                            return componentInfo.isEnabled();
                        }
                    }

                    // the component is not declared in the AndroidManifest
                    return false;
                } catch (PackageManager.NameNotFoundException e) {
                    // the package isn't installed on the device
                    return false;
                }
        }
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

    public static void disableIcon(Context context, String activityName) {
        PackageManager pm = context.getPackageManager();
        ComponentName component = getComponentName(context, activityName);

        pm.setComponentEnabledSetting(component, PackageManager.COMPONENT_ENABLED_STATE_DISABLED, PackageManager.DONT_KILL_APP);
    }

}
