//
//  MockUnityBridge.swift
//  iOSUnityBridgeDemo
//
//  Created by Roberto Teixeira on 10/06/2026.
//

import Foundation

struct MockUnityBridge: UnityBridgeProtocol {
    func loadUnity() async throws {
        try await Task.sleep(for: .milliseconds(500))
    }

    func unloadUnity() async throws {
        try await Task.sleep(for: .milliseconds(300))
    }

    func sendCommand(_ command: UnityCommand) async throws {
        try await Task.sleep(for: .milliseconds(150))
    }
}
