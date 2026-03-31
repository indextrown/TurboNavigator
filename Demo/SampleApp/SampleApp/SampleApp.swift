//
//  SampleApp.swift
//  SampleApp
//
//  Created by 김동현 on 3/31/26.
//

import SwiftUI
import TurboNavigator

@main
struct SampleApp: App {
    private let navigator = AppRouter.buildNavigator()
    var body: some Scene {
        WindowGroup {
            NavigationContainer(
                navigator: navigator,
                initialRoutes: [.home],
                prefersLargeTitles: false
            )
        }
    }
}
