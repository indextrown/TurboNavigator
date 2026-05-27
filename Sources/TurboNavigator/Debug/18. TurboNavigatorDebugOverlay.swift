//
//  TurboNavigatorDebugOverlay.swift
//  TurboNavigator
//
//  Created by 김동현 on 5/28/26.
//

import SwiftUI

public struct TurboNavigatorDebugOverlay<Dependencies, Route: Hashable>: View {
    public let navigator: Navigator<Dependencies, Route>
    public let refreshInterval: TimeInterval

    @State private var stackDescription: String

    public init(
        navigator: Navigator<Dependencies, Route>,
        refreshInterval: TimeInterval = 0.5
    ) {
        self.navigator = navigator
        self.refreshInterval = refreshInterval
        self._stackDescription = State(initialValue: navigator.debugStackDescription())
    }

    public var body: some View {
        Text(stackDescription)
            .font(.system(size: 11, weight: .medium, design: .monospaced))
            .foregroundColor(.white)
            .padding(8)
            .background(Color.black.opacity(0.75))
            .cornerRadius(8)
            .padding(12)
            .allowsHitTesting(false)
            .onReceive(
                Timer.publish(every: refreshInterval, on: .main, in: .common)
                    .autoconnect()
            ) { _ in
                stackDescription = navigator.debugStackDescription()
            }
    }
}

public extension View {

    func turboNavigatorDebugOverlay<Dependencies, Route: Hashable>(
        _ navigator: Navigator<Dependencies, Route>,
        isPresented: Bool = true,
        refreshInterval: TimeInterval = 0.5
    ) -> some View {
        overlay(
            Group {
                if isPresented {
                    TurboNavigatorDebugOverlay(
                        navigator: navigator,
                        refreshInterval: refreshInterval
                    )
                }
            },
            alignment: .topLeading
        )
    }
}
