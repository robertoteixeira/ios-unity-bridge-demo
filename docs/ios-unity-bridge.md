# iOS Unity Bridge

This document describes how the native iOS app and Unity communicate with each other.

The bridge exists to keep both sides independent:

- iOS owns platform services, navigation, lifecycle, APIs, and native UI.
- Unity owns the 3D scene, rendering, and immersive interaction.
- The bridge only routes messages between both sides.

## Communication Overview

There are two communication directions:

1. iOS sends commands to Unity.
2. Unity sends events back to iOS.

## iOS to Unity

The native iOS app sends commands to Unity through UnityFramework.

A Swift button or native event creates a command, encodes it as a string, and sends it to a known Unity GameObject.

Flow:

    SwiftUI button tap
    -> UnityBridge
    -> UnityFramework sendMessageToGO
    -> IOSBridgeReceiver GameObject
    -> ReceiveCommand method in C#
    -> Unity scene updates

Example commands:

    changeColor
    startRotation
    stopRotation
    resetCube
    requestStatus

Example message format:

    {
      "type": "changeColor",
      "payload": {
        "color": "red"
      }
    }

The Unity side should expose a receiver object with a stable name, for example:

    IOSBridgeReceiver

And a public method that accepts one string parameter:

    ReceiveCommand(string message)

Important rule:

    The GameObject name and C# method name must match exactly what iOS sends.

## Unity to iOS

Unity sends events back to iOS through a native iOS plugin.

A Unity script detects an event, serializes it as a string, and calls a native function exposed by the iOS side.

Flow:

    Unity event
    -> C# bridge sender
    -> DllImport("__Internal")
    -> Objective-C++ native function
    -> Swift callback/event handler
    -> SwiftUI event log updates

Example events:

    unityLoaded
    cubeTapped
    rotationStarted
    rotationStopped
    statusResponse

Example message format:

    {
      "type": "cubeTapped",
      "payload": {
        "objectName": "DemoCube"
      }
    }

## Swift Bridge Responsibilities

The Swift bridge should:

- Load UnityFramework.
- Keep a reference to the UnityFramework instance.
- Send commands to Unity.
- Receive Unity events.
- Decode Unity event messages.
- Publish events to the SwiftUI layer.
- Handle basic lifecycle operations such as pause, resume, and unload.

The Swift bridge should not:

- Contain Unity scene logic.
- Contain business logic.
- Know implementation details about cube behavior.
- Directly manipulate Unity objects.

## Unity Bridge Responsibilities

The Unity bridge should:

- Receive command strings from iOS.
- Decode command messages.
- Route commands to Unity scene controllers.
- Send events back to iOS.
- Keep Unity scene behavior separated from native communication.

The Unity bridge should not:

- Know about SwiftUI screens.
- Handle native app navigation.
- Own authentication, analytics, push notifications, or platform services.

## Message Design

Messages should be simple and explicit.

Recommended structure:

    {
      "type": "command_or_event_name",
      "payload": {
        "key": "value"
      }
    }

Why use a message object?

- Easier to extend.
- Easier to debug.
- Easier to log.
- Avoids creating many different native methods.
- Keeps the bridge generic.

## Example iOS to Unity Commands

Change cube color:

    {
      "type": "changeColor",
      "payload": {
        "color": "blue"
      }
    }

Start cube rotation:

    {
      "type": "startRotation",
      "payload": {
        "speed": "1.0"
      }
    }

Stop cube rotation:

    {
      "type": "stopRotation",
      "payload": {}
    }

Reset cube:

    {
      "type": "resetCube",
      "payload": {}
    }

Request Unity status:

    {
      "type": "requestStatus",
      "payload": {}
    }

## Example Unity to iOS Events

Unity loaded:

    {
      "type": "unityLoaded",
      "payload": {
        "scene": "MainScene"
      }
    }

Cube tapped:

    {
      "type": "cubeTapped",
      "payload": {
        "objectName": "DemoCube"
      }
    }

Rotation started:

    {
      "type": "rotationStarted",
      "payload": {
        "speed": "1.0"
      }
    }

Rotation stopped:

    {
      "type": "rotationStopped",
      "payload": {}
    }

Status response:

    {
      "type": "statusResponse",
      "payload": {
        "isRotating": "true",
        "currentColor": "blue"
      }
    }

## Lifecycle Notes

Unity has its own lifecycle, and the native app must respect it.

Important cases to handle:

- App enters foreground.
- App enters background.
- Unity is loaded for the first time.
- Unity is already loaded.
- Unity is paused.
- Unity is resumed.
- Unity is unloaded.
- Native view is dismissed while Unity is still active.

The native app should avoid initializing Unity multiple times.

## Debugging Tips

If iOS commands do not reach Unity, check:

- Unity is loaded.
- The target GameObject exists in the active scene.
- The GameObject name matches exactly.
- The C# method name matches exactly.
- The C# method is public.
- The C# method accepts a single string parameter.

If Unity events do not reach iOS, check:

- The native plugin file is inside Assets/Plugins/iOS.
- The C# function uses DllImport("__Internal").
- The native function name matches the imported C# function.
- The app is running on a real device build.
- The native callback is correctly routed back to Swift.

## Design Rule

Keep the bridge boring.

The bridge should be stable, small, and predictable.

It should only move messages between iOS and Unity. The real behavior should live in the correct layer:

    iOS = platform and native app behavior
    Unity = 3D scene behavior
    Bridge = communication only
