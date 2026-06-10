//
//  UnityControlsView.swift
//  iOSUnityBridgeDemo
//
//  Created by Roberto Teixeira on 10/06/2026.
//

import SwiftUI

struct UnityControlsView: View {
    let state: UnityBridgeState
    let onLoadUnity: () -> Void
    let onUnloadUnity: () -> Void
    let onChangeCubeColor: () -> Void
    let onStartRotation: () -> Void
    let onStopRotation: () -> Void
    let onRequestStatus: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Button {
                onLoadUnity()
            } label: {
                Text("Load Unity")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!state.canLoad)

            Button {
                onUnloadUnity()
            } label: {
                Text("Unload Unity")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(!state.canUnload)

            Button {
                onChangeCubeColor()
            } label: {
                Text("Change Cube Color")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(!state.canSendCommand)

            Button {
                onStartRotation()
            } label: {
                Text("Start Rotation")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(!state.canSendCommand)

            Button {
                onStopRotation()
            } label: {
                Text("Stop Rotation")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(!state.canSendCommand)

            Button {
                onRequestStatus()
            } label: {
                Text("Request Status")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(!state.canSendCommand)
        }
    }
}

#Preview {
    UnityControlsView(
        state: .loaded,
        onLoadUnity: {},
        onUnloadUnity: {},
        onChangeCubeColor: {},
        onStartRotation: {},
        onStopRotation: {},
        onRequestStatus: {}
    )
    .padding()
}
