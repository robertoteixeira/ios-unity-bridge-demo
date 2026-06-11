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

    private let notificationName = Notification.Name("UnityMessageReceivedNotification")
    private let messageKey = "message"

    private var eventHandler: ((String) -> Void)?

    private init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUnityNotification(_:)),
            name: notificationName,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func setEventHandler(_ handler: @escaping (String) -> Void) {
        eventHandler = handler
    }

    @objc private func handleUnityNotification(_ notification: Notification) {
        guard let message = notification.userInfo?[messageKey] as? String else {
            return
        }

        eventHandler?(message)
    }
}
