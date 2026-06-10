//
//  UnityEventLogView.swift.swift
//  iOSUnityBridgeDemo
//
//  Created by Roberto Teixeira on 10/06/2026.
//

import SwiftUI

struct UnityEventLogView: View {
    let events: [UnityEvent]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Event Log")
                .font(.headline)

            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(events) { event in
                        Text("[\(event.formattedTime)] \(event.displayMessage)")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(8)
                            .background(.background)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            .frame(maxHeight: 260)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    UnityEventLogView(
        events: [
            UnityEvent(type: .nativeShellStarted),
            UnityEvent(type: .unityLoaded),
            UnityEvent(type: .commandSent, payload: ["command": "changeColor"])
        ]
    )
    .padding()
}
