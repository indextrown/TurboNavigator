//
//  SwiftUIDemoApp.swift
//  SwiftUIDemo
//
//  Created by Codex on 4/1/26.
//

import SwiftUI
import TurboNavigator

@main
struct SwiftUIDemoApp: App {
    private let navigator = AppRouter.buildNavigator()

    var body: some Scene {
        WindowGroup {
            NavigationContainer(
                navigator: navigator,
                initialRoutes: [.home],
                prefersLargeTitles: true
            )
            .ignoresSafeArea(.container, edges: .bottom)
        }
    }
}
