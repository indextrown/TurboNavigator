//
//  Navigator.swift
//  SwiftUIDemo
//
//  Created by Codex on 4/1/26.
//

import TurboNavigator

struct AppDependencies {
    let userRepository: UserRepository
}

protocol UserRepository {
    func displayName(for id: String) -> String
}

struct DefaultUserRepository: UserRepository {
    func displayName(for id: String) -> String {
        "SwiftUI User \(id)"
    }
}

extension AppDependencies: PreviewDependencies {
    static var preview: Self {
        .init(userRepository: DefaultUserRepository())
    }
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
            .registering(.settings) { context in
                WrappingController(route: context.route, title: "Settings") {
                    SettingView(navigator: context.navigator)
                }
            }
            .registering(
                extracting: { (route: AppRoute) -> String? in
                    guard case let .detail(id) = route else { return nil }
                    return id
                },
                build: { (context: RouteContext<AppDependencies, AppRoute>, id: String) -> RouteViewController? in
                    WrappingController(route: context.route, title: "Detail \(id)") {
                        DetailView(
                            navigator: context.navigator,
                            userID: id,
                            repository: context.dependencies.userRepository
                        )
                    }
                }
            )

        return Navigator(
            dependencies: AppDependencies(userRepository: DefaultUserRepository()),
            registry: registry
        )
    }
}
