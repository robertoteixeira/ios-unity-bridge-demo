//
//  UnityEvent.swift
//  iOSUnityBridgeDemo
//
//  Created by Roberto Teixeira on 10/06/2026.
//

import Foundation

struct UnityEvent: Codable, Identifiable, Equatable {
    let id: UUID
    let type: EventType
    let payload: [String: String]
    let createdAt: Date

    init(
        id: UUID = UUID(),
        type: EventType,
        payload: [String: String] = [:],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.type = type
        self.payload = payload
        self.createdAt = createdAt
    }

    enum EventType: String, Codable {
        case nativeShellStarted
        case unityLoadRequested
        case unityLoaded
        case unityUnloadRequested
        case unityUnloaded
        case commandSent
        case cubeTapped
        case rotationStarted
        case rotationStopped
        case statusResponse
        case error
    }

    var displayMessage: String {
        switch type {
        case .nativeShellStarted:
            return "Native iOS shell started"
        case .unityLoadRequested:
            return "Load Unity requested"
        case .unityLoaded:
            return "Unity loaded"
        case .unityUnloadRequested:
            return "Unload Unity requested"
        case .unityUnloaded:
            return "Unity unloaded"
        case .commandSent:
            return "Command sent: \(payload["command"] ?? "unknown")"
        case .cubeTapped:
            return "Cube tapped"
        case .rotationStarted:
            return "Rotation started"
        case .rotationStopped:
            return "Rotation stopped"
        case .statusResponse:
            return "Status response: \(payload)"
        case .error:
            return "Error: \(payload["message"] ?? "unknown")"
        }
    }

    var formattedTime: String {
        createdAt.formatted(date: .omitted, time: .standard)
    }
}
