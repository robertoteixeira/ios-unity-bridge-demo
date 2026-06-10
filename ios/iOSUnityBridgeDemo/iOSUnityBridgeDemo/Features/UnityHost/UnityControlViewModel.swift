//
//  UnityControlViewModel.swift
//  iOSUnityBridgeDemo
//
//  Created by Roberto Teixeira on 10/06/2026.
//

import Foundation

@MainActor
final class UnityControlViewModel: ObservableObject {
    @Published private(set) var state: UnityBridgeState = .notLoaded
    @Published private(set) var events: [UnityEvent] = []

    private let bridge: any UnityBridgeProtocol

    init(bridge: any UnityBridgeProtocol = MockUnityBridge()) {
        self.bridge = bridge
        events = [UnityEvent(type: .nativeShellStarted)]
    }

    func loadUnity() {
        Task {
            do {
                addEvent(.unityLoadRequested)
                state = .loading

                try await bridge.loadUnity()

                state = .loaded
                addEvent(.unityLoaded)
            } catch {
                state = .failed(error.localizedDescription)
                addEvent(.error, payload: ["message": error.localizedDescription])
            }
        }
    }

    func unloadUnity() {
        Task {
            do {
                addEvent(.unityUnloadRequested)
                state = .unloading

                try await bridge.unloadUnity()

                state = .notLoaded
                addEvent(.unityUnloaded)
            } catch {
                state = .failed(error.localizedDescription)
                addEvent(.error, payload: ["message": error.localizedDescription])
            }
        }
    }

    func sendCommand(_ command: UnityCommand) {
        Task {
            do {
                try await bridge.sendCommand(command)

                addEvent(
                    .commandSent,
                    payload: ["command": command.type.rawValue]
                )
            } catch {
                addEvent(.error, payload: ["message": error.localizedDescription])
            }
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
