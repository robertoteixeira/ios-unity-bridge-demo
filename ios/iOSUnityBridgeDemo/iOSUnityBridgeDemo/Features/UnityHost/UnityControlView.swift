//
//  UnityControlView.swift
//  iOSUnityBridgeDemo
//
//  Created by Roberto Teixeira on 09/06/2026.
//

import SwiftUI

struct UnityControlView: View {
    @StateObject private var bridge = MockUnityBridge()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                headerView
                statusCard
                controlsView
                eventLogView
                Spacer()
            }
            .padding()
            .navigationTitle("Unity Bridge Demo")
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("iOS + Unity")
                .font(.largeTitle)
                .bold()
            
            Text("Native SwiftUI shell controlling a future UnityFramework scene.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var statusCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Unity Status")
                .font(.headline)
            
            HStack {
                Circle()
                    .frame(width: 12, height: 12)
                    .foregroundStyle(statusColor)
                
                Text(bridge.state.title)
                    .font(.subheadline)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var controlsView: some View {
        VStack(spacing: 12) {
            Button {
                bridge.loadUnity()
            } label: {
                Text("Load Unity")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!bridge.state.canLoad)
            
            Button {
                bridge.unloadUnity()
            } label: {
                Text("Unload Unity")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(!bridge.state.canUnload)
            
            Button {
                bridge.sendCommand(.changeColor("blue"))
            } label: {
                Text("Change Cube Color")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(!bridge.state.canSendCommand)
            
            Button {
                bridge.sendCommand(.startRotation())
            } label: {
                Text("Start Rotation")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(!bridge.state.canSendCommand)
            
            Button {
                bridge.sendCommand(.stopRotation())
            } label: {
                Text("Stop Rotation")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(!bridge.state.canSendCommand)
        }
    }
    
    private var eventLogView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Event Log")
                .font(.headline)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(bridge.events) { event in
                        Text("[\(event.formattedTime)] \(event.displayMessage)")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(8)
                            .background(.background)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            .frame(maxHeight: 220)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var statusColor: Color {
        switch bridge.state {
        case .notLoaded:
            return .red
        case .loading, .unloading:
            return .orange
        case .loaded:
            return .green
        case .failed:
            return .red
        }
    }
}

#Preview {
    UnityControlView()
}
