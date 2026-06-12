# Troubleshooting

Use this guide when the iOS app, Unity export, or bridge does not behave as expected.

## UnityFramework Not Found

Symptoms:

- Native Unity target fails to build.
- Xcode cannot find `UnityFramework.framework`.
- Linker errors mention `UnityFramework`.

Check:

- Unity was exported to `build/unity-ios-export`.
- `UnityFramework` was built from the exported Unity project.
- The framework exists at:

```text
build/unity-derived-data/Build/Products/Debug-iphoneos/UnityFramework.framework
```

Build it again:

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

## Build Fails Because of Signing

For local command-line validation, use:

```text
CODE_SIGNING_ALLOWED=NO
```

For device runs in Xcode:

- Set a valid Team.
- Use a unique bundle identifier.
- Make sure the device is trusted.
- Make sure the target is `iOSUnityBridgeDemoUnity`.

## Preview Target Accidentally Requires Unity

Symptoms:

- `iOSUnityBridgeDemoPreview` fails because it cannot find Unity headers.
- Native SwiftUI iteration requires a Unity export.

Check:

- `UnityFrameworkBridge.swift` is excluded from the preview target.
- `UnityFrameworkLoader.swift` is excluded from the preview target.
- The preview target does not set the Unity bridging header.
- The app falls back to `MockUnityBridge` when `UNITY_ENABLED` is not set.

## Unity Does Not Load

Check:

- You are running `iOSUnityBridgeDemoUnity`, not `iOSUnityBridgeDemoPreview`.
- `UnityFramework.framework` is linked and embedded.
- The Unity export was built for iOS device architecture.
- The Unity scene is included in Build Settings.
- The app is running on a physical device if simulator support is not configured.
- `UNITY_ENABLED` is set for the Unity target.

## First Load Is Slow

This is expected.

The first Unity load is a cold start:

- The framework loads.
- Unity runtime initializes.
- Graphics and scripting systems start.
- The scene loads.

Later loads are faster because Unity remains warm in the process and reloads from scene-less state.

## Close Returns to iOS But Reload Is Weird

Symptoms:

- Unity returns with old scene state.
- Floating controls stop responding.
- Native state says unloaded before Unity is really done.

Check:

- Reload goes through `runEmbedded(...)`, not only `showUnityWindow()`.
- Unload waits for `unityDidUnload`.
- The native host `UIWindow` is restored after unload.
- The floating controls window uses `makeKeyAndVisible()`.

This repo already follows that pattern in `UnityFrameworkLoader` and `UnityOverlayWindowManager`.

## iOS Commands Do Not Reach Unity

Check:

- Unity is loaded.
- The active scene contains a GameObject named `IOSBridgeReceiver`.
- The GameObject has the `IOSBridgeReceiver` component.
- The method is named `ReceiveCommand`.
- The method is public.
- The method accepts exactly one `string` parameter.
- The command JSON has a non-empty `type`.

Names are case-sensitive.

## Unity Events Do Not Reach iOS

Check:

- `NativeCallProxy.mm` exists under `Assets/Plugins/iOS`.
- C# uses `DllImport("__Internal")`.
- The native function name matches exactly.
- The app is running as an iOS build, not only inside the Unity editor.
- The Swift callback is registered before Unity sends events.

## Commands Work in One Direction Only

If iOS-to-Unity works but Unity-to-iOS does not, focus on:

- `IOSBridgeSender.cs`
- `NativeCallProxy.mm`
- `UnityEventReceiver.swift`

If Unity-to-iOS works but iOS-to-Unity does not, focus on:

- `UnityFrameworkBridge.swift`
- GameObject name.
- C# method name.
- Scene setup.

## Unity Scene Consumes Memory After Close

Embedded Unity does not behave like a separate process.

`unloadApplication()` partially unloads Unity so it can be loaded again later. It should unload the active scene state, but the Unity framework and some engine runtime memory can remain resident in the app process. This is why later loads are much faster.

If your production app needs a stronger shutdown, investigate Unity's `quitApplication(...)` path carefully. It is more disruptive and usually not ideal for an embedded experience that should reopen.

## Xcode Cannot Use the Simulator

Some command-line logs may mention CoreSimulator services even when building for `generic/platform=iOS`. That does not always mean the build failed.

Look for the final result:

```text
** BUILD SUCCEEDED **
```

or:

```text
** BUILD FAILED **
```

For real runtime validation, prefer a physical device.

## Clean Build Artifacts

To remove generated build outputs:

```sh
./scripts/clean.sh
```

Then re-export Unity and rebuild `UnityFramework`.

## Debugging Checklist

- Build Unity export first.
- Build `UnityFramework`.
- Build `iOSUnityBridgeDemoUnity`.
- Run on device.
- Load Unity.
- Send a simple command.
- Confirm Unity logs received JSON.
- Send a simple event from Unity.
- Confirm SwiftUI event log updates.
- Close Unity.
- Wait for iOS to return.
- Load Unity again.
