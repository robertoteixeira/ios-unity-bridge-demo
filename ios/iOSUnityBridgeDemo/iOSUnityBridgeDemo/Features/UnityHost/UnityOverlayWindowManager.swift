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
    private weak var hostWindow: UIWindow?
    
    private init() {}

    func captureHostWindow() {
        guard hostWindow == nil else {
            return
        }

        hostWindow = activeWindowScene?
            .windows
            .first { window in
                window.isKeyWindow && window !== overlayWindow
            }
    }
    
    func show(
        onSendCommand: @escaping (UnityCommand) -> Void,
        onClose: @escaping () -> Void
    ) {
        guard overlayWindow == nil else {
            return
        }
        
        guard let windScene = activeWindowScene else {
            return
        }
        
        let overlayView = UnityFloatingControlsView(
            onSendCommand: onSendCommand,
            onClose: onClose
        )
            
        let hostingController = UIHostingController(rootView: overlayView)
        hostingController.view.backgroundColor = .clear
        
        let window = UIWindow(windowScene: windScene)
        window.rootViewController = hostingController
        window.windowLevel = .alert + 1
        window.backgroundColor = .clear
        window.makeKeyAndVisible()
        
        overlayWindow = window
    }
    
    func hide() {
        overlayWindow?.isHidden = true
        overlayWindow = nil
    }

    func restoreHostWindow() {
        hostWindow?.isHidden = false
        hostWindow?.makeKeyAndVisible()
        hostWindow = nil
    }

    private var activeWindowScene: UIWindowScene? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
    }
}
