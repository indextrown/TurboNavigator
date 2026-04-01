//
//  Navigator.swift
//  UIKitDemo
//
//  Created by Codex on 4/1/26.
//

import TurboNavigator
import UIKit

struct AppDependencies {
    let userRepository: UserRepository
}

protocol UserRepository {
    func displayName(for id: String) -> String
}

struct DefaultUserRepository: UserRepository {
    func displayName(for id: String) -> String {
        "UIKit User \(id)"
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
                HomeViewController(navigator: context.navigator)
            }
            .registering(.settings) { context in
                SettingViewController(navigator: context.navigator)
            }
            .registering(
                extracting: { route in
                    guard case let .detail(id) = route else { return nil }
                    return id
                },
                build: { context, id in
                    DetailViewController(
                        navigator: context.navigator,
                        route: context.route,
                        userID: id,
                        repository: context.dependencies.userRepository
                    )
                }
            )

        return Navigator(
            dependencies: AppDependencies(userRepository: DefaultUserRepository()),
            registry: registry
        )
    }
}
