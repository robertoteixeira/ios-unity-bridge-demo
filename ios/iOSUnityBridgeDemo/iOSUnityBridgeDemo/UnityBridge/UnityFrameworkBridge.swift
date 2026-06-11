//
//  UnityFrameworkBridge.swift
//  iOSUnityBridgeDemo
//
//  Created by Roberto Teixeira on 11/06/2026.
//

import Foundation

@MainActor
final class UnityFrameworkBridge: UnityBridgeProtocol {
    private let loader: UnityFrameworkLoader
    
    init(loader: UnityFrameworkLoader = .shared) {
        self.loader = loader
    }
    
    func loadUnity() async throws {
        try loader.runEmbeddedUnity()
    }
    
    func unloadUnity() async throws {
        loader.unloadUnity()
    }
    
    func sendCommand(_ command: UnityCommand) async throws {
        // Real iOS -> Unity messagin will be implemented after Unity is running.
    }
}
