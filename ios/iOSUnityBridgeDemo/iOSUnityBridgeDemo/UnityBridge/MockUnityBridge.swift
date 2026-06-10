//
//  MockUnityBridge.swift
//  iOSUnityBridgeDemo
//
//  Created by Roberto Teixeira on 10/06/2026.
//

import Foundation

@MainActor
final class MockUnityBridge: UnityBridgeProtocol {
    @Published private(set) var state: UnityBridgeState = .notLoaded
    @Published private(set) var events: [UnityEvent] = [
        UnityEvent(type: .nativeShellStarted)
    ]

    func loadUnity() {
        guard state.canLoad else { return }

        addEvent(.unityLoadRequested)
        state = .loading

        Task {
            try? await Task.sleep(for: .milliseconds(500))
            state = .loaded
            addEvent(.unityLoaded)
        }
    }

    func unloadUnity() {
        guard state.canUnload else { return }

        addEvent(.unityUnloadRequested)
        state = .unloading

        Task {
            try? await Task.sleep(for: .milliseconds(300))
            state = .notLoaded
            addEvent(.unityUnloaded)
        }
    }

    func sendCommand(_ command: UnityCommand) {
        guard state.canSendCommand else {
            addEvent(
                .error,
                payload: ["message": "Cannot send command while Unity is not loaded"]
            )
            return
        }

        addEvent(
            .commandSent,
            payload: ["command": command.type.rawValue]
        )

        simulateUnityResponse(for: command)
    }

    private func simulateUnityResponse(for command: UnityCommand) {
        switch command.type {
        case .changeColor:
            addEvent(
                .statusResponse,
                payload: ["currentColor": command.payload["color"] ?? "unknown"]
            )

        case .startRotation:
            addEvent(
                .rotationStarted,
                payload: ["speed": command.payload["speed"] ?? "1.0"]
            )

        case .stopRotation:
            addEvent(.rotationStopped)

        case .resetCube:
            addEvent(
                .statusResponse,
                payload: ["cube": "reset"]
            )

        case .requestStatus:
            addEvent(
                .statusResponse,
                payload: [
                    "isLoaded": "\(state.isLoaded)",
                    "source": "mock"
                ]
            )
        }
    }

    private func addEvent(
        _ type: UnityEvent.EventType,
        payload: [String: String] = [:]
    ) {
        events.insert(
            UnityEvent(type: type, payload: payload),
            at: 0
        )
    }
}
