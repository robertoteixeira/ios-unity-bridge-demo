//
//  UnityFrameworkLoader.swift
//  iOSUnityBridgeDemo
//
//  Created by Roberto Teixeira on 11/06/2026.
//

import Foundation
import UIKit
import MachO

@MainActor
final class UnityFrameworkLoader: NSObject, UnityFrameworkListener {
    static let shared = UnityFrameworkLoader()
    
    private var unityFramework: UnityFramework?
    private var didRegisterFrameworkListener = false
    private var isUnloading = false
    private var unloadContinuations: [CheckedContinuation<Void, Never>] = []
    
    private override init() {
        super.init()
    }
    
    var isLoaded: Bool {
        unityFramework != nil
    }
    
    func loadUnityFramework() throws -> UnityFramework {
        if let unityFramework {
            return unityFramework
        }
        
        guard let bundlePath = Bundle.main.path(
            forResource: "Frameworks/UnityFramework",
            ofType: "framework"
        ) else {
            throw UnityFrameworkLoaderError.frameworkBundleNotFound
        }
        
        guard let bundle = Bundle(path: bundlePath) else {
            throw UnityFrameworkLoaderError.invalidFrameworkBundle
        }
        
        if !bundle.isLoaded {
            try bundle.loadAndReturnError()
        }
        
        guard let frameworkClass = bundle.principalClass as? UnityFramework.Type else {
            throw UnityFrameworkLoaderError.principalClassNotFound
        }
        
        let framework = frameworkClass.getInstance()
        
        guard let framework else {
            throw UnityFrameworkLoaderError.instanceNotFound
        }
        
        unityFramework = framework
        registerFrameworkListenerIfNeeded(on: framework)
        return framework
    }
    
    func runEmbeddedUnity() throws {
        guard !isUnloading else {
            throw UnityFrameworkLoaderError.unloadInProgress
        }

        let framework = try loadUnityFramework()
        framework.setExecuteHeader(machHeader)
        framework.runEmbedded(
            withArgc: CommandLine.argc,
            argv: CommandLine.unsafeArgv,
            appLaunchOpts: nil
        )
    }
   
    func unloadUnity() async {
        guard let unityFramework else {
            return
        }

        if isUnloading {
            await waitForUnload()
            return
        }

        isUnloading = true

        await withCheckedContinuation { continuation in
            unloadContinuations.append(continuation)
            unityFramework.pause(true)
            unityFramework.unloadApplication()
            hideUnityWindow(from: unityFramework)
        }
    }

    nonisolated func unityDidUnload(_ notification: Notification) {
        Task { @MainActor in
            self.handleUnityDidUnload()
        }
    }

    private func handleUnityDidUnload() {
        guard isUnloading else {
            return
        }

        if let unityFramework {
            hideUnityWindow(from: unityFramework)
        }

        isUnloading = false
        unityFramework = nil
        resumeUnloadContinuations()
    }

    private func waitForUnload() async {
        await withCheckedContinuation { continuation in
            unloadContinuations.append(continuation)
        }
    }

    private func hideUnityWindow(from unityFramework: UnityFramework) {
        guard let unityWindow = unityFramework.appController()?.window else {
            return
        }

        unityWindow.isHidden = true
    }

    private func registerFrameworkListenerIfNeeded(on unityFramework: UnityFramework) {
        guard !didRegisterFrameworkListener else {
            return
        }

        unityFramework.register(self)
        didRegisterFrameworkListener = true
    }

    private func resumeUnloadContinuations() {
        let continuations = unloadContinuations
        unloadContinuations.removeAll()

        continuations.forEach { continuation in
            continuation.resume()
        }
    }
}

private let machHeader: UnsafePointer<MachHeader> = {
    UnsafeRawPointer(_dyld_get_image_header(0))
        .assumingMemoryBound(to: MachHeader.self)
}()

enum UnityFrameworkLoaderError: LocalizedError {
    case frameworkBundleNotFound
    case invalidFrameworkBundle
    case principalClassNotFound
    case instanceNotFound
    case unloadInProgress
    
    var errorDescription: String? {
        switch self {
        case .frameworkBundleNotFound:
            return "UnityFramework bundle was not found inside the app."
        case .invalidFrameworkBundle:
            return "UnityFramework bundle could not be created."
        case .principalClassNotFound:
            return "UnityFramework principal class was not found."
        case .instanceNotFound:
            return "UnityFramework instance could not be created."
        case .unloadInProgress:
            return "Unity is still unloading. Please try again in a moment."
        }
    }
}
