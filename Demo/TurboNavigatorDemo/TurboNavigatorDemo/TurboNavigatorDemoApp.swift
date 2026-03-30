//
//  TurboNavigatorDemoApp.swift
//  TurboNavigatorDemo
//
//  Created by 김동현 on 3/29/26.
//

import SwiftUI
import TurboNavigator

@main
struct TurboNavigatorDemoApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    private let navigator = AppRouter.buildNavigator()
    
    var body: some Scene {
        WindowGroup {
            NavigationHost(
                navigator: navigator,
                initialRoutes: [.home]
            )
        }
    }
}
