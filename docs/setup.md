# Setup

This guide gets the template running with the real Unity runtime embedded in the native iOS app.

## Requirements

- macOS
- Xcode with iOS SDK
- Unity Editor with iOS Build Support
- CocoaPods is not required for this sample
- Apple Developer account or local signing setup
- Physical iOS device recommended

UnityFramework embedding is easiest to validate on device. Simulator support depends on the Unity version, exported architectures, and project settings.

## Project Paths

```text
Native iOS app:
ios/iOSUnityBridgeDemo

Unity project:
unity/UnityBridgeDemo

Unity iOS export:
build/unity-ios-export

UnityFramework build products:
build/unity-derived-data/Build/Products/
```

## Target Model

The Xcode project has two app targets:

| Target | Purpose | Unity dependency |
| --- | --- | --- |
| `iOSUnityBridgeDemoPreview` | Fast native SwiftUI development | No real Unity framework |
| `iOSUnityBridgeDemoUnity` | Real Unity integration | Links and embeds `UnityFramework.framework` |

Use `iOSUnityBridgeDemoPreview` while building native screens. Use `iOSUnityBridgeDemoUnity` when testing the bridge, lifecycle, or Unity scene.

## 1. Open Unity

Open:

```text
unity/UnityBridgeDemo
```

Confirm the scene has:

- A GameObject named `IOSBridgeReceiver`.
- An `IOSBridgeReceiver` component with `ReceiveCommand(string message)`.
- An `IOSBridgeSender` component for Unity-to-iOS events.
- The iOS native plugin at `Assets/Plugins/iOS/NativeCallProxy.mm`.

## 2. Export Unity for iOS

In Unity:

1. Open Build Settings.
2. Select iOS.
3. Switch Platform if needed.
4. Add the demo scene to Scenes In Build.
5. Export the iOS project to:

```text
build/unity-ios-export
```

The helper script at `scripts/export-unity-ios.sh` is currently a placeholder for a future batch-mode export. For now, use Unity's editor export flow.

## 3. Build UnityFramework

Build the exported Unity framework:

```sh
xcodebuild \
  -project build/unity-ios-export/Unity-iPhone.xcodeproj \
  -scheme UnityFramework \
  -configuration Debug \
  -destination generic/platform=iOS \
  -derivedDataPath build/unity-derived-data \
  CODE_SIGNING_ALLOWED=NO \
  build
```

This creates the framework where the native Unity target expects it:

```text
build/unity-derived-data/Build/Products/Debug-iphoneos/UnityFramework.framework
```

## 4. Open the Native iOS Project

Open:

```text
ios/iOSUnityBridgeDemo/iOSUnityBridgeDemo.xcodeproj
```

Select the `iOSUnityBridgeDemoUnity` scheme when you want the real Unity runtime.

## 5. Configure Signing

In Xcode, configure signing for `iOSUnityBridgeDemoUnity`:

- Set your Team.
- Use a unique bundle identifier.
- Use a physical device destination.

For command-line build checks, signing can be disabled:

```sh
xcodebuild \
  -project ios/iOSUnityBridgeDemo/iOSUnityBridgeDemo.xcodeproj \
  -scheme iOSUnityBridgeDemoUnity \
  -configuration Debug \
  -destination generic/platform=iOS \
  -derivedDataPath build/xcode-derived-unity \
  CODE_SIGNING_ALLOWED=NO \
  build
```

## 6. Run the App

Run `iOSUnityBridgeDemoUnity` on a device.

Expected flow:

1. The native SwiftUI app opens.
2. Tap Load Unity.
3. Unity appears.
4. Use the floating controls to send commands.
5. Tap close in the floating controls.
6. Unity unloads and the app returns to iOS.
7. Loading Unity again should be much faster than the first load.

## Preview-Only Native Build

Use this target when you do not want Unity involved:

```sh
xcodebuild \
  -project ios/iOSUnityBridgeDemo/iOSUnityBridgeDemo.xcodeproj \
  -scheme iOSUnityBridgeDemoPreview \
  -configuration Debug \
  -destination generic/platform=iOS \
  -derivedDataPath build/xcode-derived-preview \
  CODE_SIGNING_ALLOWED=NO \
  build
```

This target excludes the real Unity bridge files and uses `MockUnityBridge`.

## Adapting This Template

When adapting the repo for a new project:

1. Replace the Unity scene and scripts with your own experience.
2. Keep the bridge GameObject and method names stable, or update the Swift constants that send messages.
3. Replace demo commands with your own command types.
4. Replace demo events with your own event types.
5. Keep the native shell responsible for navigation, auth, networking, analytics, and platform UI.
6. Keep Unity responsible for the scene, rendering, simulation, and immersive interaction.

## Generated Files

Do not treat `build/` as source of truth. It is a local generated folder.

The durable source code lives in:

- `ios/`
- `unity/`
- `docs/`
- `scripts/`
