//
//  AppDelegate.swift
//  TurboNavigatorDemo
//
//  Created by 김동현 on 3/31/26.
//

import UIKit
import TurboNavigator

final class AppDelegate: NSObject, UIApplicationDelegate {
    
}

struct AppDependencies {
    
}

enum AppRoute: Hashable {
    case home
    case detail(id: String)
    case settings
}

enum AppRouter {
    static func buildNavigator() -> Navigator<AppDependencies, AppRoute> {
        let registry = RouteRegistry<AppDependencies, AppRoute>()
            .registering(.home) { context in
              WrappingController(route: context.route, title: "Home") {
                HomeView(navigator: context.navigator)
              }
            }
        return Navigator(
            dependencies: AppDependencies(),
            registry: registry
        )
    }
}
