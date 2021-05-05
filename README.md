# flutter_dynamic_icon

A flutter plugin for dynamically changing app icon and app icon batch number in the mobile platform. Supports both iOS (with version > `10.3`) and Android.

## Note
On Android you can't change the batch number, but you can change the name and icon of your app.
On iOS you can't change the app name, but you can change the icon and batch number.

_This are platform limitations_

## Usage

To use this plugin, add `flutter_dynamic_icon` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

## Getting Started

Check out the `example` directory for a sample app using `flutter_dynamic_icon`.

### iOS Integration

#### Index
* `2x` - `120px x 120px`  
* `3x` - `180px x 180px`

To integrate your plugin into the iOS part of your app, follow these steps

1. First let us put a few images for app icons, they are 
    * `teamfortress@2x.png`, `teamfortress@3x.png` 
    * `photos@2x.png`, `photos@3x.png`, 
    * `chills@2x.png`, `chills@3x.png`,
2. These icons shouldn't be kept in `Assets.xcassets` folder, but outside. Here is my directory structure:

![directory_structure](https://raw.githubusercontent.com/tastelessjolt/flutter_dynamic_icon/master/imgs/directory_structure.png)

3. Next, we need to setup the `Info.plist`
    1. Add `Icon files (iOS 5)` to the Information Property List
    2. Add `CFBundleAlternateIcons` as a dictionary, it is used for alternative icons
    3. Set 3 dictionaries under `CFBundleAlternateIcons`, they are correspond to `teamfortress`, `photos`, and `chills`
    4. For each dictionary, two properties — `UIPrerenderedIcon` and `CFBundleIconFiles` need to be configured


Note that if you need it work for iPads, You need to add these icon declarations in `CFBundleIcons~ipad` as well. [See here](https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html#//apple_ref/doc/uid/TP40009249-SW14) for more details.

Here is my `Info.plist` after adding Alternate Icons
#### Screenshot

![info.plist](https://raw.githubusercontent.com/tastelessjolt/flutter_dynamic_icon/master/imgs/info-plist.png)

#### Raw
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>en</string>
	<key>CFBundleExecutable</key>
	<string>$(EXECUTABLE_NAME)</string>
	<key>CFBundleIcons</key>
	<dict>
		<key>CFBundleAlternateIcons</key>
		<dict>
			<key>chills</key>
			<dict>
				<key>CFBundleIconFiles</key>
				<array>
					<string>chills</string>
				</array>
				<key>UIPrerenderedIcon</key>
				<false/>
			</dict>
			<key>photos</key>
			<dict>
				<key>CFBundleIconFiles</key>
				<array>
					<string>photos</string>
				</array>
				<key>UIPrerenderedIcon</key>
				<false/>
			</dict>
			<key>teamfortress</key>
			<dict>
				<key>CFBundleIconFiles</key>
				<array>
					<string>teamfortress</string>
				</array>
				<key>UIPrerenderedIcon</key>
				<false/>
			</dict>
		</dict>
		<key>CFBundlePrimaryIcon</key>
		<dict>
			<key>CFBundleIconFiles</key>
			<array>
				<string>chills</string>
			</array>
			<key>UIPrerenderedIcon</key>
			<false/>
		</dict>
	</dict>
	<key>CFBundleIdentifier</key>
	<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>flutter_dynamic_icon_example</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>$(FLUTTER_BUILD_NAME)</string>
	<key>CFBundleSignature</key>
	<string>????</string>
	<key>CFBundleVersion</key>
	<string>$(FLUTTER_BUILD_NUMBER)</string>
	<key>LSRequiresIPhoneOS</key>
	<true/>
	<key>UILaunchStoryboardName</key>
	<string>LaunchScreen</string>
	<key>UIMainStoryboardFile</key>
	<string>Main</string>
	<key>UISupportedInterfaceOrientations</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationLandscapeLeft</string>
		<string>UIInterfaceOrientationLandscapeRight</string>
	</array>
	<key>UISupportedInterfaceOrientations~ipad</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationPortraitUpsideDown</string>
		<string>UIInterfaceOrientationLandscapeLeft</string>
		<string>UIInterfaceOrientationLandscapeRight</string>
	</array>
	<key>UIViewControllerBasedStatusBarAppearance</key>
	<false/>
</dict>
</plist>

```

Now, you can call `FlutterDynamicIcon.setAlternateIconName` with the `CFBundleAlternateIcons` key as the argument to set that icon.

### Android integration
Place your alternative icons images in the `android/app/src/main/res/mipmap-*dpi/` directories.
Next open your AndroidManifest.xml (placed in `android/src/main/AndroidManifest.xml`) and edit as follows:
```xml
<manifest ...>

    <!-- [...] permissions -->

    <application
        android:label="Your default app name"
        android:icon="@mipmap/ic_launcher">
		<!-- The `android:name` must be "MainActivity" here -->
        <activity
            android:name=".MainActivity"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection|fontScale|screenLayout|density"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        
        <!-- Alternative icons configuration -->
        <!-- 
			The `activity-alias` are your alternative icons configuration.
			The `android:name` param is the name that will pass at FlutterDynamicIcon.setAlternateIconName.
			The `android:icon` is the icon that will show in the launcher. The name must be equal as the one in `android/app/src/main/res/mipmap-*dpi/*.png`
			The `android:label` is the app name that will show in the launcher.
			The `android:enabled` must be setted as false, otherwise you will have multiple icons for the same app.
			The `android:targetActivity` must be setted as "MainActivity"
			If you have other intent-filter (for example sharing intent), you will have to paste the same value for all your alternative icons (and the default one)
		-->
        <activity-alias
            android:name=".chills"
            android:icon="@mipmap/chills"
            android:label="Chills"
            android:enabled="false"
            android:targetActivity=".MainActivity">
            
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity-alias>

        <activity-alias
            android:name=".photos"
            android:icon="@mipmap/photos"
            android:label="Photos"
            android:enabled="false"
            android:targetActivity=".MainActivity">
            
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity-alias>

        <activity-alias
            android:name=".teamfortress"
            android:icon="@mipmap/teamfortress"
            android:label="Teamfortress"
            android:enabled="false"
            android:targetActivity=".MainActivity">
            
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity-alias>

        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
</manifest>

```

### Dart/Flutter Integration

From your Dart code, you need to import the plugin and use it's static methods:

```dart 
import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';

try {
  if (await FlutterDynamicIcon.supportsAlternateIcons) {
    await FlutterDynamicIcon.setAlternateIconName("photos");
    print("App icon change successful");
    return;
  }
} on PlatformException {} catch (e) {}
print("Failed to change app icon");

...

// set batch number (only on iOS)
try {
	await FlutterDynamicIcon.setApplicationIconBadgeNumber(9399);
} on PlatformException {} catch (e) {}

// gets currently set batch number
int batchNumber = FlutterDynamicIcon.getApplicationIconBadgeNumber();

```

Check out the `example` app for more details

## Screenrecord

## Showing App Icon change
### iOS
![Screenrecording of the example](https://raw.githubusercontent.com/tastelessjolt/flutter_dynamic_icon/master/imgs/screen.gif)
### Android
![Screenrecording of the example](https://raw.githubusercontent.com/tastelessjolt/flutter_dynamic_icon/master/imgs/icon-android.gif)

## Showing Batch number on app icon change in SpringBoard
![Screenrecording of the example](https://raw.githubusercontent.com/tastelessjolt/flutter_dynamic_icon/master/imgs/batch.gif)

## Reference 

This was made possible because this blog. I borrowed a lot of words from this blog.
https://medium.com/ios-os-x-development/dynamically-change-the-app-icon-7d4bece820d2