//
//  UnityStatusCard.swift
//  iOSUnityBridgeDemo
//
//  Created by Roberto Teixeira on 10/06/2026.
//

import SwiftUI

struct UnityStatusCard: View {
    let state: UnityBridgeState

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Unity Status")
                .font(.headline)

            HStack {
                Circle()
                    .frame(width: 12, height: 12)
                    .foregroundStyle(statusColor)

                Text(state.title)
                    .font(.subheadline)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var statusColor: Color {
        switch state {
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

struct UnityStatusCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            UnityStatusCard(state: .notLoaded)
            UnityStatusCard(state: .loading)
            UnityStatusCard(state: .loaded)
            UnityStatusCard(state: .unloading)
            UnityStatusCard(state: .failed("Preview error"))
        }
        .padding()
    }
}
