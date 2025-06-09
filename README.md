# rn-pusher-beams-sdk

- pusher beams sdk for react native works with new archtiecture.


![img](https://i.ibb.co/mFtCrfzw/Frame-1597883861.png)

## [You can check this example repository by clicking this link](https://github.com/Akifcan/rn-pusher-beams-sdk-example)
**Note (for example app)**: On android enable permissions manually on app settings page.

## If you counter any issues you can contact me at [https://akifcan.dev](akifcan.dev)

## Installation

```sh
npm install rn-pusher-beams-sdk 
or
yarn add rn-pusher-beams-sdk 
```

## Pusher Beams Setup

- Ensure that the setup steps on the Pusher dashboard are completed before proceeding.


## Android Setup
- Add google-services.json to your project **android/app** directory.
(You can follow this link for more information: [click](https://pusher.com/docs/beams/getting-started/android/sdk-integration/#add-firebase-config-file-to-your-project)
- Go to **android/app/build.gradle** then add these import in dependenices
```
dependencies {
    ...other deps
    implementation("com.google.firebase:firebase-messaging:23.1.2")
    implementation("com.pusher:push-notifications-android:1.9.0")
    implementation ("com.google.firebase:firebase-iid:21.1.0")
```

- Add this line end of the **android/app/build.gradle** `apply plugin: 'com.google.gms.google-services'`

- Go to **android/build.gradle** then add this import in dependenices.

```
buildscript {
    ...
    dependencies {
        ...other deps
        classpath("com.google.gms:google-services:4.3.8")
    }
}
```
- Go to **AndroidManifest.xml** file and add this permission.
```
    <manifest xmlns:android="http://schemas.android.com/apk/res/android">
        ...other permissions
        <uses-permission android:name="android.permission.INTERNET" />
        <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```
then add this service block:
```
    <manifest xmlns:android="http://schemas.android.com/apk/res/android">
        ...other permissions
        <uses-permission android:name="android.permission.INTERNET" />
        <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
        <application>
            <activity>...</activity>
            <service
                android:name=".NotificationsMessagingService"
                android:exported="true">
                    <intent-filter>
                        <action android:name="com.google.firebase.MESSAGING_EVENT"/>
                    </intent-filter>
            </service> 
        </application>
```
- Go to **android/app/src/main/java/your-package-name** (there should be) **MainActivity** and **MainApplication**
- - Create a file called **NotificationsMessagingService.java** and paste these blocks inside.
```
    package com.projectdemo;

    import android.util.Log;
    import com.google.firebase.messaging.RemoteMessage;
    import com.pusher.pushnotifications.fcm.MessagingService;

    public class NotificationsMessagingService extends MessagingService {
        @Override
        public void onMessageReceived(RemoteMessage remoteMessage) {
            Log.i("NotificationsService", "Got a remote message 🎉");
        }
    }
```

## IOS Setup
- go to -> **cd ios** then run **pod install**

- Enable capabilities: add push notification capability and background modes capability after back to this documentation.
[click for more info](https://pusher.com/docs/beams/getting-started/ios/sdk-integration/#enable-capabilities)

- go to **AppDelegate.swift** then import these imports first.

```
import PushNotifications
import RnPusherBeamsSdk
```

```
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  var reactNativeDelegate: ReactNativeDelegate?
  var reactNativeFactory: RCTReactNativeFactory?
  
  let beamsClient = PushNotifications.shared // -> add this line
  
  func application(
    ...
```

- Replace your application block:

```
 func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    let delegate = ReactNativeDelegate()
    let factory = RCTReactNativeFactory(delegate: delegate)
    delegate.dependencyProvider = RCTAppDependencyProvider()
    
    if let remoteNotification = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
      var modifiedNotification = remoteNotification
      modifiedNotification["backgroundMode"] = true
      NativeEventEmitter.send("message", body: modifiedNotification)
    }
    
    reactNativeDelegate = delegate
    reactNativeFactory = factory

    window = UIWindow(frame: UIScreen.main.bounds)

    factory.startReactNative(
      withModuleName: "ProjectDemo",
      in: window,
      launchOptions: launchOptions
    )

    return true
  }
```

- Add these blocks:

```
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    self.beamsClient.registerDeviceToken(deviceToken)
}

func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    NativeEventEmitter.emitter?.sendEvent(withName: "message", body: [userInfo])
}
```

- Example **Appdelegate.swift**

```
import UIKit
import React
import React_RCTAppDelegate
import ReactAppDependencyProvider
import PushNotifications
import RnPusherBeamsSdk

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  var reactNativeDelegate: ReactNativeDelegate?
  var reactNativeFactory: RCTReactNativeFactory?
  
  let beamsClient = PushNotifications.shared

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    let delegate = ReactNativeDelegate()
    let factory = RCTReactNativeFactory(delegate: delegate)
    delegate.dependencyProvider = RCTAppDependencyProvider()
    
    if let remoteNotification = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
      var modifiedNotification = remoteNotification
      modifiedNotification["backgroundMode"] = true
      NativeEventEmitter.send("message", body: modifiedNotification)
    }
    
    reactNativeDelegate = delegate
    reactNativeFactory = factory

    window = UIWindow(frame: UIScreen.main.bounds)

    factory.startReactNative(
      withModuleName: "ProjectDemo",
      in: window,
      launchOptions: launchOptions
    )

    return true
  }
  
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    self.beamsClient.registerDeviceToken(deviceToken)
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    NativeEventEmitter.emitter?.sendEvent(withName: "message", body: [userInfo])
  }

  
}

class ReactNativeDelegate: RCTDefaultReactNativeFactoryDelegate {
  override func sourceURL(for bridge: RCTBridge) -> URL? {
    self.bundleURL()
  }

  override func bundleURL() -> URL? {
#if DEBUG
    RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")
#else
    Bundle.main.url(forResource: "main", withExtension: "jsbundle")
#endif
  }
}
```

## Usage

```js
import {pusherBeams} from 'rn-pusher-beams-sdk';
```

### Register device

```js
pusherBeams.registerForRemoteNotifications()
```

**Important**: This function must be called before invoking any other Pusher-related functions.

---

### Start pusher

```js
pusherBeams.start('YOUR_PUSHER_KEY')
```

**IOS Behaviour**: When you call the `.start` function on ios you'll will be prompted by notification permission from ios.

**Android Behaviour**: You need to request notification permission manually. Example:  

```js
import {requestNotifications} from 'react-native-permissions';
const result = await requestNotifications(['alert', 'badge', 'sound']);
console.log(result)

// Then start the pusher if permission granted.
```

---

### Interests

```js
pusherBeams.addDeviceInterests('hello');
pusherBeams.addDeviceInterests('demo1');
pusherBeams.addDeviceInterests('demo2');
```
--- 
### Get Interests

```js
pusherBeams.getInterests()
```
---
### Clear Interests
```js
pusherBeams.clearDeviceInterests())
```
### Clear All State
**Note:** Call this function when you logout user.
```js
pusherBeams.clearAllState()
```
### Stop Notifications
```js
pusherBeams.stop()
```
### Set User Id
```js
    const AUTH_URL = ''
    const BEARER_TOKEN = ''
    pusherBeams.setUserId('userid03', AUTH_URL, BEARER_TOKEN)
```

### Notifications Events
**Note**: Notifications events are not available on android.

```js
    if (Platform.OS === 'android') {
      return;
    }
    pusherBeams.listenNotificationLogs();

    const subscribe = pusherBeams.onNotification(value => {
      /* This line is optional. The event will be triggered even when the app is in the background. To prevent this, you can check the current app state using `AppState.currentState`. */
      if (AppState.currentState !== 'active') {
        return;
      }
      console.log(value);
      Alert.alert('message', JSON.stringify(value));
    });

    return () => {
      subscribe.remove();
    };
  }, []);

```

## Contributing

- PR are always welcomed.
- See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
