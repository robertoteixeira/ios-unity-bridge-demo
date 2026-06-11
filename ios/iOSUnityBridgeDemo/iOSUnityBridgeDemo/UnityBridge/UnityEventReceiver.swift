//
//  UnityEventReceiver.swift
//  iOSUnityBridgeDemo
//
//  Created by Roberto Teixeira on 11/06/2026.
//

import Foundation

@MainActor
final class UnityEventReceiver {
    static let shared = UnityEventReceiver()
    
    private var eventHandler: ((String) -> Void)?
    
    private init() {}
    
    func setEventHandler(_ handler: @escaping (String) -> Void) {
        eventHandler = handler
    }
    
    func receiveMessageFromUnity(_ message: String) {
        eventHandler?(message)
    }
}
