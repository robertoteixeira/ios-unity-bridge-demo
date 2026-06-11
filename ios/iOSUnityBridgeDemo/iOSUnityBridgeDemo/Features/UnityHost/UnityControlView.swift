//
//  UnityControlView.swift
//  iOSUnityBridgeDemo
//
//  Created by Roberto Teixeira on 09/06/2026.
//

import SwiftUI

struct UnityControlView: View {
    @StateObject private var viewModel: UnityControlViewModel

    @MainActor
    init() {
        _viewModel = StateObject(wrappedValue: UnityControlViewModel())
    }

    @MainActor
    init(viewModel: UnityControlViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                headerView

                UnityStatusCard(state: viewModel.state)

                UnityControlsView(
                    state: viewModel.state,
                    onLoadUnity: {
                        viewModel.loadUnity()
                    },
                    onUnloadUnity: {
                        viewModel.unloadUnity()
                    },
                    onChangeCubeColor: {
                        viewModel.sendCommand(.changeColor("blue"))
                    },
                    onStartRotation: {
                        viewModel.sendCommand(.startRotation())
                    },
                    onStopRotation: {
                        viewModel.sendCommand(.stopRotation())
                    },
                    onRequestStatus: {
                        viewModel.sendCommand(.requestStatus())
                    }
                )

                UnityEventLogView(events: viewModel.events)

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
}

struct UnityControlView_Previews: PreviewProvider {
    static var previews: some View {
        UnityControlView()
    }
}
