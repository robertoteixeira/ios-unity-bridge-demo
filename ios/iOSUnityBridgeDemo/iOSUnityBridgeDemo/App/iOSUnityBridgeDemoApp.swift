//
//  iOSUnityBridgeDemoApp.swift
//  iOSUnityBridgeDemo
//
//  Created by Roberto Teixeira on 09/06/2026.
//

import SwiftUI

@main
struct iOSUnityBridgeDemoApp: App {
    var body: some Scene {
        WindowGroup {
#if UNITY_ENABLED
            UnityControlView(
                viewModel: UnityControlViewModel(
                    bridge: UnityFrameworkBridge()
                )
            )
#else
            UnityControlView(
                viewModel: UnityControlViewModel(
                    bridge: MockUnityBridge()
                )
            )
#endif
        }
    }
}
