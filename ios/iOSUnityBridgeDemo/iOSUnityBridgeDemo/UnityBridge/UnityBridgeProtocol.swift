//
//  UnityBridgeProtocol.swift
//  iOSUnityBridgeDemo
//
//  Created by Roberto Teixeira on 10/06/2026.
//

import Foundation

protocol UnityBridgeProtocol {
    func loadUnity() async throws
    func unloadUnity() async throws
    func sendCommand(_ command: UnityCommand) async throws
}
