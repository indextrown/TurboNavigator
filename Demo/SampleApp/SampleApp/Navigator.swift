//
//  Navigator.swift
//  SampleApp
//
//  Created by 김동현 on 3/31/26.
//

import TurboNavigator

struct AppDependencies {
    
}

extension AppDependencies: PreviewDependencies {
    static var preview: Self { .init() }
}

enum AppRoute: Hashable {
    case home
    case detail(id: String)
    case setting
}

enum AppRouter {
    static func buildNavigator() -> Navigator<AppDependencies, AppRoute> {
        let registry = RouteRegistry<AppDependencies, AppRoute>()
            .registering(.home) { context in
                WrappingController(route: context.route) {
                    HomeView(naviagtor: context.navigator)
                }
            }
        
        return Navigator(
            dependencies: AppDependencies(),
            registry: registry
        )
    }
}
