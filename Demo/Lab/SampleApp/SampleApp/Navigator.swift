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
            // home
            .registering(.home) { context in
                WrappingController(route: context.route) {
                    HomeView(navigator: context.navigator)
                }
            }
            // setting
            .registering(.setting) { context in
                WrappingController(route: context.route) {
                    SettingView(navigator: context.navigator)
                }
            }
            // detail
            .registering(
                extracting: { (route: AppRoute) -> String? in
                    guard case let .detail(id) = route else { return nil }
                    return id
                },
                build: { context, id in
                    WrappingController(route: context.route, title: "Detail") {
                        DetailView(
                            navigator: context.navigator,
                            userId: id
                        )
                    }
                })
        return Navigator(
            dependencies: AppDependencies(),
            registry: registry
        )
    }
}
