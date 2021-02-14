package io.github.tastelessjolt.flutterdynamicicon;

import android.content.ComponentName;
import android.content.Context;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;

import io.flutter.Log;

public class IconChanger {

    static private String TAG = "flutterdynamicicon";

    public static ActivityInfo getCurrentEnabledIcon(Context context) {
        PackageManager pm = context.getPackageManager();

        try {
            PackageInfo info = pm.getPackageInfo(context.getPackageName(), PackageManager.GET_ACTIVITIES | PackageManager.GET_DISABLED_COMPONENTS);
            ActivityInfo enabled = null;
            for(ActivityInfo activityInfo: info.activities) {
                // An hard coded way to get only the app activities, only way I found :(
                if(activityInfo.name.contains(context.getPackageName())) {
                    boolean isEnabled = Helper.isComponentEnabled(pm, context.getPackageName(), activityInfo.name);
                    if(isEnabled) enabled = activityInfo;
                }
            }
            return enabled;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static void enableIcon(Context context, String activityName) {
        PackageManager pm = context.getPackageManager();
        ComponentName component = Helper.getComponentName(context, activityName);
        ActivityInfo currentlyEnabledIcon = getCurrentEnabledIcon(context);

        if(currentlyEnabledIcon.name.equals(component.getClassName())) return;
        Log.d(TAG,String.format("Changing enabled activity-alias from %s to %s", currentlyEnabledIcon.name, component.getClassName()));

        ComponentName toDisable = new ComponentName(context.getPackageName(), currentlyEnabledIcon.name);

        pm.setComponentEnabledSetting(component, PackageManager.COMPONENT_ENABLED_STATE_ENABLED, PackageManager.DONT_KILL_APP);
        pm.setComponentEnabledSetting(toDisable, PackageManager.COMPONENT_ENABLED_STATE_DISABLED, PackageManager.DONT_KILL_APP);
    }

}
