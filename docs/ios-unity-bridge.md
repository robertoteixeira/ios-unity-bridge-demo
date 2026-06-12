# iOS Unity Bridge

This document describes the message contract between Swift and Unity.

The bridge moves JSON strings in two directions:

```text
iOS -> Unity: commands
Unity -> iOS: events
```

The bridge should stay generic. Product behavior should live in Swift view models, native services, or Unity scene controllers.

## Message Envelope

Use a small JSON object:

```json
{
  "type": "command_or_event_name",
  "payload": {
    "key": "value"
  }
}
```

Rules:

- `type` is required.
- `payload` should be present, even when empty.
- Keep payloads simple.
- Prefer strings, numbers, booleans, and small objects.
- Version the message type when changing behavior in a breaking way.

## iOS to Unity

Swift sends commands through `UnityFramework.sendMessageToGO`.

Current Swift target:

```text
GameObject: IOSBridgeReceiver
Method: ReceiveCommand
Parameter: one string
```

Flow:

```text
SwiftUI button tap
-> UnityControlViewModel
-> UnityFrameworkBridge
-> UnityFrameworkLoader
-> UnityFramework.sendMessageToGO
-> IOSBridgeReceiver.ReceiveCommand(string message)
-> Unity scene controller
```

Example command:

```json
{
  "type": "changeColor",
  "payload": {
    "color": "blue"
  }
}
```

Current demo commands:

| Command | Purpose |
| --- | --- |
| `changeColor` | Changes the demo cube color. |
| `startRotation` | Starts cube rotation. |
| `stopRotation` | Stops cube rotation. |
| `resetCube` | Resets the cube. |
| `requestStatus` | Asks Unity to report current state. |

## Unity to iOS

Unity sends events through a native iOS plugin.

Flow:

```text
Unity scene event
-> IOSBridgeSender.SendEvent(...)
-> DllImport("__Internal")
-> NativeCallProxy.mm
-> Swift callback
-> UnityEventReceiver
-> UnityControlViewModel
-> SwiftUI event log
```

Current native function:

```text
SendMessageToIOS(string message)
```

Example event:

```json
{
  "type": "statusResponse",
  "payload": {
    "currentColor": "blue"
  }
}
```

Current demo events:

| Event | Purpose |
| --- | --- |
| `statusResponse` | Unity reports scene state or command result. |
| `rotationStarted` | Cube rotation started. |
| `rotationStopped` | Cube rotation stopped. |
| `error` | Unity could not handle a command. |

## Swift Side Contract

Swift command model:

```swift
struct UnityCommand: Encodable {
    let type: UnityCommand.CommandType
    let payload: [String: String]
}
```

The current bridge encodes commands with `JSONEncoder` and sends them to Unity:

```swift
unityFramework.sendMessageToGO(
    withName: "IOSBridgeReceiver",
    functionName: "ReceiveCommand",
    message: message
)
```

When adapting the template, update command types in Swift and command handling in Unity together.

## Unity Side Contract

Unity receiver:

```csharp
public void ReceiveCommand(string message)
```

Unity sender:

```csharp
public void SendEvent(string type, string payload = "{}")
```

Unity iOS native plugin import:

```csharp
#if UNITY_IOS && !UNITY_EDITOR
[DllImport("__Internal")]
private static extern void SendMessageToIOS(string message);
#endif
```

Keep the `UNITY_IOS && !UNITY_EDITOR` guard. It allows the Unity project to keep running in the editor without trying to call an iOS-only native symbol.

## Naming Contract

These names must match exactly:

| Side | Name |
| --- | --- |
| Unity GameObject | `IOSBridgeReceiver` |
| Unity method | `ReceiveCommand` |
| Native plugin function | `SendMessageToIOS` |
| Swift receiver function | Function called by `NativeCallProxy.mm` |

If a message does not arrive, check names first.

## Lifecycle Contract

The native side should only send commands when Unity is loaded.

Important states:

- Not loaded.
- Loading.
- Loaded.
- Unloading.
- Failed.

Unload is asynchronous. Do not assume `unloadApplication()` means Unity is already gone. Wait for `unityDidUnload`.

## Adding a New Command

1. Add a command type in Swift.
2. Add a button, native action, or service event that creates the command.
3. Encode the command payload.
4. Add a matching case in `IOSBridgeReceiver.cs`.
5. Route the command to a Unity scene controller.
6. Send a success, status, or error event back to iOS.
7. Add the command to this document.

## Adding a New Event

1. Add the event trigger in Unity.
2. Call `IOSBridgeSender.SendEvent(...)`.
3. Handle or display the event in Swift.
4. Add the event to this document.

## Message Design Guidelines

- Prefer one generic bridge method over many native methods.
- Keep messages easy to log.
- Avoid sending large binary payloads through this bridge.
- Avoid using bridge messages as a high-frequency game loop channel.
- Keep command names stable once external users depend on them.
- Add an event for errors instead of silently ignoring invalid commands.

## When Not to Use This Bridge

Do not use this JSON bridge for:

- Streaming large files.
- Per-frame input.
- High-frequency telemetry.
- Texture or video transfer.
- Native SDK calls that Unity does not need to know about.

For those, design a dedicated native integration.
