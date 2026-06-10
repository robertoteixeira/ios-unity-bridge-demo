//
//  UnityBridgeState.swift
//  iOSUnityBridgeDemo
//
//  Created by Roberto Teixeira on 10/06/2026.
//

import Foundation

enum UnityBridgeState: Equatable {
    case notLoaded
    case loading
    case loaded
    case unloading
    case failed(String)

    var title: String {
        switch self {
        case .notLoaded:
            return "Not Loaded"
        case .loading:
            return "Loading"
        case .loaded:
            return "Loaded"
        case .unloading:
            return "Unloading"
        case .failed(let error):
            return "Failed: \(error)"
        }
    }

    var isLoaded: Bool {
        self == .loaded
    }

    var canLoad: Bool {
        switch self {
        case .notLoaded, .failed:
            return true
        case .loading, .loaded, .unloading:
            return false
        }
    }

    var canUnload: Bool {
        self == .loaded
    }

    var canSendCommand: Bool {
        self == .loaded
    }
}
