# Architecture

This project uses a hybrid architecture where the native iOS app owns platform-level concerns and Unity owns the 3D / immersive experience layer.

The goal is to keep a clear boundary between the native mobile shell and the Unity scene.

## High-Level Responsibilities

### Native iOS App

The native iOS app is responsible for:

- App lifecycle
- Navigation
- SwiftUI screens
- Loading Unity
- Unloading Unity
- Sending commands to Unity
- Receiving events from Unity
- Event logging
- Future platform integrations such as:
  - Authentication
  - Push notifications
  - Deep links
  - Analytics
  - REST APIs

### Unity

Unity is responsible for:

- 3D scene rendering
- Cube behavior
- Camera and lighting
- Receiving commands from iOS
- Sending events back to iOS
- Handling Unity-side interaction

## Communication Flow

### iOS to Unity

Swift sends commands to Unity through the bridge layer.

Flow:

    Swift button tap
    -> UnityBridge
    -> UnityFramework sendMessageToGO
    -> C# receiver object
    -> Unity scene update

Example:

    iOS button: Change Cube Color
    -> Swift creates command JSON
    -> UnityBridge sends message to GameObject named IOSBridgeReceiver
    -> IOSBridgeReceiver.cs receives the command
    -> CubeController.cs updates the cube material

### Unity to iOS

Unity sends events back to iOS through a native iOS plugin.

Flow:

    Unity event
    -> C# native plugin call
    -> Objective-C++ bridge
    -> Swift callback
    -> SwiftUI event log

Example:

    User taps cube in Unity
    -> CubeController.cs detects tap
    -> IOSBridgeSender.cs sends event
    -> Native iOS bridge receives event
    -> SwiftUI event log displays "Cube tapped"

## Bridge Layer

The bridge layer is responsible only for communication.

It should not contain business logic.

Its job is to:

- Encode Swift commands into messages Unity can understand
- Send messages to Unity GameObjects
- Receive Unity events
- Decode Unity events into Swift models
- Notify the SwiftUI layer

## Design Rule

Keep responsibilities separated:

    Native iOS = platform, navigation, lifecycle, services
    Unity = 3D scene, rendering, immersive interaction
    Bridge = message routing between both worlds

## Why This Architecture Matters

This mirrors a production hybrid mobile architecture where native mobile handles platform services and Unity handles immersive or game-like experiences.

This separation helps with:

- Maintainability
- Performance debugging
- Testing
- Team ownership
- Clear boundaries between native and Unity code
- Easier future integrations with APIs, analytics, push notifications, or AR features