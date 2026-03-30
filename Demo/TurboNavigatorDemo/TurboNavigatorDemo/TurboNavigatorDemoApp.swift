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
            /*
            NavigationHost(
                navigator: navigator,
                initialRoutes: [.home]
            )
             */
            TabNavigationHost(
              navigator: navigator,
              items: [
                .init(
                  tag: 0,
                  route: .home,
                  tabBarItem: UITabBarItem(title: "Home", image: nil, tag: 0),
                  prefersLargeTitles: true),
                .init(
                  tag: 1,
                  route: .settings,
                  tabBarItem: UITabBarItem(title: "Settings", image: nil, tag: 1),
                  prefersLargeTitles: true)
              ])
        }
    }
}
