//
//  UnityFrameworkLoader.swift
//  iOSUnityBridgeDemo
//
//  Created by Roberto Teixeira on 11/06/2026.
//

import Foundation

@MainActor
final class UnityFrameworkLoader {
    static let shared = UnityFrameworkLoader()
    
    private var unityFramework: UnityFramework?
    
    private init() {}
    
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
        return framework
    }
    
    enum UnityFrameworkLoaderError: LocalizedError {
        case frameworkBundleNotFound
        case invalidFrameworkBundle
        case principalClassNotFound
        case instanceNotFound
        
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
            }
        }
    }
}
