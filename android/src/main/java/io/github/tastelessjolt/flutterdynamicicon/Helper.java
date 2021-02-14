package io.github.tastelessjolt.flutterdynamicicon;

import android.content.ComponentName;
import android.content.Context;
import android.content.pm.ComponentInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Helper {

    public static boolean isComponentEnabled(PackageManager pm, String pkgName, String clsName) {
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

    public static ComponentName getComponentName(Context context, String activityName) {
        String packageName = context.getPackageName();
        String componentName = String.format("%s.%s", packageName, activityName);

        ComponentName component = new ComponentName(packageName, componentName);
        return component;
    }

    public static String getIconNameFromActivity(String activity) {
        String[] arr = activity.split("\\.");
        return arr[arr.length-1];
    }

}
