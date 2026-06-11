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
    private let jsonEncoder = JSONEncoder()
    
    init(loader: UnityFrameworkLoader = .shared) {
        self.loader = loader
    }
    
    func loadUnity() async throws {
        try loader.runEmbeddedUnity()
    }
    
    func unloadUnity() async throws {
        await loader.unloadUnity()
    }
    
    func sendCommand(_ command: UnityCommand) async throws {
        let unityFramework = try loader.loadUnityFramework()
        let message = try encode(command)
        
        unityFramework.sendMessageToGO(
            withName: "IOSBridgeReceiver",
            functionName: "ReceiveCommand",
            message: message
        )
    }
    
    private func encode(_ command: UnityCommand) throws -> String {
        let data = try jsonEncoder.encode(command)
        
        guard let message = String(data: data, encoding: .utf8) else {
            throw UnityFrameworkBridgeError.invalidCommandEncoding
        }
        
        return message
    }
}

enum UnityFrameworkBridgeError: LocalizedError {
    case invalidCommandEncoding
    
    var errorDescription: String? {
        switch self {
        case .invalidCommandEncoding:
            return "Could not encode Unity command."
        }
    }
    
}
