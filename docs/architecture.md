# Architecture

This project uses a hybrid architecture:

```text
Native iOS = app shell, platform services, lifecycle, navigation
Unity      = scene, rendering, simulation, immersive interaction
Bridge     = message routing between iOS and Unity
```

The goal is to keep the boundary boring and explicit. The native app should not know how the Unity scene works internally, and Unity should not own native app navigation or platform services.

## High-Level Flow

```text
SwiftUI app starts
-> user taps Load Unity
-> Swift loads UnityFramework
-> Unity shows its own UIWindow
-> native overlay UIWindow shows floating controls
-> iOS sends commands to Unity
-> Unity sends events back to iOS
-> user taps close
-> iOS asks Unity to unload
-> Unity reports unityDidUnload
-> iOS restores the native host window
```

## Native iOS Responsibilities

The native app owns:

- App lifecycle.
- SwiftUI screens.
- Native navigation.
- Native controls over Unity.
- Loading and unloading Unity.
- Platform integrations.
- Command encoding.
- Event receiving.
- Event logging.

Future production features should usually start on the native side when they involve:

- Authentication.
- Push notifications.
- Deep links.
- Analytics.
- Networking and API clients.
- Native purchases.
- Native settings.
- Device permissions.

## Unity Responsibilities

Unity owns:

- Scene rendering.
- Camera, lighting, input, and animation.
- Scene state.
- GameObject behavior.
- Command handling after a message reaches Unity.
- Events that originate from the Unity scene.

Unity should not directly own:

- Native navigation.
- Authentication.
- Push notifications.
- Native analytics SDK setup.
- App-wide networking.

## Bridge Responsibilities

The bridge owns only communication:

- Load and unload `UnityFramework`.
- Send string messages to Unity.
- Receive string messages from Unity.
- Encode and decode small message envelopes.
- Forward messages to the correct layer.

The bridge should not contain business logic or scene logic. If it starts making product decisions, it is doing too much.

## Important iOS Files

```text
iOSUnityBridgeDemoApp.swift
  Chooses UnityFrameworkBridge when UNITY_ENABLED is set.
  Chooses MockUnityBridge otherwise.

UnityControlViewModel.swift
  Coordinates loading, unloading, commands, and event log state.

UnityFrameworkBridge.swift
  Implements UnityBridgeProtocol using the real UnityFramework loader.

UnityFrameworkLoader.swift
  Loads UnityFramework, starts Unity, unloads Unity, and listens for unityDidUnload.

UnityOverlayWindowManager.swift
  Manages the floating controls window and restores the native host UIWindow.

UnityEventReceiver.swift
  Receives messages from the Objective-C++ plugin and forwards them to Swift.
```

## Important Unity Files

```text
IOSBridgeReceiver.cs
  Receives JSON commands from iOS.

IOSBridgeSender.cs
  Sends JSON events from Unity to iOS.

NativeCallProxy.mm
  Native plugin that passes Unity messages into Swift.

CubeController.cs
  Demo scene behavior. Replace this with your own scene logic.
```

## Window Model

Unity embedded in iOS uses its own `UIWindow`.

This repo manages three window concerns:

1. The native app window.
2. Unity's window.
3. The floating native controls overlay window.

Before Unity opens, the app captures the native host window. When Unity closes, the app restores that host window with `makeKeyAndVisible()`.

The floating controls also use their own alert-level window. It is made key and visible so it can reliably receive taps even after Unity has taken window focus.

## Unity Lifecycle Model

The first Unity load is a cold start:

- `UnityFramework` is loaded.
- Unity runtime initializes.
- Graphics and scripting systems start.
- The scene is loaded.
- Unity creates and shows its window.

Later loads are warm reloads:

- The Unity framework remains in the process.
- Unity reloads from scene-less state.
- Startup is much faster.

Close uses `unloadApplication()`, not `quitApplication(...)`.

That matters:

- `unloadApplication()` partially unloads Unity and supports later reloads.
- `quitApplication(...)` is a stronger app-level quit path and is usually not what an embedded template wants.

## Async Unload

Unity unload is not instant.

The native side calls:

```swift
unityFramework.unloadApplication()
```

Unity later reports:

```swift
unityDidUnload(...)
```

The Swift loader uses continuations to turn that callback into an `async` unload operation. This keeps app state honest: the SwiftUI view model does not mark Unity as unloaded until Unity actually confirms unload.

## Target Separation

The project intentionally separates the native preview target from the Unity-enabled target.

`iOSUnityBridgeDemoPreview`:

- Does not import the Unity bridging header.
- Does not compile `UnityFrameworkBridge.swift`.
- Does not compile `UnityFrameworkLoader.swift`.
- Uses `MockUnityBridge`.

`iOSUnityBridgeDemoUnity`:

- Sets `UNITY_ENABLED`.
- Imports the Unity bridging header.
- Compiles the real Unity bridge.
- Links and embeds `UnityFramework.framework`.

This separation keeps native SwiftUI iteration fast and avoids requiring a Unity export for every native UI build.

## Design Rules

- Keep the bridge small.
- Use JSON message envelopes with explicit `type` values.
- Keep GameObject names and method names stable.
- Let iOS own platform services.
- Let Unity own scene behavior.
- Wait for Unity lifecycle callbacks instead of guessing.
- Build native UI against the mock target whenever possible.
