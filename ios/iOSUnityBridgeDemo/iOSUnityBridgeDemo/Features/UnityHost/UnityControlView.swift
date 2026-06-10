//
//  UnityControlView.swift
//  iOSUnityBridgeDemo
//
//  Created by Roberto Teixeira on 09/06/2026.
//

import SwiftUI

struct UnityControlView: View {
    @StateObject private var viewModel = UnityControlViewModel()
    
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
                
                Text(viewModel.state.title)
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
                viewModel.loadUnity()
            } label: {
                Text("Load Unity")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!viewModel.state.canLoad)
            
            Button {
                viewModel.unloadUnity()
            } label: {
                Text("Unload Unity")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(!viewModel.state.canUnload)
            
            Button {
                viewModel.sendCommand(.changeColor("blue"))
            } label: {
                Text("Change Cube Color")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(!viewModel.state.canSendCommand)
            
            Button {
                viewModel.sendCommand(.startRotation())
            } label: {
                Text("Start Rotation")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(!viewModel.state.canSendCommand)
            
            Button {
                viewModel.sendCommand(.stopRotation())
            } label: {
                Text("Stop Rotation")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(!viewModel.state.canSendCommand)
        }
    }
    
    private var eventLogView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Event Log")
                .font(.headline)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(viewModel.events) { event in
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
        switch viewModel.state {
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
