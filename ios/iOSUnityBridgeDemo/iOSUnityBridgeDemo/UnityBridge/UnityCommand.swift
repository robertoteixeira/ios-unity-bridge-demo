//
//  UnityCommand.swift
//  iOSUnityBridgeDemo
//
//  Created by Roberto Teixeira on 10/06/2026.
//

import Foundation

struct UnityCommand: Codable, Equatable {
    let type: CommandType
    let payload: [String: String]
    
    enum CommandType: String, Codable {
        case changeColor
        case startRotation
        case stopRotation
        case resetCube
        case requestStatus
    }
}

extension UnityCommand {
    static func changeColor(_ color: String) -> UnityCommand {
        UnityCommand(type: .changeColor, payload: ["color": color])
    }
    
    static func startRotation(speed: String = "1.0") -> UnityCommand {
        UnityCommand(type: .startRotation, payload: ["speed": speed])
    }
    
    static func stopRotation() -> UnityCommand {
        UnityCommand(type: .stopRotation, payload: [:])
    }
    
    static func resetCube() -> UnityCommand {
        UnityCommand(type: .resetCube, payload: [:])
    }
    
    static func requestStatus() -> UnityCommand {
        UnityCommand(type: .requestStatus, payload: [:])
    }
}
