//
//  UnityControlView.swift
//  iOSUnityBridgeDemo
//
//  Created by Roberto Teixeira on 09/06/2026.
//

import SwiftUI

struct UnityControlView: View {
    @State private var isUnityLoaded = false
    @State private var eventLogs: [String] = [
        "Native iOS shell started"
    ]
    
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
                    .foregroundStyle(isUnityLoaded ? .green : .red)
                
                Text(isUnityLoaded ? "Loaded" : "Not Loaded")
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
                isUnityLoaded = true
                addLog("Load Unity requested")
            } label: {
                Text("Load Unity")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(isUnityLoaded)
            
            Button {
                isUnityLoaded = false
                addLog("Unload Unity requested")
            } label: {
                Text("Unload Unity")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(!isUnityLoaded)
            
            Button {
                isUnityLoaded = false
                addLog("Command sent: change cube color")
            } label: {
                Text("Change Cube Color")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(!isUnityLoaded)
            
            Button {
                isUnityLoaded = false
                addLog("Command sent: start cube rotation")
            } label: {
                Text("Start Rotation")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(!isUnityLoaded)
            
            Button {
                isUnityLoaded = false
                addLog("Command sent: stop cube color")
            } label: {
                Text("Stop Rotation")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(!isUnityLoaded)
        }
    }
    
    private var eventLogView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Event Log")
                .font(.headline)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(eventLogs.indices, id: \.self) { index in
                        Text(eventLogs[index])
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
    
    private func addLog(_ message: String) {
        let timestamp = Date.now.formatted(date: .omitted, time: .standard)
        eventLogs.insert("[\(timestamp)] \(message)", at: 0)
    }
}

#Preview {
    UnityControlView()
}
