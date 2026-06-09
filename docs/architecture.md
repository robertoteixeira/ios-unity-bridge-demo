```md
# Architecture

This project uses a hybrid architecture:

- The native iOS app owns platform-level concerns.
- Unity owns the 3D scene and immersive experience.
- A bridge layer connects Swift and Unity.

## Native iOS Responsibilities

- App lifecycle
- Navigation
- SwiftUI screens
- Loading and unloading Unity
- Sending commands to Unity
- Receiving events from Unity
- Event logging
- Future platform integrations such as authentication, push notifications, deep links, analytics, and APIs

## Unity Responsibilities

- 3D scene rendering
- Cube behavior
- Camera and lighting
- Receiving commands from iOS
- Sending events back to iOS
- Handling Unity-side interaction

## Communication Direction

iOS to Unity:

```text
Swift button tap
→ UnityBridge
→ UnityFramework sendMessageToGO
→ C# receiver object
→ Unity scene update