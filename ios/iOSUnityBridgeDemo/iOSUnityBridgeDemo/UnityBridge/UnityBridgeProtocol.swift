//
//  UnityBridgeProtocol.swift
//  iOSUnityBridgeDemo
//
//  Created by Roberto Teixeira on 10/06/2026.
//

import Foundation

@MainActor
protocol UnityBridgeProtocol: ObservableObject {
    var state: UnityBridgeState { get }
    var events: [UnityEvent] { get }

    func loadUnity()
    func unloadUnity()
    func sendCommand(_ command: UnityCommand)
}
