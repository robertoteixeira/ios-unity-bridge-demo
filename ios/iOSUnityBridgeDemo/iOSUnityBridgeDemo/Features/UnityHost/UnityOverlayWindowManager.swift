//
//  UnityOverlayWindowManager.swift
//  iOSUnityBridgeDemo
//
//  Created by Roberto Teixeira on 11/06/2026.
//

import SwiftUI
import UIKit

@MainActor
final class UnityOverlayWindowManager {
    static let shared = UnityOverlayWindowManager()
    
    private var overlayWindow: UIWindow?
    
    private init() {}
    
    func show(
        onSendCommand: @escaping (UnityCommand) -> Void,
        onClose: @escaping () -> Void
    ) {
        guard overlayWindow == nil else {
            return
        }
        
        guard let windScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive })
        else {
            return
        }
        
        let overlayView = UnityFloatingControlsView(
            onSendCommand: onSendCommand,
            onClose: onClose
        )
            
        let hostingController = UIHostingController(rootView: overlayView)
        hostingController.view.backgroundColor = Color.clear
        
        let window = UIWindow(windowScene: windScene)
        window.rootViewController = hostingController
        window.windowLevel = .alert + 1
        window.backgroundColor = .clear
        window.isHidden = false
        
        overlayWindow = window
    }
    
    func hide() {
        overlayWindow?.isHidden = true
        overlayWindow = nil
    }
}
