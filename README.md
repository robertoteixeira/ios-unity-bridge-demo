# iOS Unity Bridge Demo

A template project for embedding a Unity iOS export inside a native SwiftUI app.

Use this repo when you want iOS to own the app shell, navigation, platform services, and native UI, while Unity owns a 3D, AR, game, or immersive scene.

## What This Template Shows

- Load Unity from a native SwiftUI screen.
- Close Unity and return to iOS cleanly.
- Send JSON commands from Swift to Unity.
- Send JSON events from Unity back to Swift.
- Keep Unity code, iOS code, and bridge code separated.
- Build a mock-only iOS target for fast native iteration.
- Build a Unity-enabled iOS target that embeds `UnityFramework`.

## Repository Layout

```text
ios/
  iOSUnityBridgeDemo/       Native SwiftUI app and Xcode project.
unity/
  UnityBridgeDemo/          Unity project used by the sample.
docs/
  setup.md                  How to build and run the template.
  architecture.md           Project boundaries and lifecycle model.
  ios-unity-bridge.md       Message bridge contract.
  troubleshooting.md        Common integration problems.
scripts/
  *.sh                      Helper scripts and placeholders.
build/
  Generated locally. Not source of truth.
```

## Xcode Targets

This repo uses two app targets:

- `iOSUnityBridgeDemoPreview`: native SwiftUI app with `MockUnityBridge`. Use this for fast UI work without Unity.
- `iOSUnityBridgeDemoUnity`: native SwiftUI app with `UnityFrameworkBridge`. Use this when testing the real Unity integration.

The Unity target is compiled with `UNITY_ENABLED` and links `UnityFramework.framework` from:

```text
build/unity-derived-data/Build/Products/$(CONFIGURATION)$(EFFECTIVE_PLATFORM_NAME)/
```

## Quick Start

1. Open the Unity project at `unity/UnityBridgeDemo`.
2. Export it for iOS into `build/unity-ios-export`.
3. Build the exported Unity `UnityFramework` target.
4. Open `ios/iOSUnityBridgeDemo/iOSUnityBridgeDemo.xcodeproj`.
5. Run `iOSUnityBridgeDemoUnity` on a physical iOS device.

For exact commands and project settings, see [docs/setup.md](docs/setup.md).

## Bridge Contract

iOS sends commands to this Unity GameObject and method:

```text
GameObject: IOSBridgeReceiver
Method: ReceiveCommand(string message)
```

Unity sends events back to iOS through the native plugin function:

```text
SendMessageToIOS(string message)
```

Messages are JSON objects with a `type` and `payload`.

```json
{
  "type": "changeColor",
  "payload": {
    "color": "blue"
  }
}
```

## Current Sample

The demo scene contains a cube that can:

- Change color.
- Start rotation.
- Stop rotation.
- Reset state.
- Report status back to iOS.

The point is not the cube itself. The point is the reusable bridge pattern around it.

## Documentation Path

Read these in order when adapting the repo:

1. [Setup](docs/setup.md)
2. [Architecture](docs/architecture.md)
3. [iOS Unity Bridge](docs/ios-unity-bridge.md)
4. [Troubleshooting](docs/troubleshooting.md)

## Notes

Unity cold start is slower than later loads. The first launch initializes the framework and engine runtime. Later loads reuse Unity's warmed framework state and reload from Unity's scene-less state, so they are much faster.

Generated folders such as `build/` are local artifacts. Treat the Unity project and the iOS project as the source of truth.
