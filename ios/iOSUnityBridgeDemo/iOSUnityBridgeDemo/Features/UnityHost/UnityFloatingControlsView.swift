//
//  UnityFloatingControlsView.swift
//  iOSUnityBridgeDemo
//
//  Created by Roberto Teixeira on 11/06/2026.
//

import SwiftUI

struct UnityFloatingControlsView: View {
    let onSendCommand: (UnityCommand) -> Void
    let onClose: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 10) {
                HStack {
                    Text("Native Controls")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button {
                        onClose()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                    }
                }
                
                HStack(spacing: 8) {
                    Button("Blue") {
                        onSendCommand(.changeColor("blue"))
                    }
                    
                    Button("Red") {
                        onSendCommand(.changeColor("red"))
                    }
                    
                    Button("Rotate") {
                        onSendCommand(.startRotation())
                    }
                    
                    Button("Stop") {
                        onSendCommand(.stopRotation())
                    }
                }
                .buttonStyle(.borderedProminent)
                
                HStack(spacing: 8) {
                    Button("Reset") {
                        onSendCommand(.resetCube())
                    }
                    
                    Button("Status") {
                        onSendCommand(.requestStatus())
                    }
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .padding()
        }
        .allowsHitTesting(true)
    }
}

#Preview {
    UnityFloatingControlsView(
        onSendCommand: { _ in },
        onClose: {}
    )
}
