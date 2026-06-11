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
    @Published private(set) var events: [UnityEvent] = [
        UnityEvent(type: .nativeShellStarted)
    ]

    private let bridge: any UnityBridgeProtocol

    init(bridge: any UnityBridgeProtocol) {
        self.bridge = bridge
        
        UnityEventReceiver.shared.setEventHandler { [weak self] message in
            self?.handleUnityMessage(message)
        }
    }
    
    convenience init(useMockBridge: Bool = false) {
        if useMockBridge {
            self.init(bridge: MockUnityBridge())
        } else {
#if UNITY_ENABLED
            self.init(bridge: UnityFrameworkBridge())
#else
            self.init(bridge: MockUnityBridge())
#endif
        }
    }

    func loadUnity() {
        Task {
            do {
                addEvent(.unityLoadRequested)
                state = .loading
                UnityOverlayWindowManager.shared.captureHostWindow()

                try await bridge.loadUnity()

                state = .loaded
                addEvent(.unityLoaded)
                
                UnityOverlayWindowManager.shared.show(
                    onSendCommand: { [weak self] command in
                        self?.sendCommand(command)
                    },
                    onClose: { [weak self] in
                        self?.unloadUnity()
                    }
                )
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
                
                UnityOverlayWindowManager.shared.hide()

                try await bridge.unloadUnity()
                UnityOverlayWindowManager.shared.restoreHostWindow()

                state = .notLoaded
                addEvent(.unityUnloaded)
            } catch {
                UnityOverlayWindowManager.shared.restoreHostWindow()
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
    
    private func handleUnityMessage(_ message: String) {
        print("[UnityControlViewModel] Received Unity message: \(message)")
        
        addEvent(
            .statusResponse,
            payload: ["message": message]
        )
    }
}
