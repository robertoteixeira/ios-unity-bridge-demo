//
//  UnityNativeCallback.swift
//  iOSUnityBridgeDemo
//
//  Created by Roberto Teixeira on 11/06/2026.
//

import Foundation

@objc final class UnityNativeCallback: NSObject {
    @objc static func receiveMessageFromUnity(_ message: String) {
        Task { @MainActor in
            UnityEventReceiver.shared.receiveMessageFromUnity(message)
        }
    }
}
